import 'package:check_mate/constants.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/widgets/flutter_login/flutter_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Check Mate',
      titleTag: 'title',
      logo: 'assets/check_logo.png',
      logoTag: 'logo',
      headerMarginTop: 20,
      onLogin: (loginData) =>
          Provider.of<UserRepository>(context).signIn(context, loginData),
      onSignup: (loginData) =>
          Provider.of<UserRepository>(context).signUp(context, loginData),
      onSubmitAnimationCompleted: () {
        Navigator.pop(context);
      },
      onRecoverPassword: (_) => Future(null),
      theme: LoginTheme(
        primaryColor: kMainColor,
        accentColor: kEmphasisMainColor,
      ),
    );
  }
}
