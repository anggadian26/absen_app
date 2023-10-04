// To parse this JSON data, do
//
//     final loginPressensiModel = loginPressensiModelFromJson(jsonString);

import 'dart:convert';

LoginPressensiModel loginPressensiModelFromJson(String str) => LoginPressensiModel.fromJson(json.decode(str));

String loginPressensiModelToJson(LoginPressensiModel data) => json.encode(data.toJson());

class LoginPressensiModel {
    bool success;
    String message;
    Data data;

    LoginPressensiModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory LoginPressensiModel.fromJson(Map<String, dynamic> json) => LoginPressensiModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int id;
    String name;
    String username;
    String email;
    dynamic emailVerifiedAt;
    dynamic createdAt;
    dynamic updatedAt;
    String token;
    String tokenType;

    Data({
        required this.id,
        required this.name,
        required this.username,
        required this.email,
        required this.emailVerifiedAt,
        required this.createdAt,
        required this.updatedAt,
        required this.token,
        required this.tokenType,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        token: json["token"],
        tokenType: json["token_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "token": token,
        "token_type": tokenType,
    };
}
