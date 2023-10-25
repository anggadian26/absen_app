// To parse this JSON data, do
//
//     final getPresensi = getPresensiFromJson(jsonString);

import 'dart:convert';

GetPresensi getPresensiFromJson(String str) => GetPresensi.fromJson(json.decode(str));

String getPresensiToJson(GetPresensi data) => json.encode(data.toJson());

class GetPresensi {
    bool success;
    List<Datum> data;
    String message;

    GetPresensi({
        required this.success,
        required this.data,
        required this.message,
    });

    factory GetPresensi.fromJson(Map<String, dynamic> json) => GetPresensi(
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
    int userId;
    String latitude;
    String longitude;
    String tanggal;
    String masuk;
    dynamic pulang;
    DateTime createdAt;
    DateTime updatedAt;
    bool isHariIni;

    Datum({
        required this.id,
        required this.userId,
        required this.latitude,
        required this.longitude,
        required this.tanggal,
        required this.masuk,
        required this.pulang,
        required this.createdAt,
        required this.updatedAt,
        required this.isHariIni,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        tanggal: json["tanggal"],
        masuk: json["masuk"],
        pulang: json["pulang"] ?? null,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isHariIni: json["is_hari_ini"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "latitude": latitude,
        "longitude": longitude,
        "tanggal": tanggal,
        "masuk": masuk,
        "pulang": pulang,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_hari_ini": isHariIni,
    };
}