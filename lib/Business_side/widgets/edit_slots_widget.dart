import 'package:Appo/Business_side/widgets/create_slots_form.dart';
import 'package:Appo/booking_calendar/day_slots_controller.dart';
import 'package:Appo/booking_calendar/model/times_slots.dart';
import 'package:Appo/booking_calendar/widgets/booking_confirmation.dart';
import 'package:Appo/booking_calendar/widgets/booking_slot-widget.dart';
import 'package:Appo/helpers/DB_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Appo/booking_calendar/widgets/booking_explanation.dart';
import 'package:Appo/models/colors.dart';
import 'package:Appo/booking_calendar/widgets/common_button.dart';
import 'package:Appo/booking_calendar/widgets/common_card.dart';
import 'package:Appo/booking_calendar/widgets/booking_dialog.dart';
import 'package:intl/intl.dart';


class EditSlotsWidget extends StatefulWidget {

  final businessId;

  const EditSlotsWidget({Key key, this.businessId}) : super(key: key); //ctor

  @override
  State<EditSlotsWidget> createState() => _EditSlotsWidgetState();
}

class _EditSlotsWidgetState extends State<EditSlotsWidget> {
  DaySlotsController controller;
  
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller = context.read<DaySlotsController>();
    
  }

  static String formatDateTime(DateTime dt) {
    return DateFormat.Hm().format(dt);
  }

  void onRemoveButtonTap() async
  {
    controller.toggleUploading();
    await controller.deleteBusinessSlot();
    controller.toggleUploading();           
  }

  @override
  Widget build(BuildContext context) {
    controller = context.watch<DaySlotsController>();

    return Consumer<DaySlotsController>(builder: (_, controller, __) =>
      Column(
        children: [ 
            
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 8.0,
            runSpacing: 8.0,
            direction: Axis.horizontal,
            children: [
              BookingExplanation(
                          color:  Palette.kToDark[50],
                          text: "זמין"),
              
              BookingExplanation(
                          color: Colors.redAccent,
                          text: "מוזמן"),
              ],
          ),
    
          const SizedBox(height: 8),
    
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: controller.allBookingSlots.length,
              itemBuilder: (context, index) {
                final slot = controller.allBookingSlots.elementAt(index);
                return BookingSlot(
                                isBooked: controller.isSlotBooked(index),
                                isSelected: index == controller.selectedSlot,
                                onTap: () => controller.selectSlot(index),
                                child: Center(
                                  child: Text(formatDateTime(slot)),
                                ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.5,
                            ),
                          ),
          ),
                    
          const SizedBox(height: 16,),
    
          CommonButton(
            width: 50,
            text: 'הסר',
            onTap: () => onRemoveButtonTap(),
            isDisabled: controller.selectedSlot == -1,
            buttonActiveColor: Palette.kToDark[800],
          ),

          const SizedBox(height: 20,),

          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            
            InkWell(
              onTap: () {},
              child: Container(color: Colors.white,
                child: Text(
                  'הסר הכל',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  ),
              ),
            ),

            InkWell(
              onTap: () {},
              child: Container(color: Colors.white,
                child: Text(
                'הוסף שעה',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                ),
              ),
            ),
                  
          ]
        ),
    
        ],
      ),
    );
  }
}
