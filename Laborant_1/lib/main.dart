import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Прогноз погоды',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      // ),
      home: const WeatherHomePage(
        title: 'Прогноз погоды',
        key: null,
      ),
    );
  }
}

class WeatherService {
  final String apiKey = 'b28eda2584dd5a69b0852a1be14dc209';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';
  final String baseUrl2 = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherForecast> getWeather(String city) async {
    final url = '$baseUrl?q=$city&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed');
    }
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key, required this.title});
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherService weatherService = WeatherService();
  String selectedCity = 'Ханты-Мансийск';
  WeatherForecast? weatherForecast;
  Weather? currentWeather;

  @override
  Widget build(BuildContext context) {
    _getWeather(selectedCity);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //строка поиска
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  initialValue: selectedCity,
                  onChanged: (newCity) {
                    setState(() {
                      selectedCity = newCity;
                    });
                    _getWeather(selectedCity);
                  },
                  decoration: InputDecoration(
                    hintText: 'Выберите город',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),

              //вывод температуры на текущий момент времени
              if (currentWeather != null)
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.12,
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(
                        currentWeather!.icon,
                        width: 60,
                        height: 60,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Температура: ${currentWeather!.temperature.toStringAsFixed(1)}°C',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Влажность: ${currentWeather!.humidity}%',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              //создание таблицы с прогнозом погоды
              if (weatherForecast != null &&
                  weatherForecast!.forecasts.isNotEmpty)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IntrinsicWidth(
                      child: WeatherForecastTable(
                          forecasts: weatherForecast!.forecasts),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _getWeather(String city) async {
    try {
      final data = await weatherService.getWeather(city);
      setState(() {
        weatherForecast = data;
        currentWeather = data.forecasts.first;
      });
    } catch (e) {
      print(e);
    }
  }
}
