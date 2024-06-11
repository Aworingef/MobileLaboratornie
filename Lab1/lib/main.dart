import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  Widget calcbutton(String btntxt, Color btncolor, Color txtcolor){
    return Container(
      margin: EdgeInsets.all(7.0), // Задаем отступы между кнопками
      child: ElevatedButton(
        onPressed: (){
          calculation(btntxt);
        },
        child: Text(btntxt,
          style: TextStyle(
            fontSize: 35,
            color: txtcolor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(), // Указываем CircleBorder как форму кнопки
          backgroundColor: btncolor, // Цвет фона кнопки
          padding: EdgeInsets.all(0.0), // Отступы кнопки
          minimumSize: Size(85.0, 85.0), // Устанавливаем минимальный размер кнопки
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Calculator'), backgroundColor: Colors.black,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Calculator display
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(padding: EdgeInsets.all(10.0),
                  child: Text(text.length <= 6 ? text : text.substring(0, 6),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white,
                        fontSize: 100
                    ),
                  ),
                )
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // button function
                  calcbutton('AC', Colors.grey, Colors.black),
                  calcbutton('+/-', Colors.grey, Colors.black),
                  calcbutton('%', Colors.grey, Colors.black),
                  calcbutton('/', Colors.amber[700]!, Colors.black),
                ]
            ),
            SizedBox(height: 5,),
            // Column numbers
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // button function
                  calcbutton('7', Colors.grey[850]!, Colors.white),
                  calcbutton('8', Colors.grey[850]!, Colors.white),
                  calcbutton('9', Colors.grey[850]!, Colors.white),
                  calcbutton('x', Colors.amber[700]!, Colors.white),
                ]
            ),
            SizedBox(height: 5,),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // button function
                  calcbutton('4', Colors.grey[850]!, Colors.white),
                  calcbutton('5', Colors.grey[850]!, Colors.white),
                  calcbutton('6', Colors.grey[850]!, Colors.white),
                  calcbutton('-', Colors.amber[700]!, Colors.white),
                ]
            ),
            SizedBox(height: 5,),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // button function
                  calcbutton('1', Colors.grey[850]!, Colors.white),
                  calcbutton('2', Colors.grey[850]!, Colors.white),
                  calcbutton('3', Colors.grey[850]!, Colors.white),
                  calcbutton('+', Colors.amber[700]!, Colors.white),
                ]
            ),
            SizedBox(height: 5,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcbutton('^', Colors.grey[850]!, Colors.white),
                  calcbutton('0', Colors.grey[850]!, Colors.white),
                  calcbutton('.', Colors.grey[850]!, Colors.white),
                  calcbutton('=', Colors.amber[700]!, Colors.white),
                ]
            ),
          ],
        ),
      ),
    );
  }


  //Calculator logic
  dynamic text ='0';
  double numOne = 0;
  double numTwo = 0;

  dynamic result = '';
  dynamic finalResult = '';
  dynamic opr = '';
  dynamic preOpr = '';

  void calculation(btnText) {


    if(btnText  == 'AC') {
      text ='0';
      numOne = 0;
      numTwo = 0;
      result = '';
      finalResult = '0';
      opr = '';
      preOpr = '';

    } else if( opr == '=' && btnText == '=') {

      if(preOpr == '+') {
        finalResult = add();
      } else if( preOpr == '-') {
        finalResult = sub();
      } else if( preOpr == 'x') {
        finalResult = mul();
      } else if( preOpr == '/') {
        if(numTwo == double.parse('0')) {
          finalResult = 'DevZero';
        }
        else{
          finalResult = div();
        }
      } else if( preOpr == '^') {
        finalResult = deg();
      }

    } else if((btnText == '+' || btnText == '-' || btnText == 'x' || btnText == '/' || btnText == '=' || btnText == '^') && result != '') {

      if(numOne == 0) {
        numOne = double.parse(result);
      } else {
        numTwo = double.parse(result);
      }

      if(opr == '+') {
        finalResult = add();
      } else if( opr == '-') {
        finalResult = sub();
      } else if( opr == 'x') {
        finalResult = mul();
      } else if( opr == '/') {
        if(numTwo == double.parse('0')) {
          finalResult = 'DevZero';
        }
        else{
          finalResult = div();
        }
      } else if( opr == '^') {
        finalResult = deg();
      }
      preOpr = opr;
      opr = btnText;
      result = '0';
    }
    else if(btnText == '%') {
      numOne = double.parse(result);
      result = numOne / double.parse('100');
      finalResult = doesContainDecimal(result);
    } else if(btnText == '.') {
      if(!result.toString().contains('.')) {
        result = result.toString()+'.';
      }
      finalResult = result;
    }

    else if(btnText == '+/-' && result != '0') {
      result.toString().startsWith('-') ? result = result.toString().substring(1): result = '-'+result.toString();
      finalResult = result;
    }

    else if(!(btnText == '+' || btnText == '-' || btnText == 'x' || btnText == '/' || btnText == '=' || btnText == '^')){
      result = result.toString() + btnText.toString();
      finalResult = result;
    }


    setState(() {
      text = finalResult;
    });
  }




  String add() {
    result = (numOne + numTwo).toString();
    numOne = double.parse(result);
    result = '';
    return doesContainDecimal(numOne.toString());
  }

  String sub() {
    result = (numOne - numTwo).toString();
    numOne = double.parse(result);
    result = '';
    return doesContainDecimal(numOne.toString());
  }
  String mul() {
    result = (numOne * numTwo).toString();
    numOne = double.parse(result);
    result = '';
    return doesContainDecimal(numOne.toString());
  }
  String div() {
    result = (numOne / numTwo).toString();
    numOne = double.parse(result);
    result = '';
    return doesContainDecimal(numOne.toString());
  }
  String deg() {
    result = (pow(numOne, numTwo)).toString();
    numOne = double.parse(result);
    result = '';
    return doesContainDecimal(numOne.toString());
  }


  String doesContainDecimal(dynamic result) {

    if(result.toString().contains('.')) {
      List<String> splitDecimal = result.toString().split('.');
      if(!(int.parse(splitDecimal[1]) > 0))
        return result = splitDecimal[0].toString();
    }
    return result.toString();
  }
}