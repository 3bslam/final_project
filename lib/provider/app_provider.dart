// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trattamento/constants/constants.dart';
import 'package:trattamento/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:trattamento/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:trattamento/models/category_model/category_model.dart';
import 'package:trattamento/models/order_model/order_model.dart';
import 'package:trattamento/models/product_model/product_model.dart';
import 'package:trattamento/models/user_model/user_model.dart';

class AppProvider with ChangeNotifier {
  //// Cart Work
  final List<ProductModel> _cartProductList = [];
  final List<ProductModel> _buyProductList = [];
  //////admin panal
  List<UserModel> _userList = [];
  List<CategoryModel> _categoriesList = [];
  List<ProductModel> _productList = [];
  List<OrderModel> _completeOrderList = [];
  List<OrderModel> _cancelOrderList = [];
  List<OrderModel> _pendingOrderList = [];
  List<OrderModel> _deliveryOrderList = [];

  double _totalEarning = 0.0;

  //get getCategories => null;

  UserModel? _userModel;

  UserModel? get getUserInformation => _userModel;

  get getProductsList => null;

  void addCartProduct(ProductModel productModel) {
    _cartProductList.add(productModel);
    notifyListeners();
  }

  void removeCartProduct(ProductModel productModel) {
    _cartProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getCartProductList => _cartProductList;

  ///// Favourite ///////
  final List<ProductModel> _favouriteProductList = [];

  void addFavouriteProduct(ProductModel productModel) {
    _favouriteProductList.add(productModel);
    notifyListeners();
  }

  void removeFavouriteProduct(ProductModel productModel) {
    _favouriteProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getFavouriteProductList => _favouriteProductList;

  ////// USer Information
  void getUserInfoFirebase() async {
    _userModel = await FirebaseFirestoreHelper.instance.getUserInformation();
    notifyListeners();
  }

  void updateUserInfoFirebase(
      BuildContext context, UserModel userModel, File? file) async {
    if (file == null) {
      showLoaderDialog(context);

      _userModel = userModel;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    } else {
      showLoaderDialog(context);

      /* String imageUrl =
          await FirebaseStorageHelper.instance.uploadUserImage(file);
      _userModel = userModel.copyWith(image: imageUrl);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
      */
    }
    showMessage("Successfully updated profile");

    notifyListeners();
  }
  //////// TOTAL PRICE / // / // / / // / / / // /

  double totalPrice() {
    double totalPrice = 0.0;
    for (var element in _cartProductList) {
      totalPrice += element.price * element.qty!;
    }
    return totalPrice;
  }

  double totalPriceBuyProductList() {
    double totalPrice = 0.0;
    for (var element in _buyProductList) {
      totalPrice += element.price * element.qty!;
    }
    return totalPrice;
  }

  void updateQty(ProductModel productModel, int qty) {
    int index = _cartProductList.indexOf(productModel);
    _cartProductList[index].qty = qty;
    notifyListeners();
  }
  ///////// BUY Product  / / // / / // / / / // /

  void addBuyProduct(ProductModel model) {
    try {
      _buyProductList.add(model);
      notifyListeners();
    } catch (e) {
      showMessage(e.toString());
    }
  }

  void addBuyProductCartList() {
    try {
      _buyProductList.addAll(_cartProductList);
      notifyListeners();
    } catch (e) {
      showMessage(e.toString());
    }
  }

  void clearCart() {
    try {
      _cartProductList.clear();
      notifyListeners();
    } catch (e) {
      showMessage(e.toString());
    }
  }

  void clearBuyProduct() {
    try {
      _buyProductList.clear();
      notifyListeners();
    } catch (e) {
      showMessage(e.toString());
    }
  }

  List<ProductModel> get getBuyProductList => _buyProductList;

/////////admin panal

  Future<void> getUserListFun() async {
    try {
      _userList = await FirebaseFirestoreHelper.instance.getUserList();
    } catch (e) {
      // Handle the error, e.g., showMessage(e.toString())
    }
  }

  Future<void> getCompleteOrder() async {
    try {
      _completeOrderList =
          await FirebaseFirestoreHelper.instance.getCompleteOrder();
      for (var element in _completeOrderList) {
        _totalEarning += element.totalPrice;
      }
    } catch (e) {
      showMessage(e.toString());
    }
    notifyListeners();
  }

  Future<void> getCancelOrder() async {
    _cancelOrderList = await FirebaseFirestoreHelper.instance.getCancelOrder();
  }

  Future<void> getPendingOrder() async {
    _pendingOrderList =
        await FirebaseFirestoreHelper.instance.getPendingOrder();
  }

  Future<void> getDeliveryOrder() async {
    _deliveryOrderList =
        await FirebaseFirestoreHelper.instance.getDeliveryOrder();
  }

  Future<void> getCategoriesListFun() async {
    try {
      _categoriesList =
          await FirebaseFirestoreHelper.instance.getAllCategories();
    } catch (e) {
      // Handle the error, e.g., showMessage(e.toString())
    }
  }

  List<UserModel> get getUserList => _userList;
  double get getTotalEarning => _totalEarning;
  List<CategoryModel> get getCategoriesList => _categoriesList;
  List<ProductModel> get getProducts => _productList;
  List<OrderModel> get getCompleteOrderList => _completeOrderList;
  List<OrderModel> get getCancelOrderList => _cancelOrderList;
  List<OrderModel> get getPendingOrderList => _pendingOrderList;
  List<OrderModel> get getDeliveryOrderList => _deliveryOrderList;

  Future<void> callBackFunction() async {
    await getUserListFun();
    await getCategoriesListFun();
    //await getProduct();
    await getProduct();
    await getCompleteOrder();
    await getCancelOrder();
    await getPendingOrder();
    await getDeliveryOrder();
  }

  Future<void> deletCategoryFromFirebase(CategoryModel categoryModel) async {
    String value = await FirebaseFirestoreHelper.instance
        .deleteSingleCategory(categoryModel.id);
    if (value == "Successfully deleted") {
      _categoriesList.remove(categoryModel);
      showMessage("Successfully deleted");
    }
    notifyListeners();
  }

  void updateCategoryList(int index, CategoryModel categoryModel) async {
    await FirebaseFirestoreHelper.instance.updateSingleCategory(categoryModel);

    _categoriesList[index] = categoryModel;
    notifyListeners();
  }

  void addCategory(File image, String name) async {
    CategoryModel categoryModel =
        await FirebaseFirestoreHelper.instance.addSingleCategory(image, name);

    _categoriesList.add(categoryModel);
    notifyListeners();
  }

  Future<void> getProduct() async {
    try {
      _productList = await FirebaseFirestoreHelper.instance.getProducts();
    } catch (e) {
      // Handle the error, e.g., showMessage(e.toString())
    }
    notifyListeners();
  }

  Future<void> deletProductFromFirebase(ProductModel productModel) async {
    String value = await FirebaseFirestoreHelper.instance
        .deleteProduct(productModel.categoryId, productModel.id);
    if (value == "Successfully deleted") {
      _productList.remove(productModel);
      showMessage("Successfully deleted");
    }
    notifyListeners();
  }

  void updateProductList(int index, ProductModel productModel) async {
    await FirebaseFirestoreHelper.instance.updateSingleProduct(productModel);

    _productList[index] = productModel;
    notifyListeners();
  }

  void addProduct(
    File image,
    String name,
    String categoryId,
    String description,
    double price,
    int quantity,
  ) async {
    ProductModel productModel = await FirebaseFirestoreHelper.instance
        .addSingleProduct(
            image, name, categoryId, description, price, quantity);

    _productList.add(productModel);
    notifyListeners();
  }

  void updatePendingOrder(OrderModel order) {
    _deliveryOrderList.add(order);
    _pendingOrderList.remove(order);
    showMessage("Send to Delivery");
    notifyListeners();
  }

  void updateCancelPendingOrder(OrderModel order) {
    _cancelOrderList.add(order);
    _pendingOrderList.remove(order);
    showMessage("Succefully Cancel");
    notifyListeners();
  }

  void updateCancelDeliveryOrder(OrderModel order) {
    _cancelOrderList.add(order);
    _pendingOrderList.remove(order);
    showMessage("Succefully Cancel");
    notifyListeners();
  }
}
