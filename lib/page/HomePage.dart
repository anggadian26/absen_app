import 'dart:convert';

import 'package:absen_app/config/app_color.dart';
import 'package:absen_app/model/GetPengumumanModel.dart';
import 'package:absen_app/model/GetPresensi.dart';
import 'package:absen_app/page/menu_page/PengumuanPage.dart';
import 'package:absen_app/page/tab/PresensiTab.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as myHttp;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _formattedTime = DateFormat.Hms().format(DateTime.now());
  final List<String> items = List.generate(30, (index) => 'Item $index');
  Timer? _timer;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token, _name;
  GetPresensi? getPresensi;
  final PresensiBloc _presensiBloc = PresensiBloc();

  final PengumumanBloc _pengumumanBloc = PengumumanBloc();

  String masuk = "";
  String keluar = "";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null).then((_) {});
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Periksa apakah widget masih ada di dalam pohon
        setState(() {
          _formattedTime = DateFormat.Hms().format(DateTime.now());
        });
      }
    });
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
    _name = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("name") ?? "";
    });
    getData();
    getDataP();
  }

  Future getData() async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ' + await _token
    };

    var response = await myHttp.get(
      Uri.parse('http://10.0.2.2:8000/api/get-presensi-home'),
      headers: headers,
    );

    print('Data: ' + response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData["data"] is List) {
        final List<dynamic> data = responseData["data"];
        if (data.isNotEmpty) {
          final Map<String, dynamic> firstData = data.first;
          final bool isHariIni = firstData["is_hari_ini"] as bool;
          if (isHariIni) {
            masuk = firstData["masuk"];
            keluar = firstData["pulang"] ?? '';
            print('Waktu masuk: $masuk');
            print('Waktu keluar: $keluar');
          }
        }
      }
      setState(() {
        // Parsing data from the response
        getPresensi = GetPresensi.fromJson(responseData);
        _presensiBloc.updatePresensi(getPresensi!.data);
      });
    } else {
      // Handle errors if any
      print('Error: ${response.statusCode}');
    }
  }

  Future getDataP() async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ' + await _token
    };

    var response = await myHttp.get(
      Uri.parse('http://10.0.2.2:8000/api/get-pengumuman'),
      headers: headers,
    );

    print('Data: ' + response.body);

    if (response.statusCode == 200) {
      // Parsing data pengumuman dari response
      final Map<String, dynamic> responseData = json.decode(response.body);
      final GetPengumumanModel pengumuman =
          GetPengumumanModel.fromJson(responseData);

      // Update data pengumuman ke dalam stream di _pengumumanBloc
      _pengumumanBloc.updatePengumuman(pengumuman.data);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _presensiBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('EEEE, d MMMM y', 'id');

    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              FutureBuilder<String>(
                future: _name,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(left: 30.0, top: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Hallo ${snapshot.data ?? ""}', // Gunakan nilai _name jika tersedia, atau gunakan teks kosong jika null
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color.fromARGB(255, 109, 108, 108),
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 1)),
              Padding(padding: EdgeInsets.all(7)),
              Column(
                children: <Widget>[
                  Container(
                    height: 120, //mengatur tinggi
                    width: 370, //mengatur lebar
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          )
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _formattedTime,
                          style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatter.format(now),
                          style: const TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 170,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          )
                        ]),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color:
                                      const Color.fromARGB(255, 204, 186, 233)),
                              child: const Icon(
                                Icons.subdirectory_arrow_right,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Masuk',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 204, 186, 233)),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(35, 0, 35,
                                  20), // Atur jumlah padding sesuai kebutuhan Anda
                              child: Text(
                                masuk, // Tampilkan waktu di sini
                                style: TextStyle(
                                  fontSize: 30, // Atur ukuran teks jam
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Warna teks jam
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 170,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          )
                        ]),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color:
                                      const Color.fromARGB(255, 204, 186, 233)),
                              child: const Icon(
                                Icons.subdirectory_arrow_right,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Keluar',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 204, 186, 233)),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(35, 0, 35,
                                  20), // Atur jumlah padding sesuai kebutuhan Anda
                              child: Text(
                                keluar, // Tampilkan waktu di sini
                                style: TextStyle(
                                  fontSize: 30, // Atur ukuran teks jam
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Warna teks jam
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Daftar Hadir',
                              style: TextStyle(
                                  color: AppColors.font,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 160, //spasi kiri
                            right: 2, //spasi kanan
                            bottom: 9, //spasi bawah
                            top: 3, //spasi atas
                          ),
                        ),
                        InkWell(
                          child: Text(
                            '',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              StreamBuilder<List<Datum>>(
                stream: _presensiBloc.presensiStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Container(
                          width: 370,
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 223, 207, 252),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 193, 174, 255),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(7),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data![index].tanggal,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(), // Spacer untuk menggeser ke sebelah kiri
                                      Text(
                                        snapshot.data![index].flg == 'N' &&
                                                (snapshot.data![index].masuk ==
                                                        null ||
                                                    snapshot.data![index]
                                                            .pulang ==
                                                        null)
                                            ? '-'
                                            : snapshot.data![index].flg == 'I'
                                                ? 'Ijin'
                                                : snapshot.data![index].flg ==
                                                        'S'
                                                    ? ''
                                                    : snapshot.data![index]
                                                            .masuk ??
                                                        '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                      ),
                                      Text(
                                        snapshot.data![index].flg == 'N' &&
                                                (snapshot.data![index].masuk ==
                                                        null ||
                                                    snapshot.data![index]
                                                            .pulang ==
                                                        null)
                                            ? '-'
                                            : snapshot.data![index].flg == 'I'
                                                ? 'Ijin'
                                                : snapshot.data![index].flg ==
                                                        'S'
                                                    ? 'Sakit'
                                                    : snapshot.data![index]
                                                            .pulang ??
                                                        '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text('Belum ada data');
                  }
                },
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                // Pindah ke halaman pengumuman
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PengumumanPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Pengumuman',
                                style: TextStyle(
                                  color: AppColors.font,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 100, //spasi kiri
                            right: 0, //spasi kanan
                            bottom: 9, //spasi bawah
                            top: 3, //spasi atas
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Pindah ke halaman semua pengumuman
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PengumumanPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Semua',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              StreamBuilder<List<Data>>(
                stream: _pengumumanBloc.pengumumanStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Container(
                          width: 370,
                          height: 280,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 223, 207, 252),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!
                                .length, // Gunakan jumlah data yang sesuai
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 193, 174, 255),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data![index].judul,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        snapshot.data![index].konten,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.font,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text('Belum ada data pengumuman');
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class PengumumanBloc {
  final _pengumumanStreamController = StreamController<List<Data>>();

  Stream<List<Data>> get pengumumanStream => _pengumumanStreamController.stream;

  void updatePengumuman(List<Data> pengumuman) {
    _pengumumanStreamController.add(pengumuman);
  }

  void dispose() {
    _pengumumanStreamController.close();
  }
}
