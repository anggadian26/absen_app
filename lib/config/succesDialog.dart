import 'package:flutter/material.dart';

class SuccessAlertDialog extends StatefulWidget {
  @override
  _SuccessAlertDialogState createState() => _SuccessAlertDialogState();
}

class _SuccessAlertDialogState extends State<SuccessAlertDialog> {
  @override
  void initState() {
    super.initState();
    // Delay 3 detik dan kemudian kembali ke halaman sebelumnya
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80.0,
            ),
            SizedBox(height: 16),
            Text(
              "Success",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
