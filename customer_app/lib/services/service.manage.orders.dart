import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:oyil_boutique/models/modals.orders.dart';
import 'package:oyil_boutique/models/modals.product.variant.dart';
import 'package:oyil_boutique/models/model.main.order.dart';
import 'package:oyil_boutique/models/model.product.dart';
import 'package:oyil_boutique/models/models.address.dart';
import 'package:oyil_boutique/util/constants.dart';
import 'package:oyil_boutique/models/modal.admin.dart';

class ManageOrdersService {
  CollectionReference ordersCollection;
  CollectionReference readyToShopCollection;
  CollectionReference userCollection;
  Reference storageRef;
  DocumentSnapshot lastDocument;

  int pagePerProdut = 5;
  bool reachedEnd = false;

  ManageOrdersService() {
    ordersCollection = FirebaseFirestore.instance.collection("orders");
    readyToShopCollection = FirebaseFirestore.instance.collection("readytoshop");
    userCollection = FirebaseFirestore.instance.collection("users");
    storageRef = FirebaseStorage.instance.ref().child('readytoshop');
  }

  Future getOrderList(String userId) async {
    if (!reachedEnd) {
      try {
        QuerySnapshot<Map<String, dynamic>> qs =
            await ordersCollection.where("userId", isEqualTo: userId).where("paid", isEqualTo: true).orderBy("placedDate", descending: true).limit(pagePerProdut).get();
        if (qs.docs.length != 0) {
          lastDocument = qs.docs[qs.docs.length - 1];
        }
        if (qs.docs.length < pagePerProdut) {
          this.reachedEnd = true;
        }
        return await Future.wait(qs.docs.map((orderDqs) async {
          DocumentSnapshot<Map<String, dynamic>> variantDqs = await readyToShopCollection.doc(orderDqs.data()['productId']).collection("variants").doc(orderDqs.data()['variantId']).get();
          int price = variantDqs.data()['price'] ?? 0;
          int sellingPrice = variantDqs.data()['sellingPrice'] ?? 0;
          double off = 100 - ((sellingPrice / price) * 100);
          QuerySnapshot<Map<String, dynamic>> colorQSnapshot =
              await readyToShopCollection.doc(orderDqs.data()['productId']).collection("colors").where('color', isEqualTo: variantDqs.data()['color']).get();
          QueryDocumentSnapshot<Map<String, dynamic>> colorDQSnapshot = colorQSnapshot.docs[0];
          List<String> imagesNameList = colorDQSnapshot.data()['images'].cast<String>();
          List<String> urlList = [];
          String url = await storageRef.child(orderDqs.data()['productId']).child(variantDqs.data()['color']).child(imagesNameList[0]).getDownloadURL();
          urlList.add(url);
          Variant variantData = Variant(
            color: variantDqs.data()['color'] ?? 'Empty',
            productId: orderDqs.data()['productId'] ?? 'empty',
            qty: variantDqs.data()['qty'] ?? 'Empty',
            size: variantDqs.data()['size'] ?? 'Empty',
            colorname: variantDqs.data()['colorname'] ?? 'Empty',
            variantId: variantDqs.id ?? 'Empty',
            price: price,
            sellingprice: sellingPrice,
            off: off,
            imageUrls: urlList,
          );
          DocumentSnapshot<Map<String, dynamic>> productDqs = await readyToShopCollection.doc(orderDqs.data()['productId']).get();
          Product productData = Product(
            productId: productDqs.id ?? 'EMPTY',
            category: productDqs.data()['category'] ?? 'EMPTY',
            description: productDqs.data()['description'] ?? 'EMPTY',
            details: productDqs.data()['details'] ?? 'EMPTY',
            productname: productDqs.data()['productname'] ?? 'EMPTY',
            producttype: productDqs.data()['producttypes'] ?? 'EMPTY',
            subCategory: productDqs.data()['subcategory'] ?? 'EMPTY',
            variant: variantData,
          );

          ShippingAddress shippingAddress = ShippingAddress(
            address: orderDqs.data()['address'] ?? "EMPTY",
            city: orderDqs.data()['city'] ?? "EMPTY",
            country: orderDqs.data()['country'] ?? "EMPTY",
            fullname: orderDqs.data()['fullname'] ?? "EMPTY",
            phone: orderDqs.data()['phone'] ?? "EMPTY",
            pincode: orderDqs.data()['pincode'] ?? "EMPTY",
            state: orderDqs.data()['state'] ?? "EMPTY",
          );

          Orders orders = Orders(
            ahEmail: orderDqs.data()['ahEmail'] ?? "EMPTY",
            orderStatus: orderDqs.data()['orderStatus'] ?? "EMPTY",
            paid: orderDqs.data()['paid'] ?? "EMPTY",
            placedDate: orderDqs.data()['placedDate'] ?? "EMPTY",
            qty: orderDqs.data()['qty'],
            totalPrice: orderDqs.data()['totalPrice'] ?? "EMPTY",
            userId: orderDqs.data()['userId'] ?? "EMPTY",
            orderId: orderDqs.id,
            address: shippingAddress,
            productId: productDqs.id ?? 'EMPTY',
            variantId: variantDqs.id ?? 'Empty',
          );
          return MainOrder(
            orders: orders,
            product: productData,
          );
        }).toList());
      } catch (e) {
        print("XXXXXXXXXX error on getOrderList");
        print(e);
      }
    } else {
      return "Reached end";
    }
  }

  Future getMoreOrderList(String userId) async {
    if (!reachedEnd) {
      try {
        QuerySnapshot<Map<String, dynamic>> qs = await ordersCollection
            .where("userId", isEqualTo: userId)
            .where("paid", isEqualTo: true)
            .orderBy("placedDate", descending: true)
            .startAfterDocument(lastDocument)
            .limit(pagePerProdut)
            .get();
        if (qs.docs.length != 0) {
          lastDocument = qs.docs[qs.docs.length - 1];
        }
        if (qs.docs.length < pagePerProdut) {
          this.reachedEnd = true;
        }
        return await Future.wait(qs.docs.map((orderDqs) async {
          DocumentSnapshot<Map<String, dynamic>> variantDqs = await readyToShopCollection.doc(orderDqs.data()['productId']).collection("variants").doc(orderDqs.data()['variantId']).get();
          int price = variantDqs.data()['price'] ?? 0;
          int sellingPrice = variantDqs.data()['sellingPrice'] ?? 0;
          double off = 100 - ((sellingPrice / price) * 100);
          QuerySnapshot<Map<String, dynamic>> colorQSnapshot =
              await readyToShopCollection.doc(orderDqs.data()['productId']).collection("colors").where('color', isEqualTo: variantDqs.data()['color']).get();
          QueryDocumentSnapshot<Map<String, dynamic>> colorDQSnapshot = colorQSnapshot.docs[0];
          List<String> imagesNameList = colorDQSnapshot.data()['images'].cast<String>();
          List<String> urlList = [];
          String url = await storageRef.child(orderDqs.data()['productId']).child(variantDqs.data()['color']).child(imagesNameList[0]).getDownloadURL();
          urlList.add(url);
          Variant variantData = Variant(
            color: variantDqs.data()['color'] ?? 'Empty',
            productId: orderDqs.data()['productId'] ?? 'empty',
            qty: variantDqs.data()['qty'] ?? 'Empty',
            size: variantDqs.data()['size'] ?? 'Empty',
            colorname: variantDqs.data()['colorname'] ?? 'Empty',
            variantId: variantDqs.id ?? 'Empty',
            price: price,
            sellingprice: sellingPrice,
            off: off,
            imageUrls: urlList,
          );
          DocumentSnapshot<Map<String, dynamic>> productDqs = await readyToShopCollection.doc(orderDqs.data()['productId']).get();
          Product productData = Product(
            productId: productDqs.id ?? 'EMPTY',
            category: productDqs.data()['category'] ?? 'EMPTY',
            description: productDqs.data()['description'] ?? 'EMPTY',
            details: productDqs.data()['details'] ?? 'EMPTY',
            productname: productDqs.data()['productname'] ?? 'EMPTY',
            producttype: productDqs.data()['producttypes'] ?? 'EMPTY',
            subCategory: productDqs.data()['subcategory'] ?? 'EMPTY',
            variant: variantData,
          );

          ShippingAddress shippingAddress = ShippingAddress(
            address: orderDqs.data()['address'] ?? "EMPTY",
            city: orderDqs.data()['city'] ?? "EMPTY",
            country: orderDqs.data()['country'] ?? "EMPTY",
            fullname: orderDqs.data()['fullname'] ?? "EMPTY",
            phone: orderDqs.data()['phone'] ?? "EMPTY",
            pincode: orderDqs.data()['pincode'] ?? "EMPTY",
            state: orderDqs.data()['state'] ?? "EMPTY",
          );

          Orders orders = Orders(
            ahEmail: orderDqs.data()['ahEmail'] ?? "EMPTY",
            orderStatus: orderDqs.data()['orderStatus'] ?? "EMPTY",
            paid: orderDqs.data()['paid'] ?? "EMPTY",
            placedDate: orderDqs.data()['placedDate'] ?? "EMPTY",
            qty: orderDqs.data()['qty'],
            totalPrice: orderDqs.data()['totalPrice'] ?? "EMPTY",
            userId: orderDqs.data()['userId'] ?? "EMPTY",
            orderId: orderDqs.id,
            address: shippingAddress,
            productId: productDqs.id ?? 'EMPTY',
            variantId: variantDqs.id ?? 'Empty',
          );
          return MainOrder(
            orders: orders,
            product: productData,
          );
        }).toList());
      } catch (e) {
        print("XXXXXXXXXX error on getMoreProductList");
        print(e);
        //return e.message;
      }
    } else {
      return "Reached end";
    }
  }

  Future refresh(String userId) {
    this.reachedEnd = false;
    return getOrderList(userId);
  }

  Future loadAdminContactDetails() async {
    DocumentSnapshot<Map<String, dynamic>> ds = await userCollection.doc("obsadmin").get();
    if (ds.data().isNotEmpty) {
      adminContactDetail = Admin(email: ds.data()["email"] ?? "empty", phone: ds.data()["phone"] ?? "empty");
    }
  }
}
