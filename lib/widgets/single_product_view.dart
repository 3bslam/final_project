import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trattamento/constants/routes.dart';
import 'package:trattamento/models/product_model/product_model.dart';
import 'package:trattamento/screens/product_details/edit_product.dart';
import '../provider/app_provider.dart';

class SingleProductView extends StatefulWidget {
  const SingleProductView({
    Key? key,
    required this.singleProduct,
    required this.index,
  }) : super(key: key);

  final ProductModel singleProduct;
  final int index;

  @override
  _SingleProductViewState createState() => _SingleProductViewState();
}

class _SingleProductViewState extends State<SingleProductView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Card(
      color: Theme.of(context).primaryColor.withOpacity(0.3),
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 1.0,
                ),
                Image.network(
                  widget.singleProduct.image,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  widget.singleProduct.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.singleProduct.price.toString() + 'LE',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  widget.singleProduct.quantity.toString() + ' left',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 6, 66, 60),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await appProvider
                          .deletProductFromFirebase(widget.singleProduct);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                  ),
                  const SizedBox(
                    width: 100.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Routes.instance.push(
                        widget: EditProduct(
                          productModel: widget.singleProduct,
                          index: widget.index,
                        ),
                        context: context,
                      );
                    },
                    child: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
