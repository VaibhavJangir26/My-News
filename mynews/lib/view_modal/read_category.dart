
import 'package:mynews/modal/category_modal.dart';
import 'package:mynews/view_modal/get_category_news.dart';

class ReadCategory{

  GetCategoryNews repository=GetCategoryNews();

  Future<CategoryNewsModel> fetchCategoryNews(String category) async{
    var response=await repository.fetchCategoryNews(category);
    return response;
  }

}