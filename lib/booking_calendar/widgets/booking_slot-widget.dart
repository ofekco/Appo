import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:Appo/models/colors.dart';
import './common_card.dart';

class BookingSlot extends StatelessWidget {
  const BookingSlot({
    Key key,
    @required this.child,
    @required this.isBooked,
    @required this.onTap,
    @required this.isSelected,
  }) : super(key: key);

  final Widget child;
  final bool isBooked;
  final bool isSelected;
  final VoidCallback onTap;

  Color getSlotColor() {
    if (isBooked) {
      return Colors.red;
    } else {
      return isSelected
          ? Palette.kToDark[500]
          : Palette.kToDark[50];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onTap: (!isBooked) ? onTap : null,
            child: CommonCard(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                color: getSlotColor(),
                child: child),
          );
  }
}
