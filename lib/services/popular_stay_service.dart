import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Constants/prefs.dart';
import '../Constants/webservices.dart';
import '../Models/popular_stays_model.dart';
import '../Utils/shared_preferences.dart';

class PopularStayService {
  static Future<List<PopularStay>> fetchPopularStays() async {
    final url = Uri.parse(Webservices.baseUrl);

    final payload = {
      "action": "popularStay",
      "popularStay": {
        "limit": 10,
        "entityType": "Any",
        "filter": {
          "searchType": "byCity",
          "searchTypeInfo": {
            "country": "India",
            "state": "Jharkhand",
            "city": "Jamshedpur"
          }
        },
        "currency": SessionManager.getString(Prefs.currency)
      }
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "authToken": SessionManager.getString(Prefs.authToken),
        'visitortoken': SessionManager.getString(Prefs.visitorToken),


      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse["status"] == true) {
        final List stays = jsonResponse["data"];
        return stays.map((e) => PopularStay.fromJson(e)).toList();
      } else {
        throw Exception(jsonResponse["message"] ?? "Unknown error");
      }
    } else {
      throw Exception("Failed to fetch popular stays");
    }
  }
}
