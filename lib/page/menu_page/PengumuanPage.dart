import 'dart:convert';

import 'package:absen_app/model/GetPengumumanModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as myHttp;

class PengumumanPage extends StatefulWidget {
  const PengumumanPage({Key? key}) : super(key: key);

  @override
  _PengumumanPageState createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;
  GetPengumumanModel? getPengumumanModel;

  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
    getData(); // Fetch data when the page is loaded.
  }

  Future getData() async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ' + await _token
    };

    var response = await myHttp.get(
      Uri.parse('http://10.0.2.2:8000/api/get-pengumuman'),
      headers: headers,
    );

    print('Data: ' + response.body);

    if (response.statusCode == 200) {
      setState(() {
        final Map<String, dynamic> responseData = json.decode(response.body);
        getPengumumanModel = GetPengumumanModel.fromJson(responseData);
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey, // Ubah warna ikon di sini
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Pengumuman',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: getPengumumanModel?.data.isNotEmpty ?? false
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: getPengumumanModel?.data.map((pengumuman) {
                        return Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pengumuman.judul,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  pengumuman.tanggalUpload,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  pengumuman.konten,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList() ??
                      [],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/img/notfound.png'),
                      SizedBox(height: 16),
                      Text(
                        "Belum ada pengumuman terbaru",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
