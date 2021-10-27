import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

class CalcButton extends StatefulWidget {
  @override
  _CalcButtonState createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  double _currentValue = 0;
  @override
  Widget build(BuildContext context) {
    var calc = SimpleCalculator(
      value: _currentValue,
      hideExpression: false,
      hideSurroundingBorder: true,
      onChanged: (key, value, expression) {
        setState(() {
          _currentValue = value!;
        });
        print("$key\t$value\t$expression");
      },
      onTappedDisplay: (value, details) {
        print("$value\t${details.globalPosition}");
      },
      theme: const CalculatorThemeData(
        borderColor: Colors.black,
        borderWidth: 2,
        displayColor: Colors.black,
        displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
        expressionColor: Colors.indigo,
        expressionStyle: const TextStyle(fontSize: 14, color: Colors.white),
        operatorColor: Colors.pink,
        operatorStyle: const TextStyle(fontSize: 30, color: Colors.white),
        commandColor: Colors.orange,
        commandStyle: const TextStyle(fontSize: 30, color: Colors.white),
        numColor: Colors.grey,
        numStyle: const TextStyle(fontSize: 50, color: Colors.white),
      ),
    );
    return OutlinedButton(
      child: _currentValue == 0
          ? Icon(
              Icons.calculate_rounded,
              color: Colors.white,
            )
          // ? Text("Calculator",
          //     style: TextStyle(fontSize: 20, color: Colors.white))
          : Text(
              '${_currentValue.toString()}',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: calc);
            });
      },
    );
  }
}
