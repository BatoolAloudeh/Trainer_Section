
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainer_section/constant/ui/Colors/colors.dart';
import 'package:trainer_section/screen/Auth/Login.dart';

import '../../Bloc/cubit/Auth/checkCode.dart';
import '../../Bloc/states/Auth/checkCode.dart';
import '../../constant/ui/General constant/ConstantUi.dart';
import '../../localization/app_localizations.dart';

class CheckCodeScreen extends StatefulWidget {
  const CheckCodeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CheckCodeScreenState();
  }
}

class _CheckCodeScreenState extends State<CheckCodeScreen> {
  final TextEditingController codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  void _loadLanguagePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? savedLanguage = pref.getString('language');
    if (savedLanguage != null) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckCodeCubit(),
      child: Scaffold(
        backgroundColor: Color(0xFFf5f5f5),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Image.asset(
                      'assets/Images/Security.png',
                      width: 150,
                    ),
                  ),
                ),
                Expanded(child: _buildBody(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<CheckCodeCubit, CheckCodeState>(
      listener: (context, state) {
        if (state is CheckCodeSuccess) {

          navigateTo(context, LoginScreen());
        } else if (state is CheckCodeError) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)?.translate("verification_system") ?? "Verification System",

              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)?.translate("verification_instruction") ?? "Enter the verification code sent to your email.",

              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 20),
            _buildVerificationForm(state, context),
          ],
        );
      },
    );
  }

  Widget _buildVerificationForm(CheckCodeState state, BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Pinput(
            controller: codeController,
            length: 5,
            defaultPinTheme: PinTheme(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.darkBlue),
              ),
            ),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          SizedBox(height: 20),
          state is CheckCodeLoading
              ? CircularProgressIndicator(color: AppColors.darkBlue)
              : Center(
            child: ElevatedButton.icon(
              label: Text(
                AppLocalizations.of(context)?.translate("next") ?? "Next",

                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkBlue,
                padding:
                EdgeInsets.symmetric(vertical: 16, horizontal: 35),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final token = codeController.text;
                  BlocProvider.of<CheckCodeCubit>(context)
                      .verifyEmailToken(token: token);
                }
              },
              icon: Icon(Icons.check, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
