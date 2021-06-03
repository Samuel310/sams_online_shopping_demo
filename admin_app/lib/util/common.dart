import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:obs_admin/util/constants.dart';
import 'package:obs_admin/util/progress.screen.dart';

void showProgressDialog(BuildContext context, ProgressScreen ps) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return ps;
    },
  );
}

void dismissProgressDialog(BuildContext context, ProgressScreen ps) {
  ps.dismissProgress(context);
}

void showToast(String msg, Color color) {
  Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: color, textColor: Colors.white, fontSize: 12.0);
}

Widget textWidget({TextEditingController controller, String title, bool dissabled = false, bool enableParagraphInput = false, Function onChangeListener, bool numberInput = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(color: Color(0xffF84877), fontSize: 10, fontFamily: PoppinsMedium),
      ),
      SizedBox(height: 5),
      Container(
        height: enableParagraphInput ? null : 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: Color(0xffD3D3D3), width: 1),
        ),
        child: Center(
          child: enableParagraphInput
              ? TextField(
                  onChanged: (value) {
                    if (onChangeListener != null) {
                      onChangeListener();
                    }
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  enabled: !dissabled,
                  controller: controller,
                  style: TextStyle(color: Colors.black, fontFamily: PoppinsRegular, fontSize: 12),
                  decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5)),
                )
              : TextField(
                  keyboardType: numberInput ? TextInputType.number : TextInputType.text,
                  inputFormatters: numberInput
                      ? <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ]
                      : [],
                  onChanged: (value) {
                    if (onChangeListener != null) {
                      onChangeListener();
                    }
                  },
                  enabled: !dissabled,
                  controller: controller,
                  style: TextStyle(color: Colors.black, fontFamily: PoppinsRegular, fontSize: 12),
                  decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5)),
                ),
        ),
      ),
    ],
  );
}
