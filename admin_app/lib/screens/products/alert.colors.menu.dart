import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:obs_admin/models/model.colors.dart';
import 'package:obs_admin/services/service.manage.product.dart';
import 'package:smart_color/smart_color.dart';

class ColorsMenuAlert extends StatefulWidget {
  void dismissProgress(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  _ColorsMenuAlertState createState() => _ColorsMenuAlertState();
}

class _ColorsMenuAlertState extends State<ColorsMenuAlert> {
  bool screenLoading = true;
  List<OBSColor> obsColorList = [];

  @override
  void initState() {
    super.initState();
    getColors();
  }

  void getColors() async {
    List<OBSColor> list = await ManageProductService().loadColors();
    setState(() {
      obsColorList = list;
      screenLoading = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Choose color", style: TextStyle(fontWeight: FontWeight.bold)),
                screenLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: SpinKitChasingDots(color: Color(0xffF84877), size: 20.0),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: obsColorList.length,
                        itemBuilder: (context, index) {
                          return colorTile(index);
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget colorTile(int index) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, obsColorList[index]);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SmartColor.parse(obsColorList[index].color),
                border: Border.all(color: obsColorList[index].colorName == "White" ? Colors.grey[400] : SmartColor.parse(obsColorList[index].color)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(obsColorList[index].colorName),
            ),
          ],
        ),
      ),
    );
  }
}
