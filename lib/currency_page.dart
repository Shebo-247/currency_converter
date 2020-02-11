import 'package:flutter/material.dart';
import 'constants.dart';
import 'network.dart';
import 'coin.dart';

String fromCurrency = 'USD',toCurrency = 'CAD';

String from = '$fromCurrency' + '_' + '$toCurrency';
String to = '$toCurrency' + '_' + '$fromCurrency';

int amount = 1;

final firstTextController = TextEditingController();
final secondTextController = TextEditingController();

class CurrencyPage extends StatefulWidget {
  @override
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {

  String fromCurrencyDescription = 'United States Dollar';
  String toCurrencyDescription = 'Canadian Dollar';

  var currenciesSymbols = currenciesMap.keys.toList();
  var currenciesNames = currenciesMap.values.toList();


  @override
  void initState(){
    super.initState();
    firstTextController.text = amount.toString();
  }

  void updateUI(dynamic prices, int amount){
    setState(() {

      double sum = prices['$from'] * amount;

      secondTextController.text = sum.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    firstTextController.dispose();
    secondTextController.dispose();
    super.dispose();
  }

  Future<dynamic> getPrices() async {
    NetworkModel networkModel =
        NetworkModel('$siteURL?q=$from,$to&compact=ultra&apiKey=$apiKey');
    var priceData = await networkModel.getCurrencyData();

    if (priceData == 400) {
      print('There is no data found !');
    } else {
      return priceData;
    }
  }

  List<DropdownMenuItem<String>> getCurrencies() {
    List<DropdownMenuItem<String>> menuItems = [];
    for (String currency in currenciesSymbols) {
      menuItems.add(DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      ));
    }

    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text('CURRENCY CONVERTER'),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Card(
                  color: kCardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ListTile(
                        contentPadding:
                            EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                        title: DropdownButton<String>(
                          isExpanded: true,
                          value: fromCurrency,
                          elevation: 16,
                          underline: Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide.none),
                            ),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              fromCurrency = newValue;
                              fromCurrencyDescription = currenciesNames[
                                  currenciesSymbols
                                      .indexOf(fromCurrency)];

                              from = '$fromCurrency' + '_' + '$toCurrency';
                              to = '$toCurrency' + '_' + '$fromCurrency';
                            });
                          },
                          items: getCurrencies(),
                        ),
                        subtitle: Text(fromCurrencyDescription),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 35.0, horizontal: 20.0),
                        child: TextField(
                          controller: firstTextController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 25.0),
                          decoration: InputDecoration(
                            icon: Icon(Icons.attach_money),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FlatButton(
                    onPressed: () async{
                      var prices = await getPrices();
                      amount = int.parse(firstTextController.text);
                      updateUI(prices, amount);
                    },
                    child: Text(
                      ' = ',
                      style: TextStyle(fontSize: 35.0),
                    ),
                    color: kCardColor,
                    padding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
              Container(
                child: Card(
                  color: kCardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ListTile(
                        contentPadding:
                            EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                        title: DropdownButton<String>(
                          isExpanded: true,
                          value: toCurrency,
                          elevation: 16,
                          underline: Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide.none),
                            ),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              toCurrency = newValue;
                              toCurrencyDescription = currenciesNames[
                                  currenciesSymbols
                                      .indexOf(toCurrency)];

                              from = '$fromCurrency' + '_' + '$toCurrency';
                              to = '$toCurrency' + '_' + '$fromCurrency';
                            });
                          },
                          items: getCurrencies(),
                        ),
                        subtitle: Text(toCurrencyDescription),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 35.0, horizontal: 20.0),
                        child: TextField(
                          controller: secondTextController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 25.0),
                          decoration: InputDecoration(
                            icon: Icon(Icons.attach_money),
                          ),
                          readOnly: true,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
