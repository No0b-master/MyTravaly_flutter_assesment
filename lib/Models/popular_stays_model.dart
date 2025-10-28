class PopularStay {
  final String propertyName;
  final int propertyStar;
  final String propertyImage;
  final String propertyCode;
  final String propertyType;
  final double staticPrice;
  final double markedPrice;
  final double rating;
  final String city;
  final String propertyUrl;

  PopularStay({
    required this.propertyName,
    required this.propertyStar,
    required this.propertyImage,
    required this.propertyCode,
    required this.propertyType,
    required this.staticPrice,
    required this.markedPrice,
    required this.rating,
    required this.city,
    required this.propertyUrl,
  });

  factory PopularStay.fromJson(Map<String, dynamic> json) {
    return PopularStay(
      propertyName: json["propertyName"] ?? '',
      propertyStar: json["propertyStar"] ?? 0,
      propertyImage: json["propertyImage"] ?? '',
      propertyCode: json["propertyCode"] ?? '',
      propertyType: json["propertyType"] ?? '',
      staticPrice: (json["staticPrice"]?["amount"] ?? 0).toDouble(),
      markedPrice: (json["markedPrice"]?["amount"] ?? 0).toDouble(),
      rating:
      (json["googleReview"]?["data"]?["overallRating"] ?? 0).toDouble(),
      city: json["propertyAddress"]?["city"] ?? '',
      propertyUrl: json["propertyUrl"] ?? '',
    );
  }
}
