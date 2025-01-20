import 'package:plotrol/data/provider/adding_properties/adding_properties_provider.dart';
import 'package:plotrol/model/request/adding_properties_request/adding_properties_request.dart';
import 'package:plotrol/model/response/adding_properties/adding_properties_response.dart';

import '../../../helper/api_constants.dart';

class AddPropertiesRepository {

  AddingPropertiesProvider addingPropertiesProvider = AddingPropertiesProvider();

  Future<AddYourPropertiesResponse?> addProperties(AddYourPropertiesRequest data) async {

    return await addingPropertiesProvider.addProperties(ApiConstants.addProperties ,data);
  }
}