import 'package:Appo/Business_side/model/colors.dart';
import 'package:Appo/Business_side/screens/registration_screen1.dart';
import 'package:flutter/material.dart';

class RegisterationExplenationScreen extends StatelessWidget {
  static const routeName = '/explain';

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 159, 195, 212),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 70),
            Text(
              "!תודה שבחרת בנו",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 40),
            Text("באפשרותכם להגדיר את פרופיל העסק שלכם ואת השירותים הניתנים בו",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 12),
            Text("בדף הבית תוכלו להגדיר ולערוך בכל עת את שעות העבודה שלכם בקלות וביעילות",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: _deviceSize.height - _deviceSize.height*0.45),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              child: ElevatedButton(
                  child: const Text('המשך'),
                  onPressed: () {
                    Navigator.of(context)
                        .popAndPushNamed(BusinessRegistrationScreen1.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Palette.kToDark[600],
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ))),
            ),
          ]),
        ));
  }
}
