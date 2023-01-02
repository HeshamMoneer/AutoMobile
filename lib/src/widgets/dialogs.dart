import 'package:flutter/material.dart';

import '../themes/theme.dart';
import '../themes/theme_color.dart';

void showErrorDialog(BuildContext context,
    {String title = "Error",
    String body = "An error occured. Please, try again later"}) {
  showDialog<Null>(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(body),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.lightblack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay', style: AppTheme.titleStyle2),
              ),
            ],
          ));
}

void showConfirmationDialog(
    {required BuildContext context,
    required VoidCallback onConfirm,
    String title = "Confirm deletion",
    String body = "Do you really want to delete this?"}) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(body),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Cancel', style: AppTheme.titleStyle),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.lightblack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: onConfirm,
                child: Text('Confirm', style: AppTheme.titleStyle2),
              ),
            ],
          ));
}

void showLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: 150,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: new CircularProgressIndicator(
                        color: Colors.black,
                      )),
                  Text('Loading', style: AppTheme.titleStyle),
                ],
              ),
            ));
      });
}
