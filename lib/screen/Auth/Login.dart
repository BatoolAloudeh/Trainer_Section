
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainer_section/Bloc/cubit/Auth/Login.dart';
import 'package:trainer_section/Bloc/states/Auth/Login.dart';
import 'package:trainer_section/constant/ui/General%20constant/ConstantUi.dart';
import 'package:trainer_section/screen/Auth/Verification.dart';
import 'package:trainer_section/screen/Home/Courses/MainPage/ShowCourses.dart';
import '../../constant/constantKey/key.dart';
import '../../constant/ui/Colors/colors.dart';
import '../../constant/ui/Sizes/sizes.dart';
import '../../localization/app_localizations.dart';
import '../../network/local/cacheHelper.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool password = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return
      BlocProvider(
        create: (context) => LoginCubit(),
        child:
      Scaffold(
      backgroundColor: AppColors.highlightPurple,
      body: Stack(
        children: [
          isMobile ? _buildMobileLayout() : _buildWebLayout(),
          if (!isMobile)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 150.h,
                width: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.r),
                  ),
                ),
              ),
            ),
        ],
      ),),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      children: [


        Expanded(
          flex: 1,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  height: 150.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.purple,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(100.r),
                    ),
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/Images/Login.png',
                  width: 500,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        // Right Side - Form

        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: _buildLoginForm(),
              ),
            ),
          ),
        ),


      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Image.asset(
            'assets/Images/Login.png',
            width: 250.w,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: _buildLoginForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return
      Form(
        key: formKey,

        child:
      Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Text(
            AppLocalizations.of(context)?.translate("Login") ?? "Login",
            style: TextStyle(
              color: AppColors.blue,
              fontSize: AppSize.l2121,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        defaultFormField(
          keyboardtype: TextInputType.emailAddress,
          text:
          AppLocalizations.of(context)?.translate("Email") ?? "Email"
         ,
          prefix: Icons.email,
          controller: emailController,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return
                AppLocalizations.of(context)?.translate("No Email") ?? "No Email"
                ;
            } else if (!RegExp(
                r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                .hasMatch(value)) {
              return 'Invalid email format';
            }
            return null;
          },
          onChanged: (value) {},
          onTap: () {},
        ),

        SizedBox(height: 10),

        defaultFormField(
          keyboardtype: TextInputType.visiblePassword,
          text:
          AppLocalizations.of(context)?.translate("password") ?? "password"
          ,
          prefix: Icons.lock,
          controller: passwordController,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return
                AppLocalizations.of(context)?.translate("No password") ?? "No password"
              ;
            } else if (value.length < 6) {
              return
                AppLocalizations.of(context)?.translate("Invalid password") ?? "Invalid password"
               ;
            }
            return null;
          },
          isPassword: password,
          suffix: password ? Icons.visibility_off : Icons.visibility,
          suffixButton: () {
            setState(() {
              password = !password;
            });
          },
          onChanged: (value) {},
          onTap: () {},
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,

          child:
          BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                  // CacheHelper.saveData(
                  //   key: TOKENKEY,
                  //   value: state.accessData.accessToken,
                  // ).then((value) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => CoursesDashboard(token:  CacheHelper.getData(key: TOKENKEY) as String, idTrainer: state.accessData.user.id,),
                  //     ),
                  //   );
                  // });

                final trainerId = state.accessData.user.id;
                final token     = state.accessData.accessToken;
                final userName  = state.accessData.user.name;
                final userPhoto = state.accessData.user.photo; // may be null
                CacheHelper.saveData(key: 'trainer_id', value: trainerId);
                CacheHelper.saveData(key: TOKENKEY,     value: token);
                CacheHelper.saveData(key: 'user_name',    value: userName);
                CacheHelper.saveData(key: 'user_photo',   value: userPhoto);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoursesDashboard(
                      token: token,
                      idTrainer: trainerId,
                    ),
                  ),
                );

                print('TOKENKEY=$TOKENKEY');
                print('success');

              }
            },
            builder: (context, state) {
              return

                Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  SizedBox(
                    height: AppSize.buttonHeight,
                    child: state is LoginLoading
                        ? Center(child: CircularProgressIndicator(color: AppColors.white))
                        : defaultButton(
                      text:
                      AppLocalizations.of(context)?.translate("Login") ?? "Login"
                      ,
                      // داخل onPressed لزر Login
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        context.read<LoginCubit>().login(
                          email: emailController.text.trim(),
                          password: passwordController.text,
                        );
                      },



                      // onPressed: () async {
                      //   if (!formKey.currentState!.validate()) return;
                      //
                      //   // get FCM token
                      //   String? fcmToken;
                      //   try {
                      //     if (kIsWeb) {
                      //       fcmToken = await FirebaseMessaging.instance.getToken(
                      //         vapidKey: 'BMUIu0ik_OZJ9r9n3GPXib5fouwP02aKUqHBPJZFio406nmC_henlk7OtEco9fc5xd7Q3q_tZM0RuP6oBBPqTPc',
                      //       );
                      //     } else {
                      //       fcmToken = await FirebaseMessaging.instance.getToken();
                      //     }
                      //     debugPrint('FCM token when logging in: $fcmToken');
                      //   } catch (e) {
                      //     debugPrint('FCM getToken error: $e');
                      //     fcmToken = null;
                      //   }
                      //
                      //   // call cubit with fcm token
                      //   context.read<LoginCubit>().login(
                      //     email: emailController.text.trim(),
                      //     password: passwordController.text,
                      //     // fcmToken: fcmToken!,
                      //   );
                      // },

                      background: AppColors.white,
                    ),
                  ),



                  if (state is LoginNotVerified) ...[
                    SizedBox(height: 12.h),
                    Row(
                      children: [

Expanded(
  child:
                     Text(
                       AppLocalizations.of(context)?.translate("You haven't verified your account. Verify it then login again.") ?? "You haven't verified your account. Verify it then login again."
                            ,
                            style: TextStyle(color: AppColors.orange),
                          ),),



                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CheckCodeScreen()),
                            );
                          },
                          child: Text(
                              AppLocalizations.of(context)?.translate("Verification Page") ?? "Verification Page"
                             ),
                        ),
                      ],
                    ),
                  ],


                  if (state is LoginFailure) ...[
                    SizedBox(height: 12),
                    Text(
                      state.error,
                      style: TextStyle(color: Colors.red, ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              );
            },
          ),

        ),
      ],)
    );
  }
}



