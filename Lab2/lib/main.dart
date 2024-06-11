import 'package:flutter/material.dart';
import 'temperature_converter.dart';
import 'weight_converter.dart';
import 'currency_converter.dart';
import 'size_converter.dart';
import 'square_converter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Converter'),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TemperatureConverterScreen(
                    unitFrom: TemperatureUnit.Celsius,
                    unitTo: TemperatureUnit.Kelvin,
                  ),
                ),
              );
            },
            child: ListTile(
              title: const Text('Temperature'),
              leading: const Icon(Icons.thermostat),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeightConverterScreen(
                    unitFrom: WeightUnit.Gram,
                    unitTo: WeightUnit.Kilogram,
                  ),
                ),
              );
            },
            child: ListTile(
              title: const Text('Weight'),
              leading: const Icon(Icons.beach_access),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CurrencyConverterScreen(
                    unitFrom: CurrencyUnit.RUB,
                    unitTo: CurrencyUnit.USD,
                  ),
                ),
              );
            },
            child: ListTile(
              title: const Text('Currency'),
              leading: const Icon(Icons.show_chart),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SizeConverterScreen(
                    unitFrom: SizeUnit.Cm,
                    unitTo: SizeUnit.M,
                  ),
                ),
              );
            },
            child: ListTile(
              title: const Text('Size'),
              leading: const Icon(Icons.star_half),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SquareConverterScreen(
                    unitFrom: SquareUnit.sCm,
                    unitTo: SquareUnit.sM,
                  ),
                ),
              );
            },
            child: ListTile(
              title: const Text('Square'),
              leading: const Icon(Icons.stars),
            ),
          ),
        ],
      ),
    );
  }
}
