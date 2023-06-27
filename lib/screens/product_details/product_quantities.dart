import 'package:flutter/material.dart';
import 'package:trattamento/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:trattamento/models/product_model/product_model.dart';
import 'package:trattamento/screens/product_details/edit_product.dart';

class LowQuantityProductsScreen extends StatefulWidget {
  @override
  _LowQuantityProductsScreenState createState() =>
      _LowQuantityProductsScreenState();
}

class _LowQuantityProductsScreenState extends State<LowQuantityProductsScreen> {
  List<ProductModel> lowQuantityProducts = [];

  @override
  void initState() {
    super.initState();
    fetchLowQuantityProducts();
  }

  void fetchLowQuantityProducts() async {
    List<ProductModel> allProducts =
        await FirebaseFirestoreHelper.instance.getProducts();

    List<ProductModel> filteredProducts = allProducts
        .where((product) => product.quantity < 0.2 * product.quantity)
        .toList();

    setState(() {
      lowQuantityProducts = filteredProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Low Quantity Products',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: lowQuantityProducts.length,
        itemBuilder: (context, index) {
          ProductModel product = lowQuantityProducts[index];
          int remainingQty = 50 - product.quantity;
          //product.quantity - (0.2 * product.quantity).toInt();

          return Card(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProduct(
                      productModel: product,
                      index: index,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      product.image,
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      product.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Remaining Quantity: $remainingQty", // Display remainingQty
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
