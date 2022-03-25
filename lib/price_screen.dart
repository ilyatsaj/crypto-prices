import 'package:bitcoin_ticker/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  var crypto;
  var cryptoBTC = 'BTC';
  var cryptoETH = 'ETH';
  var fiat = 'USD';
  var rate;
  var rateBTC;
  var rateETH;

  void getRate(crypto, fiat) async {
    try {
      NetworkHelper net = new NetworkHelper();
      var data = await net.getData(crypto, fiat);
      setState(() {
        rate = data['rate'];
      });
    } catch (e) {
      print(e);
    }
  }

  DropdownButton getAndroidDropDownButton() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var dropDownItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(dropDownItem);
    }
    return DropdownButton<String>(
      value: fiat,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          fiat = value;
        });
      },
    );
  }

  Widget getCupertinoPicker() {
    List<Text> dropDownItems = [];
    for (String currency in currenciesList) {
      var textWidget = Text(currency);
      dropDownItems.add(textWidget);
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      scrollController: FixedExtentScrollController(initialItem: 1),
      backgroundColor: Colors.white,
      onSelectedItemChanged: (value) {
        fiat = currenciesList[value];
      },
      children: dropDownItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return getCupertinoPicker();
    } else if (Platform.isAndroid) {
      return getAndroidDropDownButton();
    }
  }

  @override
  void initState() {
    super.initState();
    getRate(crypto, fiat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(children: [
              Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    '1 BTC = $rateBTC $fiat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    '1 ETH = $rateETH $fiat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
          ElevatedButton(
            onPressed: () {
              getRate(crypto, fiat);
            },
            child: Text('Calculate'),
          ),
        ],
      ),
    );
  }
}
