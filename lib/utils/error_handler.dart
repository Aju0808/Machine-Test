import 'package:http/http.dart';

class ErrorHandler {
  static void checkForError(Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Network error: ${response.statusCode}');
    }
  }
}
