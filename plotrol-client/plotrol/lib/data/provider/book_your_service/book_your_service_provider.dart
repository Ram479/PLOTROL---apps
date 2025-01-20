import 'dart:convert';
import 'package:http/http.dart';
import 'package:plotrol/model/request/book_service/book_service.dart';
import 'package:plotrol/model/response/book_service/book_service.dart';
import '../../../Helper/Logger.dart';

class BookServiceProvider {

  Future<BookServiceResponse?> bookService(String urlData, BookServiceRequest data) async {
    BookServiceResponse? bookServiceResponse;

    try {
      final url = Uri.parse(urlData);
      https://api.plotrol.io/live/api/v1/
      print('Url : $url');
      final response = await post(url,
          body: json.encode(data),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Authorization': '$token',
          }
      );
      logger.i("addyourPropertiesData ${json.encode(data)}");
      logger.i("addYourProperties Response Data ${response.body}");

      Map<String, dynamic> parsedJson = json.decode(response.body.toString());

      bookServiceResponse = BookServiceResponse.fromJson(parsedJson);
      print('Add Your properties result $bookServiceResponse');
    } catch (e) {
      print(e.toString());
      print("errror");
    }
    return bookServiceResponse;
  }
}