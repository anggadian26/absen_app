import 'package:absen_app/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _formattedTime = DateFormat.Hms().format(DateTime.now());
  final List<String> items = List.generate(30, (index) => 'Item $index');

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null).then((_) {});
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _formattedTime = DateFormat.Hms().format(DateTime.now());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat.yMMMd('id');

    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Selamat Datang',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 50)),
                    Icon(Icons.logout)
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical:1)),
              
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(8.0)),
                  Align(
                    alignment: Alignment.centerLeft,
                  ),
                  Text(
                    'Mercy',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 150)),
                ],
              ),
              Padding(padding: EdgeInsets.all(7)),
              Column(
                children: <Widget>[
                  Container(
                    height: 120, //mengatur tinggi
                    width: 338, //mengatur lebar
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
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
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.primary,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          )
                        ]),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 204, 186, 233)),
                          child: const Icon(
                            Icons.subdirectory_arrow_right,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 65,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Masuk',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 204, 186, 233)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.primary,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          )
                        ]),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 204, 186, 233)),
                          child: const Icon(
                            Icons.subdirectory_arrow_left,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 65,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Keluar',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 204, 186, 233)),
                            ),
                          ],
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, //menengahkan teks secara horizontal
                          mainAxisAlignment: MainAxisAlignment
                              .center, //menengahkan teks secara vertikal
                          children: <Widget>[],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
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
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 100, //spasi kiri
                            right: 2, //spasi kanan
                            bottom: 0, //spasi bawah
                            top: 3, //spasi atas
                          ),
                        ),
                        InkWell(
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
              Column(
                children: <Widget>[
                  Container(
                      width: 330, //mengatur lebar
                      height: 200, //mengatur tinngi
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 223, 207, 252),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 193, 174, 255),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(7),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        formatter.format(now),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 60)),
                                      Text(
                                        DateFormat.Hm().format(DateTime.now()),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10)),
                                      Text(
                                        DateFormat.Hm().format(DateTime.now()),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )));
                        },
                      )),
                ],
              ),
            ],
          )
        ],
      ),
    ));
  }
}
