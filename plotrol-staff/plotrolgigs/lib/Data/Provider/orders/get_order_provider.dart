import 'dart:convert';
import 'package:http/http.dart';
import '../../../Helper/Logger.dart';
import '../../../Modal/Response/get_orders.dart';

class GetOrderProvider {

  Future<GetOrders?> getOrders(String urlData) async {
    GetOrders? getOrders;

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
      logger.i("orders details Response : ${response.body}");

      Map<String, dynamic> parsedJson = json.decode(response.body.toString());

      getOrders = GetOrders.fromJson(parsedJson);
      print('Orders Details $getOrders');
    } catch (e) {
      print(e.toString());
      print("errror ${e}");
    }
    return getOrders;
  }
}