import 'dart:convert';

import 'package:absen_app/config/app_color.dart';
import 'package:absen_app/config/bar_navigation.dart';
// import 'package:absen_app/page/HomePage.dart';
import 'package:absen_app/model/LogPresensiModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as myHttp;

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Future<String> _name, _token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });

    _name = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("name") ?? "";
    });
    checkToken(_token, _name);
  }

  checkToken(token, name) async {
    String tokenStr = await token;
    String nameStr = await name;
    print(tokenStr);
    print(nameStr);
    if (tokenStr != "" && nameStr != "") {
      Future.delayed(Duration(seconds: 1), () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => mainHome()))
            .then((value) {
          setState(() {});
        });
      });
    }
  }

  Future Login(email, password) async {
    LoginPressensiModel? loginPresensiModel;
    Map<String, String> body = {"email": email, "password": password};
    final header = {'Accept': 'application/json'};

    var response = await myHttp.post(
        Uri.parse('http://10.0.2.2:8000/api/login'),
        body: body,
        headers: header);

    if (response.statusCode == 422) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email dan Password yang anda berikan salah")));
    } else {
      loginPresensiModel =
          LoginPressensiModel.fromJson(json.decode(response.body));
      saveUser(loginPresensiModel.data.token, loginPresensiModel.data.name);
      print("Response : " + response.body);
    }
  }

  Future saveUser(token, name) async {
    try {
      final SharedPreferences prefs = await _prefs;
      prefs.setString("name", name);
      prefs.setString("token", token);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => mainHome()))
          .then((value) {
        setState(() {});
      });
    } catch (err) {
      print("ERROR" + err.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/iicon.png',
                width: 300,
                height: 100,
              ),
              SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        contentPadding: EdgeInsets.only(top: 15)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.key_rounded),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        contentPadding: EdgeInsets.only(top: 15)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () {
                    // masuk login
                    // print("hallo guys ini sudah bisa");
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
                    Login(emailController.text, passwordController.text);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(17)),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
