import 'package:plotrolgigs/Data/Provider/Edit_Profile/edit_profile.dart';
import 'package:plotrolgigs/Data/Provider/orders/update_orders_provider.dart';
import 'package:plotrolgigs/Modal/Request/edit_profile.dart';
import 'package:plotrolgigs/Modal/Request/update_orders.dart';
import 'package:plotrolgigs/Modal/Response/edit_profile.dart';
import 'package:plotrolgigs/Modal/Response/update_order_response.dart';
import '../../../helper/api_constants.dart';

class EditProfileRepository {

  EditProfileProvider editProfileProvider = EditProfileProvider();

  Future<EditStaffResponse?> editStaff(EditStaffRequest data) async {

    return await editProfileProvider.editStaff(ApiConstants.editProfile ,data);
  }
}