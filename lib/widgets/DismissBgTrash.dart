import 'package:flutter/material.dart';

class DismissBgTrash extends StatelessWidget {

  // a container with red background and trash icon along right for background when user swipes left on a row to delete

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
    );

  }
}