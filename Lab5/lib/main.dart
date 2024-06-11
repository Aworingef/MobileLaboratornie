import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;

void main() {
  runApp(MyApp());
}

class StockData {
  final String name;
  final String symbol;
  final String image;
  final String price;

  StockData({
    required this.name,
    required this.symbol,
    required this.image,
    required this.price,
  });

  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      price: json['price'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Prices',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StockListScreen(),
    );
  }
}

class StockListScreen extends StatefulWidget {
  @override
  _StockListScreenState createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  late List<StockData> stockDataList;

  @override
  void initState() {
    super.initState();
    stockDataList = [];
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    final List<String> symbols = [
      'bitcoin',
      'ethereum',
      'solana',
      'xrp',
      'tron',
      'litecoin',
      'dogecoin'
    ];

    for (String symbol in symbols) {
      final response = await http
          .get(Uri.parse('https://www.binance.com/ru/price/$symbol/'));
      if (response.statusCode == 200) {
        final document = htmlParser.parse(response.body);
        final name =
            document.querySelector('.css-1gboz1i')?.text.trim() ?? 'N/A';
        final image =
            document.querySelector('.css-xu40gq img')?.attributes['src'] ??
                'N/A';
        final priceString =
            document.querySelector('.css-1bwgsh3')?.text.trim() ?? '0.0';

        final stockData = StockData(
          name: name,
          symbol: symbol,
          image: image,
          price: priceString,
        );

        setState(() {
          stockDataList.add(stockData);
        });
      } else {
        throw Exception(
            'Не удалось загрузить данные о курсе акций для $symbol');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Курсы акций'),
      ),
      body: ListView.builder(
        itemCount: stockDataList.length,
        itemBuilder: (context, index) {
          final stock = stockDataList[index];
          return StockTile(stock: stock);
        },
      ),
    );
  }
}

class StockTile extends StatelessWidget {
  final StockData stock;

  StockTile({required this.stock});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(stock.image,
            height: 50, width: 50), // Изображение слева
        title: Text('${stock.name} - ${stock.symbol}'),
        subtitle: Text('${stock.price}'),
      ),
    );
  }
}
