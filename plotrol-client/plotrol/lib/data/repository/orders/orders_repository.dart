import 'package:plotrol/helper/api_constants.dart';
import 'package:plotrol/model/response/orders/get_orders_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/orders/orders_provider.dart';

class GetOrdersRepository {

  GetOrderProvider getOrderProvider = GetOrderProvider();

  int? tenantId;

  Future<GetOrders?> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tenantId = prefs.getInt('tenantId');
    return await getOrderProvider.getOrders('${ApiConstants.getOrders}/?tenantid=$tenantId');
  }
}