import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:machine_task/bloc/user_bloc.dart';
import 'package:machine_task/bloc/user_event.dart';
import 'package:machine_task/bloc/user_state.dart';
import 'package:machine_task/constants/color_constants.dart';
import 'package:machine_task/model/user_response_model.dart';
import 'package:machine_task/view/userList/widgets/user_details_edit_view.dart';

class ViewUserDetailsView extends StatefulWidget {
  final int userId;
  const ViewUserDetailsView({super.key, required this.userId});

  @override
  State<ViewUserDetailsView> createState() => _ViewUserDetailsViewState();
}

class _ViewUserDetailsViewState extends State<ViewUserDetailsView> {
  @override
  void initState() {
    final bloc = context.read<UserBloc>();
    bloc.add(LoadUserById(widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SingleUserLoaded) {
            final user = state.user;
            return _buildUserDetailContent(user ?? UserResponseModel());
          } else if (state is UserFetcingError) {
            return Center(child: Text("Error: ${state.error}"));
          } else {
            return const Center(child: Text("No data"));
          }
        },
      ),
    );
  }

  Widget _buildUserDetailContent(UserResponseModel user) {
    return Stack(
      children: [
        Column(
          children: [
            _buildAppBar(context),
            SizedBox(height: 70.h),
            Text(
              user.name ?? '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: ColorConstants.titleTextColor, fontSize: 24.sp),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              height: 220.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUserDetailsSection(
                    context,
                    icon: Icons.mail,
                    title: "Email",
                    subtitle: user.email ?? '',
                  ),
                  _buildUserDetailsSection(
                    context,
                    icon: Icons.person,
                    title: "Gender",
                    subtitle: user.gender ?? '',
                  ),
                  _buildUserDetailsSection(
                    context,
                    icon: Icons.verified_user,
                    title: "Status",
                    subtitle: user.status ?? '',
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primary,
                  fixedSize: Size(390.w, 50.h),
                  shape: const RoundedRectangleBorder()),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditUserDerailsView(
                    userId: user.id ?? 0,
                  );
                }));
              },
              child: const Text(
                "Edit Details",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
        _buildProfileIcon(user.name ?? ''),
      ],
    );
  }
}

Widget _buildAppBar(BuildContext context) {
  return Container(
    alignment: Alignment.centerLeft,
    height: 167.h,
    color: ColorConstants.primary,
    child: Row(
      children: [
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, size: 30.w, color: Colors.white),
        ),
        SizedBox(width: 5.w),
        const Text("Back", style: TextStyle(color: Colors.white)),
      ],
    ),
  );
}

Widget _buildProfileIcon(String image) {
  return Positioned(
    top: 115.h,
    left: 0.h,
    right: 0.w,
    child: Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 12,
                offset: const Offset(0, 5)),
          ]),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 56.h,
        child: AvatarPlus(image, height: 105.h, width: 105.w),
      ),
    ),
  );
}

Widget _buildUserDetailsSection(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
}) {
  return ListTile(
    minLeadingWidth: 0,
    minTileHeight: 0,
    contentPadding: EdgeInsets.zero,
    minVerticalPadding: 0,
    leading: CircleAvatar(
      backgroundColor: ColorConstants.avatarBackgroundColor,
      child: Icon(icon, color: ColorConstants.primary, size: 20.h),
    ),
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 12.sp),
    ),
    subtitle: Text(subtitle),
  );
}
