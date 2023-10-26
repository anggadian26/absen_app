// To parse this JSON data, do
//
//     final ijinModel = ijinModelFromJson(jsonString);

import 'dart:convert';

IjinModel ijinModelFromJson(String str) => IjinModel.fromJson(json.decode(str));

String ijinModelToJson(IjinModel data) => json.encode(data.toJson());

class IjinModel {
    bool success;
    Data data;
    String message;

    IjinModel({
        required this.success,
        required this.data,
        required this.message,
    });

    factory IjinModel.fromJson(Map<String, dynamic> json) => IjinModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
    };
}

class Data {
    DateTime dateFrom;
    String timeFrom;
    DateTime dateTo;
    String timeTo;
    String keterangan;
    int userId;

    Data({
        required this.dateFrom,
        required this.timeFrom,
        required this.dateTo,
        required this.timeTo,
        required this.keterangan,
        required this.userId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        dateFrom: DateTime.parse(json["date_from"]),
        timeFrom: json["time_from"],
        dateTo: DateTime.parse(json["date_to"]),
        timeTo: json["time_to"],
        keterangan: json["keterangan"],
        userId: json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "date_from": "${dateFrom.year.toString().padLeft(4, '0')}-${dateFrom.month.toString().padLeft(2, '0')}-${dateFrom.day.toString().padLeft(2, '0')}",
        "time_from": timeFrom,
        "date_to": "${dateTo.year.toString().padLeft(4, '0')}-${dateTo.month.toString().padLeft(2, '0')}-${dateTo.day.toString().padLeft(2, '0')}",
        "time_to": timeTo,
        "keterangan": keterangan,
        "user_id": userId,
    };
}
