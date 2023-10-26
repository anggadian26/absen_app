// To parse this JSON data, do
//
//     final getSakitModel = getSakitModelFromJson(jsonString);

import 'dart:convert';

GetSakitModel getSakitModelFromJson(String str) => GetSakitModel.fromJson(json.decode(str));

String getSakitModelToJson(GetSakitModel data) => json.encode(data.toJson());

class GetSakitModel {
    bool success;
    List<Datum> data;
    String message;

    GetSakitModel({
        required this.success,
        required this.data,
        required this.message,
    });

    factory GetSakitModel.fromJson(Map<String, dynamic> json) => GetSakitModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class Datum {
    int id;
    String tanggal;
    String keterangan;
    int userId;
    DateTime createdAt;
    DateTime updatedAt;

    Datum({
        required this.id,
        required this.tanggal,
        required this.keterangan,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        tanggal: json["tanggal"],
        keterangan: json["keterangan"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tanggal": tanggal,
        "keterangan": keterangan,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
