import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:oyil_boutique/global_widgets/appbar.dart';
import 'package:oyil_boutique/models/models.address.dart';
import 'package:oyil_boutique/screens/checkout/screens.add.address.dart';
import 'package:oyil_boutique/services/service.checkout.dart';
import 'package:oyil_boutique/util/constants.dart';

class ShippingAddressScreen extends StatefulWidget {
  final User user;
  ShippingAddressScreen({this.user});

  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  bool isScreenLoading = true;
  List<ShippingAddress> addressList;
  SwipeActionController controller = SwipeActionController();
  CheckOutDatabaseService checkOutDatabaseService = CheckOutDatabaseService();

  @override
  void initState() {
    super.initState();
    loadAllAddress();
  }

  void loadAllAddress() async {
    List<ShippingAddress> ls = await checkOutDatabaseService.getAllAddress(widget.user.uid);
    setState(() {
      addressList = ls;
      isScreenLoading = false;
    });
  }

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
                    child: isScreenLoading
                        ? Center(
                            child: SpinKitChasingDots(
                              color: Color(0xffF84877),
                              size: 40.0,
                            ),
                          )
                        : (addressList == null || addressList.isEmpty)
                            ? Center(
                                child: SizedBox(
                                  height: 45,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        backgroundColor: Color(0xffF84877),
                                      ),
                                      onPressed: () async {
                                        ShippingAddress sa = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddAddress(
                                                user: widget.user,
                                              ),
                                            ));
                                        if (sa != null) {
                                          addressList.add(sa);
                                          setState(() {});
                                        }
                                      },
                                      child: Text(
                                        "Add Address",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      )),
                                ),
                              )
                            : addressListWidget(context)),
              ),
              appBar(title: "Address", showBackArrow: true, context: context)
            ],
          ),
        ),
      ),
    );
  }

  Widget addressListWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "Manage Shipping Address",
            style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: PoppinsSemiBold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: addressList.length,
            itemBuilder: (context, index) {
              return SwipeActionCell(
                controller: controller,
                index: index,
                key: ValueKey(addressList[index]),
                performsFirstActionWithFullSwipe: true,
                trailingActions: [
                  SwipeAction(
                      icon: Icon(OMIcons.delete, color: Colors.white),
                      color: Color(0xffF84877),
                      onTap: (handler) async {
                        await handler(true);
                        await checkOutDatabaseService.deleteAddress(this.widget.user.uid, addressList[index].id);
                        addressList.removeAt(index);
                        setState(() {});
                      }),
                ],
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: addressListItem(addressList[index]),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  backgroundColor: Color(0xffF84877),
                ),
                onPressed: () async {
                  ShippingAddress sa = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddAddress(
                          user: widget.user,
                        ),
                      ));
                  if (sa != null) {
                    addressList.add(sa);
                    setState(() {});
                  }
                },
                child: Text(
                  "Add New Address",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )),
          ),
        ),
        SizedBox(height: 15)
      ],
    );
  }

  Widget addressListItem(ShippingAddress address) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${address.fullname} - ${address.phone}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text(address.address, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text(address.city, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text("${address.state} - ${address.pincode}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
          Text(address.country, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: PoppinsRegular)),
        ],
      ),
    );
  }
}
