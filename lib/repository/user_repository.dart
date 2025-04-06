import 'package:machine_task/model/user_list_response_model.dart';
import 'package:machine_task/model/user_response_model.dart';
import 'package:machine_task/services/api_services.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  Future<List<UserListResponseModel>> getUser({int page = 1, int limit = 10}) =>
      _apiService.fetchUser(page: page, limit: limit);
  Future<UserResponseModel> createUser(UserResponseModel item) =>
      _apiService.createUser(item);
  Future<UserResponseModel> updateUser(UserResponseModel item) =>
      _apiService.updateUser(item);
  Future<void> deleteUser(int id) => _apiService.deleteUser(id);

  Future<UserResponseModel> getUserById(int id) =>
      _apiService.fetchUserById(id);
}
