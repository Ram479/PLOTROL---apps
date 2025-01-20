import 'package:shared_preferences/shared_preferences.dart';

import '../../../Modal/Response/get_orders.dart';
import '../../../helper/api_constants.dart';
import '../../Provider/orders/get_order_provider.dart';

class GetOrdersRepository {

  GetOrderProvider getOrderProvider = GetOrderProvider();

  int? userId;

  Future<GetOrders?> getOrders() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    return await getOrderProvider.getOrders('${ApiConstants.getOrders}?userid=$userId');
  }
}