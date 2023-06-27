import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel(
      {required this.image,
      required this.id,
      required this.name,
      required this.price,
      //required this.quantity,
      //required this.expirationDate,
      required this.description,
      required this.isFavourite,
      required this.categoryId,
      this.quantity = 0,
      this.qty});

  String image;
  String id;
  bool isFavourite;
  String name, categoryId;
  double price;
  int quantity;
  //int expirationDate;
  String description;

  int? qty;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"].toString(),
        name: json["name"],
        description: json["description"],
        categoryId: json["categoryId"] ?? "",
        image: json["image"],
        isFavourite: false,
        qty: json["qty"],
        price: double.parse(json["price"].toString()),
        quantity: json['quantity'] ?? 0,
        // quantity: int.parse(json["quantity"].toString()),
        // expirationDate: int.parse(json["expirationDate"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "isFavourite": isFavourite,
        "price": price,
        //"quantity": quantity,
        // "expirationDate": expirationDate,
        "categoryId": categoryId,
        "qty": qty,
        'quantity': quantity,
      };
  /* ProductModel copyWith({
    int? qty,
  }) =>
      ProductModel(
        id: id,
        name: name,
        description: description,
        image: image,
        isFavourite: isFavourite,
        qty: qty ?? this.qty,
        price: price,
        categoryId: categoryId,
        //quantity: quantity,
        //expirationDate: expirationDate
      );
      */

  ProductModel copyWith({
    String? name,
    String? image,
    String? id,
    String? categoryId,
    double? price,
    String? description,
    int? qty,
    int? quantity,
  }) =>
      ProductModel(
          id: id ?? this.id,
          name: name ?? this.name,
          categoryId: categoryId ?? this.categoryId,
          description: description ?? this.description,
          isFavourite: false,
          price: price != null ? price : this.price,
          image: image ?? this.image,
          qty: qty ?? this.qty,
          quantity: this.quantity);
}
