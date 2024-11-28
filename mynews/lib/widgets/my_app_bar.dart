import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynews/toast_msg.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key, required this.title, required this.onSourceChanged});
  final String title;
  final ValueChanged<String> onSourceChanged;
  @override
  State<MyAppBar> createState() => MyAppBarState();
}

enum NewsSource { bbcNews, bloomberg, espnCricket }

class MyAppBarState extends State<MyAppBar> {
  NewsSource? selectedMenu;

  final auth=FirebaseAuth.instance;

  String getNewsSourceName(NewsSource source) {
    switch (source) {
      case NewsSource.bbcNews:
        return 'bbc-news';
      case NewsSource.bloomberg:
        return 'bloomberg';
      case NewsSource.espnCricket:
        return 'espn-cric-info';
      default:
        return 'bbc-news';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(widget.title),
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(onPressed: (){
        Navigator.pushNamed(context, "/category");
      }, icon: const Icon(CupertinoIcons.line_horizontal_3)),
      actions: [

        // this is for changing the news sources
        PopupMenuButton<NewsSource>(
          initialValue: selectedMenu,
          onSelected: (NewsSource item) {
            setState(() {
              selectedMenu = item;
            });
            String sourceName = getNewsSourceName(item);
            widget.onSourceChanged(sourceName);
          },
          itemBuilder: (context) => <PopupMenuEntry<NewsSource>>[
            const PopupMenuItem(
              value: NewsSource.bbcNews,
              child: Text("BBC News"),
            ),
            const PopupMenuItem(
              value: NewsSource.bloomberg,
              child: Text("Bloomberg"),
            ),
            const PopupMenuItem(
              value: NewsSource.espnCricket,
              child: Text("ESPN Cricket"),
            ),
          ],
        ),


        // this is logout button
        IconButton(onPressed: () {
          auth.signOut().then((value){
            Navigator.pushReplacementNamed(context, "/login");
          }).catchError((error,stackTrace){
            ToastMsg.showMsg(error.toString());
          });
        }, icon: const Icon(Icons.logout)),
      ],
    );
  }
}
