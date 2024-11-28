import 'package:mynews/modal/headline_modal.dart';
import 'package:mynews/view_modal/get_headline.dart';

class ReadHeadline {

  GetHeadline repository = GetHeadline();

  Future<NewsHeadlines> fetchHeadline(String sourceName) async {
    var response = await repository.fetchHeadline(sourceName);
    return response;
  }


}
