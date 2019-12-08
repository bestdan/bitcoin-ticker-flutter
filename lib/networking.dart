import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show sleep;

class NetworkHelper {
  final String _baseURL =
      'https://apiv2.bitcoinaverage.com/indices/global/ticker/';
  String cryptoTicker;
  String fiatTicker;

  String urlBuilder(baseURL, cryptoTicker, fiatTicker) {
    String finalURL = '$baseURL$cryptoTicker$fiatTicker';
    return finalURL;
  }

  Future<double> getTickerPrice(
    String fiatTicker,
    String cryptoTicker,
  ) async {
    String finalURL = urlBuilder(_baseURL, cryptoTicker, fiatTicker);
    var response = await http.get(finalURL);
    if (response.statusCode != 200) {
      print('Response status: ${response.statusCode}');
      print('Response header: ${response.headers}');
      Duration sleeper = Duration(seconds: 2);
      sleep(sleeper);
      return null;
    } else {
      return jsonDecode(response.body)['last'];
    }
  }
}
