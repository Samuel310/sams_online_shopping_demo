import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/global_widgets/appbar.dart';
import 'package:oyil_boutique/screens/cart/screen.cart.wrapper.dart';
import 'package:oyil_boutique/screens/categories/categories.dart';
import 'package:oyil_boutique/screens/home/home.dart';
import 'package:oyil_boutique/screens/profile/screen.profilescreenwrpper.dart';
import 'package:oyil_boutique/util/constants.dart';

class NavigationDrawerScreen extends StatefulWidget {
  final User user;
  NavigationDrawerScreen({this.user});
  @override
  _NavigationDrawerScreenState createState() => _NavigationDrawerScreenState();
}

class _NavigationDrawerScreenState extends State<NavigationDrawerScreen> {
  int _currentIndex = 0;
  PageController _pageController;
  String appBarTitle = "Welcome";

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("From navigation drawer screen");
    print((this.widget.user == null) ? "No user present" : this.widget.user);

    return DoubleBack(
      child: Scaffold(
        backgroundColor: Color(0xffF84877),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 56),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                        if (index == 0) {
                          appBarTitle = "Welcome";
                        } else if (index == 1) {
                          appBarTitle = "Categories";
                        } else if (index == 2) {
                          appBarTitle = "Cart";
                        } else if (index == 3) {
                          appBarTitle = "Profile";
                        }
                      });
                    },
                    children: <Widget>[
                      HomeScreen(),
                      CategoriesScreen(),
                      CartWrapper(user: this.widget.user),
                      ProfileScreenWrapper(user: this.widget.user),
                    ],
                  ),
                ),
                appBar(
                  title: appBarTitle,
                  context: context,
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index;
              if (index == 0) {
                appBarTitle = "Welcome";
              } else if (index == 1) {
                appBarTitle = "Categories";
              } else if (index == 2) {
                appBarTitle = "Cart";
              } else if (index == 3) {
                appBarTitle = "Profile";
              }
            });
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              activeColor: Color(0xffF84877),
              inactiveColor: Color(0xff515C6F),
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Home', style: TextStyle(fontFamily: PoppinsRegular, fontSize: 12)),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(OMIcons.home),
              ),
            ),
            BottomNavyBarItem(
              activeColor: Color(0xffF84877),
              inactiveColor: Color(0xff515C6F),
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Shop', style: TextStyle(fontFamily: PoppinsRegular, fontSize: 12)),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(OMIcons.localMall),
              ),
            ),
            BottomNavyBarItem(
              activeColor: Color(0xffF84877),
              inactiveColor: Color(0xff515C6F),
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Cart', style: TextStyle(fontFamily: PoppinsRegular, fontSize: 12)),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(OMIcons.shoppingCart),
              ),
            ),
            BottomNavyBarItem(
              activeColor: Color(0xffF84877),
              inactiveColor: Color(0xff515C6F),
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Profile', style: TextStyle(fontFamily: PoppinsRegular, fontSize: 12)),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(OMIcons.person),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
