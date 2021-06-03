import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:obs_admin/models/model.order.dart';
import 'package:obs_admin/models/model.product.dart';
import 'package:obs_admin/models/model.variant.dart';

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

  Future getOrderList(String orderStatus) async {
    if (!reachedEnd) {
      try {
        QuerySnapshot<Map<String, dynamic>> qs =
            await ordersCollection.where("orderStatus", isEqualTo: orderStatus).where("paid", isEqualTo: true).orderBy("placedDate", descending: true).limit(pagePerProdut).get();
        if (qs.docs.length != 0) {
          lastDocument = qs.docs[qs.docs.length - 1];
        }
        if (qs.docs.length < pagePerProdut) {
          this.reachedEnd = true;
        }
        return await Future.wait(qs.docs.map((orderDqs) async {
          DocumentSnapshot<Map<String, dynamic>> productDqs = await readyToShopCollection.doc(orderDqs.data()['productId']).get();
          Product productData = Product(
            productId: productDqs.id ?? 'EMPTY',
            category: productDqs.data()['category'] ?? 'EMPTY',
            description: productDqs.data()['description'] ?? 'EMPTY',
            details: productDqs.data()['details'] ?? 'EMPTY',
            productname: productDqs.data()['productname'] ?? 'EMPTY',
            producttype: productDqs.data()['producttypes'] ?? 'EMPTY',
            subCategory: productDqs.data()['subcategory'] ?? 'EMPTY',
          );
          DocumentSnapshot<Map<String, dynamic>> variantDqs = await readyToShopCollection.doc(orderDqs.data()['productId']).collection("variants").doc(orderDqs.data()['variantId']).get();
          int price = variantDqs.data()['price'] ?? 0;
          int sellingPrice = variantDqs.data()['sellingPrice'] ?? 0;
          double off = 100 - ((sellingPrice / price) * 100);
          QuerySnapshot colorQSnapshot = await readyToShopCollection.doc(orderDqs.data()['productId']).collection("colors").where('color', isEqualTo: variantDqs.data()['color']).get();
          QueryDocumentSnapshot<Map<String, dynamic>> colorDQSnapshot = colorQSnapshot.docs[0];
          List<String> imagesNameList = colorDQSnapshot.data()['images'].cast<String>();
          List<ProductImages> urlList = [];
          String url = await storageRef.child(orderDqs.data()['productId']).child(variantDqs.data()['color']).child(imagesNameList[0]).getDownloadURL();
          urlList.add(ProductImages(imageName: imagesNameList[0], url: url));
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
            productImageList: urlList,
          );
          return Order(
            address: orderDqs.data()['address'] ?? "EMPTY",
            city: orderDqs.data()['city'] ?? "EMPTY",
            country: orderDqs.data()['country'] ?? "EMPTY",
            fullname: orderDqs.data()['fullname'] ?? "EMPTY",
            phone: orderDqs.data()['phone'] ?? "EMPTY",
            pincode: orderDqs.data()['pincode'] ?? "EMPTY",
            state: orderDqs.data()['state'] ?? "EMPTY",
            productData: productData,
            variantData: variantData,
            ahEmail: orderDqs.data()['ahEmail'] ?? "EMPTY",
            orderStatus: orderDqs.data()['orderStatus'] ?? "EMPTY",
            paid: orderDqs.data()['paid'] ?? "EMPTY",
            placedDate: orderDqs.data()['placedDate'] ?? "EMPTY",
            qty: orderDqs.data()['qty'],
            totalPrice: orderDqs.data()['totalPrice'] ?? "EMPTY",
            userId: orderDqs.data()['userId'] ?? "EMPTY",
            orderId: orderDqs.id,
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

  Future getMoreOrderList(String orderStatus) async {
    if (!reachedEnd) {
      try {
        QuerySnapshot<Map<String, dynamic>> qs = await ordersCollection
            .where("orderStatus", isEqualTo: orderStatus)
            .where("paid", isEqualTo: true)
            .orderBy("placedDate", descending: true)
            .startAfterDocument(lastDocument)
            .limit(pagePerProdut)
            .get();
        print(qs.docs.length);
        if (qs.docs.length != 0) {
          lastDocument = qs.docs[qs.docs.length - 1];
        }
        if (qs.docs.length < pagePerProdut) {
          this.reachedEnd = true;
        }
        return await Future.wait(qs.docs.map((orderDqs) async {
          DocumentSnapshot<Map<String, dynamic>> productDqs = await readyToShopCollection.doc(orderDqs.data()['productId']).get();
          Product productData = Product(
            productId: productDqs.id ?? 'EMPTY',
            category: productDqs.data()['category'] ?? 'EMPTY',
            description: productDqs.data()['description'] ?? 'EMPTY',
            details: productDqs.data()['details'] ?? 'EMPTY',
            productname: productDqs.data()['productname'] ?? 'EMPTY',
            producttype: productDqs.data()['producttypes'] ?? 'EMPTY',
            subCategory: productDqs.data()['subcategory'] ?? 'EMPTY',
          );
          DocumentSnapshot<Map<String, dynamic>> variantDqs = await readyToShopCollection.doc(orderDqs.data()['productId']).collection("variants").doc(orderDqs.data()['variantId']).get();
          int price = variantDqs.data()['price'] ?? 0;
          int sellingPrice = variantDqs.data()['sellingPrice'] ?? 0;
          double off = 100 - ((sellingPrice / price) * 100);
          QuerySnapshot colorQSnapshot = await readyToShopCollection.doc(orderDqs.data()['productId']).collection("colors").where('color', isEqualTo: variantDqs.data()['color']).get();
          QueryDocumentSnapshot<Map<String, dynamic>> colorDQSnapshot = colorQSnapshot.docs[0];
          List<String> imagesNameList = colorDQSnapshot.data()['images'].cast<String>();
          List<ProductImages> urlList = [];
          String url = await storageRef.child(orderDqs.data()['productId']).child(variantDqs.data()['color']).child(imagesNameList[0]).getDownloadURL();
          urlList.add(ProductImages(imageName: imagesNameList[0], url: url));
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
            productImageList: urlList,
          );
          return Order(
            address: orderDqs.data()['address'] ?? "EMPTY",
            city: orderDqs.data()['city'] ?? "EMPTY",
            country: orderDqs.data()['country'] ?? "EMPTY",
            fullname: orderDqs.data()['fullname'] ?? "EMPTY",
            phone: orderDqs.data()['phone'] ?? "EMPTY",
            pincode: orderDqs.data()['pincode'] ?? "EMPTY",
            state: orderDqs.data()['state'] ?? "EMPTY",
            productData: productData,
            variantData: variantData,
            ahEmail: orderDqs.data()['ahEmail'] ?? "EMPTY",
            orderStatus: orderDqs.data()['orderStatus'] ?? "EMPTY",
            paid: orderDqs.data()['paid'] ?? "EMPTY",
            placedDate: orderDqs.data()['placedDate'] ?? "EMPTY",
            qty: orderDqs.data()['qty'],
            totalPrice: orderDqs.data()['totalPrice'] ?? "EMPTY",
            userId: orderDqs.data()['userId'] ?? "EMPTY",
            orderId: orderDqs.id,
          );
        }).toList());
      } catch (e) {
        print("XXXXXXXXXX error on getMoreProductList");
        print(e);
        print(e.message);
      }
    } else {
      return "Reached end";
    }
  }

  Future refresh(String orderStatus) {
    this.reachedEnd = false;
    return getOrderList(orderStatus);
  }

  Future updateStatusToShipped(String orderId) async {
    try {
      await ordersCollection.doc(orderId).update({'orderStatus': "shipped"});
    } catch (e) {
      print(e);
      return "Unable to update order status now.";
    }
  }
}
