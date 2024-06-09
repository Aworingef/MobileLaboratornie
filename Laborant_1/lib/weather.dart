import 'package:flutter/material.dart';

class Weather {
  final double temperature;
  final int humidity;
  final String icon;
  final String date;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.icon,
    required this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'] - 273,
      humidity: json['main']['humidity'],
      icon:
          'http://openweathermap.org/img/wn/${json['weather'][0]['icon']}.png',
      date:
          '${DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000).toString().split(' ')[0]} ${DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000).toString().split(' ')[1].substring(0, 5)}',
    );
  }

  get dt => null;
}

class WeatherForecastTable extends StatelessWidget {
  final List<Weather> forecasts;

  WeatherForecastTable({required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Table(
        children: [
          //шапка таблицы
          TableRow(
            children: [
              TableCell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Дата и время',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Температура',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Влажность',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    '   ',
                  ),
                ),
              ),
            ],
          ),

          //строки таблицы
          ...forecasts.map((forecast) {
            return TableRow(
              children: [
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      forecast.date,
                      style: TextStyle(color: Colors.black, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      '${forecast.temperature.toStringAsFixed(1)}°C',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      '${forecast.humidity}%',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(forecast.icon, width: 32, height: 32),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

class WeatherForecast {
  final List<Weather> forecasts;

  WeatherForecast({required this.forecasts});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    List<Weather> forecastList = [];
    for (var item in json['list']) {
      forecastList.add(Weather.fromJson(item));
    }
    return WeatherForecast(forecasts: forecastList);
  }
}
