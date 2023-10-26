// To parse this JSON data, do
//
//     final getIjinModel = getIjinModelFromJson(jsonString);

import 'dart:convert';

GetIjinModel getIjinModelFromJson(String str) => GetIjinModel.fromJson(json.decode(str));

String getIjinModelToJson(GetIjinModel data) => json.encode(data.toJson());

class GetIjinModel {
    bool success;
    List<Datum> data;
    String message;

    GetIjinModel({
        required this.success,
        required this.data,
        required this.message,
    });

    factory GetIjinModel.fromJson(Map<String, dynamic> json) => GetIjinModel(
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
    String dateFrom;
    String timeFrom;
    String dateTo;
    String timeTo;
    String keterangan;
    int userId;
    DateTime createdAt;
    DateTime updatedAt;

    Datum({
        required this.id,
        required this.dateFrom,
        required this.timeFrom,
        required this.dateTo,
        required this.timeTo,
        required this.keterangan,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        dateFrom: json["date_from"],
        timeFrom: json["time_from"],
        dateTo: json["date_to"],
        timeTo: json["time_to"],
        keterangan: json["keterangan"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date_from": dateFrom,
        "time_from": timeFrom,
        "date_to": dateTo,
        "time_to": timeTo,
        "keterangan": keterangan,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
