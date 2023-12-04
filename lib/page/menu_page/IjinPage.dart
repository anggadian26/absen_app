import 'dart:convert';

import 'package:absen_app/page/AddPresensi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as myhttp;
import 'package:shared_preferences/shared_preferences.dart';

class IjinPage extends StatefulWidget {
  const IjinPage({Key? key});

  @override
  State<IjinPage> createState() => _IjinPageState();
}

class _IjinPageState extends State<IjinPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController tanggalMulaiController = TextEditingController();
  TextEditingController jamMulaiController = TextEditingController();
  TextEditingController tanggalSelesaiController = TextEditingController();
  TextEditingController jamSelesaiController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();

  late Future<String> _token;

  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
  }

  DateTime date = DateTime.now();

  // void selectDatePicker(TextEditingController controller) async {
  //   DateTime? datePicker = await showDatePicker(
  //     context: context,
  //     initialDate: date,
  //     firstDate: DateTime(1999),
  //     lastDate: DateTime(2030),
  //   );
  //   if (datePicker != null && datePicker != date) {
  //     setState(() {
  //       date = datePicker;
  //       controller.text = DateFormat('yyyy-MM-dd').format(datePicker);
  //     });
  //   }
  // }
  void selectDatePicker(TextEditingController controller) async {
    DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (datePicker != null &&
        datePicker.isBefore(DateTime.now().add(Duration(days: 1)))) {
      setState(() {
        date = datePicker;
        controller.text = DateFormat('yyyy-MM-dd').format(datePicker);
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pilih Tanggal Valid'),
            content: Text(
                'Anda hanya dapat memilih tanggal hari ini atau setelahnya.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void selectTimePicker(TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        final formattedTime = selectedTime.format(context);
        controller.text = formattedTime;
      });
    }
  }

  Future<void> saveIjin() async {
    final apiUrl =
        'http://10.0.2.2:8000/api/ijin-store'; // Sesuaikan dengan URL API Anda
    final token = await _token;
    print(token);

    String formatTime(String time) {
      // Periksa jika string waktu berisi "AM" atau "PM" sebelum menambahkannya
      final containsAmPm = time.contains("AM") || time.contains("PM");
      final formattedTimeWithAmPm = containsAmPm ? time : "$time AM";
      // Konversi ke format yang diinginkan
      final formattedTime = DateFormat('HH:mm')
          .format(DateFormat('h:mm a').parse(formattedTimeWithAmPm));
      return formattedTime;
    }

    // Susun objek Map yang sesuai dengan format yang diharapkan oleh API
    final ijinData = {
      "date_from": DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(tanggalMulaiController.text)),
      // "time_from": jamMulaiController.text,
      "time_from": formatTime(jamMulaiController.text),
      "date_to": DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(tanggalSelesaiController.text)),
      "time_to": formatTime(jamSelesaiController.text),
      "keterangan": keteranganController.text,
    };
    

    // print(ijinData);

    final response = await myhttp.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // Tambahkan header otorisasi
      },
      body: ijinData, // Mengonversi Map ke JSON
    );

    print(response.body);

    if (response.statusCode == 200) {
      // Berhasil menambahkan ijin
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        // Ijin berhasil ditambahkan, lakukan tindakan sesuai kebutuhan
        print('Ijin berhasil ditambahkan');
        print(response.body);
        Navigator.pop(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SuccessAlertDialog();
          },
        );
      } else {
        // Terdapat pesan kesalahan dari API
        final errorMessage = responseData['message'];
        print('Gagal menambahkan ijin: $errorMessage');
      }
    } else {
      // Gagal mengirim permintaan ke API
      print('Gagal terhubung ke API');
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
          'Form Ijin',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            Text(
              'Tanggal Mulai:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  tanggalMulaiController.text.isEmpty
                      ? ''
                      : DateFormat('yyyy-MM-dd')
                          .format(DateTime.parse(tanggalMulaiController.text)),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () {
                  selectDatePicker(tanggalMulaiController);
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Jam Mulai:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  jamMulaiController.text.isEmpty
                      ? ''
                      : jamMulaiController.text,
                ),
                trailing: Icon(Icons.access_time),
                onTap: () {
                  selectTimePicker(jamMulaiController);
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Tanggal Selesai:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  tanggalSelesaiController.text.isEmpty
                      ? ''
                      : DateFormat('yyyy-MM-dd').format(
                          DateTime.parse(tanggalSelesaiController.text)),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () {
                  selectDatePicker(tanggalSelesaiController);
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Jam Selesai:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  jamSelesaiController.text.isEmpty
                      ? ''
                      : jamSelesaiController.text,
                ),
                trailing: Icon(Icons.access_time),
                onTap: () {
                  selectTimePicker(jamSelesaiController);
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Keterangan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: keteranganController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Keterangan',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  saveIjin, // Panggil fungsi saveIjin saat tombol ditekan
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
