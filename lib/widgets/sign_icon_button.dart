import 'package:check_mate/constants.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Provider.of<UserRepository>(context).loggedIn
                ? FontAwesomeIcons.signOutAlt
                : FontAwesomeIcons.signInAlt,
            color: Colors.black54,
            size: 30.0,
          ),
          onPressed: () async {
            if (!Provider.of<UserRepository>(context).loggedIn) {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
              if (Provider.of<UserRepository>(context).user != null)
                Provider.of<UserRepository>(context).setStateAuthenticated();
            } else {
              Provider.of<UserRepository>(context).signOut();
            }
            Navigator.pop(context);
          },
        ),
        Text(
          Provider.of<UserRepository>(context).status == Status.Authenticated
              ? "Sign out"
              : "Sign in",
          style: kTileSubtitle.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
