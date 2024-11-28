import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class DetailsOfNewsScreen extends StatefulWidget {
   const DetailsOfNewsScreen({super.key,
    required this.newsImg,
    required this.newsTitle,
    required this.author,
    required this.description,
    required this.content,
    required this.source, required this.url,
   });
  final String newsImg,newsTitle,author,description,content,source,url;

  @override
  State<DetailsOfNewsScreen> createState() => DetailsOfNewsScreenState();
}

class DetailsOfNewsScreenState extends State<DetailsOfNewsScreen> {
  void sharing() async{
    final imgUrl = widget.newsImg;
    if (imgUrl.isNotEmpty) {
      final response = await http.get(Uri.parse(imgUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final temp = await getTemporaryDirectory();
        final path = '${temp.path}/image.jpg';
        File(path).writeAsBytesSync(bytes);
        await Share.shareXFiles(
            [XFile(path)],
            text: widget.url,
            subject: widget.newsTitle
        );
        return;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("My News"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Stack(
            children: [

              SizedBox(
                height: height*0.43,
                width: width,
                child:  CachedNetworkImage(
                      imageUrl: widget.newsImg,
                      fit: BoxFit.fill,
                      width: width,
                      placeholder: (context,url)=>const Center(child: SpinKitCircle(color: Colors.blue,)),
                      errorWidget: (context,url,error)=>const Icon(Icons.error),
                  ),
                ),

              Container(
                height: height,
                width: width,
                margin: EdgeInsets.only(top: height*0.4),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius:const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Text(widget.newsTitle, style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),),
                    SizedBox(height: height*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Source: ${widget.source}", style: GoogleFonts.poppins(fontSize: 10,color: Colors.blue),),
                        InkWell(
                          onTap: sharing,
                          child: const Row(
                            children: [
                              Icon(Icons.share,color: Colors.purple,),
                              Text("Share",style: TextStyle(color: Colors.pinkAccent),),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(widget.content, style: GoogleFonts.poppins(fontSize: 11),maxLines: 5,overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: 3,),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: (){
                          launchUrl(Uri.parse(widget.url));
                        },
                        child: const Text("Read More"),
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
