import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oyil_boutique/global_widgets/appbar.dart';
import 'package:oyil_boutique/models/modal.checkout.dart';
import 'package:oyil_boutique/models/models.address.dart';
import 'package:oyil_boutique/screens/checkout/screens.summary.dart';
import 'package:oyil_boutique/services/service.checkout.dart';
import 'package:oyil_boutique/util/common.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:oyil_boutique/util/progress.screen.dart';

class AddAddress extends StatefulWidget {
  final CheckoutModel checkoutProduct;
  final List<CheckoutModel> checkoutProductList;
  final User user;
  AddAddress({this.checkoutProduct, this.user, this.checkoutProductList});
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  CheckOutDatabaseService checkOutDatabaseService = CheckOutDatabaseService();

  ProgressScreen ps = ProgressScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffF84877),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 56),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        textWidget(controller: fullNameController, title: "Full Name"),
                        SizedBox(
                          height: 15,
                        ),
                        numberWidget(controller: phoneNumberController, title: "Phone", maxlength: 10),
                        SizedBox(
                          height: 15,
                        ),
                        textWidget(controller: addressController, title: "Address"),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(right: 7.5),
                              child: numberWidget(controller: pincodeController, title: "Zip Code", maxlength: 6),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 7.5),
                              child: textWidget(controller: cityController, title: "City", dissabled: true),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(right: 7.5),
                              child: textWidget(controller: stateController, title: "State", dissabled: true),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 7.5),
                              child: textWidget(controller: countryController, title: "Country", dissabled: true),
                            )),
                          ],
                        ),
                        Expanded(child: SizedBox(width: 2)),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 7.5),
                                child: SizedBox(
                                  height: 50,
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
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Back",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 7.5),
                                child: SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        backgroundColor: Color(0xffF84877),
                                      ),
                                      onPressed: () {
                                        onSavebtnPressed();
                                      },
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              appBar(title: "Add Address", showBackArrow: true, context: context)
            ],
          ),
        ),
      ),
    );
  }

  void onSavebtnPressed() async {
    if (fullNameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        pincodeController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        countryController.text.isNotEmpty) {
      ShippingAddress shippingAddress = ShippingAddress(
          address: addressController.text,
          city: cityController.text,
          country: countryController.text,
          fullname: fullNameController.text,
          phone: phoneNumberController.text,
          pincode: pincodeController.text,
          state: stateController.text);
      showProgressDialog(context, ps);
      Map<String, dynamic> map = await checkOutDatabaseService.getAddressWithId(this.widget.user.uid, shippingAddress);
      if (map != null && map['totalDocs'] == 0) {
        String errorMsg = await checkOutDatabaseService.addNewAddress(this.widget.user.uid, shippingAddress);

        if (errorMsg != null) {
          dismissProgressDialog(context, ps);
          Fluttertoast.showToast(
              msg: errorMsg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 12.0);
        } else {
          Map<String, dynamic> map = await checkOutDatabaseService.getAddressWithId(this.widget.user.uid, shippingAddress);
          dismissProgressDialog(context, ps);
          if (map != null && map['address'] != null) {
            ShippingAddress addressWithId = map['address'];
            if (this.widget.checkoutProduct != null || this.widget.checkoutProductList != null) {
              if (this.widget.checkoutProductList != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(
                        checkoutProductList: this.widget.checkoutProductList,
                        shippingAddress: addressWithId,
                        user: this.widget.user,
                      ),
                    ));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(
                        checkoutProduct: this.widget.checkoutProduct,
                        shippingAddress: addressWithId,
                        user: this.widget.user,
                      ),
                    ));
              }
            } else {
              Navigator.pop(context, addressWithId);
            }
          } else {
            Navigator.pop(context);
          }
        }
      } else if (map == null) {
        dismissProgressDialog(context, ps);
        Fluttertoast.showToast(
            msg: 'Error occured', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 12.0);
      } else {
        dismissProgressDialog(context, ps);
        Fluttertoast.showToast(
            msg: 'This address already exists',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please fill all fields", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 12.0);
    }
  }

  Widget textWidget({TextEditingController controller, String title, bool dissabled = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Color(0xffF84877), fontSize: 10, fontFamily: PoppinsMedium),
        ),
        SizedBox(height: 5),
        Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Color(0xffD3D3D3), width: 1),
          ),
          child: Center(
            child: TextField(
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

  Widget numberWidget({TextEditingController controller, String title, bool dissabled = false, int maxlength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Color(0xffF84877), fontSize: 10, fontFamily: PoppinsMedium),
        ),
        SizedBox(height: 5),
        Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Color(0xffD3D3D3), width: 1),
          ),
          child: Center(
            child: TextField(
              onChanged: (value) async {
                if (maxlength == 6 && value.length == 6) {
                  Map<String, String> result = await getCityAndCountry(value);
                  if (result != null) {
                    setState(() {
                      cityController.text = result['city'];
                      stateController.text = result['state'];
                      countryController.text = result['country'];
                    });
                  }
                }
              },
              maxLength: maxlength,
              enabled: !dissabled,
              controller: controller,
              style: TextStyle(color: Colors.black, fontFamily: PoppinsRegular, fontSize: 12),
              decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5), counterText: ""),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        ),
      ],
    );
  }
}
