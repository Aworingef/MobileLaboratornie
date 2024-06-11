import 'package:flutter/material.dart';

enum CurrencyUnit { RUB, USD, EUR }

class CurrencyConverterScreen extends StatefulWidget {
  final CurrencyUnit unitFrom;
  final CurrencyUnit unitTo;

  CurrencyConverterScreen({
    required this.unitFrom,
    required this.unitTo,
  });

  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  TextEditingController _controllerFrom = TextEditingController();
  TextEditingController _controllerTo = TextEditingController();

  late CurrencyUnit _selectedUnitFrom;
  late CurrencyUnit _selectedUnitTo;

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
          'Currency',
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

  Widget _buildUnitDropdown(CurrencyUnit selectedUnit, bool isFrom) {
    return DropdownButton<CurrencyUnit>(
      value: selectedUnit,
      onChanged: (CurrencyUnit? newValue) {
        setState(() {
          if (isFrom) {
            _selectedUnitFrom = newValue!;
          } else {
            _selectedUnitTo = newValue!;
          }
        });
      },
      items: CurrencyUnit.values.map<DropdownMenuItem<CurrencyUnit>>(
        (CurrencyUnit value) {
          return DropdownMenuItem<CurrencyUnit>(
            value: value,
            child: Text(_getUnitName(value)),
          );
        },
      ).toList(),
    );
  }

  String _getUnitName(CurrencyUnit unit) {
    switch (unit) {
      case CurrencyUnit.RUB:
        return 'RUB';
      case CurrencyUnit.USD:
        return 'USD';
      case CurrencyUnit.EUR:
        return 'EUR';
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
      double value, CurrencyUnit from, CurrencyUnit to) {
    double result;

    // Conversion logic for Currency
    if (from == CurrencyUnit.RUB && to == CurrencyUnit.USD) {
      result = value / 90;
    } else if (from == CurrencyUnit.USD && to == CurrencyUnit.RUB) {
      result = value * 90;
    } else if (from == CurrencyUnit.RUB && to == CurrencyUnit.EUR) {
      result = value / 100;
    } else if (from == CurrencyUnit.EUR && to == CurrencyUnit.RUB) {
      result = value * 100;
    } else if (from == CurrencyUnit.USD && to == CurrencyUnit.EUR) {
      result = value / 1.11;
    } else if (from == CurrencyUnit.EUR && to == CurrencyUnit.USD) {
      result = value * 1.11;
    } else {
      result = value;
    }

    return double.parse(result.toStringAsFixed(8));
  }
}
