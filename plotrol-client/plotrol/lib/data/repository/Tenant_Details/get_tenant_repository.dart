import 'package:plotrol/model/response/get_tenant_details/get_details_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helper/api_constants.dart';
import '../../provider/Tenant_Details/get_tenant_provider.dart';

class GetTenantRepository {

  GetTenantProvider getTenantProvider = GetTenantProvider();

  int? tenantId;

  Future<GetTenantDetails?> getTenant() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    tenantId = prefs.getInt('tenantId');
    return await getTenantProvider.getTenant('${ApiConstants.getTenant}/?tenantid=$tenantId');

  }
}