
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';

import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';


class CommentTile extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLikeTap;
  final VoidCallback onCountTap;
  final Widget? extraActions;

  const CommentTile({
    Key? key,
    required this.comment,
    required this.onLikeTap,
    required this.onCountTap,
    this.extraActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                child: ClipOval(
                  child: comment.author.avatar.isNotEmpty
                      ? ImageNetwork(
                    image: comment.author.avatar,
                    width: 30,
                    height: 30,
                    fitAndroidIos: BoxFit.cover,
                  )
                      : Icon(Icons.person, size: 50),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.author.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${comment.date.hour.toString().padLeft(2, '0')}:${comment.date.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.t2),
                  ),
                ],
              ),
              Spacer(),
              if (extraActions != null) extraActions!,
            ],
          ),

          SizedBox(height: 8.h),


          Padding(
            padding: EdgeInsets.only(left: 60.w),
            child: Text(
              comment.content,
              style: TextStyle(fontSize: 16.sp, color: AppColors.t3),
            ),
          ),

          SizedBox(height: 8.h),


          Padding(
            padding: EdgeInsets.only(left: 60.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onLikeTap,
                  child: Icon(
                    Icons.favorite,
                    size: 20.sp,

                    color: comment.isLiked
                        ? AppColors.orange
                        : AppColors.t2,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: onCountTap,
                  child: Text(
                    '${comment.likesCount}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.t4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
