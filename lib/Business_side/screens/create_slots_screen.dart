import '../../booking_calendar/day_slots_controller.dart';
import '../widgets/create_slots_calendar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class CreateSlotsScreen extends StatefulWidget {
  final businessId;
  const CreateSlotsScreen(this.businessId);

  @override
  State<CreateSlotsScreen> createState() => _CreateSlotsScreenState();
}

class _CreateSlotsScreenState extends State<CreateSlotsScreen> {
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(title: const Text(' ')),

          body: ChangeNotifierProvider(
          create:(_) =>
            DaySlotsController(businessId: widget.businessId, date: DateTime.now()),

          child: Center(
            child: CreateSlotsCalendar(businessId: widget.businessId)
            ),
    ));
  }
}
