import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mynews/screens/details_of_news_screen.dart';
import 'package:mynews/view_modal/read_category.dart';
import 'package:mynews/view_modal/read_headline.dart';
import 'package:mynews/widgets/my_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../modal/headline_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  ReadHeadline readHeadline = ReadHeadline();
  ReadCategory readCategory = ReadCategory();
  String newsSource = "bbc-news";

  void updateNewsSource(String newSource) {
    setState(() {
      newsSource = newSource;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(
          title: "My News",
          onSourceChanged: updateNewsSource,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [



              SizedBox(
                  width: width,
                  height: height*.03,
                  child: Text("Top Headlines",textAlign: TextAlign.center, style: GoogleFonts.italiana(fontSize: 12, fontWeight: FontWeight.bold,),)),


              FutureBuilder<NewsHeadlines>(
                future: readHeadline.fetchHeadline(newsSource),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Skeletonizer(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 8),
                          child: Container(
                            width: width * 0.9,
                            height: height * 0.37,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade200,
                            ),
                          ),
                        )
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Unable to load data!"),
                    );
                  } else if (snapshot.hasData) {
                    return SizedBox(
                      height: height * 0.37,
                      child: ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var getData = snapshot.data!.articles?[index];
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsOfNewsScreen(
                                  newsImg: getData!.urlToImage.toString(),
                                  newsTitle: getData.title.toString(),
                                  author: getData.author.toString(),
                                  description: getData.description.toString(),
                                  content: getData.content.toString(),
                                  source: getData.source.toString(),
                                  url: getData.source.toString(),
                              )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    width: width * 0.85,
                                    height: height * 0.35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: getData?.urlToImage?.isNotEmpty == true
                                            ? getData!.urlToImage!
                                            : "https://via.placeholder.com/150",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                        const SpinKitCircle(color: Colors.blue),
                                        errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: height*.02,
                                    child: Container(
                                      width: width * 0.8,
                                      height: height * 0.13,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            getData?.title ?? "No Title Available",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(right: 5),
                                            height: height*.015,
                                            child: Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(getData?.publishedAt ?? DateTime.now().toString())),
                                              textAlign: TextAlign.end,style: const TextStyle(fontSize: 8,color: Colors.pinkAccent),),
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
                      ),
                    );
                  } else {
                    return const Center(child: Text("Unknown Error"));
                  }
                },
              ),


              SizedBox(
                  width: width,
                  height: height*.03,
                  child: Text("Daily News",textAlign: TextAlign.center, style: GoogleFonts.italiana(fontSize: 12,fontWeight: FontWeight.bold,),)),


              FutureBuilder(
                future: readCategory.fetchCategoryNews("general"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Skeletonizer(
                      enabled: true,
                      child: Column(
                        children: List.generate(5, (index) {
                          return Skeletonizer(
                            enabled: true,
                            child: ListTile(
                              leading:  CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                              ),
                              title: Container(
                                height: 12,
                                color: Colors.grey.shade200,
                              ),
                              subtitle: Container(
                                height: 12,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Unable to load data'));
                  }
                  else if (snapshot.hasData) {
                    return Column(
                      children: List.generate(snapshot.data!.articles!.length, (index) {
                        var getData = snapshot.data!.articles![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsOfNewsScreen(
                                newsImg: getData.urlToImage.toString(),
                                newsTitle: getData.title.toString(),
                                author: getData.author.toString(),
                                description: getData.description.toString(),
                                content: getData.content.toString(),
                                source: getData.source.toString(),
                                url: getData.source.toString(),
                              ))
                              );
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: getData.urlToImage ?? "",
                                width: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const SpinKitCircle(color: Colors.blue),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                            title: Text(
                              getData.title ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat("dd/MM/yyyy").format(
                                DateTime.parse(getData.publishedAt ?? DateTime.now().toString()),
                              ),textAlign: TextAlign.end,
                              style: const TextStyle(fontSize: 9,color: Colors.pinkAccent),
                            ),
                          ),
                        );
                      }),
                    );
                  } else {
                    return const Center(child: Text("No data available"));
                  }
                },
              ),





            ],
          ),
        ),
      ),
    );
  }
}
