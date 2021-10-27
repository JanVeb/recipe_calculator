import 'package:flutter/material.dart';

class Util {
  // Singleton: the below will create a singleton that can be accessed with Data()
  Util._privateConstructor();
  static final Util _instance = Util._privateConstructor();
  factory Util() {
    return _instance;
  }

  // Non-UI

  void log(String text) {
    print("[abc] " +
        text); // Use LogCat and filter on abc to see just OUR log entries
  }

  String doubleToString(double d) {
    // Removes decimal if ends with ".0"
    String text = d.toString();
    if (text.endsWith(".0"))
      text = text.substring(0, text.length - 2); // drop last two char
    return text;
  }

  // UI

  void showSnackBarMsg(String text, BuildContext context) {
    // Show temp system message at bottom of screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<dynamic> showDialogConfirmDismiss(
      BuildContext context, String title, String text) async {
    // Only used for row dismiss, as actions will call pop(true) or pop(false)
    return showDialog(
      context: context,
      barrierDismissible:
          false, // user cannot dismiss by tapping outside window
      builder: (BuildContext context) {
        return AlertDialog(
          title: title == ""
              ? null
              : Text(
                  title), // null will hide title area, so we just have the non-bolded message (content)
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(
                  false), // flutter's way to communicate back to flutter's row dismissed confirmation
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
