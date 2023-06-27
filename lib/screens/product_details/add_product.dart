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

class AddProduct extends StatefulWidget {
  const AddProduct({
    super.key,
  });

  @override
  State<AddProduct> createState() => _EditProduct();
}

class _EditProduct extends State<AddProduct> {
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

  TextEditingController price = TextEditingController();
  TextEditingController quantities = TextEditingController();
  CategoryModel? _selectedCategory;

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
              ? CupertinoButton(
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
            decoration: InputDecoration(hintText: "Product Name"),
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: description,
            maxLines: 9,
            decoration: InputDecoration(hintText: "Product description"),
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: price,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "LE Product Price"),
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: quantities,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "quantities"),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.white),
            child: DropdownButtonFormField(
              value: _selectedCategory,
              hint: const Text("please Select Category"),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items: appProvider.getCategoriesList.map((CategoryModel val) {
                return DropdownMenuItem(
                  value: val,
                  child: Text(val.name),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                if (image == null ||
                    _selectedCategory == null ||
                    name.text.isEmpty ||
                    description.text.isEmpty ||
                    price.text.isEmpty) {
                  showMessage("please fill all information");
                } else {
                  // double parsedPrice = double.parse(price.text);
                  appProvider.addProduct(
                    image!,
                    name.text,
                    _selectedCategory!.id,
                    description.text,
                    double.tryParse(price.text) ?? 0.0,
                    int.tryParse(quantities.text) ?? 0,
                  );
                  showMessage("Update SuccessFully");
                }
              },
              child: const Text("Add")),
        ],
      ),
    );
  }
}
