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

  static String getOrders = '';

  static String editProfile  = '';

  static String getTenant = '';
  /// authentication

  static String loginDev = 'https://api.plotrol.io/$mainDev/api/v1/users/tenant/login';

  static String loginLive = 'https://api.plotrol.io/$mainLive/api/v1/users/tenant/login';

  static String createAccountLive = 'https://api.plotrol.io/$mainLive/api/v1/tenants/createtenantuser';

  static String createAccountDev = 'https://api.plotrol.io/$mainDev/api/v1/tenants/createtenantuser';

  static String bookServicesLive = 'https://api.plotrol.io/$mainLive/api/v1/orders/createorders';

  static String bookYourServiceDev = 'https://api.plotrol.io/$mainDev/api/v1/orders/createorders';

  static String getCategoriesLive = 'https://api.plotrol.io/$mainLive/api/v1/utils/getservicecategory';

  static String addPropertiesLive = 'https://api.plotrol.io/$mainLive/api/v1/tenants/createlocation';

  static String addPropertiesDev = 'https://api.plotrol.io/$mainDev/api/v1/tenants/createlocation';

  static String getPropertiesLive = 'https://api.plotrol.io/$mainLive/api/v1/tenants/gettenantlocations/';

  static String getPropertiesDev = 'https://api.plotrol.io/$mainDev/api/v1/tenants/gettenantlocations/';

  static String getOrderLive = 'https://api.plotrol.io/$mainLive/api/v1/orders/tenant/getorders/';

  static String getOrderDev = 'https://api.plotrol.io/$mainDev/api/v1/orders/tenant/getorders/';

  static String editProfileDev = 'https://api.plotrol.io/$mainDev/api/v1/tenants/update';

  static String editProfileLive = 'https://api.plotrol.io/$mainLive/api/v1/tenants/update';

  static String getTenantDev =  'https://api.plotrol.io/$mainDev/api/v1/tenants/gettenantinfo/';

  static String getTenantLive =  'https://api.plotrol.io/$mainLive/api/v1/tenants/gettenantinfo/';
}