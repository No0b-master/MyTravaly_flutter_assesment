class FilteredHotelResponse {
  final bool status;
  final String message;
  final int responseCode;
  final HotelData data;

  FilteredHotelResponse({
    required this.status,
    required this.message,
    required this.responseCode,
    required this.data,
  });

  factory FilteredHotelResponse.fromJson(Map<String, dynamic> json) {
    return FilteredHotelResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      responseCode: json['responseCode'] ?? 0,
      data: HotelData.fromJson(json['data'] ?? {}),
    );
  }
}

class HotelData {
  final List<FilteredHotelModel> arrayOfHotelList;
  final List<String> arrayOfExcludedHotels;
  final List<String> arrayOfExcludedSearchType;

  HotelData({
    required this.arrayOfHotelList,
    required this.arrayOfExcludedHotels,
    required this.arrayOfExcludedSearchType,
  });

  factory HotelData.fromJson(Map<String, dynamic> json) {
    return HotelData(
      arrayOfHotelList: (json['arrayOfHotelList'] as List<dynamic>?)
          ?.map((e) => FilteredHotelModel.fromJson(e))
          .toList() ??
          [],
      arrayOfExcludedHotels: List<String>.from(
          json['arrayOfExcludedHotels'] ?? []),
      arrayOfExcludedSearchType: List<String>.from(
          json['arrayOfExcludedSearchType'] ?? []),
    );
  }
}

class FilteredHotelModel {
  final String propertyCode;
  final String propertyName;
  final String propertyType;
  final int propertyStar;
  final PropertyImage propertyImage;
  final PropertyAddress propertyAddress;
  final String propertyUrl;
  final String roomName;
  final int numberOfAdults;
  final Price markedPrice;
  final Price propertyMaxPrice;
  final Price propertyMinPrice;
  final List<AvailableDeal> availableDeals;
  final bool isFavorite;
  final SimplPriceList simplPriceList;
  final GoogleReview? googleReview;

  FilteredHotelModel({
    required this.propertyCode,
    required this.propertyName,
    required this.propertyType,
    required this.propertyStar,
    required this.propertyImage,
    required this.propertyAddress,
    required this.propertyUrl,
    required this.roomName,
    required this.numberOfAdults,
    required this.markedPrice,
    required this.propertyMaxPrice,
    required this.propertyMinPrice,
    required this.availableDeals,
    required this.isFavorite,
    required this.simplPriceList,
    this.googleReview,
  });

  factory FilteredHotelModel.fromJson(Map<String, dynamic> json) {
    return FilteredHotelModel(
      propertyCode: json['propertyCode'] ?? '',
      propertyName: json['propertyName'] ?? 'Unknown',
      propertyType: json['propertytype'] ?? '',
      propertyStar: json['propertyStar'] ?? 0,
      propertyImage:
      PropertyImage.fromJson(json['propertyImage'] ?? {}),
      propertyAddress:
      PropertyAddress.fromJson(json['propertyAddress'] ?? {}),
      propertyUrl: json['propertyUrl'] ?? '',
      roomName: json['roomName'] ?? '',
      numberOfAdults: json['numberOfAdults'] ?? 0,
      markedPrice: Price.fromJson(json['markedPrice'] ?? {}),
      propertyMaxPrice: Price.fromJson(json['propertyMaxPrice'] ?? {}),
      propertyMinPrice: Price.fromJson(json['propertyMinPrice'] ?? {}),
      availableDeals: (json['availableDeals'] as List<dynamic>?)
          ?.map((e) => AvailableDeal.fromJson(e))
          .toList() ??
          [],
      isFavorite: json['isFavorite'] ?? false,
      simplPriceList:
      SimplPriceList.fromJson(json['simplPriceList'] ?? {}),
      googleReview: json['googleReview'] != null
          ? GoogleReview.fromJson(json['googleReview'])
          : null,
    );
  }
}

class PropertyImage {
  final String fullUrl;
  final String location;
  final String imageName;

  PropertyImage({
    required this.fullUrl,
    required this.location,
    required this.imageName,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      fullUrl: json['fullUrl'] ?? '',
      location: json['location'] ?? '',
      imageName: json['imageName'] ?? '',
    );
  }
}

class PropertyAddress {
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipcode;
  final String mapAddress;
  final double latitude;
  final double longitude;

  PropertyAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipcode,
    required this.mapAddress,
    required this.latitude,
    required this.longitude,
  });

  factory PropertyAddress.fromJson(Map<String, dynamic> json) {
    return PropertyAddress(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipcode: json['zipcode'] ?? '',
      mapAddress: json['mapAddress'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}

class Price {
  final double amount;
  final String displayAmount;
  final String currencySymbol;

  Price({
    required this.amount,
    required this.displayAmount,
    required this.currencySymbol,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: (json['amount'] ?? 0).toDouble(),
      displayAmount: json['displayAmount'] ?? '',
      currencySymbol: json['currencySymbol'] ?? '',
    );
  }
}

class AvailableDeal {
  final String headerName;
  final String websiteUrl;
  final String dealType;
  final Price price;

  AvailableDeal({
    required this.headerName,
    required this.websiteUrl,
    required this.dealType,
    required this.price,
  });

  factory AvailableDeal.fromJson(Map<String, dynamic> json) {
    return AvailableDeal(
      headerName: json['headerName'] ?? '',
      websiteUrl: json['websiteUrl'] ?? '',
      dealType: json['dealType'] ?? '',
      price: Price.fromJson(json['price'] ?? {}),
    );
  }
}

class SimplPriceList {
  final Price simplPrice;
  final double originalPrice;

  SimplPriceList({
    required this.simplPrice,
    required this.originalPrice,
  });

  factory SimplPriceList.fromJson(Map<String, dynamic> json) {
    return SimplPriceList(
      simplPrice: Price.fromJson(json['simplPrice'] ?? {}),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
    );
  }
}

class GoogleReview {
  final bool reviewPresent;
  final GoogleReviewData? data;

  GoogleReview({
    required this.reviewPresent,
    this.data,
  });

  factory GoogleReview.fromJson(Map<String, dynamic> json) {
    return GoogleReview(
      reviewPresent: json['reviewPresent'] ?? false,
      data: json['data'] != null
          ? GoogleReviewData.fromJson(json['data'])
          : null,
    );
  }
}

class GoogleReviewData {
  final double overallRating;
  final int totalUserRating;
  final int withoutDecimal;

  GoogleReviewData({
    required this.overallRating,
    required this.totalUserRating,
    required this.withoutDecimal,
  });

  factory GoogleReviewData.fromJson(Map<String, dynamic> json) {
    return GoogleReviewData(
      overallRating: (json['overallRating'] ?? 0).toDouble(),
      totalUserRating: json['totalUserRating'] ?? 0,
      withoutDecimal: json['withoutDecimal'] ?? 0,
    );
  }
}
