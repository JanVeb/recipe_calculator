import 'package:recipe_calculator/models/Ingredient.dart';

class Recipe {
  String name;
  late double recipeAmount;
  late double desiredAmount;
  late double setMultiplier;
  String recipeDirections;
  List<Ingredient> ingredients = []; // init as empty array

  // Constructor
  Recipe(this.name, this.recipeAmount, this.desiredAmount, this.setMultiplier,
      this.recipeDirections);

/*  void addIngredient(Ingredient ingredient) {
    ingredients.add(ingredient);
  }

  void removeIngredient(Ingredient ingredient) {
    ingredients.remove(ingredient);
  }*/

  // JSON

  Recipe.fromJson(Map<String, dynamic> json)
      : name = "",
        recipeAmount = 0.0,
        desiredAmount = 0.0,
        setMultiplier = 0.0,
        recipeDirections = "" {
    // name initializer required since we don't allow nulls
    // JSON -> Object ; called from dart's jsonEncode
    name = json['name'];
    recipeAmount = json['recipeAmount'];
    desiredAmount = json['desiredAmount'];
    setMultiplier = json['setMultiplier'];
    recipeDirections = json['recipeDirections'];

    List ingredientsJson = json['ingredients'];
    for (dynamic ingredientJson in ingredientsJson)
      ingredients.add(Ingredient.fromJson(ingredientJson));
  }

  Map<String, dynamic>
      toJson() => // Object -> JSON ; called from dart's jsonDecode
          {
            'name': name,
            'ingredients': ingredients,
            'recipeAmount': recipeAmount,
            'desiredAmount': desiredAmount,
            'setMultiplier': setMultiplier,
            'recipeDirections': recipeDirections
          };
}

// static Resource<List<CategoryDishes>> get all {
//   return Resource(
//       url: Constants.FOOD_API_URL,
//       parse: (response) {
//         final result = json.decode(response.body.toString());
//         print(response);
//         Iterable list = result['category_dishes'];
//         return list.map((model) => CategoryDishes.fromJson(model)).toList();
//       });
// }
// }
//
// static Resource<List<CategoryDishes>> get all {
//   return Resource(
//       url: Constants.FOOD_API_URL,
//       parse: (response) {
//         final result = json.decode(response.body.toString());
//         print(response);
//         //added 0 indexex, so it gets 1st element of JSON Arrays
//         Iterable list = result[0]['table_menu_list'][0]['category_dishes'];
//         return list.map((model) => CategoryDishes.fromJson(model)).toList();
//       });
// }
//
// }
