import 'package:machine_task/model/user_response_model.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {}

class LoadMoreUser extends UserEvent {
  final int page;
  LoadMoreUser(this.page);
}

class AddUser extends UserEvent {
  final UserResponseModel item;
  AddUser(this.item);
}

class UpdateUser extends UserEvent {
  final UserResponseModel item;
  UpdateUser(this.item);
}

class DeleteUser extends UserEvent {
  final int id;
  DeleteUser(this.id);
}

class LoadUserById extends UserEvent {
  final int id;
  LoadUserById(this.id);
}
