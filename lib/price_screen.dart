import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform, sleep;
import 'package:bitcoin_ticker/networking.dart';

class PriceScreen extends StatefulWidget {
  PriceScreen({this.networkHelper});
  final networkHelper;

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String fiatCurrency = 'USD';
  String cryptoCurrency = 'BTC';
  NetworkHelper networkHelper = NetworkHelper();
  double currentPrice;

  void updateUI(dynamic newPrice) {
    setState(
      () {
        if (newPrice == null) {
          currentPrice = -99.0;
          return;
        }
        //print(networkHelper[0]['last']);
        currentPrice = newPrice;
      },
    );
  }

  DropdownButton<String> getAndroidPicker() {
    List<DropdownMenuItem<String>> currencyOptions = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      currencyOptions.add(newItem);
    }

    return DropdownButton<String>(
      value: fiatCurrency,
      items: currencyOptions,
      onChanged: (value) {
        //print(fiatCurrency);
        setState(() {
          fiatCurrency = value;
        });
      },
    );
  }

  CupertinoPicker getiOSPicker() {
    List<Text> currencyOptions = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      currencyOptions.add(newItem);
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      useMagnifier: true,
      itemExtent: 32.0,
      scrollController: FixedExtentScrollController(initialItem: 19),
      onSelectedItemChanged: (value) async {
        fiatCurrency = currenciesList[value];
        print(fiatCurrency);
        var newPrice =
            await networkHelper.getTickerPrice(fiatCurrency, cryptoCurrency);
        print(newPrice.toString());
        updateUI(newPrice);
      },
      children: currencyOptions,
    );
  }

  @override
  void initState() {
    super.initState();
    updateUI(widget.networkHelper);
  }

  Widget build(BuildContext context) {
    updateUI(currentPrice);
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 $fiatCurrency = ${currentPrice.toString()} $cryptoCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getiOSPicker() : getAndroidPicker(),
          ),
        ],
      ),
    );
  }
}
