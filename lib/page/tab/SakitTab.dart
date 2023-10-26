import 'package:absen_app/model/GetSakitModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SakitTab extends StatefulWidget {
  const SakitTab({super.key});

  @override
  State<SakitTab> createState() => _SakitTabState();
}

class _SakitTabState extends State<SakitTab> {
  Future<List<Datum>>? _futureData;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;

  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });

    _futureData = fetchData();
  }

    Future<List<Datum>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/get-sakit'),
        headers: {
          'Accept' : 'application/json',
          'Authorization': 'Bearer ' + await _token,
        }
        
        );

    if (response.statusCode == 200) {
      final data = getSakitModelFromJson(response.body);
      return data.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Datum>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/img/datanotfound.png',width: 300),
                  SizedBox(height: 16),
                  Text(
                    "Belum ada data Sakit",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final sakit = snapshot.data![index];
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal: ${sakit.tanggal}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Keterangan: ${sakit.keterangan}',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}