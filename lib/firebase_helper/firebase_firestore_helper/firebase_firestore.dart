// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:trattamento/constants/constants.dart';
import 'package:trattamento/models/category_model/category_model.dart';
import 'package:trattamento/models/order_model/order_model.dart';
import 'package:trattamento/models/product_model/product_model.dart';
import 'package:trattamento/models/user_model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _storge = FirebaseStorage.instance;
  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("categories").get();

      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();

      return categoriesList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getBestProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup("products").get();

      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getCategoryViewProduct(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("categories")
              .doc(id)
              .collection("products")
              .get();

      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    return UserModel.fromJson(querySnapshot.data()!);
  }

  Future<bool> uploadOrderedProductFirebase(
    List<ProductModel> list,
    BuildContext context,
    String payment,
  ) async {
    try {
      showLoaderDialog(context);
      double totalPrice = 0.0;
      for (var element in list) {
        totalPrice += element.price * element.qty!;
      }

      // Deduct the quantity of ordered products from the available quantity
      for (var element in list) {
        int orderedQty = element.quantity ?? 0;
        int availableQty = element.quantity ?? 0;
        int remainingQty = availableQty - orderedQty;

        if (remainingQty < 0) {
          showMessage("Insufficient quantity for ${element.name}");
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        }

        await FirebaseFirestore.instance
            .collection("categories")
            .doc(element.categoryId)
            .collection("products")
            .doc(element.id)
            .update({"quantity": remainingQty});
      }

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("usersOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc();
      DocumentReference admin = FirebaseFirestore.instance
          .collection("orders")
          .doc(documentReference.id);
      String uid = FirebaseAuth.instance.currentUser!.uid;
      admin.set({
        "products": list.map((e) => e.toJson()).toList(),
        "status": "Pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "userId": uid,
        "orderId": admin.id,
      });
      documentReference.set({
        "products": list.map((e) => e.toJson()).toList(),
        "status": "Pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "userId": uid,
        "orderId": documentReference.id,
      });
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Ordered Successfully");
      return true;
    } catch (e) {
      showMessage(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      return false;
    }
  }

  ////// Get Order User//////

  Future<List<OrderModel>> getUserOrder() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("usersOrders")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("orders")
              .get();

      List<OrderModel> orderList = querySnapshot.docs
          .map((element) => OrderModel.fromJson(element.data()))
          .toList();

      return orderList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  void updateTokenFromFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "notificationToken": token,
      });
    }
  }

  Future<void> updateOrder(OrderModel orderModel, String status) async {
    await _firebaseFirestore
        .collection("usersOrders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orders")
        .doc(orderModel.orderId)
        .update({"status": status});
    await _firebaseFirestore
        .collection("orders")
        .doc(orderModel.orderId)
        .update({"status": status});
  }

  /////////////////////admin panal//////////////
  Future<List<UserModel>> getUserList() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collection("users").get();
    return querySnapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
  }

  Future<String> deleteSingleCategory(String id) async {
    try {
      // await Future.delayed(const Duration(seconds: 3), () {});
      await _firebaseFirestore.collection("categories").doc(id).delete();
      return "Successfully deleted";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateSingleCategory(CategoryModel categoryModel) async {
    try {
      await _firebaseFirestore
          .collection("categories")
          .doc(categoryModel.id)
          .update(categoryModel.toJson());
    } catch (e) {}
  }

  Future<String> uploadUserImage(String userId, File image) async {
    TaskSnapshot taskSnapshot = await _storge.ref(userId).putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<CategoryModel> addSingleCategory(File image, String name) async {
    DocumentReference reference =
        _firebaseFirestore.collection("categories").doc();
    String imageUrl = await FirebaseFirestoreHelper.instance
        .uploadUserImage(reference.id, image);
    CategoryModel addCategory =
        CategoryModel(image: imageUrl, id: reference.id, name: name);
    await reference.set(addCategory.toJson());
    return addCategory;
  }

  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collectionGroup("products").get();
    List<ProductModel> productList =
        querySnapshot.docs.map((e) => ProductModel.fromJson(e.data())).toList();
    return productList;
  }

  Future<String> deleteProduct(String categoryId, String productId) async {
    try {
      // await Future.delayed(const Duration(seconds: 3), () {});
      await _firebaseFirestore
          .collection("categories")
          .doc(categoryId)
          .collection("products")
          .doc(productId)
          .delete();
      return "Successfully deleted";
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("categories").get();

      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();

      return categoriesList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<void> updateSingleProduct(ProductModel productModel) async {
    try {
      // await Future.delayed(const Duration(seconds: 3), () {});
      await _firebaseFirestore
          .collection("categories")
          .doc(productModel.categoryId)
          .collection("products")
          .doc(productModel.id)
          .update(productModel.toJson());
    } catch (e) {
      ;
    }
  }

  Future<ProductModel> addSingleProduct(
    File image,
    String name,
    String categoryId,
    String description,
    double price,
    int quantity,
  ) async {
    DocumentReference reference = _firebaseFirestore
        .collection("categories")
        .doc(categoryId)
        .collection("products")
        .doc();
    String imageUrl = await FirebaseFirestoreHelper.instance
        .uploadUserImage(reference.id, image);
    ProductModel addProduct = ProductModel(
        image: imageUrl,
        id: reference.id,
        name: name,
        categoryId: categoryId,
        description: description,
        isFavourite: false,
        price: price,
        quantity: quantity,
        qty: 1);

    await reference.set(addProduct.toJson());
    return addProduct;
  }

  Future<List<OrderModel>> getCompleteOrder() async {
    QuerySnapshot<Map<String, dynamic>> completeOrder = await _firebaseFirestore
        .collection("orders")
        .where("status", isEqualTo: "Completed")
        .get();
    List<OrderModel> completedOrderList =
        completeOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return completedOrderList;
  }

  Future<List<OrderModel>> getCancelOrder() async {
    QuerySnapshot<Map<String, dynamic>> cancelOrder = await _firebaseFirestore
        .collection("orders")
        .where("status", isEqualTo: "Cancel")
        .get();
    List<OrderModel> cancelOrderList =
        cancelOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return cancelOrderList;
  }

  Future<List<OrderModel>> getPendingOrder() async {
    QuerySnapshot<Map<String, dynamic>> deliveryOrder = await _firebaseFirestore
        .collection("orders")
        .where("status", isEqualTo: "Pending")
        .get();
    List<OrderModel> deliveryOrderList =
        deliveryOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return deliveryOrderList;
  }

  Future<List<OrderModel>> getDeliveryOrder() async {
    QuerySnapshot<Map<String, dynamic>> pendingOrder = await _firebaseFirestore
        .collection("orders")
        .where("status", isEqualTo: "Delivery")
        .get();
    List<OrderModel> pendingOrderList =
        pendingOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return pendingOrderList;
  }

  Future<void> updateOrderByAdmin(OrderModel orderModel, String status) async {
    await _firebaseFirestore
        .collection("usersOrders")
        .doc(orderModel.userId)
        .collection("orders")
        .doc(orderModel.orderId)
        .update({"status": status});
    await _firebaseFirestore
        .collection("orders")
        .doc(orderModel.orderId)
        .update({"status": status});
  }
}
