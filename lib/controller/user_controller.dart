import 'package:machine_task/bloc/user_bloc.dart';
import 'package:machine_task/bloc/user_event.dart';
import 'package:machine_task/model/user_response_model.dart';

class UserController {
  final UserBloc itemBloc;

  UserController(this.itemBloc);

  void loadItems() => itemBloc.add(LoadUser());

  void getUserById(int id) {
    itemBloc.add(LoadUserById(id));
  }

  void addItem(String name) {
    final item = UserResponseModel(
      name: name,
      email: '',
      gender: '',
      status: '',
    );
    itemBloc.add(AddUser(item));
  }

  Future<void> loadMoreItems(int page) async {
    itemBloc.add(LoadMoreUser(page));
  }

  void updateItem(UserResponseModel user, String updatedName) {
    final updatedItem = UserResponseModel(id: user.id, name: updatedName);
    itemBloc.add(UpdateUser(updatedItem));
  }

  void deleteItem(int id) => itemBloc.add(DeleteUser(id));
}
