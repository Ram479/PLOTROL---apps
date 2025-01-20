import 'dart:convert';
import 'package:http/http.dart';
import 'package:plotrol/model/response/get_tenant_details/get_details_response.dart';
import '../../../Helper/Logger.dart';

class GetTenantProvider {

  Future<GetTenantDetails?> getTenant(String urlData) async {
    GetTenantDetails? getTenantDetails;

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
      logger.i("Rider details Response : ${response.body}");

      Map<String, dynamic> parsedJson = json.decode(response.body.toString());

      getTenantDetails = GetTenantDetails.fromJson(parsedJson);
      print('Rider Details $getTenantDetails');
    } catch (e) {
      print(e.toString());
      print("errror ${e}");
    }
    return getTenantDetails;
  }
}