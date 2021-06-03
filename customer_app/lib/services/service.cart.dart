import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:oyil_boutique/models/modal.cart.dart';
import 'package:oyil_boutique/models/modals.product.variant.dart';
import 'package:oyil_boutique/models/model.product.dart';

List<CartItem> globalCartList = new List<CartItem>.empty(growable: true);
bool initialCartDataLoad = true;

class CartDatabaseService {
  CollectionReference userCollection;
  Reference storageRef;
  CollectionReference readyToShopCollection;

  CartDatabaseService() {
    userCollection = FirebaseFirestore.instance.collection("users");
    storageRef = FirebaseStorage.instance.ref().child('readytoshop');
    readyToShopCollection = FirebaseFirestore.instance.collection("readytoshop");
  }

  Future<bool> getAllProductsInCart(String userid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> cartQuerySnapshot = await userCollection.doc(userid).collection('cart').get();
      List<CartItem> list = await Future.wait(cartQuerySnapshot.docs.map((doc) async {
        String cartid = doc.id;
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
        return CartItem(cartid: cartid, product: product);
      }).toList());
      globalCartList = list;
      initialCartDataLoad = false;
      return true;
    } catch (e) {
      print("xxxxxxxxxxxxx error on getAllProductsInCart");
      print(e);
      return null;
    }
  }

  Future<bool> addProductToCart(String userid, Product product) async {
    try {
      // QuerySnapshot qs = await userCollection
      //     .doc(userid)
      //     .collection('cart')
      //     .where('productid', isEqualTo: productid)
      //     .where('variantid', isEqualTo: variantid)
      //     .get();
      // if (qs.size != 0) {
      //   return false; // * Already added to cart
      // }
      bool isPresent = false;
      globalCartList.forEach((element) {
        if (element.product.productId == product.productId && element.product.variant.variantId == product.variant.variantId) {
          isPresent = true;
        }
      });
      if (isPresent) {
        return false; // * Already added to cart
      }
      await userCollection.doc(userid).collection('cart').add({
        'productid': product.productId,
        'variantid': product.variant.variantId,
      }).catchError((e) {
        print("xxxxxxxxxxxxx error while uploading on addProductToCart");
        print(e);
        return null;
      });
      QuerySnapshot nqs = await userCollection.doc(userid).collection('cart').where('productid', isEqualTo: product.productId).where('variantid', isEqualTo: product.variant.variantId).get();
      String cartid = nqs.docs[0].id; //* item added to wishlist
      if (globalCartList.isEmpty) {
        List<CartItem> li = [new CartItem(product: product, cartid: cartid)];
        print(globalCartList);
        globalCartList = li;
      } else {
        globalCartList.add(new CartItem(cartid: cartid, product: product));
      }

      return true;
    } catch (e) {
      print("xxxxxxxxxxxxx error on addProductToCart");
      print(e);
      return null;
    }
  }

  Future<bool> removeProductFromCart(String userid, String cartid, int index) async {
    try {
      await userCollection.doc(userid).collection('cart').doc(cartid).delete().catchError((e) {
        print("xxxxxxxxxxxxx error while removing product");
        print(e);
        return null;
      });
      globalCartList.removeAt(index);
      return true;
    } catch (e) {
      print("xxxxxxxxxxxxx error on removeProductFromCart");
      print(e);
      return null;
    }
  }

  Future<bool> deleteCart(String userid) async {
    try {
      QuerySnapshot qs = await userCollection.doc(userid).collection('cart').get();
      for (DocumentSnapshot doc in qs.docs) {
        await doc.reference.delete();
      }
      globalCartList.clear();
      return true;
    } catch (e) {
      print("xxxxxxxxxxxxx error on deleteCart");
      print(e);
      return null;
    }
  }
}
