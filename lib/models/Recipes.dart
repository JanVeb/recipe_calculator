import 'Recipe.dart';

Recipe recipe = Recipe("", 0, 0, 0, '');

class Recipes {
  List<Recipe> recipes = [];
  List<Recipe> filteredRecipes = []; // init as empty array
  late List<String> listOfRecipes =
      []; // list of recipes for Search Box, not in use curently, cleanup

  // Constructor (default constructor explicitly required since we have named constructor fromJson below)
  Recipes(this.filteredRecipes);

  // JSON

  //Recipes.fromJson(Map<String, dynamic> json) :   // JSON -> Object ; called from dart's jsonEncode
  //recipes = json['recipes'];

  Recipes.fromJson(Map<String, dynamic> json) : listOfRecipes = ['1'] {
    // listOfRecipes = json['listOfRecipes']; // need to preload it to work on iOS, not sure ho to do that
    List recipesJson = json['recipes'];
    // List filteredRecipesJson = json['filteredRecipes']; ///TODO check issue with this line
    for (dynamic recipeJson in recipesJson)
      recipes.add(Recipe.fromJson(recipeJson));
  }

  Map<String, dynamic>
      toJson() => // Object -> JSON ; called from dart's jsonDecode
          {'recipes': recipes, 'filteredRecipes': filteredRecipes};

  @override
  toString() => 'Recipe: ${recipe.name}';
}
