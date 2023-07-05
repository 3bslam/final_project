import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.image,
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  });

  String? image;
  String name;
  String email;

  String id;
  String address;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        image: json["image"],
        email: json["email"],
        name: json["name"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "email": email,
        "address": address,
      };

  UserModel copyWith({
    String? name,
    image,
    String? address,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email,
        image: image ?? this.image,
        address: address ?? this.address,
      );
}
