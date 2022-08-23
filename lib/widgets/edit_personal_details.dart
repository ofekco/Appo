import 'package:Appo/models/customer.dart';
import 'package:flutter/material.dart';


class EditPersonalDetails extends StatefulWidget {
  final Customer currentCustomer;

  EditPersonalDetails(this.currentCustomer);

  @override
  State<EditPersonalDetails> createState() => _EditPersonalDetailsState();
}

class _EditPersonalDetailsState extends State<EditPersonalDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {

                  }, 
                ),
              ),
              Spacer(),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'פרטים אישיים',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "כתובת מייל"
                ),
                onSaved: (value) {
                  
                },
              ),
                
              SizedBox(width: 15,),
              Icon(Icons.email_outlined),             
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(widget._currentUser.phoneNumber,
                style: TextStyle(fontSize: 18)),
              SizedBox(width: 15,),
              Icon(Icons.phone_outlined),             
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(widget._currentUser.city + ", " + widget._currentUser.address,
                style: TextStyle(fontSize: 18)),
              SizedBox(width: 15,),
              Icon(Icons.home_outlined),             
            ],
          ),
        ],
      ),
    );
  }
}