import 'dart:convert';

import 'package:http/http.dart';
import 'package:jiffy/jiffy.dart';

class NetworkService {

  final baseUrl = "https://api.covid19api.com/total/country";

  Future<List<dynamic>> fetchByCountry(String countryName, String type) async {
      DateTime now =  DateTime.now();
      now = now.subtract(Duration(hours: now.hour, minutes: now.minute, seconds: now.second, milliseconds: now.millisecond, microseconds: now.microsecond));
      DateTime from = DateTime.now();
      switch(type) {
        case 'All time':
          from = DateTime(2020, 1, 1);
          break;
        case '2 weeks':
          from = now.subtract(Duration(days: 14));
          break;
        case '30 days':
          from = now.subtract(Duration(days: 30));
          break;
        case '3 months':
          from = Jiffy(now)
              .subtract(months: 3)
              .dateTime;
          break;
        case '6 months':
          from = Jiffy(now)
              .subtract(months: 6)
              .dateTime;
          break;
        default:
          from = DateTime(2020, 1, 1);
          break;
      }
      try {
        final response = await get(Uri.parse(baseUrl +
            "/${countryName.replaceAll(" ", "-")}?from=$from&to=$now"));
        return jsonDecode(response.body) as List;
      }
      catch(e){
        throw e;
    }
  }

}