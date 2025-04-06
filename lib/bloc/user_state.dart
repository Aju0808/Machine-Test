import 'package:machine_task/model/user_list_response_model.dart';
import 'package:machine_task/model/user_response_model.dart';

abstract class UserState {
  final List<UserListResponseModel>? items;
  final UserResponseModel? user;
  final String? error;

  UserState({this.items, this.user, this.error});
}

class UserInitial extends UserState {}

class UserDetailsLoading extends UserState {}

class UserLoaded extends UserState {
  UserLoaded(List<UserListResponseModel> items) : super(items: items);
}

class SingleUserLoaded extends UserState {
  SingleUserLoaded(UserResponseModel user, List<UserListResponseModel> items)
      : super(user: user, items: items);
}

class UserFetcingError extends UserState {
  UserFetcingError(String message) : super(error: message);
}
