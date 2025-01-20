import '../../../Modal/Request/create_staff_request.dart';
import '../../../Modal/Response/create_staff_response.dart';
import '../../../helper/api_constants.dart';
import '../../Provider/Create_Account/create_account_provider.dart';


class CreateAccountRepository {

  CreateAccountProvider createAccountProvider = CreateAccountProvider();

  Future<CreateAccountResponse?> createNewUser(CreateAccountRequest data) async {

    return await createAccountProvider.createNewUser(ApiConstants.createAccount, data);
  }
}