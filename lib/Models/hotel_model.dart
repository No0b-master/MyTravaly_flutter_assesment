class HotelModel {
  final String? propertyName;
  final String? valueToDisplay;
  final String? city;
  final String? state;
  final String? country;
  final String? type;
  final List<String>? query;

  HotelModel({
    this.propertyName,
    this.valueToDisplay,
    this.city,
    this.state,
    this.country,
    this.type,
    this.query,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    final address = json['address'] ?? {};
    final searchArray = json['searchArray'] ?? {};
    return HotelModel(
      propertyName: json['propertyName'],
      valueToDisplay: json['valueToDisplay'],
      city: address['city'],
      state: address['state'],
      country: address['country'],
      type: searchArray['type'],
      query: searchArray['query'] != null
          ? List<String>.from(searchArray['query'])
          : [],
    );
  }
}


