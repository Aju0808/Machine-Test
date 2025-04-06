import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:machine_task/bloc/user_bloc.dart';
import 'package:machine_task/constants/app_text_style.dart';
import 'package:machine_task/repository/user_repository.dart';
import 'package:machine_task/view/userList/user_list_view.dart';

import 'bloc/user_event.dart';

void main() {
  runApp(BlocProvider(
      create: (context) => UserBloc(UserRepository())..add(LoadUser()),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final userRepository = UserRepository();
    return ScreenUtilInit(
      fontSizeResolver: (fontSize, instance) =>
          FontSizeResolvers.height(fontSize, instance),
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Machine Task',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            textTheme: AppTextStyle.lightTextTheme,
          ),
          home: const UserListView(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
