import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trattamento/constants/routes.dart';
import 'package:trattamento/models/product_model/product_model.dart';
import 'package:trattamento/provider/app_provider.dart';
import 'package:trattamento/screens/product_details/add_product.dart';
import 'package:trattamento/widgets/single_product_view.dart';

class AdminProductView extends StatefulWidget {
  const AdminProductView({super.key});

  @override
  State<AdminProductView> createState() => _AdminProductViewState();
}

class _AdminProductViewState extends State<AdminProductView> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Products view",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Routes.instance.push(widget: AddProduct(), context: context);
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Products",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 24.0,
              ),
              GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: appProvider.getProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.9,
                      crossAxisCount: 2),
                  itemBuilder: (ctx, index) {
                    ProductModel singleProduct = appProvider.getProducts[index];
                    return SingleProductView(
                      singleProduct: singleProduct,
                      index: index,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
