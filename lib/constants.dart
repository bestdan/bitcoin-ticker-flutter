import "package:flutter_money_formatter/flutter_money_formatter.dart";

const String apiKey = 'X-ba-key: Y2UyODJhMWJiODEyNGExYzhhOTMxNmVjNzBkZDQ0NWU';

class DollarFormatter extends FlutterMoneyFormatter {
  DollarFormatter(this.amount);

  final double amount;

  String getDollar() {
    MoneyFormatterOutput fo = FlutterMoneyFormatter(amount: amount).output;
    String dollar = fo.compactNonSymbol;
    return dollar;
  }
}
