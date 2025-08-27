
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';
import 'package:trainer_section/constant/constantKey/key.dart';
import 'package:trainer_section/constant/ui/Colors/colors.dart';
import 'package:trainer_section/screen/Settings/DarkMode/SettingPage.dart';
import '../../../localization/app_localizations.dart';
import '../../../models/tests/create test.dart';
import '../../../network/local/cacheHelper.dart';
import '../../../screen/Auth/logout.dart';
import '../../../screen/Calendar/calendar.dart';
import '../../../screen/Home/Courses/MainPage/ShowCourses.dart';
import '../../../screen/Home/Profiles/Trainer.dart';
import '../../../screen/notification/notification.dart';


Widget defaultFormField({
  required String text,
  required IconData prefix,
  Function? onPressed,
  required TextEditingController controller,
  required TextInputType? keyboardtype,
  required String? Function(String?) validate,
  IconData? suffix,
  String? initialValue,
  void Function(String)? onChanged,
  Function? suffixButton,
  required void Function() onTap,
  bool isPassword = false,
  void Function(String)? onsubmitted,
  void Function(String?)? onSaved,
  double width = double.infinity,
  double height = 65,
}) =>

    Container(
      height: height,
      width: width,
      child: Column(
        children: [
          Expanded(
            child: TextFormField(
              onSaved: onSaved,
              initialValue: initialValue,
              cursorColor: AppColors.darkBlue,
              keyboardType: keyboardtype,
              onChanged: onChanged,
              onTap: onTap,
              onFieldSubmitted: onsubmitted,
              decoration: InputDecoration(
                labelText: text,
                labelStyle: TextStyle(color: AppColors.darkBlue),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(color: AppColors.darkBlue)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(color: AppColors.darkBlue)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(color: AppColors.darkBlue)),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  prefix,
                  color: AppColors.darkBlue,
                ),
                suffixIcon: suffix != null
                    ? IconButton(
                  onPressed: () {
                    suffixButton!();
                  },
                  icon: Icon(
                    suffix,
                    color: AppColors.darkBlue,
                  ),
                  highlightColor: AppColors.lightPurple,
                  hoverColor: AppColors.lightPurple,
                )
                    : null,
              ),
              controller: controller,
              validator: validate,
              obscureText: isPassword,
            ),
          ),

        ],
      ),
    );





Widget defaultButton({
  required String text,
  required Function onPressed,
  double? fontSize = 20.0,
  Color background = Colors.brown,
  bool loading = false,
  double width = double.infinity,
  double sizewidth = 40,
  double radius = 100.0,
  double height = 50,
  IconData? suffix,
}) =>
    Container(
      width: width,
      height: height,
      child: Container(
        width: 300,
        height: 100,
        decoration: ShapeDecoration(
          shape: StadiumBorder(),

        ),
        child: MaterialButton(

          padding: EdgeInsetsDirectional.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: AppColors.darkBlue),

          ),
          // color: Colors.blueGrey[500],
          onPressed: () {
            onPressed();
          },
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
                color:    AppColors.darkBlue,
              ),
            ),
          ),
        ),
      ),
    );






Widget _sidebarItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget page,
      }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            SizedBox(width: 16.w),
            Icon(icon, color: AppColors.white, size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(color: AppColors.white, fontSize: 14.sp),
            ),

          ],
        ),
      ),
    );
  }





enum SidebarItem { courses, Profile, search, calendar, settings, logout, notifications }

class AppSidebar extends StatelessWidget {
  final SidebarItem selectedItem;
  const AppSidebar({Key? key, required this.selectedItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = CacheHelper.getData(key: TOKENKEY) as String?;
    final trainerId = CacheHelper.getData(key: 'trainer_id') as int?;
    final userName = CacheHelper.getData(key: 'user_name') as String? ?? '';
    final userPhoto = CacheHelper.getData(key: 'user_photo') as String?; // may be null
    String photoUrl = userPhoto != null ? "$BASE_URL$userPhoto" : "";

    final double itemHeight = 100.h;
    final double radius = itemHeight / 2;

    // مهيأ الترجمة
    final tr = AppLocalizations.of(context)?.translate;

    return Container(
      width: 200.w,
      color: AppColors.purple,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(0),
            onDoubleTap: () {
              if (token != null && trainerId != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TrainerProfilePage(
                      token: token,
                      idTrainer: trainerId,
                    ),
                  ),
                );
              }
            },
            child: CircleAvatar(
              radius: 25,
              child: ClipOval(
                child: userPhoto != null
                    ? ImageNetwork(
                  image: photoUrl,
                  width: 50,
                  height: 50,
                  fitAndroidIos: BoxFit.cover,
                )
                    : Icon(Icons.person, size: 20),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            userName.isNotEmpty
                ? userName
                : tr?.call("Trainer") ?? "Trainer",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 40.h),

          _sidebarItem(
            context,
            icon: Icons.menu_book,
            label: tr?.call('Courses') ?? 'Courses',
            item: SidebarItem.courses,
            page: (token != null && trainerId != null)
                ? CoursesDashboard(token: token, idTrainer: trainerId)
                : Center(child: Text(tr?.call('Please login') ?? 'Please login')),
            itemHeight: itemHeight,
            radius: radius,
          ),
          _sidebarItem(
            context,
            icon: Icons.person_pin_outlined,
            label: tr?.call('Profile') ?? 'Profile',
            item: SidebarItem.Profile,
            page: (token != null)
                ? TrainerProfilePage(token: token, idTrainer: trainerId!)
                : Center(child: Text(tr?.call('Please login') ?? 'Please login')),
            itemHeight: itemHeight,
            radius: radius,
          ),
          _sidebarItem(
            context,
            icon: Icons.calendar_today,
            label: tr?.call('Calendar') ?? 'Calendar',
            item: SidebarItem.calendar,
            page: (token != null && trainerId != null)
                ? CalendarPage(token: token)
                : Center(child: Text(tr?.call('Please login') ?? 'Please login')),
            itemHeight: itemHeight,
            radius: radius,
          ),
          _sidebarItem(
            context,
            icon: Icons.notifications_active_outlined,
            label: tr?.call('Notifications') ?? 'Notifications',
            item: SidebarItem.notifications,
            page: NotificationsPage(),
            itemHeight: itemHeight,
            radius: radius,
          ),
          _sidebarItem(
            context,
            icon: Icons.list_alt,
            label: tr?.call('Settings') ?? 'Settings',
            item: SidebarItem.settings,
            page: const SettingsPage(),
            itemHeight: itemHeight,
            radius: radius,
          ),
          _sidebarItem(
            context,
            icon: Icons.logout_rounded,
            label: tr?.call('Logout') ?? 'Logout',
            item: SidebarItem.logout,
            page: LogoutPage(),
            itemHeight: itemHeight,
            radius: radius,
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required SidebarItem item,
        required Widget page,
        required double itemHeight,
        required double radius,
      }) {
    final bool isSelected = item == selectedItem;

    return InkWell(
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        }
      },
      child: Container(
        height: itemHeight,
        width: double.infinity,
        decoration: isSelected
            ? BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
          ),
        )
            : null,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isSelected
                  ? AppColors.purple
                  : AppColors.white.withOpacity(0.8),
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.purple
                    : AppColors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






//
// enum SidebarItem { courses, Profile, search, calendar, settings,logout ,notifications}
//
// class AppSidebar extends StatelessWidget {
//   final SidebarItem selectedItem;
//   const AppSidebar({Key? key, required this.selectedItem}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final token     = CacheHelper.getData(key: TOKENKEY)      as String?;
//     final trainerId = CacheHelper.getData(key: 'trainer_id') as int?;
//     final userName  = CacheHelper.getData(key: 'user_name')  as String? ?? '';
//     final userPhoto = CacheHelper.getData(key: 'user_photo') as String?; // may be null
//     String photoUrl = userPhoto!= null
//         ? "$BASE_URL$userPhoto"
//         : "";
//
//     final double itemHeight = 100.h;
//
//     final double radius = itemHeight / 2;
//
//     return Container(
//       width: 200.w,
//       color: AppColors.purple,
//       padding: EdgeInsets.symmetric(vertical: 40.h),
//       child: Column(
//         children: [
//
//
//
//       InkWell(
//       borderRadius: BorderRadius.circular(0),
//
//       onDoubleTap: (){
//         if (token != null && trainerId != null) {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => TrainerProfilePage(
//                 token: token, idTrainer: trainerId,
//
//               ),
//             ),
//           );}
//         },
//       child:
//
//               CircleAvatar(
//                 radius: 25,
//                 child:
//                 ClipOval(
//                   child: userPhoto  != null
//                       ? ImageNetwork(
//                     image: photoUrl,
//                     width: 50,
//                     height: 50,
//                     fitAndroidIos: BoxFit.cover,
//                   )
//                       : Icon(Icons.person, size: 20),
//                 ),),),
//
//
//
//           SizedBox(height: 12.h),
//           Text(
//             userName.isNotEmpty ? userName : 'Trainer',
//             style: TextStyle(
//               color: AppColors.white,
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 40.h),
//
//           _sidebarItem(
//             context,
//             icon: Icons.menu_book,
//             label: 'Courses',
//             item: SidebarItem.courses,
//             page: (token != null && trainerId != null)
//                 ? CoursesDashboard(token: token, idTrainer: trainerId)
//                 : Center(child: Text('Please login')),
//             itemHeight: itemHeight,
//             radius: radius,
//           ),
//           _sidebarItem(
//             context,
//             icon: Icons.person_pin_outlined,
//             label: 'Profile',
//             item: SidebarItem.Profile,
//             page: (token != null )
//                 ? TrainerProfilePage(token: token,idTrainer: trainerId!,)
//                 : Center(child: Text('Please login')),
//             itemHeight: itemHeight,
//             radius: radius,
//           ),
//           // _sidebarItem(
//           //   context,
//           //   icon: Icons.search,
//           //   label: 'Search',
//           //   item: SidebarItem.search,
//           //   page: const SearchPage(),
//           //   itemHeight: itemHeight,
//           //   radius: radius,
//           // ),
//           _sidebarItem(
//             context,
//             icon: Icons.calendar_today,
//             label: 'Calendar',
//             item: SidebarItem.calendar,
//
//             page: (token != null && trainerId != null)
//                 ? CalendarPage(token: token,)
//                 : Center(child: Text('Please login')),
//             itemHeight: itemHeight,
//             radius: radius,
//           ),
//           _sidebarItem(
//             context,
//             icon: Icons.list_alt,
//             label: 'Settings',
//             item: SidebarItem.settings,
//             page: const SettingsPage(),
//
//             itemHeight: itemHeight,
//             radius: radius,
//           ),
//           _sidebarItem(
//             context,
//             icon: Icons.notifications_active_outlined,
//             label: 'Notifications',
//             item: SidebarItem.notifications,
//             page:  NotificationsPage(),
//             itemHeight: itemHeight,
//             radius: radius,
//           ),
//           _sidebarItem(
//             context,
//             icon: Icons.logout_rounded,
//             label: 'Logout',
//             item: SidebarItem.logout,
//             // صفحة هوك صغيرة تفتح الديالوج ثم ترجع
//             page: LogoutPage(),
//             itemHeight: itemHeight,
//             radius: radius,
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _sidebarItem(
//       BuildContext context, {
//         required IconData icon,
//         required String label,
//         required SidebarItem item,
//         required Widget page,
//         required double itemHeight,
//         required double radius,
//       }) {
//     final bool isSelected = item == selectedItem;
//
//     return InkWell(
//       onTap: () {
//         if (!isSelected) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//         }
//       },
//       child: Container(
//         height: itemHeight,
//         width: double.infinity,
//         decoration: isSelected
//             ? BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(radius),
//             bottomLeft: Radius.circular(radius),
//           ),
//         )
//             : null,
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               size: 20.sp,
//               color: isSelected ? AppColors.purple : AppColors.white.withOpacity(0.8),
//             ),
//             SizedBox(width: 12.w),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 color: isSelected ? AppColors.purple : AppColors.white.withOpacity(0.8),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



class StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconBg;

  const StatItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconBg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: iconBg.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: iconBg, size: 30.sp),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 17.sp, color: AppColors.t2)),
            Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.t4)),
          ],
        ),
      ],
    );
  }
}

class Poll {
  final String question;
  final List<String> options;
  final int correctIndex;
  Poll({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}



class CourseCard extends StatelessWidget {
  final String title;
  final int students;
  final String day;
  final double rating;
  final bool online;
  final VoidCallback onTap;

  const CourseCard({
    Key? key,
    required this.title,
    required this.students,
    required this.day,
    required this.rating,
    required this.onTap,
    this.online = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6.r, offset: Offset(0, 4.h))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundColor: AppColors.lightPurple,
              backgroundImage: AssetImage('assets/Images/stu.png'),
            ),
            SizedBox(height: 16.h),
            Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.t4)),
            SizedBox(height: 4.h),
            Text('$students Students  $day', style: TextStyle(fontSize: 14.sp, color: AppColors.t2)),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(rating.toString(), style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: AppColors.t4)),
                SizedBox(width: 4.w),
                Icon(Icons.star, size: 17.sp, color: AppColors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onShowLikes;
  final VoidCallback onComment;

  const PostCard({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onShowLikes,
    required this.onComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLiked = post.likedBy.any((u) => u.name == 'Alia AI');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              // CircleAvatar(
              //   radius: 24.r,
              //   backgroundImage: NetworkImage(post.author.avatar),
              // ),
              CircleAvatar(
                radius: 24.r,
                child: ClipOval(

                  child: post.author.avatar != null
                      ? ImageNetwork(
                    image: post.author.avatar,
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
                  Text(post.author.name,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue)),
                  SizedBox(height: 4.h),
                  Text(
                    '${post.date.hour.toString().padLeft(2, '0')}:${post.date.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.t2),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.more_horiz, color: AppColors.t2, size: 24.sp),
            ],
          ),

          SizedBox(height: 12.h),


          Text(post.content,
              style: TextStyle(fontSize: 16.sp, color: AppColors.t3)),

          SizedBox(height: 16.h),


          Row(
            children: [

              GestureDetector(
                onTap: onComment,
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 20.sp, color: AppColors.t3),
                    SizedBox(width: 4.w),
                    Text('${post.comments.length}',
                        style: TextStyle(fontSize: 16.sp, color: AppColors.t3)),
                  ],
                ),
              ),

              SizedBox(width: 24.w),

              // إعجاب
              GestureDetector(
                onTap: onLike,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_outline,
                  size: 20.sp,
                  color: isLiked ? AppColors.orange : AppColors.t3,
                ),
              ),

              SizedBox(width: 4.w),


              GestureDetector(
                onTap: onShowLikes,
                child: Text('${post.likedBy.length}',
                    style: TextStyle(fontSize: 16.sp, color: AppColors.orange)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Post {
  final User author;
  final DateTime date;
  final String content;
  final List<User> likedBy;
  final List<Comment> comments;

  Post({
    required this.author,
    required this.date,
    required this.content,
    List<User>? likedBy,
    List<Comment>? comments, required int id,
  })  : likedBy = likedBy ?? [],
        comments = comments ?? [];
}

class User {
  final String name;
  final String avatar;
  User({required this.name, required this.avatar});
}

class Comment {
  final User author;
  final DateTime date;
  final String content;
  final List<Comment> replies;
  final int likesCount;
  final bool isLiked;
  int likes;
  Comment({
    required this.author,
    required this.date,
    required this.content,
    this.replies = const [],
    this.likes = 0,
    required this.likesCount,
    required this.isLiked,
  });
}


void navigateTo(context, Widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Widget,
  ),
);











class PollDialog extends StatefulWidget {
  const PollDialog({Key? key}) : super(key: key);

  @override
  State<PollDialog> createState() => _PollDialogState();
}

class _PollDialogState extends State<PollDialog> {
  final _questionCtrl = TextEditingController();
  final List<TextEditingController> _optionCtrls = [];
  int? _correctIdx;

  @override
  void initState() {
    super.initState();

    _addOption();
    _addOption();
  }

  void _addOption() {
    if (_optionCtrls.length < 10) {
      setState(() => _optionCtrls.add(TextEditingController()));
    }
  }

  void _removeOption(int i) {
    setState(() {
      _optionCtrls.removeAt(i);
      if (_correctIdx != null && _correctIdx! >= _optionCtrls.length) {
        _correctIdx = null;
      }
    });
  }

  bool get _canCreate {
    return _questionCtrl.text.trim().isNotEmpty &&
        _optionCtrls.length >= 2 &&
        _correctIdx != null &&
        _optionCtrls.every((c) => c.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 600.w,
        padding: EdgeInsets.all(24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New Question',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue)),
              SizedBox(height: 16.h),


              TextField(
                controller: _questionCtrl,
                decoration: InputDecoration(
                  labelText: 'Question',
                  filled: true,
                  fillColor: AppColors.highlightPurple,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 24.h),
              Divider(),
              SizedBox(height: 16.h),

              // الخيارات
              Text('Options',
                  style: TextStyle(fontSize: 16.sp, color: AppColors.t3)),
              SizedBox(height: 8.h),
              for (int i = 0; i < _optionCtrls.length; i++) ...[
                Row(
                  children: [
                    Radio<int>(
                      value: i,
                      groupValue: _correctIdx,
                      activeColor: AppColors.orange,
                      onChanged: (v) => setState(() => _correctIdx = v),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _optionCtrls[i],
                        decoration: InputDecoration(
                          hintText: 'Option ${i + 1}',
                          filled: true,
                          fillColor: AppColors.highlightPurple,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppColors.orange),
                      onPressed: () => _removeOption(i),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],


              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _optionCtrls.length < 10 ? _addOption : null,
                    icon: Icon(Icons.add),
                    label: Text('Add option'),
                    style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      'Can add ${10 - _optionCtrls.length} more',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.t2),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),


              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child:
                    Text('Cancel', style: TextStyle(color: AppColors.darkBlue)),
                  ),
                  SizedBox(width: 24.w),
                  ElevatedButton(
                    onPressed: _canCreate
                        ? () {

                      final options = _optionCtrls
                          .asMap()
                          .entries
                          .map((e) => QuizOption(
                        option: e.value.text.trim(),
                        isCorrect: e.key == _correctIdx,
                      ))
                          .toList();
                      final question = QuizQuestion(
                        question: _questionCtrl.text.trim(),
                        options: options,
                      );
                      Navigator.pop(context, question);
                    }
                        : null,
                    child: Text('Create', style: TextStyle(fontSize: 16.sp)),
                    style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
