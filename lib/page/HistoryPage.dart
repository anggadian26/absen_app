import 'package:absen_app/config/app_color.dart';
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
          title: Text("R I W A Y A T"),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Container(
              child: TabBar(
                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Absen" ),
                  Tab(text: "Ijin"),
                  Tab(text: "Sakit"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Contents for Tab 1
                  Center(child: Text("Content for Tab 1")),
                  // Contents for Tab 2
                  Center(child: Text("Content for Tab 2")),
                  // Contents for Tab 3
                  Center(child: Text("Content for Tab 3")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

