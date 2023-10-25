// To parse this JSON data, do
//
//     final getPengumumanModel = getPengumumanModelFromJson(jsonString);

import 'dart:convert';

GetPengumumanModel getPengumumanModelFromJson(String str) => GetPengumumanModel.fromJson(json.decode(str));

String getPengumumanModelToJson(GetPengumumanModel data) => json.encode(data.toJson());

class GetPengumumanModel {
    bool success;
    List<Datum> data;
    String message;

    GetPengumumanModel({
        required this.success,
        required this.data,
        required this.message,
    });

    factory GetPengumumanModel.fromJson(Map<String, dynamic> json) => GetPengumumanModel(
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
    String judul;
    String tanggalUpload;
    DateTime tanggalDelete;
    String konten;
    dynamic createdAt;
    dynamic updatedAt;

    Datum({
        required this.id,
        required this.judul,
        required this.tanggalUpload,
        required this.tanggalDelete,
        required this.konten,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        judul: json["judul"],
        tanggalUpload: json["tanggal_upload"],
        tanggalDelete: DateTime.parse(json["tanggal_delete"]),
        konten: json["konten"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "tanggal_upload": tanggalUpload,
        "tanggal_delete": "${tanggalDelete.year.toString().padLeft(4, '0')}-${tanggalDelete.month.toString().padLeft(2, '0')}-${tanggalDelete.day.toString().padLeft(2, '0')}",
        "konten": konten,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
