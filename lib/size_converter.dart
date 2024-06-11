import 'package:flutter/material.dart';

enum SizeUnit { Cm, M, Km }

class SizeConverterScreen extends StatefulWidget {
  final SizeUnit unitFrom;
  final SizeUnit unitTo;

  SizeConverterScreen({
    required this.unitFrom,
    required this.unitTo,
  });

  @override
  _SizeConverterScreenState createState() => _SizeConverterScreenState();
}

class _SizeConverterScreenState extends State<SizeConverterScreen> {
  TextEditingController _controllerFrom = TextEditingController();
  TextEditingController _controllerTo = TextEditingController();

  late SizeUnit _selectedUnitFrom;
  late SizeUnit _selectedUnitTo;

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
          'Size',
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

  Widget _buildUnitDropdown(SizeUnit selectedUnit, bool isFrom) {
    return DropdownButton<SizeUnit>(
      value: selectedUnit,
      onChanged: (SizeUnit? newValue) {
        setState(() {
          if (isFrom) {
            _selectedUnitFrom = newValue!;
          } else {
            _selectedUnitTo = newValue!;
          }
        });
      },
      items: SizeUnit.values.map<DropdownMenuItem<SizeUnit>>(
        (SizeUnit value) {
          return DropdownMenuItem<SizeUnit>(
            value: value,
            child: Text(_getUnitName(value)),
          );
        },
      ).toList(),
    );
  }

  String _getUnitName(SizeUnit unit) {
    switch (unit) {
      case SizeUnit.Cm:
        return 'Cm';
      case SizeUnit.M:
        return 'M';
      case SizeUnit.Km:
        return 'Km';
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
      double value, SizeUnit from, SizeUnit to) {
    double result;

    // Conversion logic for Size
    if (from == SizeUnit.Cm && to == SizeUnit.M) {
      result = value / 100;
    } else if (from == SizeUnit.M && to == SizeUnit.Cm) {
      result = value * 100;
    } else if (from == SizeUnit.Cm && to == SizeUnit.Km) {
      result = value / 100000;
    } else if (from == SizeUnit.Km && to == SizeUnit.Cm) {
      result = value * 100000;
    } else if (from == SizeUnit.M && to == SizeUnit.Km) {
      result = value / 1000;
    } else if (from == SizeUnit.Km && to == SizeUnit.M) {
      result = value * 1000;
    } else {
      result = value;
    }

    return double.parse(result.toStringAsFixed(8));
  }
}
