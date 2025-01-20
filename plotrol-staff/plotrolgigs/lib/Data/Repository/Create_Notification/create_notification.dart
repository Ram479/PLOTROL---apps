import 'package:plotrolgigs/Modal/Request/createNotification_request.dart';
import 'package:plotrolgigs/Modal/Response/createNotification_response.dart';
import '../../../helper/api_constants.dart';
import '../../Provider/Create_Notification/create_notification.dart';


class CreateNotificationRepository {

  CreateNotificationProvider createNotificationProvider = CreateNotificationProvider();

  Future<CreateNotificationResponse?> createNotification(CreateNotificationRequest data) async {

    return await createNotificationProvider.createNotification(ApiConstants.createNotification, data);
  }
}