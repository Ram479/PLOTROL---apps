import 'dart:convert';
import 'package:http/http.dart';
import '../../../Helper/Logger.dart';
import '../../../model/response/adding_properties/get_properties_response.dart';

class GetPropertiesProvider {

  Future<GetProperties?> getProperties(String urlData) async {
    GetProperties? getProperties;

    try {
      final url = Uri.parse(urlData);
      logger.i('Url : $url');
      final response = await get(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Authorization': '$token',
          }
      );
      logger.i("addYourProperties Response Data ${response.body}");

      Map<String, dynamic> parsedJson = json.decode(response.body.toString());

      getProperties = GetProperties.fromJson(parsedJson);
      print('Add Your properties result $getProperties');
    } catch (e) {
      print(e.toString());
      print("errror ${e}");
    }
    return getProperties;
  }
}