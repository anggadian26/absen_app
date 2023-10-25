import 'package:absen_app/config/app_color.dart';
import 'package:absen_app/page/tab/IjinTab.dart';
import 'package:absen_app/page/tab/PresensiTab.dart';
import 'package:absen_app/page/tab/SakitTab.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("R I W A Y A T", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              child: TabBar(
                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Presensi" ),
                  Tab(text: "Ijin"),
                  Tab(text: "Sakit"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Contents for Tab 1
                  PresensiTab(),
                  // Contents for Tab 2
                  IjinTab(),
                  // Contents for Tab 3
                  SakitTab()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

