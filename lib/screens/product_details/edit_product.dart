import 'dart:io';

import 'package:trattamento/constants/constants.dart';
import 'package:trattamento/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:trattamento/models/category_model/category_model.dart';
import 'package:trattamento/models/product_model/product_model.dart';
import 'package:trattamento/models/user_model/user_model.dart';
import 'package:trattamento/provider/app_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class EditProduct extends StatefulWidget {
  const EditProduct(
      {super.key, required this.productModel, required this.index});
  final ProductModel productModel;
  final int index;

  @override
  State<EditProduct> createState() => _EditProduct();
}

class _EditProduct extends State<EditProduct> {
  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController quantities = TextEditingController();

  TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Category Edit",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          image == null
              ? widget.productModel.image.isNotEmpty
                  ? CupertinoButton(
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage:
                            NetworkImage(widget.productModel.image),
                      ),
                      onPressed: () {
                        takePicture();
                      })
                  : CupertinoButton(
                      child: const CircleAvatar(
                        radius: 55,
                        child: Icon(Icons.camera_alt),
                      ),
                      onPressed: () {
                        takePicture();
                      })
              : CupertinoButton(
                  child: CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 55,
                  ),
                  onPressed: () {
                    takePicture();
                  }),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: name,
            decoration: InputDecoration(hintText: widget.productModel.name),
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: description,
            maxLines: 9,
            decoration:
                InputDecoration(hintText: widget.productModel.description),
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: price,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: "LE ${widget.productModel.price.toString()}"),
          ),
          TextFormField(
            controller: quantities,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: " ${widget.productModel.quantity.toString()}"),
          ),
          const SizedBox(
            height: 12.0,
          ),
          ElevatedButton(
              onPressed: () async {
                if (image == null &&
                    name.text.isEmpty &&
                    description.text.isEmpty &&
                    price.text.isEmpty) {
                  Navigator.of(context).pop();
                } else if (image != null) {
                  String imageUrl = await FirebaseFirestoreHelper.instance
                      .uploadUserImage(widget.productModel.id, image!);

                  ProductModel productModel = widget.productModel.copyWith(
                    image: imageUrl,
                    name: name.text.isEmpty ? null : name.text,
                    description:
                        description.text.isEmpty ? null : description.text,
                    price:
                        price.text.isEmpty ? null : double.tryParse(price.text),
                    quantity: quantities.text.isEmpty
                        ? null
                        : int.tryParse(quantities.text),
                  );
                  appProvider.updateProductList(widget.index, productModel);
                  showMessage("Update SuccessFully");
                } else {
                  ProductModel productModel = widget.productModel.copyWith(
                    name: name.text.isEmpty ? null : name.text,
                    description:
                        description.text.isEmpty ? null : description.text,
                    price:
                        price.text.isEmpty ? null : double.tryParse(price.text),
                    quantity: quantities.text.isEmpty
                        ? null
                        : int.tryParse(quantities.text),
                  );
                  appProvider.updateProductList(widget.index, productModel);
                  showMessage("Update SuccessFully");
                }
              },
              child: const Text("Update")),
        ],
      ),
    );
  }
}
