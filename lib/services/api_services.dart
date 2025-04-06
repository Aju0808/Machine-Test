import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:machine_task/model/user_list_response_model.dart';
import 'package:machine_task/model/user_response_model.dart';
import '../utils/error_handler.dart';

class ApiService {
  final baseUrl = 'https://gorest.co.in/public/v2/users';
  final token =
      '090a4d13b368ea5cbc5c1f05cd08a2b0cb5cd4234b51f1b2aa2a8e6a4edaf183';

  Future<List<UserListResponseModel>> fetchUser(
      {int page = 2000, int limit = 10}) async {
    final response = await http.get(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
      Uri.parse("$baseUrl?page=$page&per_page=5"),
    );
    print(response.request!.url);
    ErrorHandler.checkForError(response);
    return (jsonDecode(response.body) as List)
        .map((e) => UserListResponseModel.fromJson(e))
        .toList();
  }

  Future<UserResponseModel> createUser(UserResponseModel item) async {
    final response = await http
        .post(Uri.parse(baseUrl), body: jsonEncode(item.toJson()), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token",
    });
    ErrorHandler.checkForError(response);
    return UserResponseModel.fromJson(jsonDecode(response.body));
  }

  Future<UserResponseModel> updateUser(UserResponseModel item) async {
    final response = await http.put(Uri.parse('$baseUrl/${item.id}'),
        body: jsonEncode(item.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        });
    ErrorHandler.checkForError(response);
    return UserResponseModel.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        Uri.parse(
          '$baseUrl/$id',
        ));
    ErrorHandler.checkForError(response);
  }

  Future<UserResponseModel> fetchUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token",
    });
    print(response.request!.url);
    print(response.body);
    ErrorHandler.checkForError(response);
    return UserResponseModel.fromJson(jsonDecode(response.body));
  }
}
