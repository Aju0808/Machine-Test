import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:machine_task/bloc/user_bloc.dart';
import 'package:machine_task/bloc/user_event.dart';
import 'package:machine_task/bloc/user_state.dart';
import 'package:machine_task/constants/color_constants.dart';
import 'package:machine_task/model/user_response_model.dart';
import 'package:machine_task/view/userList/widgets/reusabel_textform_field.dart';

class EditUserDerailsView extends StatefulWidget {
  final int userId;
  const EditUserDerailsView({super.key, required this.userId});

  @override
  State<EditUserDerailsView> createState() => _EditUserDerailsViewState();
}

class _EditUserDerailsViewState extends State<EditUserDerailsView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _genderController;
  late final TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _genderController = TextEditingController();
    _statusController = TextEditingController();

    // Load user data
    context.read<UserBloc>().add(LoadUserById(widget.userId));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is SingleUserLoaded) {
            _nameController.text = state.user?.name ?? '';
            _emailController.text = state.user?.email ?? '';
            _genderController.text = state.user?.gender ?? '';
            _statusController.text = state.user?.status ?? '';
          }
        },
        builder: (context, state) {
          if (state is UserDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildEditForm(context,
              user: state.user ?? UserResponseModel());
        },
      ),
    );
  }

  Widget _buildEditForm(BuildContext context,
      {required UserResponseModel user}) {
    return Stack(
      children: [
        Column(
          children: [
            _buildAppBar(context),
            SizedBox(height: 70.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildFormField('Name', _nameController),
                  _buildFormField('Email', _emailController),
                  _buildFormField('Gender', _genderController),
                  _buildFormField('Status', _statusController),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
                fixedSize: Size(390.w, 50.h),
              ),
              child: const Text('Update Details',
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20.h),
          ],
        ),
        _buildProfileIcon(user.name ?? ""),
      ],
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return ReusabelTextformField(title: label, controller: controller);
  }

  void _submitForm() {
    final updatedUser = UserResponseModel(
      id: widget.userId,
      name: _nameController.text,
      email: _emailController.text,
      gender: _genderController.text,
      status: _statusController.text,
    );
    context.read<UserBloc>().add(UpdateUser(updatedUser));
    Navigator.pop(context);
  }
}

// Add these helper methods in your edit view file
Widget _buildAppBar(BuildContext context) {
  return Container(
    alignment: Alignment.centerLeft,
    height: 167.h,
    color: ColorConstants.primary,
    child: Row(
      children: [
        SizedBox(width: 12.w),
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 56.h,
        child: AvatarPlus(image, height: 105.h, width: 105.w),
      ),
    ),
  );
}
