class PopularStay {
  final String propertyName;
  final int propertyStar;
  final String propertyImage;
  final String propertyCode;
  final String propertyType;
  final Price markedPrice;
  final Price staticPrice;
  final GoogleReview googleReview;
  final String propertyUrl;
  final PropertyAddress propertyAddress;
  final PropertyPoliciesAndAmenities propertyPoliciesAndAmenities;

  PopularStay({
    required this.propertyName,
    required this.propertyStar,
    required this.propertyImage,
    required this.propertyCode,
    required this.propertyType,
    required this.markedPrice,
    required this.staticPrice,
    required this.googleReview,
    required this.propertyUrl,
    required this.propertyAddress,
    required this.propertyPoliciesAndAmenities,
  });

  factory PopularStay.fromJson(Map<String, dynamic> json) {
    return PopularStay(
      propertyName: json["propertyName"] ?? '',
      propertyStar: json["propertyStar"] ?? 0,
      propertyImage: json["propertyImage"] ?? '',
      propertyCode: json["propertyCode"] ?? '',
      propertyType: json["propertyType"] ?? '',
      markedPrice: Price.fromJson(json["markedPrice"] ?? {}),
      staticPrice: Price.fromJson(json["staticPrice"] ?? {}),
      googleReview: GoogleReview.fromJson(json["googleReview"] ?? {}),
      propertyUrl: json["propertyUrl"] ?? '',
      propertyAddress: PropertyAddress.fromJson(json["propertyAddress"] ?? {}),
      propertyPoliciesAndAmenities: PropertyPoliciesAndAmenities.fromJson(
        json["propertyPoliciesAndAmmenities"] ?? {},
      ),
    );
  }
}


class Price {
  final double amount;
  final String displayAmount;
  final String currencyAmount;
  final String currencySymbol;

  Price({
    required this.amount,
    required this.displayAmount,
    required this.currencyAmount,
    required this.currencySymbol,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: (json["amount"] ?? 0).toDouble(),
      displayAmount: json["displayAmount"] ?? '',
      currencyAmount: json["currencyAmount"] ?? '',
      currencySymbol: json["currencySymbol"] ?? '',
    );
  }
}


class GoogleReview {
  final bool reviewPresent;
  final double overallRating;
  final int totalUserRating;
  final int withoutDecimal;

  GoogleReview({
    required this.reviewPresent,
    required this.overallRating,
    required this.totalUserRating,
    required this.withoutDecimal,
  });

  factory GoogleReview.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};
    return GoogleReview(
      reviewPresent: json["reviewPresent"] ?? false,
      overallRating: (data["overallRating"] ?? 0).toDouble(),
      totalUserRating: data["totalUserRating"] ?? 0,
      withoutDecimal: data["withoutDecimal"] ?? 0,
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
      street: json["street"] ?? '',
      city: json["city"] ?? '',
      state: json["state"] ?? '',
      country: json["country"] ?? '',
      zipcode: json["zipcode"] ?? '',
      mapAddress: json["map_address"] ?? '',
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
    );
  }
}


class PropertyPoliciesAndAmenities {
  final bool present;
  final PolicyData? data;

  PropertyPoliciesAndAmenities({required this.present, this.data});

  factory PropertyPoliciesAndAmenities.fromJson(Map<String, dynamic> json) {
    return PropertyPoliciesAndAmenities(
      present: json["present"] ?? false,
      data: json["data"] != null ? PolicyData.fromJson(json["data"]) : null,
    );
  }
}

class PolicyData {
  final String cancelPolicy;
  final String refundPolicy;
  final String childPolicy;
  final String damagePolicy;
  final String propertyRestriction;
  final bool petsAllowed;
  final bool coupleFriendly;
  final bool suitableForChildren;
  final bool bachularsAllowed;
  final bool freeWifi;
  final bool freeCancellation;
  final bool payAtHotel;
  final bool payNow;
  final String lastUpdatedOn;

  PolicyData({
    required this.cancelPolicy,
    required this.refundPolicy,
    required this.childPolicy,
    required this.damagePolicy,
    required this.propertyRestriction,
    required this.petsAllowed,
    required this.coupleFriendly,
    required this.suitableForChildren,
    required this.bachularsAllowed,
    required this.freeWifi,
    required this.freeCancellation,
    required this.payAtHotel,
    required this.payNow,
    required this.lastUpdatedOn,
  });

  factory PolicyData.fromJson(Map<String, dynamic> json) {
    return PolicyData(
      cancelPolicy: json["cancelPolicy"] ?? '',
      refundPolicy: json["refundPolicy"] ?? '',
      childPolicy: json["childPolicy"] ?? '',
      damagePolicy: json["damagePolicy"] ?? '',
      propertyRestriction: json["propertyRestriction"] ?? '',
      petsAllowed: json["petsAllowed"] ?? false,
      coupleFriendly: json["coupleFriendly"] ?? false,
      suitableForChildren: json["suitableForChildren"] ?? false,
      bachularsAllowed: json["bachularsAllowed"] ?? false,
      freeWifi: json["freeWifi"] ?? false,
      freeCancellation: json["freeCancellation"] ?? false,
      payAtHotel: json["payAtHotel"] ?? false,
      payNow: json["payNow"] ?? false,
      lastUpdatedOn: json["lastUpdatedOn"] ?? '',
    );
  }
}

