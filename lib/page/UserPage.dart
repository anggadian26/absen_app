import 'package:absen_app/config/app_color.dart';
import 'package:absen_app/login/loginPage.dart';
import 'package:absen_app/model/GetUserModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<List<Data>>? _futureData;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });

    _futureData = fetchData();
  }

  Future<List<Data>> fetchData() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8000/api/get-user'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await _token,
    });

    print(response.body);

    if (response.statusCode == 200) {
      final data = getUserModelFromJson(response.body);
      return [data.data];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> logOut() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token") ?? "";
    print(token);

    final Uri logOutUri = Uri.parse(
        'http://10.0.2.2:8000/api/log-out'); // Sesuaikan dengan URL log-out Anda.

    final http.Response response = await http.post(
      logOutUri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      // Log out berhasil, hapus token di sisi klien (Flutter).
      await prefs.remove("token");
      print("Berhasil log out");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => loginPage()));
      // Jangan lupa mengupdate state jika perlu.
    } else {
      throw Exception('Gagal log-out: ${response.statusCode}');
    }
  } catch (e) {
    print("Error log-out: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "P R O F I L E",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: FutureBuilder<List<Data>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data![0];
            return Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/img/profil.jpg'),
                  ),
                  SizedBox(height: 40),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Mengatur radius border
                      side: BorderSide(
                          color: AppColors.primary,
                          width: 1.0), // Mengatur warna dan lebar border
                    ),
                    child: ListTile(
                      title: Text(
                        'Nama',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.grey),
                      ),
                      subtitle: Text(
                        '${user.name}',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Mengatur radius border
                      side: BorderSide(
                          color: AppColors.primary,
                          width: 1.0), // Mengatur warna dan lebar border
                    ),
                    child: ListTile(
                      title: Text('ID Pengguna',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.grey)),
                      subtitle: Text(
                        '${user.username}',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(
                        Icons.account_circle_outlined,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Mengatur radius border
                      side: BorderSide(
                          color: AppColors.primary,
                          width: 1.0), // Mengatur warna dan lebar border
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ListTile(
                      title: Text('Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.grey)),
                      subtitle: Text(
                        '${user.email}',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(
                        Icons.email_outlined,
                        color: AppColors.primary,
                        size: 27,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Mengatur radius border
                      side: BorderSide(
                          color: AppColors.primary,
                          width: 1.0), // Mengatur warna dan lebar border
                    ),
                    child: ListTile(
                      title: Text('Role',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.grey)),
                      subtitle: Text(
                        '${user.role}',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(
                        Icons.assignment_ind_outlined,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                      onTap: () async {
                        await logOut();
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        elevation: 0,
                        color: Colors.red[900],
                        child: ListTile(
                          title: Text(
                            'Log-Out',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white,
                            ),
                          ),
                          trailing: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        ),
                      ))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
