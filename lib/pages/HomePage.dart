import 'package:flutter/material.dart';
import 'package:recipe_calculator/models/Data.dart';
import 'package:recipe_calculator/models/Ingredient.dart';
import 'package:recipe_calculator/models/Recipe.dart';
import 'package:recipe_calculator/models/Util.dart';
import 'package:recipe_calculator/widgets/DismissBgTrash.dart';

import 'RecipePage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  // Properties (Widget) ; use final
  final String title = "Recipes";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // Properties (State)

  Data data = Data();
  Util util = Util();

  // Init + app state observer
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  } // ! used in null safety to force this as non-null

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) data.appToBackground();
  }

  // Event Handlers / Functions

  void _titleBarMenuOnSelect(String text) {
    if (text == "Settings") util.showSnackBarMsg("Settings pressed", context);
  }

  void _addOnTap() async {
    Recipe recipe = new Recipe("", 0, 0, 0, '');
    Ingredient ingredient = new Ingredient("", 0, 0, "", false);
    data.r.filteredRecipes.add(
        recipe); // save to our array now (even though blank) so it will saved to storage when user leaves app
    data.r.recipes.add(
        recipe); // save to our array now (even though blank) so it will saved to storage when user leaves app
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RecipePage(recipe: recipe, ingredient: ingredient)));
    // wait until we return to this page ; if new recipe was not edited, remove from our array
    if (recipe.name.length == 0 &&
        recipe.ingredients.length == 0 &&
        recipe.recipeDirections == '') data.r.recipes.remove(recipe);
    redrawUI();
  }

  void _recipeOnTap(Recipe recipe, Ingredient ingredient) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipePage(
                recipe: recipe,
                ingredient:
                    ingredient))); // wait until return, then redraw UI in case user changed name
    redrawUI();
  }

  void recipeOnDismissed(Recipe recipe) {
    data.r.recipes.remove(recipe);
    data.r.filteredRecipes.remove(recipe);
    redrawUI();
  }

  void redrawUI() {
    setState(() {}); // redraw
  }

  // List<Recipe> filteredRecipes = [];

  int runLFRNoTimes =
      0; //used to show recipes before filteredRecipes list is populated
  // String filterText = '';
  final TextEditingController _textController = new TextEditingController();
  void loadFilteredRecipes(String filterText) {
    runLFRNoTimes++;
    // fils filteredRecipes list, which will then be used as source in ListView
    data.r.filteredRecipes.clear();
    if (filterText.length == 0) {
      data.r.filteredRecipes.addAll(data.r.recipes);
      redrawUI();
    } else {
      for (Recipe recipe in data.r.recipes) {
        if (recipe.name.toLowerCase().contains(filterText))
          data.r.filteredRecipes.add(recipe);
        redrawUI();
      }
    }
  }

  void resetFilteredRecipesList() {
    _textController.clear();
    data.r.filteredRecipes.clear();
    data.r.filteredRecipes.addAll(data.r.recipes);
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = data.r.recipes.removeAt(oldindex);
      data.r.recipes.insert(newindex, items);
    });
  }

  // Build UI

  Ingredient ingredient = new Ingredient("", 0, 0, "", false);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          // add buttons along top-right in title bar
          PopupMenuButton<String>(
            // 3-dot button
            onSelected: _titleBarMenuOnSelect,
            itemBuilder: (BuildContext context) {
              Set<String> items = new Set();
              items.add("Settings");
              return items.map((String choice) {
                // standard flutter code that just works
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Icon(
                Icons.search,
                color: _textController.text.length > 0
                    ? Colors.lightBlueAccent
                    : Colors.grey,
              ),
              new SizedBox(
                width: 10.0,
              ),
              new Expanded(
                child: new Stack(
                    alignment: const Alignment(1.0, 1.0),
                    children: <Widget>[
                      new TextField(
                        decoration: InputDecoration(hintText: 'Search'),
                        onChanged: (filterText) {
                          print("${util.log}");
                          loadFilteredRecipes(filterText.toLowerCase());
                          redrawUI();
                        },
                        controller: _textController,
                      ),
                      _textController.text.length > 0
                          ? new IconButton(
                              icon: new Icon(Icons.clear),
                              onPressed: () {
                                resetFilteredRecipesList();
                                redrawUI();
                              })
                          : new Container(
                              height: 0.0,
                            )
                    ]),
              ),
            ],
          ),
          if (runLFRNoTimes == 0)
            Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemCount: data.r.recipes.length,
                // itemCount: data.r.filteredRecipes.length, // filter search
                itemBuilder: (context, index) {
                  final Recipe recipe = data.r.recipes[index];
                  // final Recipe recipe = data.r.filteredRecipes[index];

                  return Row(
                    key: UniqueKey(),
                    children: [
                      Expanded(
                        child: Dismissible(
                          // allows row to be swiped left/right
                          key: UniqueKey(),
                          // Each Dismissible must contain a Key. Keys allow Flutter to uniquely identify widgets
                          direction: DismissDirection.endToStart,
                          // only swipe left supported
                          background: DismissBgTrash(),
                          onDismissed: (direction) {
                            recipeOnDismissed(recipe);
                          },
                          // called by framework after user swipes away
                          confirmDismiss: (DismissDirection direction) async =>
                              await util.showDialogConfirmDismiss(context, "",
                                  "Delete recipe '${recipe.name}'?"),
                          // child: Container(
                          //   width: 400,
                          //   height: 50,
                          //   padding: const EdgeInsets.all(8),
                          //   child: ReorderableDragStartListener(
                          //     index: index,
                          child: ListTile(
                            title: Text(recipe.name.length == 0
                                ? "(no name)"
                                : '${recipe.name}'),
                            onTap: () {
                              _recipeOnTap(recipe, ingredient);
                            },
                          ),
                          // ),
                          // ),
                        ),
                      ),
                      ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_indicator,
                            color: Colors.grey),
                      ),
                    ],
                  );
                },
                onReorder: reorderData,
              ),
            )
          else
            Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                // itemCount: data.r.recipes.length,
                itemCount: data.r.filteredRecipes.length, // filter search
                itemBuilder: (context, index) {
                  // final Recipe recipe = data.r.recipes[index];
                  final Recipe recipe = data.r.filteredRecipes[index];

                  return Row(
                    key: UniqueKey(),
                    children: [
                      Expanded(
                        child: Dismissible(
                          // allows row to be swiped left/right
                          key: UniqueKey(),
                          // Each Dismissible must contain a Key. Keys allow Flutter to uniquely identify widgets
                          direction: DismissDirection.endToStart,
                          // only swipe left supported
                          background: DismissBgTrash(),
                          onDismissed: (direction) {
                            recipeOnDismissed(recipe);
                          },
                          // called by framework after user swipes away
                          confirmDismiss: (DismissDirection direction) async =>
                              await util.showDialogConfirmDismiss(context, "",
                                  "Delete recipe '${recipe.name}'?"),
                          // child: Container(
                          //   width: 64,
                          //   height: 64,
                          //   padding: const EdgeInsets.all(8),
                          //   child: ReorderableDragStartListener(
                          //     index: index,

                          child: ListTile(
                            title: Text(recipe.name.length == 0
                                ? "(no name)"
                                : '${recipe.name}'),
                            onTap: () {
                              _recipeOnTap(recipe, ingredient);
                            },
                          ),
                          //   ),
                          // ),
                        ),
                      ),
                      ReorderableDragStartListener(
                        index: index,
                        child:
                            const Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                    ],
                  );
                },
                onReorder: reorderData,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOnTap,
        child: Icon(Icons.add),
      ),
    );
  }
}
