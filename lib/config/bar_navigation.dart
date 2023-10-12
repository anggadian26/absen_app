import 'package:absen_app/config/app_color.dart';
import 'package:absen_app/page/AddPresensi.dart';
import 'package:absen_app/page/HistoryPage.dart';
import 'package:absen_app/page/HomePage.dart';
import 'package:absen_app/page/NotifPage.dart';
import 'package:absen_app/page/UserPage.dart';
import 'package:flutter/material.dart';

class mainHome extends StatefulWidget {
  const mainHome({super.key});

  @override
  State<mainHome> createState() => _mainHomeState();
}

class _mainHomeState extends State<mainHome> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomePage(),
    NotifPage(),
    HistoryPage(),
    UserPage()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.ballot_outlined,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddPresensi()))
              .then((value) {
                setState(() {
                  
                });
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        // color: AppColors.primary,
        child: Container(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // home
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = HomePage();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 30,
                          Icons.home,
                          color:
                              currentTab == 0 ? AppColors.primary : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  // </home>
                  // notif
                  MaterialButton(
                    minWidth: 60,
                    onPressed: () {
                      setState(() {
                        currentScreen = NotifPage();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 25,
                          Icons.dashboard_sharp,
                          color:
                              currentTab == 1 ? AppColors.primary : Colors.grey,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // right
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // home
                  MaterialButton(
                    minWidth: 60,
                    onPressed: () {
                      setState(() {
                        currentScreen = HistoryPage();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 30,
                          Icons.history,
                          color:
                              currentTab == 3 ? AppColors.primary : Colors.grey,
                        )
                      ],
                    ),
                  ),
                  // </home>
                  // notif
                  MaterialButton(
                    // minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = UserPage();
                        currentTab = 4;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 30,
                          Icons.person,
                          color:
                              currentTab == 4 ? AppColors.primary : Colors.grey,
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
