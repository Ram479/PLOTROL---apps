import 'package:plotrol/data/provider/get_properties/get_properties_provider.dart';
import 'package:plotrol/helper/api_constants.dart';
import 'package:plotrol/model/response/adding_properties/get_properties_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetPropertiesRepository {

  GetPropertiesProvider getPropertiesProvider = GetPropertiesProvider();

  int? tenantId;

  Future<GetProperties?> getProperties() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tenantId = prefs.getInt('tenantId');
    return await getPropertiesProvider.getProperties('${ApiConstants.getProperties}/?tenantid=$tenantId');
  }
}