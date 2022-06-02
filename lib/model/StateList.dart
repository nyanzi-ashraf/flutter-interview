class AllState {
  int? id;
  String? name;
  int? countryId;
  int? status;
  dynamic? createdAt;
  dynamic? updatedAt;

  AllState({
    this.id,
    this.name,
    this.countryId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AllState.fromJson(Map<String, dynamic> json) {
    return AllState(
      id: json["id"],
      name: json["name"],
      countryId: json["country_id"],
      status: json["status"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_id": countryId,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class StateList {
  List<AllState>? states = [];

  StateList({this.states});

  factory StateList.fromJson(List<dynamic> json) {
    List<AllState> stateList;

    stateList = json.map((i) => AllState.fromJson(i)).toList();

    return StateList(states: stateList);
  }
}
