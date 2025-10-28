import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mytravaly_flutter_assesment/Constants/prefs.dart';
import 'package:mytravaly_flutter_assesment/Utils/shared_preferences.dart';
import '../Constants/webservices.dart';
import '../models/hotel_model.dart';

class SearchService {
  static Future<List<HotelModel>> searchHotels(
    String query, {
    int limit = 10,
  }) async {
    try {
      final url = Uri.parse(Webservices.baseUrl);
      final body = {
        "action": "searchAutoComplete",
        "searchAutoComplete": {
          "inputText": query,
          "searchType": [
            "byCity",
            "byState",
            "byCountry",
            "byRandom",
            "byPropertyName",
          ],
          "limit": limit,
        },
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authToken': SessionManager.getString(Prefs.authToken),
          'visitortoken': SessionManager.getString(Prefs.visitorToken),
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == true) {
          final autoCompleteList = jsonResponse['data']['autoCompleteList'];

          List<HotelModel> hotels = [];

          for (var item in autoCompleteList.values) {
            if (item['present'] == true && item['listOfResult'] != null) {
              for (var h in item['listOfResult']) {
                hotels.add(HotelModel.fromJson(h));
              }
            }
          }

          return hotels;
        }
      }
      return [];
    } catch (e) {
      print('Search API Error: $e');
      return [];
    }
  }
}
