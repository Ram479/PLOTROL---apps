import 'package:plotrol/data/provider/autentication/login_provider.dart';

import '../../../helper/api_constants.dart';
import '../../../model/request/autentication_request/autentication_request.dart';
import '../../../model/response/autentication_response/autentication_response.dart';

class LoginRepository {

  LoginProvider loginProvider = LoginProvider();

  Future<LoginResponse?> signIn(LoginRequest data) async {

    return await loginProvider.signIn(ApiConstants.login,data);
  }
}