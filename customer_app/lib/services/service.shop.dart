import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:oyil_boutique/models/modals.product.variant.dart';
import 'package:oyil_boutique/models/model.banner.dart';
import 'package:oyil_boutique/models/model.product.dart';

class ShopDatabaseService {
  CollectionReference readyToShopCollection;
  CollectionReference bannerCollection;
  Reference storageRef;
  Reference bannerStorage;
  DocumentSnapshot lastDocument;

  int pagePerProdut = 10;
  bool reachedEnd = false;

  ShopDatabaseService() {
    readyToShopCollection = FirebaseFirestore.instance.collection("readytoshop");
    bannerCollection = FirebaseFirestore.instance.collection("banners");
    storageRef = FirebaseStorage.instance.ref().child('readytoshop');
    bannerStorage = FirebaseStorage.instance.ref().child('banners');
  }

  Future getProductList({String category, String subcategory, bool getOnlyFeatured = false}) async {
    print("cccccccccccccccccccccccccccccc");
    print(category);
    if (!reachedEnd) {
      try {
        QuerySnapshot<Map<String, dynamic>> qs;
        if (getOnlyFeatured) {
          qs = await readyToShopCollection.orderBy("createdon", descending: true).limit(10).get();
        } else if (subcategory == null) {
          qs = await readyToShopCollection.orderBy("createdon", descending: true).where('category', isEqualTo: category).limit(pagePerProdut).get();
        } else {
          qs = await readyToShopCollection.orderBy("createdon", descending: true).limit(pagePerProdut).where('category', isEqualTo: category).where('subcategory', isEqualTo: subcategory).get();
        }
        if (qs.docs.length != 0) {
          lastDocument = qs.docs[qs.docs.length - 1];
        }
        if (qs.docs.length < pagePerProdut) {
          this.reachedEnd = true;
        }
        return await Future.wait(qs.docs.map((doc) async {
          print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
          print(doc.data());
          QuerySnapshot<Map<String, dynamic>> variantQSnapshot = await readyToShopCollection.doc(doc.id).collection("variants").limit(1).get();
          QueryDocumentSnapshot<Map<String, dynamic>> variantDQSnapshot = variantQSnapshot.docs[0];
          int price = variantDQSnapshot.data()['price'] ?? 0;
          int sellingPrice = variantDQSnapshot.data()['sellingPrice'] ?? 0;
          double off = 100 - ((sellingPrice / price) * 100);
          QuerySnapshot<Map<String, dynamic>> colorQSnapshot = await readyToShopCollection.doc(doc.id).collection("colors").where('color', isEqualTo: variantDQSnapshot.data()['color']).get();
          QueryDocumentSnapshot<Map<String, dynamic>> colorDQSnapshot = colorQSnapshot.docs[0];
          List<String> imagesNameList = colorDQSnapshot.data()['images'].cast<String>();
          List<String> urlList = [];
          for (String imageName in imagesNameList) {
            String url = await storageRef.child(doc.id).child(variantDQSnapshot.data()['color']).child(imageName).getDownloadURL();
            urlList.add(url);
          }
          Variant variant = Variant(
              color: variantDQSnapshot.data()['color'] ?? 'Empty',
              productId: doc.id ?? 'empty',
              qty: variantDQSnapshot.data()['qty'] ?? 0,
              size: variantDQSnapshot.data()['size'] ?? 'Empty',
              variantId: variantDQSnapshot.id ?? 'Empty',
              colorname: variantDQSnapshot.data()['colorname'] ?? 'Empty',
              price: price,
              sellingprice: sellingPrice,
              off: off,
              imageUrls: urlList);
          return Product(
              productId: doc.id ?? 'EMPTY',
              category: doc.data()['category'] ?? 'EMPTY',
              description: doc.data()['description'] ?? 'EMPTY',
              details: doc.data()['details'] ?? 'EMPTY',
              productname: doc.data()['productname'] ?? 'EMPTY',
              producttype: doc.data()['producttypes'] ?? 'EMPTY',
              subCategory: doc.data()['subCategory'] ?? 'EMPTY',
              variant: variant);
        }).toList());
      } catch (e) {
        print("XXXXXXXXXX error on getProductList");
        print(e);
        return null;
      }
    } else {
      return "Reached end";
    }
  }

  Future getMoreProductList({String category, String subcategory}) async {
    if (!reachedEnd) {
      try {
        QuerySnapshot<Map<String, dynamic>> qs;
        if (subcategory == null) {
          qs = await readyToShopCollection.orderBy("createdon", descending: true).where('category', isEqualTo: category).startAfterDocument(lastDocument).limit(pagePerProdut).get();
        } else {
          qs = await readyToShopCollection
              .orderBy("createdon", descending: true)
              .where('category', isEqualTo: category)
              .where('subcategory', isEqualTo: subcategory)
              .startAfterDocument(lastDocument)
              .limit(pagePerProdut)
              .get();
        }
        if (qs.docs.length != 0) {
          lastDocument = qs.docs[qs.docs.length - 1];
        }
        if (qs.docs.length < pagePerProdut) {
          this.reachedEnd = true;
        }
        return await Future.wait(qs.docs.map((doc) async {
          print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
          print(doc.data());
          QuerySnapshot<Map<String, dynamic>> variantQSnapshot = await readyToShopCollection.doc(doc.id).collection("variants").limit(1).get();
          QueryDocumentSnapshot<Map<String, dynamic>> variantDQSnapshot = variantQSnapshot.docs[0];
          int price = variantDQSnapshot.data()['price'] ?? 0;
          int sellingPrice = variantDQSnapshot.data()['sellingPrice'] ?? 0;
          double off = 100 - ((sellingPrice / price) * 100);
          QuerySnapshot<Map<String, dynamic>> colorQSnapshot = await readyToShopCollection.doc(doc.id).collection("colors").where('color', isEqualTo: variantDQSnapshot.data()['color']).get();
          QueryDocumentSnapshot<Map<String, dynamic>> colorDQSnapshot = colorQSnapshot.docs[0];
          List<String> imagesNameList = colorDQSnapshot.data()['images'].cast<String>();
          List<String> urlList = [];
          for (String imageName in imagesNameList) {
            String url = await storageRef.child(doc.id).child(variantDQSnapshot.data()['color']).child(imageName).getDownloadURL();
            urlList.add(url);
          }
          Variant variant = Variant(
              color: variantDQSnapshot.data()['color'] ?? 'Empty',
              productId: doc.id ?? 'empty',
              qty: variantDQSnapshot.data()['qty'] ?? 0,
              size: variantDQSnapshot.data()['size'] ?? 'Empty',
              colorname: variantDQSnapshot.data()['colorname'] ?? 'Empty',
              variantId: variantDQSnapshot.id ?? 'Empty',
              price: price,
              sellingprice: sellingPrice,
              off: off,
              imageUrls: urlList);
          return Product(
              productId: doc.id ?? 'EMPTY',
              category: doc.data()['category'] ?? 'EMPTY',
              description: doc.data()['description'] ?? 'EMPTY',
              details: doc.data()['details'] ?? 'EMPTY',
              productname: doc.data()['productname'] ?? 'EMPTY',
              producttype: doc.data()['producttypes'] ?? 'EMPTY',
              subCategory: doc.data()['subCategory'] ?? 'EMPTY',
              variant: variant);
        }).toList());
      } catch (e) {
        print("XXXXXXXXXX error on getMoreProductList");
        print(e);
        return null;
      }
    } else {
      return "Reached end";
    }
  }

  Future refresh({String category, String subcategory}) {
    this.reachedEnd = false;
    if (subcategory != null) {
      return getProductList(category: category, subcategory: subcategory);
    } else {
      return getProductList(category: category);
    }
  }

  Future<List<Variant>> getAllVariants(String productID) async {
    try {
      QuerySnapshot<Map<String, dynamic>> variantQSnapshot = await readyToShopCollection.doc(productID).collection("variants").get();
      return await Future.wait(variantQSnapshot.docs.map((doc) async {
        print("xxxxxxxx Variants xxxxxxxx");
        print(doc.data());
        int price = doc.data()['price'] ?? 0;
        int sellingPrice = doc.data()['sellingPrice'] ?? 0;
        double off = 100 - ((sellingPrice / price) * 100);
        QuerySnapshot<Map<String, dynamic>> colorQSnapshot = await readyToShopCollection.doc(productID).collection("colors").where('color', isEqualTo: doc.data()['color']).get();
        QueryDocumentSnapshot<Map<String, dynamic>> colorDQSnapshot = colorQSnapshot.docs[0];
        List<String> imagesNameList = colorDQSnapshot.data()['images'].cast<String>();
        List<String> urlList = [];
        for (String imageName in imagesNameList) {
          String url = await storageRef.child(productID).child(doc.data()['color']).child(imageName).getDownloadURL();
          urlList.add(url);
        }
        return Variant(
            color: doc.data()['color'] ?? 'Empty',
            productId: productID ?? 'empty',
            qty: doc.data()['qty'] ?? 'Empty',
            size: doc.data()['size'] ?? 'Empty',
            colorname: doc.data()['colorname'] ?? 'Empty',
            variantId: doc.id ?? 'Empty',
            price: price,
            sellingprice: sellingPrice,
            off: off,
            imageUrls: urlList);
      }).toList());
    } catch (e) {
      print("variats error");
      print(e);
      return null;
    }
  }

  Future<int> getProductQty(String productID, String variantID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> ds = await readyToShopCollection.doc(productID).collection("variants").doc(variantID).get();
      return ds.data()['qty'];
    } catch (e) {
      print("XXXXXXXXXX error on checkAvailability");
      print(e);
      return null;
    }
  }

  Future<bool> updateProductQty(int newQty, String productID, String variantID) async {
    try {
      await readyToShopCollection.doc(productID).collection("variants").doc(variantID).update({'qty': newQty});
      return true;
    } catch (e) {
      print("XXXXXXXXXX error on updateProductQty");
      print(e);
      return false;
    }
  }

  Future<List<Product>> getFeaturedProduct() async {
    try {
      List<Product> plist = [];
      plist = await getProductList(getOnlyFeatured: true);
      return plist;
    } catch (e) {
      print("XXXXXXXXXX error on updateProductQty");
      print(e);
      return [];
    }
  }

  Future<List<Product>> searchProduct(String searchkey) async {
    try {
      QuerySnapshot<Map<String, dynamic>> qs = await readyToShopCollection.where("searchkey", isEqualTo: searchkey.substring(0, 1).toUpperCase()).get();
      return await Future.wait(qs.docs.map((doc) async {
        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
        print(doc.data());
        QuerySnapshot<Map<String, dynamic>> variantQSnapshot = await readyToShopCollection.doc(doc.id).collection("variants").limit(1).get();
        QueryDocumentSnapshot<Map<String, dynamic>> variantDQSnapshot = variantQSnapshot.docs[0];
        int price = variantDQSnapshot.data()['price'] ?? 0;
        int sellingPrice = variantDQSnapshot.data()['sellingPrice'] ?? 0;
        double off = 100 - ((sellingPrice / price) * 100);
        QuerySnapshot<Map<String, dynamic>> colorQSnapshot = await readyToShopCollection.doc(doc.id).collection("colors").where('color', isEqualTo: variantDQSnapshot.data()['color']).get();
        QueryDocumentSnapshot<Map<String, dynamic>> colorDQSnapshot = colorQSnapshot.docs[0];
        List<String> imagesNameList = colorDQSnapshot.data()['images'].cast<String>();
        List<String> urlList = [];
        for (String imageName in imagesNameList) {
          String url = await storageRef.child(doc.id).child(variantDQSnapshot.data()['color']).child(imageName).getDownloadURL();
          urlList.add(url);
        }
        Variant variant = Variant(
            color: variantDQSnapshot.data()['color'] ?? 'Empty',
            productId: doc.id ?? 'empty',
            qty: variantDQSnapshot.data()['qty'] ?? 0,
            size: variantDQSnapshot.data()['size'] ?? 'Empty',
            variantId: variantDQSnapshot.id ?? 'Empty',
            colorname: variantDQSnapshot.data()['colorname'] ?? 'Empty',
            price: price,
            sellingprice: sellingPrice,
            off: off,
            imageUrls: urlList);
        return Product(
            productId: doc.id ?? 'EMPTY',
            category: doc.data()['category'] ?? 'EMPTY',
            description: doc.data()['description'] ?? 'EMPTY',
            details: doc.data()['details'] ?? 'EMPTY',
            productname: doc.data()['productname'] ?? 'EMPTY',
            producttype: doc.data()['producttypes'] ?? 'EMPTY',
            subCategory: doc.data()['subCategory'] ?? 'EMPTY',
            variant: variant);
      }).toList());
    } catch (e) {
      print("XXXXXXXXXX error on search");
      print(e);
      return null;
    }
  }

  Future<List<OBSBanner>> getBanners() async {
    try {
      QuerySnapshot<Map<String, dynamic>> qs = await bannerCollection.get();
      return await Future.wait(qs.docs.map((doc) async {
        String imageUrl = await bannerStorage.child(doc.id).child(doc.data()['image']).getDownloadURL();
        return OBSBanner(
          id: doc.id,
          category: doc.data()["category"] ?? "empty",
          content: doc.data()["content"] ?? "empty",
          image: imageUrl ?? "empty",
          subcategory: doc.data()["subcategory"] ?? "empty",
        );
      }).toList());
    } catch (e) {
      print("XXXXXXXXXX error on getBanners");
      print(e);
      return [];
    }
  }
}
