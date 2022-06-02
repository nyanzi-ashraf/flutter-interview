class TagData {
  TagData({
    this.id,
    this.name,
    this.url,
  });

  int? id;
  String? name;
  dynamic url;
  // AllProducts products;

  factory TagData.fromJson(Map<String, dynamic> json) => TagData(
        id: json["id"],
        name: json["name"],
        url: json["url"] == null ? null : json["url"],
        // products: json["Products"] == null
        //     ? null
        //     : AllProducts.fromJson(json["Products"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        // "Products": products.toJson(),
      };
}
