
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mynews/view_modal/read_category.dart';

import '../modal/category_modal.dart';
import 'details_of_news_screen.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {

  ReadCategory readCategory=ReadCategory();
  String categoryName = "General";

  List<String> categoriesList = [
    "General",
    "Entertainment",
    "Health",
    "Sports",
    "Business",
    "Technology"
  ];

  DateFormat dateFormat = DateFormat("dd/MMMM/yyyy");

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                SizedBox(
                  height: height * 0.048,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoriesList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              categoryName = categoriesList[index];});
                          },
                          child: Container(
                            height: height * 0.005,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: categoryName.toLowerCase() == categoriesList[index].toLowerCase()
                                  ?Colors.blue:Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                categoriesList[index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 5,),

                SizedBox(
                  height: height * 0.75,
                  child: FutureBuilder<CategoryNewsModel>(
                    future: readCategory.fetchCategoryNews(categoryName),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitCircle(color: Colors.blue),
                        );
                      }
                      else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.articles!.isEmpty) {
                        return const Center(
                          child: Text('No data available'),
                        );
                      }
                      else {
                        return ListView.builder(
                          itemCount: snapshot.data!.articles!.length,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsOfNewsScreen(
                                  newsImg: snapshot.data!.articles![index].urlToImage.toString(),
                                  newsTitle: snapshot.data!.articles![index].title.toString(),
                                  author: snapshot.data!.articles![index].author.toString(),
                                  description: snapshot.data!.articles![index].description.toString(),
                                  content: snapshot.data!.articles![index].content.toString(),
                                  source: snapshot.data!.articles![index].source!.name.toString(),
                                  url: snapshot.data!.articles![index].url.toString(),
                                )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                        height: height * .18,
                                        width: width * 0.2,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                        const Center(child: SpinKitCircle(color: Colors.blue)),
                                        errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 15),
                                        height: height * .18,
                                        child: Column(
                                          children: [
                                            Text(snapshot.data!.articles![index].title.toString(),
                                              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  style: GoogleFonts.poppins(color: Colors.pink,fontSize: 9),
                                                ),
                                                Text(dateFormat.format(dateTime), style: const TextStyle(color: Colors.blue,fontSize: 10)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
