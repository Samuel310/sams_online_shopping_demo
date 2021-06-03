import 'package:flutter/material.dart';
import 'package:oyil_boutique/screens/auth/screen.login.dart';
import 'package:oyil_boutique/screens/profile/local_widgets/widget.profile.menu.dart';
import 'package:oyil_boutique/util/constants.dart';

class NoUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_banner.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              height: 45,
              child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xffF84877),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'Login or Signup',
                    style: TextStyle(color: Colors.white, fontFamily: PoppinsMedium),
                  )),
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: profileMenu(context: context)),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    ));
  }
}
