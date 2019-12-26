import 'package:check_mate/constants.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/widgets/check_mate_logo_app_bar.dart';
import 'package:check_mate/widgets/simple_button.dart';
import 'package:check_mate/widgets/simple_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _error = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: CheckMateLogoAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text('사용자 정보', style: Theme.of(context).textTheme.display1),
              SizedBox(height: 30),
              //todo get user profile picture and upload it
              //todo if nickname already exists error
              //todo if white space in nickname error
              SimpleTextField(
                suffixIcon: Icon(FontAwesomeIcons.user),
                labelText: "사용자 닉네임",
                controller: controller,
                errorText: _error ? "닉네임을 입력하세요." : null,
              ),
              SizedBox(height: 12),
              Center(
                child: SimpleButton(
                  color: kMainColor,
                  onPressed: () {
                    setState(() {
                      //todo verify unique nickname
                      controller.text.isEmpty ? _error = true : _error = false;
                      if (!_error) {
                        FirebaseUser user =
                            Provider.of<UserRepository>(context).user;

                        Map<String, dynamic> userData = {
                          'uid': user.uid,
                          "nickname": controller.text
                        };
                        Provider.of<UserRepository>(context)
                            .todoFirestoreProvider
                            .addUsersData(userData);
                        Provider.of<UserRepository>(context).setUidExists();
                      }
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
