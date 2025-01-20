import 'dart:convert';
import 'package:http/http.dart';
import 'package:plotrolgigs/Modal/Response/createNotification_response.dart';
import '../../../Helper/Logger.dart';
import '../../../Modal/Request/createNotification_request.dart';

class CreateNotificationProvider {
  Future<CreateNotificationResponse?> createNotification(String urlData, CreateNotificationRequest data) async {
    CreateNotificationResponse? createNotificationResponse;

    try {
      final url = Uri.parse(urlData);
      final response = await post(url,
          body: json.encode(data),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }
      );
      logger.i("CreateNotification ${json.encode(data)}");
      logger.i("CreateNotificationResponse ${response.body}");

      Map<String, dynamic> parsedJson = json.decode(response.body.toString());

      createNotificationResponse = CreateNotificationResponse.fromJson(parsedJson);
      logger.i('provider result $createNotificationResponse');
    } catch (e) {
      logger.i(e.toString());
      logger.i("errror");
    }
    return createNotificationResponse;
  }
}