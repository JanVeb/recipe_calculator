import 'package:flutter/material.dart';

class ListSectionHeader extends StatelessWidget {
  // header row with single line of text for use has a table section header
  // background color and text color is hardcoded

  // Constructor
  ListSectionHeader(this.text);

  // Properties (must be final here)
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30,
        color: Colors.grey[200],
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: TextStyle(fontSize: 12),
                ))));
  }
}
