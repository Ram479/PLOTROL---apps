import 'dart:convert';
import 'package:http/http.dart';
import 'package:plotrol/model/request/adding_properties_request/adding_properties_request.dart';
import 'package:plotrol/model/response/adding_properties/adding_properties_response.dart';
import '../../../Helper/Logger.dart';

class AddingPropertiesProvider {

  Future<AddYourPropertiesResponse?> addProperties(String urlData, AddYourPropertiesRequest data) async {
    AddYourPropertiesResponse? addYourPropertiesResponse;

    try {
      final url = Uri.parse(urlData);
      print('Url : $url');
      final response = await post(url,
          body: json.encode(data),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }
      );
      logger.i("addyourPropertiesData ${json.encode(data)}");
      logger.i("addYourProperties Response Data ${response.body}");

      Map<String, dynamic> parsedJson = json.decode(response.body.toString());

      addYourPropertiesResponse = AddYourPropertiesResponse.fromJson(parsedJson);
      print('Add Your properties result $addYourPropertiesResponse');
    } catch (e) {
      print(e.toString());
      print("errror");
    }
    return addYourPropertiesResponse;
  }
}