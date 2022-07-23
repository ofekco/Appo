import 'package:Appo/models/Business.dart';
import 'package:flutter/material.dart'; 

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
            widget._business.toggleFavoriteStatus();
          });
        },
        icon: widget._business.isFavorite ? 
          Icon(Icons.favorite, color: Theme.of(context).primaryColor,) 
          : Icon(Icons.favorite_border, color: Theme.of(context).primaryColor,),
    );
  }
}