import 'package:flutter/material.dart';
import '../models/Recipe.dart';

class CustomEditableText extends StatefulWidget {
  CustomEditableText({
    Key? key,
    required this.recipe,
    // required this.ingredient,
  }) : super(key: key); // send recipe when loading page

  // Properties (Widget) ; use final
  final Recipe recipe;
  // final Ingredient ingredient;

  // late double amountCET;
  // late double amountOnChangedCET;
  //
  // CustomEditableText({
  //   required this.amountCET,
  //   required this.amountOnChangedCET,
  // });

  @override
  _CustomEditableTextState createState() => _CustomEditableTextState();
}

class _CustomEditableTextState extends State<CustomEditableText> {
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

  // Recipe recipe = new Recipe("", 0.0, 0.0, 0.0, "test");

  void recipeDirectionOnChanged(String text) {
    widget.recipe.recipeDirections = text;
  }

  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: TextFormField(
          initialValue: widget.recipe.recipeDirections,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          textInputAction: TextInputAction.newline,
          // FocusNode: focusNode,
          autofocus: true,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: "Recipe Directions",
            hintStyle: TextStyle(color: Colors.black),
          ),
          onChanged: (text) {
            recipeDirectionOnChanged(text);
          },
          enabled: isEditable,
        ),
      ),
      Positioned(
        right: 0.0,
        bottom: 0.0,
        child: IconButton(
          icon: Icon(Icons.edit),
          color: isEditable ? Colors.blue : Colors.black,
          onPressed: () {
            setState(() => {
                  if (isEditable == false)
                    {
                      isEditable = true,
                    }
                  else if (isEditable == true)
                    {
                      isEditable = false,
                    }
                });
          },
        ),
      )
    ]);
  }
}

// @override
// Widget build(BuildContext context) {
//   return Center(
//     child: _editTitleTextField(),
//   );
// }
//
// // Ingredient ingredient = new Ingredient('', 0.0, 0.0, '');
// // Util util = Util();
//
// Widget _editTitleTextField() {
//   // if (_isEditingText)
//   return Stack(
//     children: <Widget>[
//       Column(
//         children: [
//           Container(
//             width: 100,
//             child: TextFormField(
//               initialValue: widget.recipe.recipeDirections,
//               keyboardType: TextInputType.multiline,
//               maxLines: null,
//               decoration: InputDecoration(
//                 hintText: "Direction",
//                 hintStyle: TextStyle(color: Colors.black),
//               ),
//               onChanged: (text) {
//                 recipeDirectionOnChanged(text);
//               },
//               enabled: _isEnable,
//             ),
//           ),
//           Positioned(
//             left: 0.0,
//             right: 1000.0,
//             bottom: 100000.0,
//             top: 10.0,
//             child: IconButton(
//                 icon: Icon(Icons.edit),
//                 onPressed: () {
//                   setState(() {
//                     _isEnable = true;
//                   });
//                 }),
//           ),
//         ],
//       ),
//     ],
//   );

//       TextField(
//       // initialValue: recipe.recipeDirections,
//       keyboardType: TextInputType.multiline,
//       maxLines: null,
//       decoration: InputDecoration(
//           border: UnderlineInputBorder(), hintText: 'Recipe Directions'),
//       onChanged: (text) {
//         recipeDirectionOnChanged(text);
//       },
//     );
//   return InkWell(
//     onTap: () {
//       setState(() {
//         _isEditingText = true;
//       });
//     },
//     child: Text(
//       '${widget.recipe.recipeDirections}',
//       style: TextStyle(
//         color: Colors.black,
//         fontSize: 18.0,
//       ),
//     ),
//   );
