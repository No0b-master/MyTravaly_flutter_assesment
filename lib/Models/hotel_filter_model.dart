import 'package:mytravaly_flutter_assesment/Utils/helpers/date_formator.dart';

class HotelFilter {
  DateTime? checkIn;
  DateTime? checkOut;
  int rooms;
  int adults;
  int children;
  List<String> accommodation;
  double lowPrice;
  double highPrice;
  String searchType ;
  List<String>? searchQuery ;
  List<String> preloaderList ;
  List<String> arrayOfExcludedSearchType ;

  int limit;
  int rid ;
  String currency;

  HotelFilter({
    this.checkIn,
    this.checkOut,
    required this.arrayOfExcludedSearchType,
    required this.rid,
    required this.preloaderList,
    this.searchQuery,
    required this.searchType,
    this.rooms = 1,
    this.adults = 2,
    this.children = 0,
    this.accommodation = const ["all"],
    this.lowPrice = 0,
    this.highPrice = 10000,
    this.limit = 10,
    this.currency = "INR",
  });

  Map<String, dynamic> toJson() {
    return {
      "checkIn": formatDate(checkIn!),
      "checkOut": formatDate(checkOut!),
      "rooms": rooms,
      "adults": adults,
      "children": children,
      "accommodation": accommodation,
      "searchQuery" : searchQuery ?? ["qyhZqzVt"],
      "searchType" : searchType,
      "preloaderList": [],
      "rid": rid ,
      "lowPrice": lowPrice,
      "highPrice": highPrice,
      "limit": limit,
      "currency": currency,
    };
  }
}
