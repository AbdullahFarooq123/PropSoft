import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flashchat/Constants.dart';
import 'package:flutter/material.dart';

class AwesomeDialogueBox {
  static void showDialogueWithoutCancel(
      {required String title,
      required DialogType dialogType,
      required BuildContext context,
      required Color btnColor,
      required String btnText,
      required IconData btnIcon,
      required int duration}) {
    AwesomeDialog(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.10,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15),
          ),
        ),
      ),
      dialogBackgroundColor: appBarColor,
      context: context,
      dialogType: dialogType,
      btnOkOnPress: () {},
      btnOkIcon: btnIcon,
      btnOkColor: btnColor,
      autoHide: Duration(seconds: duration),
    ).show();
  }

  static Future<bool> showDialogueWithCancel(
      {required String title,
      required DialogType dialogType,
      required String okText,
      required String cancelText,
      required BuildContext context}) async {
    bool value = false;
    await AwesomeDialog(
            body: SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15),
                ),
              ),
            ),
            dialogBackgroundColor: appBarColor,
            context: context,
            dialogType: dialogType,
            animType: AnimType.BOTTOMSLIDE,
            btnCancelOnPress: () {
              value = false;
            },
            btnOkOnPress: () {
              value = true;
            },
            btnOkColor: Colors.green,
            btnCancelColor: Colors.red,
            btnOkIcon: Icons.check_circle,
            btnCancelIcon: Icons.cancel,
            btnOkText: okText,
            btnCancelText: cancelText)
        .show();
    return value;
  }
}
