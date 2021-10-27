import 'package:recipe_calculator/models/Ingredient.dart';
import 'package:recipe_calculator/models/Recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'Recipes.dart';

class Data {
  // Singleton: the below will create a singleton that can be accessed with Data()
  Data._privateConstructor();
  static final Data _instance = Data._privateConstructor();
  factory Data() {
    return _instance;
  }

  Recipes r = new Recipes([]); // init as object (non-null)
  int activeRecipeIndex =
      -1; // -1 : no active recipe ; not implemented, but can be used to reopen last active recipe when app starts

  int counter = 0;

  Future<void> startup() async {
    // called once from app startup

    // Read data from prefs and restore
    final prefs = await SharedPreferences
        .getInstance(); // documentation shows using await
    String rJson = prefs.getString("recipes") ?? "";
    //Util().log(rJson == null ? "null" : rJson);
    if (rJson.length != 0) {
      //Recipes loadRecipes = jsonDecode(rJson);
      Recipes loadRecipes = Recipes.fromJson(jsonDecode(rJson));
      // for (Recipe recipe in r.recipes) {
      // for (Recipes loadRecipes in loadRecipes.r.recipes) {
      //   Recipes recipes = new Recipes(loadRecipes.listOfRecipes);
      // }
      for (Recipe loadR in loadRecipes.recipes) {
        Recipe recipe = new Recipe(loadR.name, loadR.recipeAmount,
            loadR.desiredAmount, loadR.setMultiplier, loadR.recipeDirections);
        for (Ingredient loadI in loadR.ingredients) {
          recipe.ingredients.add(new Ingredient(loadI.name, loadI.amount,
              loadI.amountCalculated, loadI.unit, loadI.isEditable));
        }
        r.recipes.add(recipe);
      }
    }
    activeRecipeIndex =
        prefs.getInt("defaultRecipeIndex") ?? -1; // if doesn't exist, return -1
  }

  void appToBackground() async {
    // Save data
    final prefs = await SharedPreferences
        .getInstance(); // documentation shows using await
    String rJson = jsonEncode(r);
    prefs.setString("recipes", rJson);
    prefs.setInt("activeRecipeIndex", activeRecipeIndex);
  }

  /*
  void createSampleData () {

    Recipe recipe;
    recipe = new Recipe("Soy Milk");
    recipe.ingredients.add(new Ingredient('Soy beans', 1, 'g'));
    r.recipes.add(recipe);

    recipe = new Recipe("Bagel");
    recipe.ingredients.add(new Ingredient('Flour', 1, 'g'));
    r.recipes.add(recipe);
  }
  */

  //Container(margin: EdgeInsets.all(10),child: Text("1")),
  //Container(height: 20,width: 1,color: Colors.blue,),
  //Container(margin:EdgeInsets.all(10),child: Text("asdasd"))

}
