import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trattamento/models/order_model/order_model.dart';
import 'package:trattamento/screens/order_screen/single_order_widget.dart';

class OrderList extends StatelessWidget {
  final List<OrderModel>? orderModelList; // Make the list nullable
  final String title;

  const OrderList({
    Key? key,
    required this.orderModelList,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orderModelList == null || orderModelList!.isEmpty) {
      // Handle null or empty list case
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            "${title} Order List",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: Text('No orders available.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "${title} Order List",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: ListView.builder(
          itemCount: orderModelList!.length,
          itemBuilder: (context, index) {
            OrderModel orderModel = orderModelList![index];
            return SingleOrderWidget(orderModel: orderModel);
          },
        ),
      ),
    );
  }
}
