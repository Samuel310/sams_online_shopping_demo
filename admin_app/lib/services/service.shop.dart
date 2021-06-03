import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:obs_admin/models/model.liked.products.dart';
import 'package:obs_admin/models/model.product.dart';
import 'package:obs_admin/models/model.variant.dart';

class ShopDatabaseService {
  CollectionReference readyToShopCollection;
  CollectionReference userCollection;
  Reference storageRef;
  DocumentSnapshot lastDocument;

  int pagePerProdut = 10;
  bool reachedEnd = false;

  ShopDatabaseService() {
    readyToShopCollection = FirebaseFirestore.instance.collection("readytoshop");
    userCollection = FirebaseFirestore.instance.collection("users");
    storageRef = FirebaseStorage.instance.ref().child('readytoshop');
  }

  Future getProductList({String category, String subcategory}) async {
    if (!reachedEnd) {
      try {
        QuerySnapshot<Map<String, dynamic>> qs;
        if (subcategory == null) {
          qs = await readyToShopCollection.where('category', isEqualTo: category).orderBy("createdon", descending: true).limit(pagePerProdut).get();
        } else {
          qs = await readyToShopCollection.where('category', isEqualTo: category).where('subcategory', isEqualTo: subcategory).orderBy("createdon", descending: true).limit(pagePerProdut).get();
        }
        if (qs.docs.length != 0) {
          lastDocument = qs.docs[qs.docs.length - 1];
        }
        if (qs.docs.length < pagePerProdut) {
          this.reachedEnd = true;
        }
        return qs.docs.map((doc) {
          return Product(
            productId: doc.id ?? 'EMPTY',
            category: doc.data()['category'] ?? 'EMPTY',
            description: doc.data()['description'] ?? 'EMPTY',
            details: doc.data()['details'] ?? 'EMPTY',
            productname: doc.data()['productname'] ?? 'EMPTY',
            producttype: doc.data()['producttypes'] ?? 'EMPTY',
            subCategory: doc.data()['subcategory'] ?? 'EMPTY',
            createdon: doc.data()['createdon'],
            updatedon: doc.data()['updatedon'],
          );
        }).toList();
      } catch (e) {
        print("XXXXXXXXXX error on getProductList");
        print(e);
        //return e.message;
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
          qs = await readyToShopCollection.where('category', isEqualTo: category).orderBy("createdon", descending: true).startAfterDocument(lastDocument).limit(pagePerProdut).get();
        } else {
          qs = await readyToShopCollection
              .startAfterDocument(lastDocument)
              .where('category', isEqualTo: category)
              .where('subcategory', isEqualTo: subcategory)
              .orderBy("createdon", descending: true)
              .limit(pagePerProdut)
              .get();
        }
        if (qs.docs.length != 0) {
          lastDocument = qs.docs[qs.docs.length - 1];
        }
        if (qs.docs.length < pagePerProdut) {
          this.reachedEnd = true;
        }
        return qs.docs.map((doc) {
          return Product(
            productId: doc.id ?? 'EMPTY',
            category: doc.data()['category'] ?? 'EMPTY',
            description: doc.data()['description'] ?? 'EMPTY',
            details: doc.data()['details'] ?? 'EMPTY',
            productname: doc.data()['productname'] ?? 'EMPTY',
            producttype: doc.data()['producttypes'] ?? 'EMPTY',
            subCategory: doc.data()['subcategory'] ?? 'EMPTY',
            createdon: doc.data()['createdon'],
            updatedon: doc.data()['updatedon'],
          );
        }).toList();
      } catch (e) {
        print("XXXXXXXXXX error on getMoreProductList");
        print(e);
        //return e.message;
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
        QuerySnapshot colorQSnapshot = await readyToShopCollection.doc(productID).collection("colors").where('color', isEqualTo: doc.data()['color']).get();
        QueryDocumentSnapshot<Map<String, dynamic>> colorDQSnapshot = colorQSnapshot.docs[0];
        List<String> imagesNameList = colorDQSnapshot.data()['images'].cast<String>();
        List<ProductImages> urlList = [];
        for (String imageName in imagesNameList) {
          String url = await storageRef.child(productID).child(doc.data()['color']).child(imageName).getDownloadURL();
          urlList.add(ProductImages(imageName: imageName, url: url));
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
          productImageList: urlList,
          createdon: doc.data()['createdon'],
          updatedon: doc.data()['updatedon'],
        );
      }).toList());
    } catch (e) {
      print("variats error");
      print(e);
      return [];
    }
  }

  Future getTopLikedProducts(String screenName) async {
    try {
      print("getting top products");
      QuerySnapshot qs = await userCollection.get();
      HashMap productHashMap = new HashMap<String, int>();
      print("getting user wise liked products");
      print("docs count - ${qs.docs.length}");
      await Future.forEach(qs.docs, (userDocument) async {
        print(userDocument.id);
        if (userDocument.id != "obsadmin") {
          QuerySnapshot<Map<String, dynamic>> wishlistDocSnapshot = await userCollection.doc(userDocument.id).collection(screenName).get();
          wishlistDocSnapshot.docs.forEach((wishlistDoc) {
            String key = "${wishlistDoc.data()["productid"]}_${wishlistDoc.data()["variantid"]}";
            //String key = wishlistDoc.data()["productid"];
            if (productHashMap.containsKey(key)) {
              productHashMap.update(key, (value) => int.parse(value.toString()) + 1);
            } else {
              productHashMap.putIfAbsent(key, () => 1);
            }
          });
        }
      });
      print("identifying top 5 products");
      // get top 5 products
      if (productHashMap.isNotEmpty) {
        HashMap topProductsMap = new HashMap<String, int>();
        List<String> topProductsList = [];
        for (int i = 0; i < 5; i++) {
          int maxCount = 0;
          String res;
          productHashMap.forEach((key, value) {
            if (maxCount < value) {
              res = key;
              maxCount = value;
            }
          });
          if (res != null) {
            topProductsMap.putIfAbsent(res, () => maxCount);
            topProductsList.add(res);
            productHashMap.remove(res);
          }
        }
        print("identification successfull");
        print(topProductsMap);
        print("fetching product by product id");
        List<LikedProduct> prodList = [];
        await Future.forEach(topProductsList, (String ids) async {
          List<String> idList = ids.split("_");
          DocumentSnapshot<Map<String, dynamic>> doc = await readyToShopCollection.doc(idList[0]).get();
          Product p = Product(
            productId: doc.id ?? 'EMPTY',
            category: doc.data()['category'] ?? 'EMPTY',
            description: doc.data()['description'] ?? 'EMPTY',
            details: doc.data()['details'] ?? 'EMPTY',
            productname: doc.data()['productname'] ?? 'EMPTY',
            producttype: doc.data()['producttypes'] ?? 'EMPTY',
            subCategory: doc.data()['subcategory'] ?? 'EMPTY',
            createdon: doc.data()['createdon'],
            updatedon: doc.data()['updatedon'],
          );
          prodList.add(LikedProduct(product: p, likes: topProductsMap[ids], variantid: idList[1]));
        });
        print("finished !!");
        return prodList;
      } else {
        return "No products is in wishlist";
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future getVariantById(String productid, String variantid) async {
    try {
      print(productid);
      print(variantid);
      DocumentSnapshot<Map<String, dynamic>> doc = await readyToShopCollection.doc(productid).collection("variants").doc(variantid).get();
      print(doc.data());
      int price = doc.data()['price'] ?? 0;
      int sellingPrice = doc.data()['sellingPrice'] ?? 0;
      double off = 100 - ((sellingPrice / price) * 100);
      QuerySnapshot colorQSnapshot = await readyToShopCollection.doc(productid).collection("colors").where('color', isEqualTo: doc.data()['color']).get();
      QueryDocumentSnapshot<Map<String, dynamic>> colorDQSnapshot = colorQSnapshot.docs[0];
      List<String> imagesNameList = colorDQSnapshot.data()['images'].cast<String>();
      List<ProductImages> urlList = [];
      for (String imageName in imagesNameList) {
        String url = await storageRef.child(productid).child(doc.data()['color']).child(imageName).getDownloadURL();
        urlList.add(ProductImages(imageName: imageName, url: url));
      }
      return Variant(
        color: doc.data()['color'] ?? 'Empty',
        productId: productid ?? 'empty',
        qty: doc.data()['qty'] ?? 'Empty',
        size: doc.data()['size'] ?? 'Empty',
        colorname: doc.data()['colorname'] ?? 'Empty',
        variantId: doc.id ?? 'Empty',
        price: price,
        sellingprice: sellingPrice,
        off: off,
        productImageList: urlList,
        createdon: doc.data()['createdon'],
        updatedon: doc.data()['updatedon'],
      );
    } catch (e) {
      print(e);
      return null;
    }
  }
}
