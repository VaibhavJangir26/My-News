import 'dart:convert';
import 'package:mynews/modal/headline_modal.dart';
import 'package:http/http.dart' as http;

class GetHeadline{

  Future<NewsHeadlines> fetchHeadline(String sourceName) async{
    try{
      var headlineUrl="https://newsapi.org/v2/top-headlines?sources=$sourceName&apiKey=acc315978fc04c13932837eb5a776500";
      var response=await http.get(Uri.parse(headlineUrl));
      if(response.statusCode==200){
        var jsonDataFormat=jsonDecode(response.body);
        return NewsHeadlines.fromJson(jsonDataFormat);
      }
      throw Exception("Unknown Error Occurred");
    }
    catch(e){
      throw Exception(e);
    }
  }



}