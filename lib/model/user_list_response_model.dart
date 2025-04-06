// To parse this JSON data, do
//
//     final announcementResposneModel = announcementResposneModelFromJson(jsonString);

import 'dart:convert';

List<UserListResponseModel> announcementResposneModelFromJson(String str) =>
    List<UserListResponseModel>.from(
        json.decode(str).map((x) => UserListResponseModel.fromJson(x)));

String announcementResposneModelToJson(List<UserListResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserListResponseModel {
  final int? id;
  final String? name;
  final String? email;
  final String? gender;
  final String? status;

  UserListResponseModel({
    this.id,
    this.name,
    this.email,
    this.gender,
    this.status,
  });

  factory UserListResponseModel.fromJson(Map<String, dynamic> json) =>
      UserListResponseModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        gender: json["gender"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "gender": gender,
        "status": status,
      };
}
