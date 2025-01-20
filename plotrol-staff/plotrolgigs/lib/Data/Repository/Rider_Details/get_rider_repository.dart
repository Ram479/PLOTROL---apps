import 'package:plotrolgigs/Modal/Response/get_rider_detais.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Modal/Response/get_orders.dart';
import '../../../helper/api_constants.dart';
import '../../Provider/Rider_Details/get_rirder_provider.dart';
import '../../Provider/orders/get_order_provider.dart';

class GetRiderRepository {

  GetRiderProvider getRiderProvider = GetRiderProvider();
  int? userId;

  Future<GetRiderDetails?> getRider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     userId = prefs.getInt('userId');
     return await getRiderProvider.getRider('${ApiConstants.getRider}?userid=$userId');
  }
}