import 'package:flutter/material.dart';
import 'package:recipe_calculator/models/Ingredient.dart';

import '../models/Recipe.dart';

class RecalculatedDesiretAmount extends StatefulWidget {
  RecalculatedDesiretAmount({
    Key? key,
    required this.recipe,
    required this.ingredient,

    // required this.ingredient,
  }) : super(key: key); // send recipe when loading page

  // Properties (Widget) ; use final
  final Recipe recipe;
  final Ingredient ingredient;
  static bool isEditable = false;
  // late double amountCET;
  // late double amountOnChangedCET;
  //
  // CustomEditableText({
  //   required this.amountCET,
  //   required this.amountOnChangedCET,
  // });

  @override
  _RecalculatedDesiretAmountState createState() =>
      _RecalculatedDesiretAmountState();
}

class _RecalculatedDesiretAmountState extends State<RecalculatedDesiretAmount> {
  late TextEditingController _editingController;
  // String initialText = "";

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  Recipe recipe = new Recipe("", 0.0, 0.0, 0.0, "test");

  void recipeDirectionOnChanged(String text) {
    widget.recipe.recipeDirections = text;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0.0,
      bottom: 0.0,
      child: IconButton(
        icon: RecalculatedDesiretAmount.isEditable
            ? Icon(Icons.drag_handle)
            : Icon(Icons.edit),
        color:
            RecalculatedDesiretAmount.isEditable ? Colors.blue : Colors.black,
        onPressed: () {
          setState(() {
            if (RecalculatedDesiretAmount.isEditable == false) {
              RecalculatedDesiretAmount.isEditable = true;
            } else if (RecalculatedDesiretAmount.isEditable == true) {
              RecalculatedDesiretAmount.isEditable = false;
            }
          });
        },
      ),
      // )
      // ],
    );
  }
}
