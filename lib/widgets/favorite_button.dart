import 'package:Appo/models/business.dart';
import 'package:Appo/models/authentication.dart';
import 'package:Appo/models/businesses.dart';
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';

class FavoriteButton extends StatefulWidget {
  final Business _business;

  FavoriteButton(this._business);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {

  
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {
            final businesses = Provider.of<Businesses>(context, listen: false);
            widget._business.toggleFavoriteStatus(businesses.ClientId);
            widget._business.isFavorite ? businesses.addFavorite(widget._business) : businesses.removeFavorite(widget._business);
          });
        },
        icon: widget._business.isFavorite ? 
          Icon(Icons.favorite, color: Theme.of(context).primaryColor,) 
          : Icon(Icons.favorite_border, color: Theme.of(context).primaryColor,),
    );
  }
}