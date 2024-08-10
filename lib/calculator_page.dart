import 'package:calculator/button_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final String title = "Calculator App!";
  String num1 = ""; // 0-9
  String operand = ""; // + - * /
  String num2 = "";
  String result_text = "";

  get text => null;

  get painter => null;

  get child => null;

  get body => null; // 0-9

  @override
  Widget build(BuildContext context) {
    final screen_size = MediaQuery.of(context).size;
    return Scaffold(
      //appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white, title: Center(child: Text(title))),
      backgroundColor: Color.fromRGBO(28, 28, 28, 1),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // output
            Expanded(
              // scroll for multiple values
              child: SingleChildScrollView(
                reverse: true,
                child: SizedBox(
                  child: Container(
                    /* 
                  
                    height: 300,
                    width: 400,
                    decoration: BoxDecoration(
                        border: Border.all(
                            //color: Colors.red,
                            ),
                        color: const Color.fromARGB(255, 55, 65, 56),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                       */
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "$num1$operand$num2".isEmpty ? "0" : "$num1$operand$num2",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
            ),
            // input/ buttons
            const Divider(
              thickness: 2,
              color: Color.fromARGB(255, 72, 75, 72),
            ),
            SizedBox(
              child: Wrap(
                children: Btn.buttonValues
                    .map((value) => SizedBox(
                          width: value == Btn.n0 ? screen_size.width / 2.15 : (screen_size.width / 4.25),
                          height: screen_size.height / 9,
                          child: buildBtn(value),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBtn(value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          color: btnColor(value),
          clipBehavior: Clip.hardEdge,
          shape: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(300),
          ),
          child: InkWell(
              onTap: () => BtnTap(value),
              child: Center(
                  child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
              )))),
    );
  }

  void BtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    AppendValue(value);
  }

  // calculate
  void calculate() {
    if (num1.isEmpty) return;
    if (operand.isEmpty) return;
    if (num2.isEmpty) return;

    final num1double = double.parse(num1);
    final num2double = double.parse(num2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1double + num2double;
        break;
      case Btn.subtract:
        result = num1double - num2double;
        break;
      case Btn.multiply:
        result = num1double * num2double;
        break;
      case Btn.divide:
        result = num1double / num2double;
        break;
    }

    setState(() {
      num1 = "$result";
      result_text = "$result";

      if (num1.endsWith(".0")) {
        num1 = num1.substring(0, num1.length - 2);
      }

      operand = "";
      num2 = "";
    });
  }

  // convert to %
  void convertToPercentage() {
    // 2+2
    if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {
      // calculate before conversion
      calculate();
    }

    if (operand.isNotEmpty) {
      // cant convert
      return;
    }

    final number = double.parse(num1);
    setState(() {
      num1 = "${(number / 100)}";
      operand = "";
      num2 = "";
    });
  }

// clear all value
  void clearAll() {
    setState(() {
      num1 = "";
      operand = "";
      num2 = "";
    });
  }

// delete one by one
  void delete() {
    if (num2.isNotEmpty) {
      // 1234 => 123
      num2 = num2.substring(0, num2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }

    setState(() {});
  }

  // Appends
  void AppendValue(String value) {
    // num1 operand num2
    // 2       +     2

    // if its operand and not "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      // check operand
      if (operand.isNotEmpty && num2.isNotEmpty) {
        // calculate
        calculate();
      }
      operand = value;
      // check num1
    }
    // assign value to num1
    else if (num1.isEmpty || operand.isEmpty) {
      // check value is"." ||num1="2.5"
      if (value == Btn.dot && num1.contains(Btn.dot)) return;
      if (value == Btn.dot && (num1.isEmpty || num1 == Btn.n0)) {
        // num1="" || "0"
        value = "0.";
      }
      num1 += value;
    }
    // assign value to num2
    else if (num2.isEmpty || operand.isNotEmpty) {
      // check value is"." ||num2="2.5"
      if (value == Btn.dot && num2.contains(Btn.dot)) return;
      if (value == Btn.dot && (num2.isEmpty || num2 == Btn.n0)) {
        // num1="" || "0"
        value = "0.";
      }
      num2 += value;
    }

    setState(() {});
  }
}

//

//
Color btnColor(value) {
  return [
    Btn.del,
    Btn.clr,
  ].contains(value)
      ? Color.fromRGBO(223, 18, 26, 1)
      : [
          Btn.per,
          Btn.multiply,
          Btn.add,
          Btn.subtract,
          Btn.divide,
          Btn.calculate,
        ].contains(value)
          ? Color.fromRGBO(255, 149, 0, 1)
          : const Color.fromRGBO(80, 80, 80, 1);
}
