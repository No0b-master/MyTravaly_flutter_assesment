class FilteredHotelModel {
  final String propertyName;
  final String city;
  final double rating;
  final String propertyImage;
  final double price;

  FilteredHotelModel({
    required this.propertyName,
    required this.city,
    required this.rating,
    required this.propertyImage,
    required this.price,
  });

  factory FilteredHotelModel.fromJson(Map<String, dynamic> json) {
    return FilteredHotelModel(
      propertyName: json['propertyName'] ?? 'Unknown',
      city: json['propertyAddress']?['city'] ?? 'Unknown City',
      rating: (json['googleReview']?['data']?['overallRating'] ?? 0).toDouble(),
      propertyImage: json['propertyImage']?['fullUrl'] ?? '',
      price: (json['propertyMinPrice']?['amount'] ?? 0).toDouble(),
    );
  }
}
