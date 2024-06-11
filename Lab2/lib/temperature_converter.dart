import 'package:flutter/material.dart';

enum TemperatureUnit { Celsius, Kelvin, Leiden }

class TemperatureConverterScreen extends StatefulWidget {
  final TemperatureUnit unitFrom;
  final TemperatureUnit unitTo;

  TemperatureConverterScreen({
    required this.unitFrom,
    required this.unitTo,
  });

  @override
  _TemperatureConverterScreenState createState() =>
      _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  TextEditingController _controllerFrom = TextEditingController();
  TextEditingController _controllerTo = TextEditingController();

  late TemperatureUnit _selectedUnitFrom;
  late TemperatureUnit _selectedUnitTo;

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
          'Temperature',
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

  Widget_buildUnitDropdown(TemperatureUnit selectedUnit, bool isFrom) {
    return DropdownButton<TemperatureUnit>(
      value: selectedUnit,
      onChanged: (TemperatureUnit? newValue) {
        setState(() {
          if (isFrom) {
            _selectedUnitFrom = newValue!;
          } else {
            _selectedUnitTo = newValue!;
          }
        });
      },
      items: TemperatureUnit.values.map<DropdownMenuItem<TemperatureUnit>>(
        (TemperatureUnit value) {
          return DropdownMenuItem<TemperatureUnit>(
            value: value,
            child: Text(_getUnitName(value)),
          );
        },
      ).toList(),
    );
  }

  String _getUnitName(TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.Celsius:
        return 'Celsius';
      case TemperatureUnit.Kelvin:
        return 'Kelvin';
      case TemperatureUnit.Leiden:
        return 'Leiden';
    }
  }

  void _convert() {
    try {
      double inputValue = double.tryParse(_controllerFrom.text) ?? 0;
      double result;

      if (_selectedUnitFrom == _selectedUnitTo) {
        result = inputValue;
      } else {
        result = _performConversion(inputValue, _selectedUnitFrom, _selectedUnitTo);
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

  double _performConversion(double value, TemperatureUnit from, TemperatureUnit to) {
    double result;
    
    // Сonversion logic
    if (from == TemperatureUnit.Celsius && to == TemperatureUnit.Kelvin) {
      result = value + 273.15;
    } else if (from == TemperatureUnit.Kelvin && to == TemperatureUnit.Celsius) {
      result = value - 273.15;
    } else if (from == TemperatureUnit.Celsius && to == TemperatureUnit.Leiden) {
      result = value + 253;
    } else if (from == TemperatureUnit.Leiden && to == TemperatureUnit.Celsius) {
      result = value - 253;
    } else if (from == TemperatureUnit.Leiden && to == TemperatureUnit.Kelvin) {
      result = value + 20.15;
    } else if (from == TemperatureUnit.Kelvin && to == TemperatureUnit.Leiden) {
      result = value - 20.15;
    } else {
      result = value;
    }

    // Округление до восьми знаков после запятой
    return double.parse(result.toStringAsFixed(8));
  }
}
