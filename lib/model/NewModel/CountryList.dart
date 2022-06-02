class AllCountry {
  int? id;
  String? code;
  String? name;
  String? phonecode;
  String? flag;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;

  AllCountry({
    this.id,
    this.code,
    this.name,
    this.phonecode,
    this.flag,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AllCountry.fromJson(Map<String, dynamic> json) {
    return AllCountry(
      id: json["id"],
      code: json["code"],
      name: json["name"],
      phonecode: json["phonecode"],
      flag: json["flag"] == null ? null : json["flag"],
      status: json["status"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "phonecode": phonecode,
        "flag": flag == null ? null : flag,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class CountryList {
  List<AllCountry> countries = [];

  CountryList({required this.countries});

  factory CountryList.fromJson(List<dynamic> json) {
    List<AllCountry> countryList;

    countryList = json.map((i) => AllCountry.fromJson(i)).toList();

    return CountryList(countries: countryList);
  }
}
