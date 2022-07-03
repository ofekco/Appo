import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Appo/models/Dummy_data.dart';
import 'package:Appo/widgets/myNext_item.dart';
import 'package:Appo/widgets/favorite_item.dart';
import 'search_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget buildSectionTitle(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      width: double.infinity,
      alignment: Alignment.topRight,
      height: 30,
      child: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
    );
  }

  void search_clicked(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (_) {
        return SearchScreen();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            child: Center(
              child: ElevatedButton(
                  child: Text('חפש עסק'),
                  onPressed: () => search_clicked(context),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor,
                      textStyle: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
            ),
          ),
          buildSectionTitle(context, 'התורים הקרובים שלי'),
          Container(
            height: 180,
            width: double.infinity,
            alignment: Alignment.topRight,
            child: ListView(
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: DUMMY_FAV.map((bis) => MyNextItem(bis)).toList(),
            ),
          ),
          buildSectionTitle(context, 'עסקים שאהבתי'),
          Container(
            height: 150,
            width: double.infinity,
            alignment: Alignment.topRight,
            child: Scrollbar(
              scrollbarOrientation: ScrollbarOrientation.left,
              child: ListView.builder(
                itemBuilder: (ctx, index) =>
                    FavoriteItem(DUMMY_BUSINESSES[index]),
                itemCount: DUMMY_BUSINESSES.length,
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
