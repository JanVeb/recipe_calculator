import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipe_calculator/models/Data.dart';
import 'package:recipe_calculator/models/Ingredient.dart';
import 'package:recipe_calculator/models/Recipe.dart';

import 'package:recipe_calculator/models/Util.dart';
import 'package:recipe_calculator/widgets/Calculator.dart';
import 'package:recipe_calculator/widgets/CustomEditableText.dart';
import 'package:recipe_calculator/widgets/DismissBgTrash.dart';
import 'package:recipe_calculator/widgets/ListSectionHeader.dart';

import '../models/Ingredient.dart';

class RecipePage extends StatefulWidget {
  // static int testIndex = 0;

  RecipePage({Key? key, required this.recipe, required this.ingredient})
      : super(key: key); // send recipe when loading page

  // Properties (Widget) ; use final
  final Recipe recipe;
  final Ingredient ingredient;

  @override
  RecipePageState createState() {
    return RecipePageState();
  }
}

class RecipePageState extends State<RecipePage> with WidgetsBindingObserver {
  // Properties (State)

  Data data = Data();
  Util util = Util();

  ///ToDo testing
  // Multiplier multiplier = Multiplier([], 'test');

  // Init + app state observer
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    // _editingController = TextEditingController(
    //     text: initialText); // code for Text/TextFormField switch
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    // _editingController.dispose(); // code for Text/TextFormField switch
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) data.appToBackground();
  }

  // Event Handlers / Functions
  void recipeNameOnChanged(String text) {
    // Save recipe name as user changes text box
    widget.recipe.name = text;
  }

  void addOnTap() {
    widget.recipe.ingredients.add(new Ingredient("", 0, 0, "", false));

    //${multiplier.ingredientHint[multiplier.menuIndex]}
    // multiplier.ingredientHintGenerator();
    redrawUI();
  }

  void ingredientOnDismissed(Ingredient ingredient) {
    widget.recipe.ingredients.remove(ingredient);
    redrawUI();
  }

  void nameOnChanged(String text, Ingredient ingredient) {
    ingredient.name = text;
  }

  void recipeDirectionOnChanged(String text, Recipe recipe) {
    recipe.recipeDirections = text;
  }

  void amountOnChanged(String text, Ingredient ingredient) {
    double d = double.tryParse(text) ?? 0;
    ingredient.amount = d;
  }

  // Recipe recipe = new Recipe('', 0.0, 0.0, 0.0, 'Edit');
  // Ingredient ingredient = new Ingredient('', 0.0, 0.0, '');

  void recipeAmountOnChanged(String text) {
    // save recipe amount that user enters/changes input
    double d = double.tryParse(text) ?? 0;
    widget.recipe.recipeAmount = d;
    // amountOnChanged(text, widget.ingredient); ///TODO not sure if i need this???
  }

  void desiredAmountOnChanged(String text) {
    // save desired amount that user enters/changes input
    double d = double.tryParse(text) ?? 0;
    widget.recipe.desiredAmount = d;
    // amountOnChanged(text, widget.ingredient); ///TODO not sure if i need this???
  }

  void unitOnChanged(String text, Ingredient ingredient) {
    ingredient.unit = text;
  }

  void redrawUI() {
    setState(() {}); // redraw
  }

  void multiplier() {
    widget.recipe.setMultiplier =
        widget.recipe.desiredAmount / widget.recipe.recipeAmount;
  }

  void calculate() {
    for (Ingredient ingredient in widget.recipe.ingredients) {
      ingredient.amountCalculated =
          ingredient.amount * widget.recipe.setMultiplier;
    }
    redrawUI();
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = widget.recipe.ingredients.removeAt(oldindex);
      widget.recipe.ingredients.insert(newindex, items);
    });
  }

  // late  final jsonString = data.rJson;
  // Build UI

  // void _titleBarMenuOnSelect(String text) {
  //   if (text == "Settings") util.showSnackBarMsg("Settings pressed", context);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
            child: Align(alignment: Alignment.topRight, child: CalcButton())),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListSectionHeader("Recipe Name"),
            ListTile(
              title: TextFormField(
                  initialValue: widget.recipe.name,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), hintText: 'Recipe Name'),
                  onChanged: (text) {
                    recipeNameOnChanged(text);
                  }),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(
                    flex: 12,
                    child: Container(
                      margin: EdgeInsets.all(2),
                      // height: 60,
                      color: Colors.grey[200],
                      child: Center(
                        child: ListSectionHeader(
                          "Ingredients",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: Container(
                      margin: EdgeInsets.all(2),
                      // height: 60,
                      color: Colors.grey[200],
                      child: Center(
                        child: ListSectionHeader(
                          "Recipe Amount",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 14,
                    child: Container(
                      margin: EdgeInsets.all(2),
                      // height: 60,
                      color: Colors.grey[200],
                      child: Center(
                        child: ListSectionHeader(
                          "Recalculated / Desired Amount",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.all(2),
                      // height: 60,
                      color: Colors.grey[200],
                      // padding: EdgeInsets.all(5),
                      child: Center(
                        child: ListSectionHeader(
                          "Unit",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ReorderableListView.builder(
                physics: ClampingScrollPhysics(),
                buildDefaultDragHandles: false,
                onReorder: reorderData,
                shrinkWrap: true,
                itemCount: widget.recipe.ingredients
                    .length, // add header, recipe name, header, footer (add ingredient), ...
                itemBuilder: (context, testIndex) {
                  // Ingredient row
                  final Ingredient ingredient =
                      widget.recipe.ingredients[testIndex];

                  return Dismissible(
                    key:
                        UniqueKey(), // Each Dismissible must contain a Key. Keys allow Flutter to uniquely identify widgets
                    direction:
                        DismissDirection.endToStart, // swipe left to dismiss
                    background: DismissBgTrash(),
                    onDismissed: (direction) {
                      ingredientOnDismissed(ingredient);
                    }, // called by framework after user swipes away
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 12,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: TextFormField(
                                initialValue: ingredient.name,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'ingredient'),
                                onChanged: (text) {
                                  nameOnChanged(text, ingredient);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 12,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              // child: CustomEditableText(),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [DecimalTextInputFormatter()],
                                initialValue: util
                                    .doubleToString(ingredient.amount)
                                    .replaceFirst(new RegExp(r'^0'),
                                        ''), // .replaceFirst(new RegExp(r'^0'), ''), : remove initial 0
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Amount'),
                                onChanged: (text) {
                                  amountOnChanged(text, ingredient);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 14,
                            child: Stack(children: [
                              Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    DecimalTextInputFormatter()
                                  ],
                                  //.replaceFirst(new RegExp(r'^0'), ''), // .replaceFirst(new RegExp(r'^0'), ''), // remove initial 0
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: (() {
                                      if (ingredient
                                              .amountCalculated.isInfinite ||
                                          ingredient.amountCalculated.isNaN) {
                                        return '0';
                                      } else if (ingredient.amountCalculated ==
                                          ingredient.amountCalculated
                                              .roundToDouble()) {
                                        return ingredient.amountCalculated
                                            .toString();
                                      } else {
                                        return ingredient.amountCalculated
                                            .toStringAsFixed(2);
                                      }
                                    })(),
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  onChanged: (text) {
                                    desiredAmountOnChanged(text);
                                    widget.recipe.recipeAmount =
                                        ingredient.amount;
                                  },
                                  enabled: ingredient.isEditable,
                                ),
                              ),
                              Positioned(
                                right: 0.0,
                                bottom: 0.0,
                                child: IconButton(
                                  icon: ingredient.isEditable
                                      ? Icon(Icons.calculate)
                                      : Icon(Icons.edit),
                                  color: ingredient.isEditable
                                      ? Colors.blue
                                      : Colors.black,
                                  onPressed: () {
                                    multiplier();
                                    calculate();
                                    setState(() {
                                      if (ingredient.isEditable == false) {
                                        ingredient.isEditable = true;
                                      } else if (ingredient.isEditable ==
                                          true) {
                                        ingredient.isEditable = false;
                                      }
                                    });
                                  },
                                ),
                                // )
                                // ],
                              ),
                            ]),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: TextFormField(
                                initialValue: ingredient.unit,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Unit'),
                                onChanged: (text) {
                                  unitOnChanged(text, ingredient);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ReorderableDragStartListener(
                              index: testIndex,
                              // child: const Icon(Icons.drag_handle,
                              //     color: Colors.grey),
                              child: const Icon(Icons.drag_handle,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ListTile(
              key: UniqueKey(),
              title: Center(child: Text("Add Ingredient")),
              onTap: () {
                addOnTap();
              },
            ),
            ListTile(
              key: UniqueKey(),
              title: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: EdgeInsets.all(2),
                      // height: 60,
                      color: Colors.grey[200],
                      child: Center(
                        child: ListSectionHeader(
                          "Recipe Directions",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              key: UniqueKey(),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: CustomEditableText(
                      recipe: widget.recipe,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r"^\d*\.?\-?\+?\d*");
    String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}
