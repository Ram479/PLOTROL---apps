import 'dart:convert';
import 'package:http/http.dart';
import 'package:plotrolgigs/Modal/Request/update_orders.dart';
import 'package:plotrolgigs/Modal/Response/update_order_response.dart';
import '../../../Helper/Logger.dart';

class UpdateOrdersProvider {

  Future<UpdateOrdersResponse?> updateOrders(String urlData, UpdateOrdersRequest data) async {
    UpdateOrdersResponse? updateOrdersResponse;
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
      logger.i("updateOrders  ${json.encode(data)}");
      logger.i("update Orders Response ${response.body}");

      Map<String, dynamic> parsedJson = json.decode(response.body.toString());

      updateOrdersResponse = UpdateOrdersResponse.fromJson(parsedJson);
      logger.i('update Order Result : $updateOrdersResponse');
    } catch (e) {
      logger.i(e.toString());
      logger.i("error");
    }
    return updateOrdersResponse;
  }
}

