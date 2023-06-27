import 'dart:io';

import 'package:trattamento/constants/constants.dart';
import 'package:trattamento/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:trattamento/models/category_model/category_model.dart';
import 'package:trattamento/models/user_model/user_model.dart';
import 'package:trattamento/provider/app_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditCategory extends StatefulWidget {
  const EditCategory(
      {super.key, required this.categoryModel, required this.index});
  final CategoryModel categoryModel;
  final int index;

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
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
            decoration: InputDecoration(hintText: widget.categoryModel.name),
          ),
          const SizedBox(
            height: 12.0,
          ),
          ElevatedButton(
              onPressed: () async {
                if (image == null && name.text.isEmpty) {
                  Navigator.of(context).pop();
                } else if (image != null) {
                  String imageUrl = await FirebaseFirestoreHelper.instance
                      .uploadUserImage(widget.categoryModel.id, image!);
                  CategoryModel categoryModel = widget.categoryModel.copyWith(
                    image: imageUrl,
                    name: name.text.isEmpty ? null : name.text,
                  );
                  appProvider.updateCategoryList(widget.index, categoryModel);
                  showMessage("Update SuccessFully");
                } else {
                  CategoryModel categoryModel = widget.categoryModel.copyWith(
                    name: name.text.isEmpty ? null : name.text,
                  );
                  appProvider.updateCategoryList(widget.index, categoryModel);
                  showMessage("Update SuccessFully");
                }
              },
              child: const Text("Update")),
        ],
      ),
    );
  }
}
