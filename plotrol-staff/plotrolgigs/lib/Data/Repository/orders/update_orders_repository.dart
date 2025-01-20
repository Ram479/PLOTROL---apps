import 'package:plotrolgigs/Data/Provider/orders/update_orders_provider.dart';
import 'package:plotrolgigs/Modal/Request/update_orders.dart';
import 'package:plotrolgigs/Modal/Response/update_order_response.dart';
import '../../../helper/api_constants.dart';

class UpdateOrderRepository {

  UpdateOrdersProvider updateOrdersProvider = UpdateOrdersProvider();

  Future<UpdateOrdersResponse?> updateOrders(UpdateOrdersRequest data) async {

    return await updateOrdersProvider.updateOrders(ApiConstants.updateOrders,data);
  }
}