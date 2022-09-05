import 'package:Appo/Business_side/add_edit_calendar.dart';
import '../../booking_calendar/day_slots_controller.dart';
import '../widgets/create_slots_form.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class AddOrEditSlotsScreen extends StatefulWidget {
  final businessId;
  const AddOrEditSlotsScreen(this.businessId);

  @override
  State<AddOrEditSlotsScreen> createState() => _AddOrEditSlotsScreenState();
}

class _AddOrEditSlotsScreenState extends State<AddOrEditSlotsScreen> {
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(title: const Text(' ')),

          body: ChangeNotifierProvider(
          create:(_) =>
            DaySlotsController(businessId: widget.businessId, date: DateTime.now()),

          child: Center(
            child: AddOrEditCalendar(businessId: widget.businessId)
            ),
    ));
  }
}