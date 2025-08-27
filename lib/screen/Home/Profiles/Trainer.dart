//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_network/image_network.dart';
// import 'package:intl/intl.dart';
// import '../../../Bloc/cubit/Profiles/Trainer.dart';
// import '../../../Bloc/states/Profiles/Trainer.dart';
// import '../../../constant/constantKey/key.dart';
// import '../../../constant/ui/Colors/colors.dart';
// import '../../../constant/ui/General constant/ConstantUi.dart';
// import '../../../localization/app_localizations.dart';
// import '../../Auth/resetPassword.dart';
//
// class TrainerProfilePage extends StatefulWidget {
//   final String token;
//   final int idTrainer;
//   const TrainerProfilePage({
//     Key? key,
//     required this.token,
//     required this.idTrainer,
//   }) : super(key: key);
//
//   @override
//   _TrainerProfilePageState createState() => _TrainerProfilePageState();
// }
//
// class _TrainerProfilePageState extends State<TrainerProfilePage> {
//   late final TrainerProfileCubit _cubit;
//
//   @override
//   void initState() {
//     super.initState();
//     _cubit = TrainerProfileCubit()..fetchProfile();
//   }
//
//   @override
//   void dispose() {
//     _cubit.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return ScreenUtilInit(
//       designSize: const Size(1440, 1024),
//       builder: (_, __) => BlocProvider.value(
//         value: _cubit,
//         child: Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           body: Row(
//             children: [
//               const AppSidebar(selectedItem: SidebarItem.Profile),
//
//               // ===== مساحة المحتوى فقط (يمين الـsidebar) =====
//               Expanded(
//                 child: BlocBuilder<TrainerProfileCubit, TrainerProfileState>(
//                   builder: (ctx, state) {
//                     if (state is TrainerProfileLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (state is TrainerProfileError) {
//                       return Center(
//                         child: Padding(
//                           padding: EdgeInsets.all(24.w),
//                           child: Text(
//                             state.message,
//                             style: TextStyle(color: Colors.red, fontSize: 16.sp),
//                           ),
//                         ),
//                       );
//                     }
//                     if (state is TrainerProfileLoaded) {
//                       final p = state.profile;
//                       final photoUrl = (p.photo?.isNotEmpty == true)
//                           ? '$BASE_URL${p.photo}'
//                           : null;
//
//                       // ارتفاع الشريط العلوي المحلي
//                       final topBarH = 64.h;
//
//                       return Column(
//                         children: [
//                           // ===== AppBar محلي داخل منطقة المحتوى =====
//                           Container(
//                             height: topBarH,
//                             padding: EdgeInsets.symmetric(horizontal: 24.w),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: theme.scaffoldBackgroundColor,
//                               border: Border(
//                                 bottom: BorderSide(
//                                   color: Colors.black12.withOpacity(0.06),
//                                   width: 1,
//                                 ),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     p.name,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       fontSize: 22.sp,
//                                       fontWeight: FontWeight.w800,
//                                       color: AppColors.darkBlue,
//                                     ),
//                                   ),
//                                 ),
//                                 IconButton(
//                                   tooltip: 'Settings',
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => PrivacySecurityPage(
//                                           prefilledEmail: p.email,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   icon: Icon(Icons.settings_rounded,
//                                       size: 24.sp, color: AppColors.t3),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           // ===== المحتوى مُوسَّط عموديًا/أفقيًا =====
//                           Expanded(
//                             child: LayoutBuilder(
//                               builder: (context, constraints) {
//                                 // نضمن أن المحتوى على الأقل بارتفاع المساحة المتاحة كي نقدر نوسّطه عموديًا
//                                 return SingleChildScrollView(
//                                   child: ConstrainedBox(
//                                     constraints: BoxConstraints(
//                                       minHeight: constraints.maxHeight,
//                                     ),
//                                     child: Center(
//                                       // يوسّط أفقيًا أيضًا
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 32.w, vertical: 24.h),
//                                         child: _CenteredContent(
//                                           photoUrl: photoUrl,
//                                           name: p.name,
//                                           specialization: p.specialization,
//                                           phone: p.phone,
//                                           email: p.email,
//                                           bio: _composeBio(
//                                               p.experience, p.specialization),
//                                           birthDate: DateFormat('yyyy-MM-dd')
//                                               .format(p.createdAt),
//                                           gender: p.gender,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _composeBio(String exp, String spec) {
//     if (exp.isEmpty && spec.isEmpty) return 'No bio provided.';
//     if (exp.isEmpty) return spec;
//     if (spec.isEmpty) return exp;
//     return '$exp • $spec';
//   }
// }
//
// /* ===================== Widgets ===================== */
//
// /// هذا الودجت يضع الصورة و About على نفس المستوى
// /// ويُبقِيهما في منتصف الصفحة مع عرض أقصى لطيف.
// class _CenteredContent extends StatelessWidget {
//   final String? photoUrl;
//   final String name;
//   final String specialization;
//   final String phone;
//   final String email;
//   final String bio;
//   final String birthDate;
//   final String gender;
//
//   const _CenteredContent({
//     required this.photoUrl,
//     required this.name,
//     required this.specialization,
//     required this.phone,
//     required this.email,
//     required this.bio,
//     required this.birthDate,
//     required this.gender,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // عرض أقصى للمحتوى كي لا يتمدّد كثيرًا على الشاشات العريضة
//     final maxW = 1040.w;
//
//     return ConstrainedBox(
//       constraints: BoxConstraints(maxWidth: maxW),
//       child: LayoutBuilder(
//         builder: (context, c) {
//           final isNarrow = c.maxWidth < 880.w;
//           if (isNarrow) {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _AvatarBlock(
//                   photoUrl: photoUrl,
//                   name: name,
//                   specialization: specialization,
//                   phone: phone,
//                   email: email,
//                   avatarSize: 260.r,
//                 ),
//                 SizedBox(height: 28.h),
//                 _AboutBlock(
//                   bio: bio,
//                   birthDate: birthDate,
//                   gender: gender,
//                 ),
//               ],
//             );
//           }
//           return Row(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _AvatarBlock(
//                   photoUrl: photoUrl,
//                   name: name,
//                   specialization: specialization,
//                   phone: phone,
//                   email: email,
//                   avatarSize: 280.r,
//                 ),
//               ),
//
//               Expanded(
//                 child: _AboutBlock(
//                   bio: bio,
//                   birthDate: birthDate,
//                   gender: gender,
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _AvatarBlock extends StatelessWidget {
//   final String? photoUrl;
//   final String name;
//   final String specialization;
//   final String phone;
//   final String email;
//   final double avatarSize;
//
//   const _AvatarBlock({
//     required this.photoUrl,
//     required this.name,
//     required this.specialization,
//     required this.phone,
//     required this.email,
//     required this.avatarSize,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: avatarSize,
//           height: avatarSize,
//           decoration: const BoxDecoration(shape: BoxShape.circle),
//           child: ClipOval(
//             child: photoUrl != null
//                 ? ImageNetwork(
//               image: photoUrl!,
//               width: avatarSize,
//               height: avatarSize,
//               fitAndroidIos: BoxFit.cover,
//             )
//                 : Container(
//               color: theme.cardColor,
//               child: Icon(Icons.person,
//                   size: avatarSize * .36, color: AppColors.t3),
//             ),
//           ),
//         ),
//         SizedBox(height: 14.h),
//         Text(
//           name,
//           style: TextStyle(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.w600,
//             color: AppColors.darkBlue,
//           ),
//         ),
//         SizedBox(height: 6.h),
//         Text(
//           specialization.isEmpty ? '—' : specialization,
//           style: TextStyle(fontSize: 14.sp, color: AppColors.t2),
//         ),
//         SizedBox(height: 16.h),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _ActionText(icon: Icons.call_rounded, label:
//             AppLocalizations.of(context)?.translate("Call") ?? "Call"
//             , onTap: () {}),
//             SizedBox(width: 18.w),
//             _ActionText(icon: Icons.mail_outline, label:
//             AppLocalizations.of(context)?.translate("Email") ?? "Email"
//             , onTap: () {}),
//           ],
//         ),
//         SizedBox(height: 12.h),
//         Wrap(
//           alignment: WrapAlignment.center,
//           spacing: 10.w,
//           runSpacing: 8.h,
//           children: [
//             _MiniChip(icon: Icons.phone, text: phone),
//             _MiniChip(icon: Icons.email, text: email),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class _AboutBlock extends StatelessWidget {
//   final String bio;
//   final String birthDate;
//   final String gender;
//
//   const _AboutBlock({
//     required this.bio,
//     required this.birthDate,
//     required this.gender,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       Center(child:
//       Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(height: 40,),
//         Text(
//             AppLocalizations.of(context)?.translate("About") ?? "About"
//             ,
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w700,
//               color: AppColors.darkBlue,
//             )),
//         SizedBox(height: 10.h),
//         Text(
//           bio,
//           style: TextStyle(fontSize: 14.sp, height: 1.6, color: AppColors.t2),
//         ),
//         SizedBox(height: 22.h),
//         Container(height: 1, color: Colors.black12.withOpacity(0.08)),
//         SizedBox(height: 18.h),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//               Icon(Icons.date_range,color:  AppColors.orange,)
//               ,SizedBox(width: 10,),
//            _FieldBlock(label:
//                 AppLocalizations.of(context)?.translate("Birth date") ?? "Birth date"
//                     , value: birthDate),
//
//
//             ],),
//
//             SizedBox(width: 24.w),
//             Row(children: [
//               Icon(Icons.group,color: AppColors.orange,)
//               ,SizedBox(width: 10,),
//               _FieldBlock(
//                   label:
//                   AppLocalizations.of(context)?.translate("Gender") ?? "Gender"
//                   , value: gender.isEmpty ? '-' : gender),
//
//
//             ],),
//
//
//           ],
//         ),
//       ],
//     ),);
//   }
// }
//
// class _ActionText extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   const _ActionText({required this.icon, required this.label, required this.onTap});
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(6.r),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
//         child: Row(
//           children: [
//             Icon(icon, size: 18.sp, color: AppColors.t3),
//             SizedBox(width: 6.w),
//             Text(label, style: TextStyle(fontSize: 14.sp, color: AppColors.t2)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _MiniChip extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   const _MiniChip({required this.icon, required this.text});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//       decoration: BoxDecoration(
//         color: AppColors.w1,
//         borderRadius: BorderRadius.circular(22.r),
//         border: Border.all(color: Colors.black12.withOpacity(0.06)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16.sp, color: AppColors.orange),
//           SizedBox(width: 6.w),
//           Text(text, style: TextStyle(fontSize: 13.sp, color: AppColors.t2)),
//         ],
//       ),
//     );
//   }
// }
//
// class _FieldBlock extends StatelessWidget {
//   final String label;
//   final String value;
//   const _FieldBlock({required this.label, required this.value});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: TextStyle(
//               fontSize: 12.sp,
//               color: AppColors.t3,
//               fontWeight: FontWeight.w600,
//             )),
//         SizedBox(height: 6.h),
//         Text(value, style: TextStyle(fontSize: 14.sp, color: AppColors.t2)),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:trainer_section/network/local/cacheHelper.dart';
import 'package:trainer_section/router/route-paths.dart';

import '../../../Bloc/cubit/Profiles/Trainer.dart';
import '../../../Bloc/states/Profiles/Trainer.dart';
import '../../../constant/constantKey/key.dart';
import '../../../constant/ui/Colors/colors.dart';
import '../../../constant/ui/General constant/ConstantUi.dart';
import '../../../localization/app_localizations.dart';

class TrainerProfilePage extends StatefulWidget {
  const TrainerProfilePage({Key? key}) : super(key: key);

  @override
  _TrainerProfilePageState createState() => _TrainerProfilePageState();
}

class _TrainerProfilePageState extends State<TrainerProfilePage> {
  late final TrainerProfileCubit _cubit;
  late final String token;
  late final int idTrainer;

  @override
  void initState() {
    super.initState();
    _cubit = TrainerProfileCubit()..fetchProfile();
    token = CacheHelper.getData(key: TOKENKEY) ?? '';
    idTrainer = CacheHelper.getData(key: 'idTrainer') ?? 0;
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      builder:
          (_, __) => BlocProvider.value(
            value: _cubit,
            child: Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: Row(
                children: [
                  const AppSidebar(selectedItem: SidebarItem.profile),

                  // ===== مساحة المحتوى فقط (يمين الـsidebar) =====
                  Expanded(
                    child: BlocBuilder<
                      TrainerProfileCubit,
                      TrainerProfileState
                    >(
                      builder: (ctx, state) {
                        if (state is TrainerProfileLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is TrainerProfileError) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.w),
                              child: Text(
                                state.message,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          );
                        }
                        if (state is TrainerProfileLoaded) {
                          final p = state.profile;
                          final photoUrl =
                              (p.photo?.isNotEmpty == true)
                                  ? '$BASE_URL${p.photo}'
                                  : null;

                          // ارتفاع الشريط العلوي المحلي
                          final topBarH = 64.h;

                          return Column(
                            children: [
                              // ===== AppBar محلي داخل منطقة المحتوى =====
                              Container(
                                height: topBarH,
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: theme.scaffoldBackgroundColor,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black12.withOpacity(0.06),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        p.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 26.sp,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.darkBlue,
                                        ),
                                      ),
                                    ),

                                    // صورة صغيرة يمين الـ AppBar مثل التصميم
                                    CircleAvatar(
                                      radius: 18.r,
                                      backgroundColor: theme.cardColor,
                                      child: ClipOval(
                                        child:
                                            (photoUrl != null)
                                                ? ImageNetwork(
                                                  image: photoUrl,
                                                  width: 36.r,
                                                  height: 36.r,
                                                  fitAndroidIos: BoxFit.cover,
                                                )
                                                : Icon(
                                                  Icons.person,
                                                  size: 18.sp,
                                                  color: AppColors.t3,
                                                ),
                                      ),
                                    ),

                                    IconButton(
                                      tooltip: 'Settings',
                                      onPressed: () {
                                        context.go(RoutePaths.profileSettings);
                                      },
                                      icon: Icon(
                                        Icons.settings_rounded,
                                        size: 22.sp,
                                        color: AppColors.t3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ===== المحتوى =====
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        // نملأ ارتفاع المنطقة المتاحة تحت الـ AppBar
                                        constraints: BoxConstraints(
                                          minHeight: constraints.maxHeight,
                                        ),
                                        // هذا ما يجعل المحتوى يتوسّط عموديًا وأفقيًا
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 40.w,
                                          vertical: 28.h,
                                        ),
                                        child: _CenteredContent(
                                          photoUrl: photoUrl,
                                          name: p.name,
                                          specialization: p.specialization,
                                          phone: p.phone,
                                          email: p.email,
                                          bio: _composeBio(
                                            p.experience,
                                            p.specialization,
                                          ),
                                          birthDate: DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(p.createdAt),
                                          gender: p.gender,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  String _composeBio(String exp, String spec) {
    if (exp.isEmpty && spec.isEmpty) return '—';
    if (exp.isEmpty) return spec;
    if (spec.isEmpty) return exp;
    return '$exp • $spec';
  }
}

/* ===================== Widgets ===================== */

/// يجعل الواجهة مثل الصورة: صورة كبيرة يسار + معلومات يمين.
/// لا يغيّر أي مهام/داتا.
class _CenteredContent extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final String specialization;
  final String phone;
  final String email;
  final String bio;
  final String birthDate;
  final String gender;

  const _CenteredContent({
    required this.photoUrl,
    required this.name,
    required this.specialization,
    required this.phone,
    required this.email,
    required this.bio,
    required this.birthDate,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    // أقصى عرض مشابه للصورة
    final maxW = 1140.w;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 980.w;

            if (!wide) {
              // موبايل/ضيّق: كولمن فوق بعض
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AvatarBlock(
                    photoUrl: photoUrl,
                    name: name,
                    specialization: specialization,
                    phone: phone,
                    email: email,
                    // أصغر على الشاشات الضيقة
                    avatarSize: 220.r,
                  ),
                  SizedBox(height: 28.h),
                  _AboutBlock(bio: bio, birthDate: birthDate, gender: gender),
                ],
              );
            }

            // شاشة عريضة: صف مثل التصميم
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العمود الأيسر: صورة كبيرة + الاسم + الوظيفة + أزرار
                SizedBox(
                  width: 460.w,
                  child: _AvatarBlock(
                    photoUrl: photoUrl,
                    name: name,
                    specialization: specialization,
                    phone: phone,
                    email: email,
                    avatarSize: 300.r, // قريب جدًا من حجم الصورة في اللقطة
                  ),
                ),

                SizedBox(width: 80.w),

                // العمود الأيمن: About + Birth/Gender
                Expanded(
                  child: _AboutBlock(
                    bio: bio,
                    birthDate: birthDate,
                    gender: gender,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AvatarBlock extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final String specialization;
  final String phone;
  final String email;
  final double avatarSize;

  const _AvatarBlock({
    required this.photoUrl,
    required this.name,
    required this.specialization,
    required this.phone,
    required this.email,
    required this.avatarSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr = AppLocalizations.of(context)?.translate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // الصورة الكبيرة
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child:
                (photoUrl != null)
                    ? ImageNetwork(
                      image: photoUrl!,
                      width: avatarSize,
                      height: avatarSize,
                      fitAndroidIos: BoxFit.cover,
                    )
                    : Container(
                      color: theme.cardColor,
                      child: Icon(
                        Icons.person,
                        size: avatarSize * .38,
                        color: AppColors.t3,
                      ),
                    ),
          ),
        ),

        SizedBox(height: 18.h),

        // الاسم تحت الصورة
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlue,
          ),
        ),

        SizedBox(height: 6.h),

        // الوظيفة + نجمة صغيرة (شكل فقط)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              specialization.isEmpty ? '—' : specialization,
              style: TextStyle(fontSize: 13.sp, color: AppColors.t2),
            ),
            SizedBox(width: 10.w),
            Icon(Icons.star, size: 16.sp, color: AppColors.orange),
          ],
        ),

        SizedBox(height: 18.h),

        // أزرار Call / Email كبيرة مثل اللقطة
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SquareAction(
              icon: Icons.call_rounded,
              label: tr?.call("Call") ?? "Call",
              onTap: () {},
            ),
            SizedBox(width: 16.w),
            _SquareAction(
              icon: Icons.mail_outline_rounded,
              label: tr?.call("Email") ?? "Email",
              onTap: () {},
            ),
          ],
        ),

        SizedBox(height: 14.h),

        // شرائط صغيرة لرقم الهاتف/الإيميل
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10.w,
          runSpacing: 8.h,
          children: [
            _MiniChip(icon: Icons.phone, text: phone),
            _MiniChip(icon: Icons.email_outlined, text: email),
          ],
        ),
      ],
    );
  }
}

class _AboutBlock extends StatelessWidget {
  final String bio;
  final String birthDate;
  final String gender;

  const _AboutBlock({
    required this.bio,
    required this.birthDate,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)?.translate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 100),
        // عنوان About
        Text(
          tr?.call("About") ?? "About",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlue,
          ),
        ),

        SizedBox(height: 10.h),

        // نص الـ About
        Text(
          bio,
          style: TextStyle(fontSize: 13.5.sp, height: 1.6, color: AppColors.t2),
        ),

        SizedBox(height: 30.h),

        // صف المعلومات: Birth date / Gender على شكل Pills
        Row(
          children: [
            Expanded(
              child: _InfoPill(
                icon: Icons.cake_outlined,
                title: tr?.call("Birth date") ?? "Birth date",
                value: birthDate,
              ),
            ),
            SizedBox(width: 18.w),
            Expanded(
              child: _InfoPill(
                icon: Icons.transgender,
                title: tr?.call("Gender") ?? "Gender",
                value: gender.isEmpty ? "—" : gender,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/* ---------- عناصر صغيرة ---------- */

class _SquareAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SquareAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: 56.r,
        height: 56.r,
        decoration: BoxDecoration(
          color: t.colorScheme.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.black12.withOpacity(.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 22.sp, color: AppColors.t3),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.w1,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: Colors.black12.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.orange),
          SizedBox(width: 6.w),
          Text(text, style: TextStyle(fontSize: 13.sp, color: AppColors.t2)),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoPill({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.purple.withOpacity(.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18.sp, color: AppColors.orange),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: t.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.t2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
