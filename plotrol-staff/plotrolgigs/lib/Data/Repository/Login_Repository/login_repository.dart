import '../../../Modal/Request/login_request.dart';
import '../../../Modal/Response/login_response.dart';
import '../../../helper/api_constants.dart';
import '../../Provider/Login_Provider/login_provider.dart';


class LoginRepository {

  LoginProvider loginProvider = LoginProvider();

  Future<LoginResponse?> signIn(LoginRequest data) async {

    return await loginProvider.signIn(ApiConstants.login,data);
  }
}