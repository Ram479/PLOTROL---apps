import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

import 'Helper/Logger.dart';


class PushNotificationService {

  static Future<String>  getAccessToken() async {
    final serviceAccountJson = {
        "type": "service_account",
        "project_id": "plotrol",
        "private_key_id": "1cc23fb12f3793ebf0b6d4bf78a0417bfd97bd5e",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCbjRZ2YFEU7nTc\nHSQrdA1hA01naGdZgwjyvpNFJJQHIhtRGlerpFIcO0EtPnWXTSVz2jR5b9a6nKtM\nPfbF8ADa6MW6sFG34PEfF4QcO2eM5skim8ESmuECkNKJejb71MmD8o+1XfCcEl9h\nJ3yAFWGxGsY2xnMFgDWB79ECPkyogs34pvk4vPPqttfKukL5KNksy49rU91aFthh\nO4OOKJGugG3FP09l+xurSCfCcYaeHdEjqdg3kiORBE5Ge3FAAHuCmmmhh3/9mTKI\nH3Gf983qUHJulv771QrMXsqGFHxTQNVwmDr1cQH6Jw0NBlLA4qjD2DSMCijLqK2h\n9xanZBcFAgMBAAECggEAGcOhr9O+OlBQzNCK2COtv57TaEhTrfDVP5evPumTFydg\nDOvnD4f1DbYG0p6gzYG6rVi8Dk0m7NvcR5GP2TMqgRfDAGwJ7QH2DidP+3kfaqgj\nMndH4HQExu8D4D988fNJuXAou2qm2sL0R1xJ89EW0EXWBOaT0JpuwmndXZjCC7r0\neLUpRaNi1YShTynlfkxb2Ckd7Asqujdzzvc6aJ8ydN+xZFFlLzjd2BvwGy6eF5I4\nxVS5WDh1VWodEvaF5/EzSHo4B5fDUhx3f1N9sfqni6ZxpYg8eWg7u3fAW8M35Z6N\nvkypHj2y2houX5ZpTlleGGuZM7x/69ZD1gP3jE3adQKBgQDTlw21De3YDQ/WmyPJ\n8nwJNQOFIbc0GnqoQzVYQSCO5MMS/poXLagQNc05DUAjvTqm4uLxzp2nrwzBQoAQ\n0FZp3mq+HrFWOW7R8HYC1l+gbjSAO/gliviT+0Kgl3Zbx+FkC6wW+e7YovH7wMRE\nuPynz3Lds4VAQ/FWeWsWKZz5kwKBgQC8MwGTuC1cgsAN8xFBz/DlFihysDjcWFhW\nXCqArVUalQzlVFEt7Eom9Tza9ymq/h+mH+nPuU8aRe1l+56H+ZQniNdKTc1MOZHZ\nCey3XeFAOgEr9FzQrRnBLtfqvVB5b1JAS/AXvrDOwr9r3UdXDSRHDNXvruaxqq+u\n+iOVgnwsBwKBgQCW12wFNB3oVT+CTe1QrdaxNaMByQxzT6E7zVX9ScitNfa/1tQB\nTCIxFDnuvzyHfgKPMNZ7bkHEZi3gpMjps6y3IsHUMctY3e7cKeHnme5oT8iL1rTM\nBuu5i3lvRSsyuSc8jHmtk5YryNZcFIuXNo2gEGsiFDYdn5IwhLTMAvSOkwKBgDnd\nHOEEQb4t3UrsryOjAZgOBgWtNO5ao156G/9QS9hOd5aTJBqQigQMZteUItWWKLj1\nGvhpK28SjPlMMePw0qKNKlSIM1T6ZmNq78M5NCaBLxcKnPb0IfUJqA1eg72ygoGO\nV5WVZdtMeXp6oJKdUcgepDB7gCakKjwMYKB5bCBFAoGAXJ/k3+HnCY/Dd3jfa4EN\n9vE4SBYDaTH3mlSXeYml4GizKUWt5KWIoPrZmXnF3zAmilHNi3RlYt0OBTLnk9wE\nzRCFnStKX95aSDEEv+oFGCrvixTdGNfJqlIaq574vIau92RJ3MOZRChunhntUkk1\nycs/Kmr37jS/uiChwDkY9xY=\n-----END PRIVATE KEY-----\n",
        "client_email": "plotrol@plotrol.iam.gserviceaccount.com",
        "client_id": "116755952372698587858",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/plotrol%40plotrol.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client
    );

    client.close();
    logger.i('Accesss token : ${credentials.accessToken.data}');
    return credentials.accessToken.data;
  }

  static sendNotificationToSelectTenant(String deviceToken, BuildContext context)  async {
      final String serverAccessKey = await getAccessToken();
      String endpointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/plotrol/messages:send';

      final Map<String, dynamic> message = {
        'message' :
            {
              'token' : deviceToken,
              'notification' :
                  {
                    'title' : 'Hi',
                    'body' : 'Hello'
                  },
            }
      };

      final http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudMessaging),
        headers: <String, String> {
          'Content-Type' : 'application/json',
          'Authorization' : 'Bearer $serverAccessKey'
        },
        body : jsonEncode(message),
      );

      if(response.statusCode == 200) {
        print(response.body);
        print('Fcm message is successful');
      }
      else {
        print('Fcm message unsuccessful');
      }

      print('The AccessToken : ${serverAccessKey}');
  }
}