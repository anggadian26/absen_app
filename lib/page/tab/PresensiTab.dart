import 'dart:async';
import 'dart:convert';

import 'package:absen_app/model/GetPresensi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as myHttp;

class PresensiTab extends StatefulWidget {
  const PresensiTab({Key? key}) : super(key: key);

  @override
  _PresensiTabState createState() => _PresensiTabState();
}

class _PresensiTabState extends State<PresensiTab> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;
  GetPresensi? getPresensi;
  final PresensiBloc _presensiBloc = PresensiBloc();

  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
    getData(); // Panggil getData saat initState dijalankan.
  }

  Future getData() async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ' + await _token
    };

    var response = await myHttp.get(
      Uri.parse('http://10.0.2.2:8000/api/get-presensi'),
      headers: headers,
    );

    print('Data: ' + response.body);

    if (response.statusCode == 200) {
      setState(() {
        // Parsing data dari response
        final Map<String, dynamic> responseData = json.decode(response.body);
        getPresensi = GetPresensi.fromJson(responseData);
        _presensiBloc.updatePresensi(getPresensi!.data);
      });
    } else {
      // Handle kesalahan jika ada
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Datum>>(
      stream: _presensiBloc.presensiStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Card(
                elevation: 1, // Tambahkan efek shadow pada card
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Text(
                    snapshot.data![index].tanggal,
                    style: TextStyle(
                      fontSize: 18, // Ukuran sedikit diperbesar
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index].masuk,
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "Masuk",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index].pulang != null
                                    ? snapshot.data![index].pulang
                                    : '-',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "Pulang",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/img/datanotfound.png',width: 300),
                  SizedBox(height: 16),
                  Text(
                    "Belum ada data ijin",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          } 
        // Loading indicator
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void dispose() {
    _presensiBloc.dispose();
    super.dispose();
  }
}

class PresensiBloc {
  final _presensiController = StreamController<List<Datum>>();

  Stream<List<Datum>> get presensiStream => _presensiController.stream;

  void updatePresensi(List<Datum> presensi) {
    _presensiController.add(presensi);
  }

  void dispose() {
    _presensiController.close();
  }
}
