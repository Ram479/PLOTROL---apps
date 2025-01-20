import 'package:plotrol/model/request/book_service/book_service.dart';
import 'package:plotrol/model/response/book_service/book_service.dart';
import '../../../helper/api_constants.dart';
import '../../provider/book_your_service/book_your_service_provider.dart';

class BookServiceRepository {

  BookServiceProvider  addYourPropertiesProvider = BookServiceProvider();

  Future<BookServiceResponse?> bookService(BookServiceRequest data) async {

    return await addYourPropertiesProvider.bookService(ApiConstants.bookService ,data);
  }
}