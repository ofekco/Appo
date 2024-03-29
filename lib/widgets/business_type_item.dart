import 'package:Appo/Business_side/model/colors.dart';
import 'package:Appo/models/Business.dart';
import 'package:Appo/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Appo/models/type.dart';

class BusinessTypeListItem extends StatefulWidget {
  final Type _type;
  final Function itemClicked;

  BusinessTypeListItem(this._type, this.itemClicked);

  @override
  State<BusinessTypeListItem> createState() => _BusinessTypeListItemState();
}

class _BusinessTypeListItemState extends State<BusinessTypeListItem> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.itemClicked,
      onHighlightChanged: (param) {
        setState(() {
          isClicked = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AspectRatio(
                    //business image
                    aspectRatio: 2,
                    child: widget._type.imageUrl == null
                        ? Container()
                        : Image.network(
                            widget._type.imageUrl,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    color: Theme.of(context).canvasColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //type
                                  Text(
                                    widget._type.title,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: isClicked
                                            ? FontWeight.bold
                                            : FontWeight.w600,
                                        fontSize: 22,
                                        color: isClicked
                                            ? Palette.kToDark[800]
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
