import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:machine_task/constants/color_constants.dart';

class CustomIconButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(5.r),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon, height: 16.h, width: 16.w),
            SizedBox(width: 8.w),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: ColorConstants.primary),
            )
          ],
        ),
      ),
    );
  }
}
