import 'dart:convert';

List<University> universitiesFromJson(String str) =>
    List<University>.from(json.decode(str).map((x) => University.fromJson(x)));

class University {
  University({
    this.alphaTwoCode,
    this.stateProvince,
    this.country,
    this.name,
    this.webPages,
    this.domains,
  });

  String? alphaTwoCode;
  String? stateProvince;
  String? country;
  String? name;
  List<String>? webPages;
  List<String>? domains;

  factory University.fromJson(Map<String, dynamic> json) => University(
        alphaTwoCode:
            json["alpha_two_code"] == null ? null : json["alpha_two_code"],
        stateProvince:
            json["state-province"] == null ? null : json["state-province"],
        country: json["country"] == null ? null : json["country"],
        name: json["name"] == null ? null : json["name"],
        webPages: json["web_pages"] == null
            ? null
            : List<String>.from(json["web_pages"].map((x) => x)),
        domains: json["domains"] == null
            ? null
            : List<String>.from(json["domains"].map((x) => x)),
      );
}

// enum AlphaTwoCode { US }

final alphaTwoCodeValues = "US";

// enum Country { UNITED_STATES }

final countryValues = "United States";

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
