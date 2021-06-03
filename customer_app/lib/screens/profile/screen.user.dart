import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/screens/profile/local_widgets/widget.profile.menu.dart';
import 'package:oyil_boutique/services/service.auth.dart';
import 'package:oyil_boutique/util/common.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:oyil_boutique/util/progress.screen.dart';

class UserScreen extends StatefulWidget {
  final User user;
  UserScreen({this.user});
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool editBtnClicked = false;
  TextEditingController nameController = TextEditingController();
  File imageFile;

  ProgressScreen ps = ProgressScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            editBtnClicked ? editProfileWidget() : profileWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: profileMenu(user: this.widget.user, context: context),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget editProfileWidget() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Update profile image", style: TextStyle(fontFamily: PoppinsSemiBold)),
                        content: Container(
                          height: 100,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          try {
                                            PickedFile pf = await ImagePicker().getImage(source: ImageSource.gallery);
                                            setState(() {
                                              imageFile = File(pf.path);
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text("Choose Image", style: TextStyle(fontFamily: PoppinsRegular, fontSize: 15, color: Color(0xff515C6F))),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          try {
                                            PickedFile pf = await ImagePicker().getImage(source: ImageSource.camera);
                                            setState(() {
                                              imageFile = File(pf.path);
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text("Capture Image", style: TextStyle(fontFamily: PoppinsRegular, fontSize: 15, color: Color(0xff515C6F))),
                                          ],
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                height: 120,
                width: 120,
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        // boxShadow: <BoxShadow>[
                        //   new BoxShadow(
                        //     color: Colors.grey,
                        //     blurRadius: 1,
                        //     offset: new Offset(0.0, 1.0),
                        //   ),
                        // ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageFile != null
                              ? FileImage(imageFile)
                              : widget.user.photoURL != null
                                  ? NetworkImage(widget.user.photoURL)
                                  : AssetImage('assets/images/dummyprofile.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xffF84877)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(OMIcons.edit, color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Color(0xffD3D3D3), width: 1),
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.black, fontFamily: PoppinsMedium, fontSize: 14),
                      decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.black, fontFamily: PoppinsMedium, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      OMIcons.person,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          // borderSide: BorderSide(
                          //   color: Color(0xffF84877),
                          //   style: BorderStyle.solid,
                          //   width: 1,
                          // ),
                        ),
                        onPressed: () {
                          setState(() {
                            editBtnClicked = false;
                          });
                        },
                        child: Text("Cancel", style: TextStyle(color: Colors.black, fontFamily: PoppinsMedium))),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    height: 45,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xffF84877),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        onPressed: () async {
                          if (nameController.text.isNotEmpty) {
                            showProgressDialog(context, ps);
                            await FirebaseAuthService().updateProfile(this.widget.user.uid, imageFile, nameController.text);
                            dismissProgressDialog(context, ps);
                            setState(() {
                              editBtnClicked = false;
                            });
                          } else {
                            showToast("Name cannot be empty", Colors.red);
                          }
                        },
                        child: Text(
                          'Update Profile',
                          style: TextStyle(color: Colors.white, fontFamily: PoppinsMedium),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget profileWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              // boxShadow: <BoxShadow>[
              //   new BoxShadow(
              //     color: Colors.grey,
              //     blurRadius: 15.0,
              //     offset: new Offset(0.0, 5.0),
              //   ),
              // ],
              shape: BoxShape.circle,
              image: DecorationImage(
                image: widget.user.photoURL != null ? NetworkImage(widget.user.photoURL) : AssetImage('assets/images/dummyprofile.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(widget.user.displayName, style: TextStyle(fontSize: 20, fontFamily: PoppinsMedium, color: Colors.black)),
        Text(widget.user.email, style: TextStyle(fontSize: 12, fontFamily: PoppinsMedium, color: Colors.black)),
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
                  setState(() {
                    editBtnClicked = true;
                    nameController.text = this.widget.user.displayName;
                  });
                },
                child: Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white, fontFamily: PoppinsMedium),
                )),
          ),
        )
      ],
    );
  }
}
