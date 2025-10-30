import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mytravaly_flutter_assesment/Constants/webservices.dart';
import 'package:mytravaly_flutter_assesment/Utils/enums/snackbar_type.dart';
import 'package:mytravaly_flutter_assesment/Utils/helpers/snackbar_message.dart';
import '../Constants/prefs.dart';
import '../Models/filtered_hotel_model.dart';
import '../Models/hotel_model.dart';
import '../Models/hotel_filter_model.dart';
import '../Utils/shared_preferences.dart';

class HotelService {
  static Future<List<FilteredHotelModel>?>? fetchHotels({HotelFilter? filter, required BuildContext context}) async {
    final url = Uri.parse(Webservices.baseUrl);
    final payload = {
      "action": "getSearchResultListOfHotels",
      "getSearchResultListOfHotels" :{
        "searchCriteria": filter?.toJson() ?? HotelFilter(arrayOfExcludedSearchType: [], rid: 0, preloaderList: [], searchType: "hotelIdSearch").toJson()
      }
    };


    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json",
        "authToken": SessionManager.getString(Prefs.authToken),
        'visitortoken': SessionManager.getString(Prefs.visitorToken),
      },
      body: jsonEncode(payload),
    );

    print(response.body);


    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);



        final data = jsonBody['data']['arrayOfHotelList'] as List<dynamic>;
        return data.map((e) => FilteredHotelModel.fromJson(e)).toList();




    }
    else if (response.statusCode == 400){

      showSnackBarMessage(context: context, message: jsonDecode(response.body)["message"] , type: SnackBarType.error);
      print(jsonDecode(response.body)["message"]);
      return null ;
    }
    else {
      throw Exception('Failed to load hotels');
    }
  }
}

