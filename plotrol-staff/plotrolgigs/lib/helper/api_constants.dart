class ApiConstants {

  static String mainDev = 'dev';

  static String mainLive = 'live';

  ///authentication

  static String login = '';

  static String createAccount = '';

  static String bookService = '';

  static String getCategories = '';

  static String addProperties = '';

  static String getProperties = '';

  static int tenantId = 0;

  static int userId = 0;

  static String getOrders = '';

  static String updateOrders = '';

  static String status = '';

  static String createNotification = '';

  static String editProfile = '';

  static String getRider = '';
  /// authentication

  static String loginDev = 'https://api.plotrol.io/$mainDev/api/v1/users/staff/login';

  static String loginLive = 'https://api.plotrol.io/$mainLive/api/v1/users/staff/login';

  static String createAccountLive = 'https://api.plotrol.io/$mainLive/api/v1/partners/createstaff';

  static String createAccountDev = 'https://api.plotrol.io/$mainDev/api/v1/partners/createstaff';

  static String bookServicesLive = 'https://api.plotrol.io/$mainLive/api/v1/orders/createorders';

  static String bookYourServiceDev = 'https://api.plotrol.io/$mainDev/api/v1/orders/createorders';

  static String getCategoriesLive = 'https://api.plotrol.io/$mainLive/api/v1/utils/getservicecategory';

  static String addPropertiesLive = 'https://api.plotrol.io/$mainLive/api/v1/tenants/createlocation';

  static String addPropertiesDev = 'https://api.plotrol.io/$mainDev/api/v1/tenants/createlocation';

  static String getPropertiesLive = 'https://api.plotrol.io/$mainLive/api/v1/tenants/gettenantlocations/?tenantid=$tenantId';

  static String getPropertiesDev = 'https://api.plotrol.io/$mainDev/api/v1/tenants/gettenantlocations/?tenantid=$tenantId';

  static String getOrderLive = 'https://api.plotrol.io/$mainLive/api/v1/orders/staff/getorders/';

  static String getOrderDev = 'https://api.plotrol.io/$mainDev/api/v1/orders/staff/getorders/?userid=$userId&status=$status';

  static String updateOrderLive = 'https://api.plotrol.io/$mainLive/api/v1/orders/updateorderstatus';

  static String updateOrderDev = 'https://api.plotrol.io/$mainDev/api/v1/orders/updateorderstatus';

  static String createNotificationLive = 'https://api.plotrol.io/$mainLive/api/v1/utils/notifyuser';

  static String createNotificationDev = 'https://api.plotrol.io/$mainDev/api/v1/utils/notifyuser';

  static String editProfileDev = 'https://api.plotrol.io/$mainDev/api/v1/partners/updaterider';

  static String editProfileLive = 'https://api.plotrol.io/$mainLive/api/v1/partners/updaterider';

  static String getRiderDev = "https://api.plotrol.io/$mainDev/api/v1/partners/getriderdetail/?userid=$userId";

  static String getRiderLive = "https://api.plotrol.io/$mainLive/api/v1/partners/getriderdetail/";

}