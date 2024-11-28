import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mynews/modal/category_modal.dart';
class GetCategoryNews{

  Future<CategoryNewsModel> fetchCategoryNews(String category) async{
    String categoryUrl="https://newsapi.org/v2/everything?q=$category&apiKey=acc315978fc04c13932837eb5a776500";
    try{
      var response=await http.get(Uri.parse(categoryUrl));
      if(response.statusCode==200){
        var jsonData= jsonDecode(response.body);
        return CategoryNewsModel.fromJson(jsonData);
      }
      throw Exception("Unknown Error Occurred");
    }
    catch(e){
      throw Exception(e);
    }
  }

}