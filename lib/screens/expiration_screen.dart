import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trattamento/models/product_model/product_model.dart';
import 'package:trattamento/provider/app_provider.dart';
/*
class ExpirationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    DateTime currentDate = DateTime.now();

    // Filter the products based on the expiration date
    List<ProductModel> expiredProducts =
        appProvider.getProducts.where((product) {
      return product.expirationDate.isBefore(currentDate);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expired Products",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: expiredProducts.length,
        itemBuilder: (context, index) {
          ProductModel product = expiredProducts[index];
          int monthsLeft = product.expirationDate.month - currentDate.month;

          return ListTile(
            leading:
                Image.network(product.image), // Replace with your image URL
            title: Text(product.name),
            subtitle: Text("$monthsLeft months left"),
          );
        },
      ),
    );
  }
}
*/
