import 'dart:convert';
import 'package:http/http.dart';
import '../../../helper/Logger.dart';
import '../../../model/request/autentication_request/autentication_request.dart';
import '../../../model/response/autentication_response/autentication_response.dart';

class LoginProvider {

  Future<LoginResponse?> signIn(String urldata, LoginRequest data) async {
    LoginResponse? loginResponse;

    try {
      final url = Uri.parse(urldata);
      final response = await post(url,
          body: json.encode(data),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Authorization': '$token',
          }
      );
       logger.i("signInDataBody ${json.encode(data)}");
       logger.i("responseeeeeedata ${response.body}");

      Map<String, dynamic> parsedJson = json.decode(response.body.toString());

      loginResponse = LoginResponse.fromJson(parsedJson);
      print('provider result$loginResponse');
    } catch (e) {
      print(e.toString());
      print("errror");
    }
    return loginResponse;
  }
}






