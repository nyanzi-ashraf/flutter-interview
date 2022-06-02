class FlashDeal {
  FlashDeal({
    this.id,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.startDate,
    this.endDate,
    this.slug,
    this.bannerImage,
    this.status,
    this.isFeatured,
  });

  int? id;
  String? title;
  String? backgroundColor;
  String? textColor;
  DateTime? startDate;
  DateTime? endDate;
  String? slug;
  String? bannerImage;
  int? status;
  int? isFeatured;

  factory FlashDeal.fromJson(Map<String, dynamic> json) => FlashDeal(
        id: json["id"],
        title: json["title"],
        backgroundColor: json["background_color"],
        textColor: json["text_color"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        slug: json["slug"],
        bannerImage: json["banner_image"],
        status: json["status"],
        isFeatured: json["is_featured"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "background_color": backgroundColor,
        "text_color": textColor,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "slug": slug,
        "banner_image": bannerImage,
        "status": status,
        "is_featured": isFeatured,
      };
}
