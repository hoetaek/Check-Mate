import 'package:check_mate/constants.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CheckMateIconAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kMainColor,
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/check_logo.png',
                width: 50,
              ),
            ),
            Center(
              child: Hero(
                  tag: 'title',
                  child: Text(
                    'Check Mate',
                    style: Theme.of(context).textTheme.display2.copyWith(
                        color: kEmphasisMainColor, fontWeight: FontWeight.bold),
                  )),
            ),
            SignIconButton()
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}

class SignIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
          },
        ),
        Text(
          Provider.of<UserRepository>(context).status == Status.Authenticated
              ? "Sign out"
              : "Sign in",
          style: Theme.of(context).textTheme.button,
        ),
      ],
    );
  }
}
