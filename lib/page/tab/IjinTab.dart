import 'package:absen_app/model/GetIjinModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IjinTab extends StatefulWidget {
  const IjinTab({Key? key}) : super(key: key);

  @override
  State<IjinTab> createState() => _IjinTabState();
}

class _IjinTabState extends State<IjinTab> {
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
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8000/api/get-ijin'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await _token,
    });

    if (response.statusCode == 200) {
      final data = getIjinModelFromJson(response.body);
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
                  Image.asset('assets/img/datanotfound.png', width: 300),
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
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ijin = snapshot.data![index];
                return Card(
                  elevation: 2,
                  color: getCardColor(ijin.flg),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal ${ijin.dateFrom}, ${ijin.timeFrom} - ${ijin.dateTo}, ${ijin.timeTo}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Keterangan: ${ijin.keterangan}',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            getIcon(ijin.flg),
                          ],
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
Color getCardColor(String flg) {
  switch (flg) {
    case 'A':
      return Colors.green;
    case 'P':
      return Colors.yellow.shade800;
    case 'R':
      return Colors.red;
    default:
      return Colors.white; // Default color
  }
}

Icon getIcon(String flg) {
  switch (flg) {
    case 'A':
      return Icon(Icons.check_circle, color: Colors.white);
    case 'P':
      return Icon(Icons.pending, color: Colors.white);
    case 'R':
      return Icon(Icons.close, color: Colors.white);
    default:
      return Icon(Icons.error, color: Colors.white); // Default icon
  }
}
