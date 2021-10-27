class Ingredient {
  String name;
  double amount;
  late double amountCalculated;
  String unit;
  bool isEditable = false;

  // Constructor
  Ingredient(this.name, this.amount, this.amountCalculated, this.unit,
      this.isEditable); // special Dart format

  // Same as above in a more "standard" format
  /*
  Ingredient (String name, String amount, String unit) {
    this.name = name;
    this.amount = amount;
    this.unit = unit;
  } */

  // JSON

  // dart:  : defines an "initializer list".  No body needed in this case
  Ingredient.fromJson(Map<String, dynamic> json)
      : name = '',
        amount = 0,
        amountCalculated = 0,
        unit = '' {
    // JSON -> Object ; called from dart's jsonEncode
    name = json['name'];
    amount = json['amount'];
    amountCalculated = json['amountCalculated'];

    ///TODO check issue with upper line
    unit = json['unit'];
  }

  /*
  // Same as above in a more "standard" format
  Ingredient.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
    unit = json['unit'];
  } */

// dart:  => means return ... without having to use standard { }
  Map<String, dynamic>
      toJson() => // Object -> JSON ; called from dart's jsonDecode
          {
            'name': name,
            'amount': amount,
            'amountCalculated': amountCalculated,
            'unit': unit
          };

  /*
  // Same as above in a more "standard" format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit };
  }
  */

}
