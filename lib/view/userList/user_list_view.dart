import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:machine_task/bloc/user_bloc.dart';
import 'package:machine_task/bloc/user_event.dart';
// import 'package:machine_task/bloc/user_event.dart';
import 'package:machine_task/bloc/user_state.dart';
import 'package:machine_task/constants/color_constants.dart';
import 'package:machine_task/constants/image_constants.dart';
import 'package:machine_task/controller/user_controller.dart';
import 'package:machine_task/view/userList/widgets/custom_Icon_button.dart';
import 'package:machine_task/view/userList/widgets/user_details_edit_view.dart';
import 'package:machine_task/view/userList/widgets/view_user_details.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  late final UserController userController;
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //           _scrollController.position.maxScrollExtent - 100 &&
  //       !isLoadingMore) {
  //     isLoadingMore = true;
  //     _currentPage++;
  //     userController.loadMoreItems(_currentPage).then((_) {
  //       isLoadingMore = false;
  //     });
  //   }
  // }

  void loadMoreUser() {
    if (!isLoadingMore) {
      isLoadingMore = true;
      _currentPage++;
      userController.loadMoreItems(_currentPage).then((_) {
        isLoadingMore = false;
      });
    }
  }

  @override
  void initState() {
    // print("init state");
    super.initState();

    userController = UserController(context.read<UserBloc>());
    // print("init state");
    // _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 45.h),
                      Text(
                        "No of Users",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                                color: ColorConstants.titleTextColor,
                                fontSize: 16.sp),
                      ),
                      SizedBox(height: 10.h),
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserDetailsLoading) {
                            return const Expanded(
                                child:
                                    Center(child: CircularProgressIndicator()));
                          } else if (state.items != null) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 615.h,
                                  child: ListView.separated(
                                    // controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount: state.items?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final userDetails = state.items?[index];
                                      return UserListItem(
                                        userId: userDetails?.id ?? 0,
                                        name: userDetails?.name ?? "",
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 20.h),
                                  ),
                                ),
                                // Spacer(),
                                SizedBox(height: 20.h),
                                _buildLoadMoreButton(context,
                                    onPressed: loadMoreUser)
                              ],
                            );
                          } else if (state.error != null) {
                            return Center(child: Text(state.error ?? ""));
                          } else {
                            return const Text("No data");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBackgroundContainer(context, onPressed: () {
            // userController.loadItems();
          })
        ],
      ),
    );
  }
}

Widget _buildLoadMoreButton(
  BuildContext context, {
  required void Function()? onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: 105.w,
      height: 40.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: ColorConstants.primary.withOpacity(0.3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Load More",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: ColorConstants.primary, fontSize: 12.sp)),
        ],
      ),
    ),
  );
}

class UserListItem extends StatelessWidget {
  const UserListItem({super.key, required this.name, required this.userId});

  static const Map<String, String> _actionIcons = {
    "Edit": ImageConstants.editIcon,
    "View": ImageConstants.viewIcon,
    "Delete": ImageConstants.deleteIcon,
  };

  final String name;
  final int userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: 1.w,
          ),
        ),
      ),
      height: 101.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarPlus(name, height: 45.h, width: 45.w),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: ColorConstants.titleTextColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Row(
                  children: _actionIcons.entries
                      .map(
                        (entry) => Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: CustomIconButton(
                            icon: entry.value,
                            label: entry.key,
                            onPressed: () async {
                              switch (entry.key) {
                                case "View":
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value:
                                            BlocProvider.of<UserBloc>(context),
                                        child:
                                            ViewUserDetailsView(userId: userId),
                                      ),
                                    ),
                                  );
                                  break;
                                case "Edit":
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider.value(
                                          value: BlocProvider.of<UserBloc>(
                                              context),
                                          child: EditUserDerailsView(
                                              userId: userId),
                                        ),
                                      ));
                                  break;
                                case "Delete":
                                  bool confirmed =
                                      await shwoConfirmDialog(context);
                                  if (confirmed) {
                                    context
                                        .read<UserBloc>()
                                        .add(DeleteUser(userId));
                                  }
                                  break;
                              }
                            },
                          ),
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> shwoConfirmDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

Widget _buildAppBar(BuildContext context) {
  return Container(
    color: ColorConstants.primary,
    height: 136.h,
  );
}

Widget _buildBackgroundContainer(BuildContext context,
    {void Function()? onPressed}) {
  return Positioned(
    right: 0,
    left: 0,
    top: 100.h,
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 5)),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      height: 74.h,
      width: double.infinity,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorConstants.avatarBackgroundColor,
            radius: 24.r,
            child: Icon(Icons.group_outlined, color: ColorConstants.primary),
          ),
          SizedBox(width: 10.w),
          Text("User List", style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          TextButton(
            onPressed: onPressed,
            child: Row(
              children: [
                Icon(Icons.refresh, color: ColorConstants.primary, size: 20.h),
                SizedBox(width: 5.w),
                Text(
                  "Load User Data",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: ColorConstants.primary, fontSize: 12.sp),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
