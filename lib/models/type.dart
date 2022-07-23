import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Type {
  final int id;
  final String title;
  final String imageUrl;
  bool isSelected;

  Type({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    this.isSelected=false,
  });
}

