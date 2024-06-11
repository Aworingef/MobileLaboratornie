import 'package:flutter/material.dart';

enum SquareUnit { sCm, sM, sKm }

class SquareConverterScreen extends StatefulWidget {
  final SquareUnit unitFrom;
  final SquareUnit unitTo;

  SquareConverterScreen({
    required this.unitFrom,
    required this.unitTo,
  });

  @override
  _SquareConverterScreenState createState() => _SquareConverterScreenState();
}

class _SquareConverterScreenState extends State<SquareConverterScreen> {
  TextEditingController _controllerFrom = TextEditingController();
  TextEditingController _controllerTo = TextEditingController();

  late SquareUnit _selectedUnitFrom;
  late SquareUnit _selectedUnitTo;

  @override
  void initState() {
    super.initState();
    _selectedUnitFrom = widget.unitFrom;
    _selectedUnitTo = widget.unitTo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Square',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildUnitDropdown(_selectedUnitFrom, true),
            SizedBox(height: 20),
            TextField(
              controller: _controllerFrom,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _getUnitName(_selectedUnitFrom),
              ),
            ),
            SizedBox(height: 20),
            _buildUnitDropdown(_selectedUnitTo, false),
            SizedBox(height: 20),
            TextField(
              controller: _controllerTo,
              keyboardType: TextInputType.number,
              enabled: false,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
              decoration: InputDecoration(
                labelText: _getUnitName(_selectedUnitTo),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _swapUnits,
              child: Text('Swap Units'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitDropdown(SquareUnit selectedUnit, bool isFrom) {
    return DropdownButton<SquareUnit>(
      value: selectedUnit,
      onChanged: (SquareUnit? newValue) {
        setState(() {
          if (isFrom) {
            _selectedUnitFrom = newValue!;
          } else {
            _selectedUnitTo = newValue!;
          }
        });
      },
      items: SquareUnit.values.map<DropdownMenuItem<SquareUnit>>(
        (SquareUnit value) {
          return DropdownMenuItem<SquareUnit>(
            value: value,
            child: Text(_getUnitName(value)),
          );
        },
      ).toList(),
    );
  }

  String _getUnitName(SquareUnit unit) {
    switch (unit) {
      case SquareUnit.sCm:
        return 'Square Centimeters';
      case SquareUnit.sM:
        return 'Square Meters';
      case SquareUnit.sKm:
        return 'Square Kilometers';
    }
  }

  void _convert() {
    try {
      double inputValue = double.tryParse(_controllerFrom.text) ?? 0;
      double result;

      if (_selectedUnitFrom == _selectedUnitTo) {
        result = inputValue;
      } else {
        result = _performConversion(
            inputValue, _selectedUnitFrom, _selectedUnitTo);
      }

      _controllerTo.text = result.toString();
    } catch (e) {
      print('Invalid input: $e');
    }
  }

  void _swapUnits() {
    String temp = _controllerFrom.text;
    _controllerFrom.text = _controllerTo.text;
    _controllerTo.text = temp;
  }

  double _performConversion(
      double value, SquareUnit from, SquareUnit to) {
    double result;

    // Conversion logic for Square
    if (from == SquareUnit.sCm && to == SquareUnit.sM) {
      result = value / 10000;
    } else if (from == SquareUnit.sM && to == SquareUnit.sCm) {
      result = value * 10000;
    } else if (from == SquareUnit.sCm && to == SquareUnit.sKm) {
      result = value / 10000000000;
    } else if (from == SquareUnit.sKm && to == SquareUnit.sCm) {
      result = value * 10000000000;
    } else if (from == SquareUnit.sM && to == SquareUnit.sKm) {
      result = value / 1000000;
    } else if (from == SquareUnit.sKm && to == SquareUnit.sM) {
      result = value * 1000000;
    } else {
      result = value;
    }

    return double.parse(result.toStringAsFixed(8));
  }
}
