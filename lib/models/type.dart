import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Type {
  final int id;
  final String title;
  final String imageUrl;
  bool isSelected;

  int get Id {
    return id;
  }

  String get Title {
    return title;
  }

  String get ImageUrl {
    return imageUrl;
  }

  bool get IsSelected {
    return isSelected;
  }

  Type({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    this.isSelected=false,
  });
}

