import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_task/bloc/user_event.dart';
import 'package:machine_task/bloc/user_state.dart';
import 'package:machine_task/model/user_list_response_model.dart';
import 'package:machine_task/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  List<UserListResponseModel> _items = [];

  int _currentPage = 1;

  UserBloc(this.repository) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserDetailsLoading());
      try {
        _currentPage = 1;
        final items = await repository.getUser();
        _items = items;
        emit(UserLoaded(_items));
      } catch (e) {
        emit(UserFetcingError(e.toString()));
      }
    });

    on<LoadMoreUser>((event, emit) async {
      emit(UserDetailsLoading());
      try {
        _currentPage = event.page;
        final newItems = await repository.getUser(page: _currentPage);
        _items = newItems;
        emit(UserLoaded(List.from(_items)));
      } catch (e) {
        emit(UserFetcingError(e.toString()));
      }
    });

    on<AddUser>((event, emit) async {
      try {
        await repository.createUser(event.item);
        add(LoadUser());
      } catch (e) {
        emit(UserFetcingError(e.toString()));
      }
    });

    on<UpdateUser>((event, emit) async {
      try {
        final updatedUser = await repository.updateUser(event.item);
        final index = _items.indexWhere((u) => u.id == updatedUser.id);
        if (index != -1) {
          _items[index] = UserListResponseModel(
            id: updatedUser.id,
            name: updatedUser.name,
            email: updatedUser.email,
            gender: updatedUser.gender,
            status: updatedUser.status,
          );
          emit(UserLoaded(List.from(_items)));
        }
      } catch (e) {
        // Handle error but keep current state
        emit(UserFetcingError(e.toString()));
        emit(UserLoaded(_items));
      }
    });

    on<DeleteUser>((event, emit) async {
      try {
        await repository.deleteUser(event.id);
        _items.removeWhere((item) => item.id == event.id);
        emit(UserLoaded(List.from(_items)));
      } catch (e) {
        emit(UserFetcingError(e.toString()));
        emit(UserLoaded(_items));
      }
    });

    on<LoadUserById>((event, emit) async {
      emit(UserDetailsLoading());
      try {
        final user = await repository.getUserById(event.id);
        emit(SingleUserLoaded(user, _items)); // Include existing items
      } catch (e) {
        emit(UserFetcingError(e.toString()));
      }
    });
  }
}
