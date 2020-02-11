import 'package:http/http.dart' as http;

import 'dart:convert';

class NetworkModel{

  final String url;

  NetworkModel(this.url);

  Future getCurrencyData() async{
    http.Response response = await http.get(url);

    if (response.statusCode == 200){
      return jsonDecode(response.body);
    }
    else{
      return response.statusCode;
    }
  }

}