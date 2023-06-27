import 'dart:math';

import 'package:trattamento/constants/routes.dart';
import 'package:trattamento/models/category_model/category_model.dart';
import 'package:trattamento/provider/app_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trattamento/screens/category_view/add_category.dart';
import 'package:trattamento/screens/category_view/single_category_item.dart';

class AdminCategoriesView extends StatelessWidget {
  const AdminCategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Categories view",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Routes.instance
                  .push(widget: const AddCategory(), context: context);
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: Consumer<AppProvider>(builder: (context, value, child) {
        // Call the callBackFunction to fetch categories
        value.callBackFunction();

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "categories",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: value.getCategoriesList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    CategoryModel categoryModel =
                        value.getCategoriesList[index];
                    return SingleCategoryItem(
                      singleCategory: categoryModel,
                      index: index,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
