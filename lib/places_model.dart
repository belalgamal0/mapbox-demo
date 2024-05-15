class PlacesSugesstions {
    List<Result> results;

    PlacesSugesstions({
        required this.results,
    });

    factory PlacesSugesstions.fromJson(Map<String, dynamic> json) => PlacesSugesstions(
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Result {
    Type type;
    SuggestionText text;
    String link;
    Place place;

    Result({
        required this.type,
        required this.text,
        required this.link,
        required this.place,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        type: typeValues.map[json["type"]]!,
        text: SuggestionText.fromJson(json["text"]),
        link: json["link"],
        place: Place.fromJson(json["place"]),
    );

    Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "text": text.toJson(),
        "link": link,
        "place": place.toJson(),
    };
}

class Place {
    String fsqId;
    List<Category> categories;
    int distance;
    Geocodes geocodes;
    Location location;
    String name;

    Place({
        required this.fsqId,
        required this.categories,
        required this.distance,
        required this.geocodes,
        required this.location,
        required this.name,
    });

    factory Place.fromJson(Map<String, dynamic> json) => Place(
        fsqId: json["fsq_id"],
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        distance: json["distance"],
        geocodes: Geocodes.fromJson(json["geocodes"]),
        location: Location.fromJson(json["location"]),
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "fsq_id": fsqId,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "distance": distance,
        "geocodes": geocodes.toJson(),
        "location": location.toJson(),
        "name": name,
    };
}

class Category {
    int id;
    String name;
    String shortName;
    String pluralName;
    IconWidget icon;

    Category({
        required this.id,
        required this.name,
        required this.shortName,
        required this.pluralName,
        required this.icon,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        shortName: json["short_name"],
        pluralName: json["plural_name"],
        icon: IconWidget.fromJson(json["icon"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_name": shortName,
        "plural_name": pluralName,
        "icon": icon.toJson(),
    };
}

class IconWidget {
    String prefix;
    Suffix suffix;

    IconWidget({
        required this.prefix,
        required this.suffix,
    });

    factory IconWidget.fromJson(Map<String, dynamic> json) => IconWidget(
        prefix: json["prefix"],
        suffix: suffixValues.map[json["suffix"]]!,
    );

    Map<String, dynamic> toJson() => {
        "prefix": prefix,
        "suffix": suffixValues.reverse[suffix],
    };
}

enum Suffix {
    PNG
}

final suffixValues = EnumValues({
    ".png": Suffix.PNG
});

class Geocodes {
    Main main;
    Main? dropOff;
    Main? roof;

    Geocodes({
        required this.main,
        this.dropOff,
        this.roof,
    });

    factory Geocodes.fromJson(Map<String, dynamic> json) => Geocodes(
        main: Main.fromJson(json["main"]),
        dropOff: json["drop_off"] == null ? null : Main.fromJson(json["drop_off"]),
        roof: json["roof"] == null ? null : Main.fromJson(json["roof"]),
    );

    Map<String, dynamic> toJson() => {
        "main": main.toJson(),
        "drop_off": dropOff?.toJson(),
        "roof": roof?.toJson(),
    };
}

class Main {
    double latitude;
    double longitude;

    Main({
        required this.latitude,
        required this.longitude,
    });

    factory Main.fromJson(Map<String, dynamic> json) => Main(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

class Location {
    Country country;
    String? crossStreet;
    String formattedAddress;
    String? address;
    String? locality;
    String? region;
    String? addressExtended;

    Location({
        required this.country,
        this.crossStreet,
        required this.formattedAddress,
        this.address,
        this.locality,
        this.region,
        this.addressExtended,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        country: countryValues.map[json["country"]]!,
        crossStreet: json["cross_street"],
        formattedAddress: json["formatted_address"],
        address: json["address"],
        locality: json["locality"],
        region: json["region"],
        addressExtended: json["address_extended"],
    );

    Map<String, dynamic> toJson() => {
        "country": countryValues.reverse[country],
        "cross_street": crossStreet,
        "formatted_address": formattedAddress,
        "address": address,
        "locality": locality,
        "region": region,
        "address_extended": addressExtended,
    };
}

enum Country {
    EG
}

final countryValues = EnumValues({
    "EG": Country.EG
});

class SuggestionText {
    String primary;
    String secondary;
    List<Highlight> highlight;

    SuggestionText({
        required this.primary,
        required this.secondary,
        required this.highlight,
    });

    factory SuggestionText.fromJson(Map<String, dynamic> json) => SuggestionText(
        primary: json["primary"],
        secondary: json["secondary"],
        highlight: List<Highlight>.from(json["highlight"].map((x) => Highlight.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "primary": primary,
        "secondary": secondary,
        "highlight": List<dynamic>.from(highlight.map((x) => x.toJson())),
    };
}

class Highlight {
    int start;
    int length;

    Highlight({
        required this.start,
        required this.length,
    });

    factory Highlight.fromJson(Map<String, dynamic> json) => Highlight(
        start: json["start"],
        length: json["length"],
    );

    Map<String, dynamic> toJson() => {
        "start": start,
        "length": length,
    };
}

enum Type {
    PLACE
}

final typeValues = EnumValues({
    "place": Type.PLACE
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
