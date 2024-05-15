class PolylinesModel {
    String status;
    DistanceAndDuration distanceAndDuration;

    PolylinesModel({
        required this.status,
        required this.distanceAndDuration,
    });

    factory PolylinesModel.fromJson(Map<String, dynamic> json) => PolylinesModel(
        status: json["status"],
        distanceAndDuration: DistanceAndDuration.fromJson(json["distanceAndDuration"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "distanceAndDuration": distanceAndDuration.toJson(),
    };
}

class DistanceAndDuration {
    DriverDistanceMatrix driverDistanceMatrix;
    List<List<double>> points;

    DistanceAndDuration({
        required this.driverDistanceMatrix,
        required this.points,
    });

    factory DistanceAndDuration.fromJson(Map<String, dynamic> json) => DistanceAndDuration(
        driverDistanceMatrix: DriverDistanceMatrix.fromJson(json["driverDistanceMatrix"]),
        points: List<List<double>>.from(json["points"].map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
    );

    Map<String, dynamic> toJson() => {
        "driverDistanceMatrix": driverDistanceMatrix.toJson(),
        "points": List<dynamic>.from(points.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
}

class DriverDistanceMatrix {
    Distance distance;
    Distance duration;

    DriverDistanceMatrix({
        required this.distance,
        required this.duration,
    });

    factory DriverDistanceMatrix.fromJson(Map<String, dynamic> json) => DriverDistanceMatrix(
        distance: Distance.fromJson(json["distance"]),
        duration: Distance.fromJson(json["duration"]),
    );

    Map<String, dynamic> toJson() => {
        "distance": distance.toJson(),
        "duration": duration.toJson(),
    };
}

class Distance {
    int value;
    String text;

    Distance({
        required this.value,
        required this.text,
    });

    factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        value: json["value"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "text": text,
    };
}
