import 'dart:async';
import 'dart:convert';

import 'package:absen_app/config/app_color.dart';
import 'package:absen_app/config/bar_navigation.dart';
import 'package:absen_app/model/SavePresensiModel.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:http/http.dart' as myHttp;

class AddPresensi extends StatefulWidget {
  const AddPresensi({super.key});

  @override
  State<AddPresensi> createState() => _AddPresensiState();
}

class _AddPresensiState extends State<AddPresensi> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;

  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
  }

  Future<LocationData?> _currenctLocation() async {
    bool serviceEnable;
    PermissionStatus permissionGranted;

    Location location = new Location();
    serviceEnable = await location.serviceEnabled();

    if (!serviceEnable) {
      serviceEnable = await location.requestService();
      if (!serviceEnable) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  Future savePresensi(latitude, longitude) async {
    SavePresensiModel savePresensiModel;
    Map<String, String> body = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString()
    };
    print(latitude.toString());
    Map<String, String> headers = {
      "Authorization": 'Bearer ' + await _token,
      'Accept': 'application/json'
    };

    var response = await myHttp.post(
        Uri.parse('http://10.0.2.2:8000/api/save-presensi'),
        body: body,
        headers: headers);

    savePresensiModel = SavePresensiModel.fromJson(json.decode(response.body));
    print("Request Headers: $headers");
    print("Kode Status Respons: ${response.statusCode}");

    if (savePresensiModel.success) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => mainHome()))
          .then((value) {
        setState(() {});
      });
      print(response.body);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SuccessAlertDialog();
        },
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal menyimpan presensi")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LocationData?>(
          future: _currenctLocation(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final LocationData currentLocation = snapshot.data;
              print("KODING : " +
                  currentLocation.latitude.toString() +
                  " | " +
                  currentLocation.longitude.toString());
              return Stack(children: [
                SfMaps(
                  layers: [
                    MapTileLayer(
                      initialFocalLatLng: MapLatLng(
                        currentLocation.latitude!,
                        currentLocation.longitude!,
                      ),
                      initialZoomLevel: 15,
                      initialMarkersCount: 1,
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      markerBuilder: (BuildContext context, int index) {
                        return MapMarker(
                          latitude: currentLocation.latitude!,
                          longitude: currentLocation.longitude!,
                          child: Icon(
                            size: 50,
                            Icons.location_on,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Positioned(
                  top: 35,
                  left: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back),
                    backgroundColor: AppColors.primary,
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 25,
                  right: 25,
                  child: ElevatedButton(
                    onPressed: () {
                      savePresensi(
                          currentLocation.latitude, currentLocation.longitude);
                    },
                    style: ElevatedButton.styleFrom(primary: AppColors.primary),
                    child: Text("Simpan"),
                  ),
                ),
              ]);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class SuccessAlertDialog extends StatefulWidget {
  @override
  _SuccessAlertDialogState createState() => _SuccessAlertDialogState();
}

class _SuccessAlertDialogState extends State<SuccessAlertDialog> {
  @override
  void initState() {
    super.initState();
    // Delay 3 detik dan kemudian kembali ke halaman sebelumnya
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80.0,
            ),
            SizedBox(height: 16),
            Text(
              "Success",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
