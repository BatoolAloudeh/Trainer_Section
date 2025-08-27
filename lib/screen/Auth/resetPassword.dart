import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_section/router/route-paths.dart';

import '../../../constant/ui/Colors/colors.dart';
import '../../../constant/ui/General constant/ConstantUi.dart';
import '../../Bloc/cubit/Auth/forgetPassword.dart';
import '../../Bloc/cubit/Auth/resetPassword.dart';
import '../../Bloc/states/Auth/forgetPassword.dart';
import '../../Bloc/states/Auth/resetPassword.dart';
import '../../localization/app_localizations.dart';

class PrivacySecurityPage extends StatefulWidget {
  final String? prefilledEmail;

  const PrivacySecurityPage({Key? key, this.prefilledEmail}) : super(key: key);

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  final _emailCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();

  bool _ob1 = true;
  bool _ob2 = true;

  @override
  void initState() {
    super.initState();
    if ((widget.prefilledEmail ?? '').isNotEmpty) {
      _emailCtrl.text = widget.prefilledEmail!;
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _tokenCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      builder:
          (_, __) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ForgotPasswordCubit()),
              BlocProvider(create: (_) => ResetPasswordCubit()),
            ],
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Row(
                children: [
                  const AppSidebar(selectedItem: SidebarItem.profile),
                  // ضمن قسم البروفايل
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // عنوان كبير
                          Row(
                            children: [
                              Icon(
                                Icons.lock_person,
                                color: AppColors.purple,
                                size: 26.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                AppLocalizations.of(
                                      context,
                                    )?.translate("privacy_security") ??
                                    "Privacy & Security",

                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18.h),

                          // بطاقة إرسال كود
                          _glassCard(
                            child: BlocConsumer<
                              ForgotPasswordCubit,
                              ForgotPasswordState
                            >(
                              listener: (context, state) {
                                if (state is ForgotPasswordSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.data.message)),
                                  );
                                } else if (state is ForgotPasswordFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.error)),
                                  );
                                }
                              },
                              builder: (context, state) {
                                final loading = state is ForgotPasswordLoading;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.mark_email_read,
                                          color: AppColors.orange,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          AppLocalizations.of(
                                                context,
                                              )?.translate(
                                                "send_verification_code",
                                              ) ??
                                              "Send verification code",

                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.darkBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    TextField(
                                      controller: _emailCtrl,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: _input(
                                        AppLocalizations.of(
                                              context,
                                            )?.translate("email_address") ??
                                            "Email address",
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    SizedBox(
                                      width: 180.w,
                                      height: 42.h,
                                      child: ElevatedButton(
                                        onPressed:
                                            loading
                                                ? null
                                                : () {
                                                  if (_emailCtrl.text
                                                      .trim()
                                                      .isEmpty)
                                                    return;
                                                  context
                                                      .read<
                                                        ForgotPasswordCubit
                                                      >()
                                                      .sendCode(
                                                        email:
                                                            _emailCtrl.text
                                                                .trim(),
                                                      );
                                                },
                                        style: _btnStyle(
                                          primary: AppColors.purple,
                                        ),
                                        child:
                                            loading
                                                ? const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                                : Text(
                                                  AppLocalizations.of(
                                                        context,
                                                      )?.translate(
                                                        "send_code",
                                                      ) ??
                                                      "Send code",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 18.h),

                          // بطاقة إعادة التعيين
                          _glassCard(
                            child: BlocConsumer<
                              ResetPasswordCubit,
                              ResetPasswordState
                            >(
                              listener: (context, state) {
                                if (state is ResetPasswordSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.data.message)),
                                  );
                                  _tokenCtrl.clear();
                                  _passCtrl.clear();
                                  _pass2Ctrl.clear();
                                  context.go(RoutePaths.login);
                                } else if (state is ResetPasswordFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.error)),
                                  );
                                }
                              },
                              builder: (context, state) {
                                final loading = state is ResetPasswordLoading;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.password,
                                          color: AppColors.purple,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Reset password',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.darkBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    TextField(
                                      controller: _tokenCtrl,
                                      decoration: _input(
                                        'Verification token (from email)',
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    TextField(
                                      controller: _passCtrl,
                                      obscureText: _ob1,
                                      decoration: _input(
                                        'New password',
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _ob1
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed:
                                              () =>
                                                  setState(() => _ob1 = !_ob1),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    TextField(
                                      controller: _pass2Ctrl,
                                      obscureText: _ob2,
                                      decoration: _input(
                                        'Confirm password',
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _ob2
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed:
                                              () =>
                                                  setState(() => _ob2 = !_ob2),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 14.h),
                                    SizedBox(
                                      width: 220.w,
                                      height: 44.h,
                                      child: ElevatedButton.icon(
                                        onPressed:
                                            loading
                                                ? null
                                                : () {
                                                  if (_tokenCtrl.text
                                                      .trim()
                                                      .isEmpty)
                                                    return;
                                                  if (_passCtrl.text !=
                                                      _pass2Ctrl.text) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'Passwords do not match',
                                                        ),
                                                      ),
                                                    );
                                                    return;
                                                  }
                                                  context
                                                      .read<
                                                        ResetPasswordCubit
                                                      >()
                                                      .resetPassword(
                                                        token:
                                                            _tokenCtrl.text
                                                                .trim(),
                                                        password:
                                                            _passCtrl.text,
                                                        passwordConfirmation:
                                                            _pass2Ctrl.text,
                                                      );
                                                },
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        label:
                                            loading
                                                ? const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                                : const Text(
                                                  'Update password',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        style: _btnStyle(
                                          primary: AppColors.purple,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  // ===== Helpers UI =====
  BoxDecoration _glassDeco(BuildContext context) => BoxDecoration(
    color: Theme.of(context).cardColor.withOpacity(.9),
    borderRadius: BorderRadius.circular(16.r),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.06),
        blurRadius: 18.r,
        offset: Offset(0, 10.h),
      ),
    ],
    border: Border.all(color: AppColors.purple.withOpacity(.08)),
  );

  Widget _glassCard({required Widget child}) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(18.w),
    decoration: _glassDeco(context),
    child: child,
  );

  InputDecoration _input(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: AppColors.w1,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  ButtonStyle _btnStyle({required Color primary}) => ElevatedButton.styleFrom(
    backgroundColor: primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
  );
}
