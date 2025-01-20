import 'dart:convert';
import 'package:http/http.dart';
import 'package:plotrolgigs/Modal/Response/get_rider_detais.dart';
import '../../../Helper/Logger.dart';

class GetRiderProvider {

  Future<GetRiderDetails?> getRider(String urlData) async {
    GetRiderDetails? getRiderDetails;

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

      getRiderDetails = GetRiderDetails.fromJson(parsedJson);
      print('Rider Details $getRiderDetails');
    } catch (e) {
      print(e.toString());
      print("errror ${e}");
    }
    return getRiderDetails;
  }
}