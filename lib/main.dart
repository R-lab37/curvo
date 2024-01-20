import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(CurvoApp());
}

class CurvoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curvo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: CurrencyConverter(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  double amount = 0.0;
  String sourceCurrency = 'USD';
  String targetCurrency = 'EUR';
  double result = 0.0;
  Map<String, double> rates = {
    "AUD": 1.5154902571,
    "BGN": 1.7876103168,
    "BRL": 4.9307908369,
    "CAD": 1.3428901721,
    "CHF": 0.8681500991,
    "CNY": 7.190121004,
    "CZK": 22.7103733435,
    "DKK": 6.8438712339,
    "EUR": 0.9177101602,
    "GBP": 0.7873301254,
    "HKD": 7.816351265,
    "HRK": 7.0223109296,
    "HUF": 350.2811332825,
    "IDR": 15582.545233602,
    "ILS": 3.7419006167,
    "INR": 82.992171041,
    "ISK": 136.6674167587,
    "JPY": 148.1584643089,
    "KRW": 1332.9766309212,
    "MXN": 17.0788632046,
    "MYR": 4.7118906697,
    "NOK": 10.4868816639,
    "NZD": 1.6348102939,
    "PHP": 55.9310989158,
    "PLN": 3.9931105249,
    "RON": 4.5663406241,
    "RUB": 88.0074421792,
    "SEK": 10.4591713228,
    "SGD": 1.3400901943,
    "THB": 35.5197163022,
    "TRY": 30.1747131768,
    "USD": 1,
    "ZAR": 19.0319037124
  };

  Future<double> fetchExchangeRate(String source, String target) async {
    const apiKey =
        'fca_live_RlldNiCDgCW92U1YZJwKbLdkTGBfxMBqBC9zNbBY'; // Replace with your Free Currency Converter API key
    const apiUrl =
        'https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_RlldNiCDgCW92U1YZJwKbLdkTGBfxMBqBC9zNbBY';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rate = data['data'][target];
      return rate.toDouble();
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Curvo - Currency Converter'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.parse(value);
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: sourceCurrency,
                  onChanged: (value) {
                    setState(() {
                      sourceCurrency = value!;
                    });
                  },
                  items: rates.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Icon(Icons.arrow_forward, size: 30),
                DropdownButton<String>(
                  value: targetCurrency,
                  onChanged: (value) {
                    setState(() {
                      targetCurrency = value!;
                    });
                  },
                  items: rates.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final exchangeRate =
                      await fetchExchangeRate(sourceCurrency, targetCurrency);
                  setState(() {
                    result = amount * exchangeRate;
                  });
                } catch (e) {
                  // Handle error (e.g., show an error message)
                  print('Error: $e');
                }
              },
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Result: $result ${targetCurrency}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
