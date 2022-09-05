import 'package:Appo/models/Business.dart';
import 'package:Appo/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessListItem extends StatefulWidget {
  final Business _business;

  BusinessListItem(this._business);

  @override
  State<BusinessListItem> createState() => _BusinessListItemState();
}

class _BusinessListItemState extends State<BusinessListItem> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
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

                  AspectRatio( //business image
                    aspectRatio: 2,
                    child: widget._business.imageUrl == null? Container() : Image.network(
                    widget._business.imageUrl, fit: BoxFit.cover,),
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
                                mainAxisAlignment:MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  //business name
                                  Text(widget._business.name, textAlign: TextAlign.left, style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,),
                                      ),
                                  Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(widget._business.phoneNumber,
                                              style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),),
                                        const SizedBox(width: 4,),
                                        Icon(Icons.home, size: 12, color: Theme.of(context).primaryColor,),
                                        Expanded(
                                          child: Text(widget._business.city, overflow: TextOverflow.ellipsis, style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey.withOpacity(0.8)),
                                                    ),
                                                  ),
                                        ],
                                      ),
                                      Padding(
                                        padding:const EdgeInsets.only(top: 4),
                                        child: Text(widget._business.address),
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

                    
                    Positioned( //favorite button
                        top: 8, right: 8, child: Material(
                        color: Colors.transparent,
                        child: FavoriteButton(widget._business),
                                      ),
                    ),
                    
             ],
         ),
        ),
   );
  }
}