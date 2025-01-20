import 'dart:convert';
import 'package:http/http.dart';
import 'package:plotrolgigs/Modal/Request/edit_profile.dart';
import 'package:plotrolgigs/Modal/Response/edit_profile.dart';
import '../../../Helper/Logger.dart';

class EditProfileProvider {

  Future<EditStaffResponse?> editStaff(String urlData, EditStaffRequest data) async {
    EditStaffResponse? editStaffResponse;
    try {
      final url = Uri.parse(urlData);
      print('Urlforupdate : ${url}');
      final response = await put(url,
          body: json.encode(data),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Authorization': '$token',
          }
      );
      logger.i("editProfile ${json.encode(data)}");
      logger.i("edit Response ${response.body}");

      Map<String, dynamic> parsedJson = json.decode(response.body.toString());

      editStaffResponse = EditStaffResponse.fromJson(parsedJson);
      logger.i('edit Result : $editStaffResponse');
    } catch (e) {
      logger.i(e.toString());
      logger.i("error");
    }
    return editStaffResponse;
  }
}
