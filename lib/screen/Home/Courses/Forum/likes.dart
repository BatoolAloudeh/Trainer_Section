// lib/screens/likes_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';

import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';

class LikesPage extends StatelessWidget {
  final List<User> likes;
  const LikesPage({Key? key, required this.likes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          const AppSidebar(selectedItem: SidebarItem.courses,),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 24.h),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    '${likes.length} Likes',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),


                Expanded(
                  child: likes.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/Images/no notification.png',
                          width: 200.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'No Likes at this time',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.orange,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Search to view more items',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.t2,
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: likes.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: AppColors.t2),
                    itemBuilder: (context, index) {
                      final user = likes[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 8.h),
                        leading:
                        // CircleAvatar(
                        //   radius: 24.r,
                        //   backgroundImage: AssetImage(user.avatar),
                        // ),
                        CircleAvatar(
                          radius: 24.r,
                          child: ClipOval(

                            child: user.avatar != null
                                ? ImageNetwork(
                              image: user.avatar,
                              width: 30,
                              height: 30,
                              fitAndroidIos: BoxFit.cover,
                            )
                                : Icon(Icons.person, size: 50),
                          ),
                        ),
                        title: Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue,
                          ),
                        ),
                        trailing: Text(
                          '•',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.orange,
                          ),
                        ),
                      );
                    },
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
