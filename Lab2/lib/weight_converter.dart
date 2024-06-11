import 'package:flutter/material.dart';

enum WeightUnit { Gram, Kilogram, Ton }

class WeightConverterScreen extends StatefulWidget {
  final WeightUnit unitFrom;
  final WeightUnit unitTo;

  WeightConverterScreen({
    required this.unitFrom,
    required this.unitTo,
  });

  @override
  _WeightConverterScreenState createState() => _WeightConverterScreenState();
}

class _WeightConverterScreenState extends State<WeightConverterScreen> {
  TextEditingController _controllerFrom = TextEditingController();
  TextEditingController _controllerTo = TextEditingController();

  late WeightUnit _selectedUnitFrom;
  late WeightUnit _selectedUnitTo;

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
          'Weight',
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
                color: Theme.of(context).textTheme.bodyLarge!.color,
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

  Widget _buildUnitDropdown(WeightUnit selectedUnit, bool isFrom) {
    return DropdownButton<WeightUnit>(
      value: selectedUnit,
      onChanged: (WeightUnit? newValue) {
        setState(() {
          if (isFrom) {
            _selectedUnitFrom = newValue!;
          } else {
            _selectedUnitTo = newValue!;
          }
        });
      },
      items: WeightUnit.values.map<DropdownMenuItem<WeightUnit>>(
        (WeightUnit value) {
          return DropdownMenuItem<WeightUnit>(
            value: value,
            child: Text(_getUnitName(value)),
          );
        },
      ).toList(),
    );
  }

  String _getUnitName(WeightUnit unit) {
    switch (unit) {
      case WeightUnit.Gram:
        return 'Gram';
      case WeightUnit.Kilogram:
        return 'Kilogram';
      case WeightUnit.Ton:
        return 'Ton';
    }
  }

  void _convert() {
    try {
      double inputValue = double.tryParse(_controllerFrom.text) ?? 0;
      double result;

      if (_selectedUnitFrom == _selectedUnitTo) {
        result = inputValue;
      } else {
        result =
            _performConversion(inputValue, _selectedUnitFrom, _selectedUnitTo);
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
      double value, WeightUnit from, WeightUnit to) {
    double result;

    // Сonversion logic for Weight
    if (from == WeightUnit.Gram && to == WeightUnit.Kilogram) {
      result = value / 1000;
    } else if (from == WeightUnit.Kilogram && to == WeightUnit.Gram) {
      result = value * 1000;
    } else if (from == WeightUnit.Gram && to == WeightUnit.Ton) {
      result = value / 1000000;
    } else if (from == WeightUnit.Ton && to == WeightUnit.Gram) {
      result = value * 1000000;
    } else if (from == WeightUnit.Kilogram && to == WeightUnit.Ton) {
      result = value / 1000;
    } else if (from == WeightUnit.Ton && to == WeightUnit.Kilogram) {
      result = value * 1000;
    } else {
      result = value;
    }

    // Округление до восьми знаков после запятой
    return double.parse(result.toStringAsFixed(8));
  }
}
