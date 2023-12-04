import 'dart:convert';

import 'package:absen_app/page/AddPresensi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as myHttp;

class SakitPage extends StatefulWidget {
  const SakitPage({super.key});

  @override
  State<SakitPage> createState() => _SakitPageState();
}

class _SakitPageState extends State<SakitPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;
  TextEditingController tanggalController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
  }

  DateTime date = DateTime.now();
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

  Future<void> saveSakit() async {
    final apiUrl = 'http://10.0.2.2:8000/api/sakit-store';
    final token = await _token;
    print(token);

    final sakitData = {
      "tanggal": DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(tanggalController.text)),
      "keterangan": keteranganController.text
    };

    final response = await myHttp.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: sakitData);

    print(response.body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        print('Sakit berhasil ditambahkan');
        print(response.body);
        Navigator.pop(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SuccessAlertDialog();
          },
        );
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
          'Form Sakit',
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
              'Tanggal:',
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
                  tanggalController.text.isEmpty
                      ? ''
                      : DateFormat('yyyy-MM-dd')
                          .format(DateTime.parse(tanggalController.text)),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () {
                  selectDatePicker(tanggalController);
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Keterangan Sakit:',
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
              onPressed: saveSakit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
