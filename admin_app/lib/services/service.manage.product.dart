import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:obs_admin/models/model.colors.dart';
import 'package:obs_admin/models/model.product.dart';
import 'package:obs_admin/models/model.variant.dart';
import 'package:path/path.dart';

class ManageProductService {
  CollectionReference readyToShopCollection;
  Reference storageRef;

  ManageProductService() {
    readyToShopCollection = FirebaseFirestore.instance.collection("readytoshop");
    storageRef = FirebaseStorage.instance.ref().child('readytoshop');
  }

  Future addNewProduct(Product product, Variant variant, List<File> productImages) async {
    try {
      List<String> fileNameList = [];
      for (File imageFile in productImages) {
        fileNameList.add(basename(imageFile.path));
      }
      QuerySnapshot qs = await readyToShopCollection
          .where('category', isEqualTo: product.category)
          .where('subcategory', isEqualTo: product.subCategory)
          .where('productname', isEqualTo: product.productname)
          .where('producttypes', isEqualTo: product.producttype)
          .get();
      if (qs.size == 0) {
        String productId;
        await readyToShopCollection.add({
          "category": product.category,
          "description": product.description,
          "details": product.details,
          "productname": product.productname,
          "producttypes": product.producttype,
          "subcategory": product.subCategory,
          "createdon": product.createdon,
          "updatedon": product.updatedon,
          "searchkey": product.productname.substring(0, 1).toUpperCase(),
        }).then((DocumentReference docRef) async {
          productId = docRef.id;
          await readyToShopCollection.doc(productId).collection("variants").add({
            "color": variant.color,
            "size": variant.size,
            "price": variant.price,
            "sellingPrice": variant.sellingprice,
            "qty": variant.qty,
            "colorname": variant.colorname,
            "createdon": variant.createdon,
            "updatedon": variant.updatedon,
          }).then((DocumentReference docRef) async {
            await readyToShopCollection.doc(productId).collection("colors").add({"color": variant.color, "images": FieldValue.arrayUnion(fileNameList)}).then((DocumentReference docRef) async {
              for (File imageFile in productImages) {
                await storageRef.child(productId).child(variant.color).child(basename(imageFile.path)).putFile(imageFile);
              }
            });
          });
        });
      } else {
        return "This Product Already Exists";
      }
    } catch (e) {
      print(e);
    }
  }

  Future addNewVariant(String productId, Variant variant, List<File> productImages) async {
    try {
      List<String> fileNameList = [];
      for (File imageFile in productImages) {
        fileNameList.add(basename(imageFile.path));
      }
      QuerySnapshot qs = await readyToShopCollection
          .doc(productId)
          .collection("variants")
          .where('color', isEqualTo: variant.color)
          .where('colorname', isEqualTo: variant.colorname)
          .where('price', isEqualTo: variant.price)
          .where('qty', isEqualTo: variant.qty)
          .where('sellingPrice', isEqualTo: variant.sellingprice)
          .where('size', isEqualTo: variant.size)
          .get();
      if (qs.size == 0) {
        QuerySnapshot colorQs = await readyToShopCollection.doc(productId).collection("variants").where('color', isEqualTo: variant.color).get();
        await readyToShopCollection.doc(productId).collection("variants").add({
          "color": variant.color,
          "colorname": variant.colorname,
          "price": variant.price,
          "qty": variant.qty,
          "sellingPrice": variant.sellingprice,
          "size": variant.size,
          "createdon": variant.createdon,
          "updatedon": variant.updatedon,
        }).then((DocumentReference docRef) async {
          if (colorQs.size == 0) {
            if (productImages.isNotEmpty) {
              await readyToShopCollection.doc(productId).collection("colors").add({"color": variant.color, "images": FieldValue.arrayUnion(fileNameList)}).then((DocumentReference docRef) async {
                for (File imageFile in productImages) {
                  await storageRef.child(productId).child(variant.color).child(basename(imageFile.path)).putFile(imageFile);
                }
              });
            } else {
              return "Need to upload images for this color";
            }
          }
        });
      } else {
        return "This Product Already Exists";
      }
    } catch (e) {
      print(e);
    }
  }

  Future updateProduct(Product product) async {
    try {
      QuerySnapshot qs = await readyToShopCollection
          .where('category', isEqualTo: product.category)
          .where('subcategory', isEqualTo: product.subCategory)
          .where('productname', isEqualTo: product.productname)
          .where('producttypes', isEqualTo: product.producttype)
          .where('description', isEqualTo: product.description)
          .where('details', isEqualTo: product.details)
          .get();
      if (qs.size == 0) {
        await readyToShopCollection.doc(product.productId).update(
          {
            "description": product.description,
            "details": product.details,
            "productname": product.productname,
            "producttypes": product.producttype,
            "updatedon": product.updatedon,
            "searchkey": product.productname.substring(0, 1).toUpperCase(),
          },
        );
      } else {
        return "Already Exists";
      }
    } catch (e) {
      print(e);
      return "Unable to update";
    }
  }

  Future updateVariant(String productId, Variant variant) async {
    try {
      QuerySnapshot qs = await readyToShopCollection
          .doc(productId)
          .collection("variants")
          .where('color', isEqualTo: variant.color)
          .where('colorname', isEqualTo: variant.colorname)
          .where('price', isEqualTo: variant.price)
          .where('qty', isEqualTo: variant.qty)
          .where('sellingPrice', isEqualTo: variant.sellingprice)
          .where('size', isEqualTo: variant.size)
          .get();
      if (qs.size == 0) {
        await readyToShopCollection.doc(productId).collection("variants").doc(variant.variantId).update({
          "price": variant.price,
          "qty": variant.qty,
          "sellingPrice": variant.sellingprice,
          "size": variant.size,
          "updatedon": variant.updatedon,
        });
      } else {
        return "Already Exists";
      }
    } catch (e) {
      print(e);
      return "Unable to update";
    }
  }

  Future addImage(String productId, String color, File image) async {
    try {
      QuerySnapshot qs = await readyToShopCollection.doc(productId).collection("colors").where('color', isEqualTo: color).get();
      await readyToShopCollection.doc(productId).collection("colors").doc(qs.docs[0].id).update({
        "images": FieldValue.arrayUnion([basename(image.path)])
      });
      await storageRef.child(productId).child(color).child(basename(image.path)).putFile(image);
    } catch (e) {
      print(e);
      return "Unable to add";
    }
  }

  Future deleteImage(String productId, String color, String imageName) async {
    try {
      QuerySnapshot qs = await readyToShopCollection.doc(productId).collection("colors").where('color', isEqualTo: color).get();
      await readyToShopCollection.doc(productId).collection("colors").doc(qs.docs[0].id).update({
        "images": FieldValue.arrayRemove([imageName])
      });
      await storageRef.child(productId).child(color).child(imageName).delete();
    } catch (e) {
      print(e);
      return "Unable to delete";
    }
  }

  Future deleteVariant(String productId, String variantId) async {
    try {
      QuerySnapshot qs = await FirebaseFirestore.instance.collection("orders").where('productId', isEqualTo: productId).where('variantId', isEqualTo: variantId).get();
      if (qs.size != 0) {
        return "Cannot delete, Someone has ordered this product";
      } else {
        await readyToShopCollection.doc(productId).collection("variants").doc(variantId).delete();
      }
    } catch (e) {
      print(e);
      return "Unable to delete";
    }
  }

  Future deleteProduct(String productId) async {
    try {
      QuerySnapshot qs = await FirebaseFirestore.instance.collection("orders").where('productId', isEqualTo: productId).get();
      if (qs.size != 0) {
        return "Cannot delete, Someone has ordered this product";
      } else {
        await readyToShopCollection.doc(productId).delete();
        await storageRef.child(productId).delete();
      }
    } catch (e) {
      print(e);
      return "Unable to delete";
    }
  }

  Future<List<OBSColor>> loadColors() async {
    try {
      QuerySnapshot<Map<String, dynamic>> qs = await FirebaseFirestore.instance.collection("colors").get();
      return qs.docs.map((doc) {
        return OBSColor(
          color: doc.data()['color'] ?? "Empty",
          colorName: doc.data()['colorname'] ?? "Empty",
        );
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Product>> searchProduct(String searchkey) async {
    try {
      QuerySnapshot<Map<String, dynamic>> qs = await readyToShopCollection.where("searchkey", isEqualTo: searchkey.substring(0, 1).toUpperCase()).get();
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
      print(e);
      return [];
    }
  }
}
