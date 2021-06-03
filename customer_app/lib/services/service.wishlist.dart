import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:oyil_boutique/models/modal.wishlist.dart';
import 'package:oyil_boutique/models/modals.product.variant.dart';
import 'package:oyil_boutique/models/model.product.dart';

List<WishlistItem> globalWishList = <WishlistItem>[];
bool initialWishlistDataLoad = true;

class WishlistDatabaseService {
  CollectionReference userCollection;
  Reference storageRef;
  CollectionReference readyToShopCollection;

  WishlistDatabaseService() {
    userCollection = FirebaseFirestore.instance.collection("users");
    storageRef = FirebaseStorage.instance.ref().child('readytoshop');
    readyToShopCollection = FirebaseFirestore.instance.collection("readytoshop");
  }

  Future<bool> getAllProductsInWishlist(String userid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> wishlistQuerySnapshot = await userCollection.doc(userid).collection('wishlist').get();
      List<WishlistItem> list = await Future.wait(wishlistQuerySnapshot.docs.map((doc) async {
        String wishlistid = doc.id;
        String productid = doc.data()['productid'];
        String variantid = doc.data()['variantid'];
        DocumentSnapshot<Map<String, dynamic>> productDS = await readyToShopCollection.doc(productid).get();
        DocumentSnapshot<Map<String, dynamic>> variantDS = await readyToShopCollection.doc(productid).collection("variants").doc(variantid).get();
        int price = variantDS.data()['price'] ?? 0;
        int sellingPrice = variantDS.data()['sellingPrice'] ?? 0;
        double off = 100 - ((sellingPrice / price) * 100);
        QuerySnapshot colorQSnapshot = await readyToShopCollection.doc(productid).collection("colors").where('color', isEqualTo: variantDS.data()['color']).get();
        QueryDocumentSnapshot<Map<String, dynamic>> colorDQSnapshot = colorQSnapshot.docs[0];
        List<String> imagesNameList = colorDQSnapshot.data()['images'].cast<String>();
        List<String> urlList = [];
        for (String imageName in imagesNameList) {
          String url = await storageRef.child(productid).child(variantDS.data()['color']).child(imageName).getDownloadURL();
          urlList.add(url);
        }
        Variant variant = Variant(
            color: variantDS.data()['color'] ?? 'Empty',
            productId: productid ?? 'empty',
            qty: variantDS.data()['qty'] ?? 0,
            size: variantDS.data()['size'] ?? 'Empty',
            variantId: variantDS.id ?? 'Empty',
            colorname: variantDS.data()['colorname'] ?? 'Empty',
            price: price,
            sellingprice: sellingPrice,
            off: off,
            imageUrls: urlList);
        Product product = Product(
            productId: productDS.id ?? 'EMPTY',
            category: productDS.data()['category'] ?? 'EMPTY',
            description: productDS.data()['description'] ?? 'EMPTY',
            details: productDS.data()['details'] ?? 'EMPTY',
            productname: productDS.data()['productname'] ?? 'EMPTY',
            producttype: productDS.data()['producttypes'] ?? 'EMPTY',
            subCategory: productDS.data()['subCategory'] ?? 'EMPTY',
            variant: variant);
        return WishlistItem(wishlistid: wishlistid, product: product);
      }).toList());
      globalWishList = list;
      initialWishlistDataLoad = false;
      return true;
    } catch (e) {
      print("xxxxxxxxxxxxx error on getAllProductsInWihlist");
      print(e);
      return null;
    }
  }

  Future<bool> addProductToWishlist(String userid, Product product) async {
    try {
      bool isPresent = false;
      globalWishList.forEach((element) {
        if (element.product.productId == product.productId && element.product.variant.variantId == product.variant.variantId) {
          isPresent = true;
        }
      });
      if (isPresent) {
        return false; // * Already added to wishlist
      }
      await userCollection.doc(userid).collection('wishlist').add({
        'productid': product.productId,
        'variantid': product.variant.variantId,
      }).catchError((e) {
        print("xxxxxxxxxxxxx error while uploading on addProductToWishlist");
        print(e);
        return null;
      });
      QuerySnapshot nqs = await userCollection.doc(userid).collection('wishlist').where('productid', isEqualTo: product.productId).where('variantid', isEqualTo: product.variant.variantId).get();
      String wishlistid = nqs.docs[0].id; //* item added to wishlist
      print("Product data : ${product.productId}");
      print("wishlistid : $wishlistid");
      if (globalWishList.isEmpty) {
        List<WishlistItem> li = [new WishlistItem(product: product, wishlistid: wishlistid)];
        print(globalWishList);
        globalWishList = li;
      } else {
        print(globalWishList);
        globalWishList.add(new WishlistItem(product: product, wishlistid: wishlistid));
      }
      print(globalWishList);
      return true;
    } catch (e) {
      print("xxxxxxxxxxxxx error on addProductToWishlist");
      print(e);
      return null;
    }
  }

  Future<bool> removeProductFromWishlist(String userid, String wishlistid, int index) async {
    try {
      await userCollection.doc(userid).collection('wishlist').doc(wishlistid).delete().catchError((e) {
        print("xxxxxxxxxxxxx error while removeProductFromWishlist");
        print(e);
        return null;
      });
      globalWishList.removeAt(index);
      return true;
    } catch (e) {
      print("xxxxxxxxxxxxx error on removeProductFromWishlist");
      print(e);
      return null;
    }
  }
}
