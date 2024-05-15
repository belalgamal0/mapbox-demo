import 'dart:developer';

import 'package:android_id/android_id.dart';
import 'package:client_information/client_information.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_3/polylines_model.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:throttling/throttling.dart';
import 'package:uuid/uuid.dart';
import 'package:mapbox_search/mapbox_search.dart';

import 'places_model.dart' ;
// fsq3SiQxo1ETGQhoPyegAUOfCQ0Zqpx680nsf05WGrRH8V8=
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mapbox Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Dio dio = Dio();
  TextEditingController searchController = TextEditingController();
  final Throttling thr = new Throttling(duration: Duration(seconds: 2));

  TextEditingController _startPointController = TextEditingController();
  Future<List<Result>> getSuggestions (String place)async{
    List<Result> places=[];
    await dio.get("https://api.foursquare.com/v3/autocomplete?query=$place&session_token=AJBSDSDSFFFF55SDA5WE8788SW22FASD&radius=60000&types=place&ll=30.137860,31.390310",options: Options(headers: {"Authorization":"fsq3SiQxo1ETGQhoPyegAUOfCQ0Zqpx680nsf05WGrRH8V8="})).then((value) {
    PlacesSugesstions sugesstions = PlacesSugesstions.fromJson(value.data);
    sugesstions.results.forEach((element) {
      places.add(element);
    });
    setState(() {
    });
    log(sugesstions.results.length.toString());
    });
    return places;
  }
  SearchBoxAPI search = SearchBoxAPI(
      apiKey:
          'pk.eyJ1IjoiYmVsYWwwIiwiYSI6ImNsdnc4OWdhaDF1azEyam5uNnhqeG41ZzgifQ.XB-QeEUU9XmAXv0vObul1A', 
      limit: 10,
      country: "EG",types: [PlaceType.place]);
//5f2bf6e06ba8cf45
Future<Uint8List> loadMarkerImage(String markerName) async {
    log("loadMarkerImage has been called");
    print("===================== loadMarkerImage has been called =====================");

  var byteData = await rootBundle.load("assets/img/$markerName.png");
  return byteData.buffer.asUint8List();
}
MapboxMapController? mapController;
void onMapCreated(MapboxMapController controller, String markerName, double lat, double lng) async {
  mapController = controller;
  log("===================== onMapCreated has been called =====================");
  print("===================== onMapCreated has been called =====================");
  var markerImage = await loadMarkerImage(markerName);

  mapController!.addImage(markerName, markerImage);

  await mapController!.addSymbol(
    SymbolOptions(
      iconSize: 0.25,
      iconImage: markerName,
      geometry: LatLng(lat, lng),
      iconAnchor: "bottom",
    ),
  ).then((value){
    log("$value has been added");
  }).onError((error, stackTrace) {
    log("failed to add marker");
  });setState(() {
    
  });
}
List<LatLng> convertToLatLngList(List<List<double>> coordinatesList) {
  List<LatLng> result = [];

  for (List<double> coordinates in coordinatesList) {
    for (int i = 0; i < coordinates.length; i += 2) {
      double lat = coordinates[i];
      double lng = coordinates[i + 1];
      result.add(LatLng(lat, lng));
    }
  }

  return result;
}
Future<PolylinesModel> getPolylines()async{
  final response = await dio.post("https://apidev.helpooapp.net/api/v2/drivers/getDurationAndDistance",options: Options(),
  data: {"driverLocation": { "lat": sourceLocation!.latitude, "lng": sourceLocation!.longitude},"curClientLocation": { "lat": destinationLocation!.latitude, "lng": destinationLocation!.longitude},"from": "mobile"});
  PolylinesModel polylinesModel = PolylinesModel.fromJson(response.data);
  
log(convertToLatLngList(polylinesModel.distanceAndDuration.points).toString());
setState(() {
    mapController!.addLine(
            LineOptions(lineWidth: 5,geometry: convertToLatLngList(polylinesModel.distanceAndDuration.points))
          );
});
return polylinesModel;
}
LatLng? sourceLocation;
LatLng? destinationLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
  
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Stack(children: [
                             MapboxMap(onMapCreated: (controller) => {
                                       setState(() {
                                         mapController = controller;
                                       })
                                     },
                                       accessToken:
                                           "pk.eyJ1IjoiYmVsYWwwIiwiYSI6ImNsdnc4OWdhaDF1azEyam5uNnhqeG41ZzgifQ.XB-QeEUU9XmAXv0vObul1A",
                                       initialCameraPosition: CameraPosition(
                                           target: LatLng(30.137860, 31.390310), zoom: 15),
                                     ),
Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),margin: EdgeInsets.all(10),
                 child: Autocomplete<Result>(
                  displayStringForOption:(option) => option.place.name,
                optionsViewBuilder: (context, onSelected, options) {
                  
                  return Center(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: List.generate(options.length, (index) =>
                     GestureDetector(onTap: ()async{
                      onSelected(options.elementAt(index));
                      sourceLocation = LatLng(options.elementAt(index).place.geocodes.main.latitude, options.elementAt(index).place.geocodes.main.longitude);
                      // LatLng(options.elementAt(index).place.geocodes.main.latitude, options.elementAt(index).place.geocodes.main.longitude)
                      await mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(options.elementAt(index).place.geocodes.main.latitude, options.elementAt(index).place.geocodes.main.longitude)))
                      .then((value){
                        onMapCreated(mapController!,"marker",options.elementAt(index).place.geocodes.main.latitude,options.elementAt(index).place.geocodes.main.longitude);
                      log("Source LOCATION VALUE ${options.elementAt(index).place.geocodes.main.latitude}, ${ options.elementAt(index).place.geocodes.main.longitude}");
            
                      });
                      setState(() {
                      });
            
                     },
                       child: Center(
                         child: Container(width: MediaQuery.of(context).size.width,padding: EdgeInsets.fromLTRB(10,0,10,5),decoration: BoxDecoration(
                          color: Colors.white,
                          
                          border: Border(
                                       bottom: BorderSide(width: 1.5, color: Colors.grey.shade300),
                                     ),
                         ),child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Text("${options.elementAt(index).place.name}",style: TextStyle(color: Colors.black,fontSize: 14,decorationColor: Colors.white),),
                             Text(options.elementAt(index).text.secondary,style: TextStyle(color: Colors.grey,fontSize: 12,decorationColor: Colors.white)),
                           ],
                         )),
                       ),
                     )),),
                  );
                },
                           optionsBuilder: (TextEditingValue textEditingValue) async {
                             if (textEditingValue.text.isEmpty) {
                               return []; 
                             }
                             final suggestions = await getSuggestions(textEditingValue.text);
                             
                             return suggestions;
                           },
                           // ...
                 ),
               ),

               SizedBox(height: 10,),
               Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),margin: EdgeInsets.fromLTRB(10,70,10,10),
                 child: Autocomplete<Result>(
                  displayStringForOption:(option) => option.place.name,
                optionsViewBuilder: (context, onSelected, options) {
                  
                  return Center(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: List.generate(options.length, (index) =>
                     GestureDetector(onTap: ()async{
                      onSelected(options.elementAt(index));
                      destinationLocation = LatLng(options.elementAt(index).place.geocodes.main.latitude, options.elementAt(index).place.geocodes.main.longitude);
                      await mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(options.elementAt(index).place.geocodes.main.latitude, options.elementAt(index).place.geocodes.main.longitude)))
                      .then((value){
                        onMapCreated(mapController!,"second",options.elementAt(index).place.geocodes.main.latitude,options.elementAt(index).place.geocodes.main.longitude);
                      log("Destination LOCATION VALUE ${options.elementAt(index).place.geocodes.main.latitude}, ${ options.elementAt(index).place.geocodes.main.longitude}");
            
                      });
                      setState(() {
                      });
                    await getPolylines();
                     },
                       child: Center(
                         child: Container(width: MediaQuery.of(context).size.width,padding: EdgeInsets.fromLTRB(10,0,10,5),decoration: BoxDecoration(
                          color: Colors.white,
                          
                          border: Border(
                                       bottom: BorderSide(width: 1.5, color: Colors.grey.shade300),
                                     ),
                         ),child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Text("${options.elementAt(index).place.name}",style: TextStyle(color: Colors.black,fontSize: 14,decorationColor: Colors.white),),
                             Text(options.elementAt(index).text.secondary,style: TextStyle(color: Colors.grey,fontSize: 12,decorationColor: Colors.white)),
                           ],
                         )),
                       ),
                     )),),
                  );
                },
                           optionsBuilder: (TextEditingValue textEditingValue) async {
                             if (textEditingValue.text.isEmpty) {
                               return []; 
                             }
                             final suggestions = await getSuggestions(textEditingValue.text);
                             
                             return suggestions;
                           },
                           // ...
                 ),
               ),
            ],)),
  

            
    
      
          ],
        ),
      ),
    );
  }
}
