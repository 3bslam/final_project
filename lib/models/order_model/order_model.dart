import 'package:trattamento/models/product_model/product_model.dart';

class OrderModel {
  OrderModel(
      {required this.totalPrice,
      required this.orderId,
      required this.payment,
      required this.products,
      required this.status,
      this.userId});

  String payment;
  String status;
  String? userId;
  List<ProductModel> products;
  double totalPrice;
  String orderId;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> productMap = json["products"];
    return OrderModel(
      orderId: json["orderId"],
      userId: json["userId"],
      products: productMap.map((e) => ProductModel.fromJson(e)).toList(),
      totalPrice: json["totalPrice"].toDouble(), // Explicitly cast to double
      status: json["status"],
      payment: json["payment"],
    );
  }
}
