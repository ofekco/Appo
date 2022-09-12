import 'package:Appo/models/Business.dart';
import 'package:Appo/models/authentication.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Appo/models/businesses.dart';
import 'package:Appo/widgets/myNext_item.dart';
import 'package:Appo/widgets/wrap_inkwell.dart';
import 'package:provider/provider.dart';
import '../models/authentication.dart';
import '../models/types.dart';
import '../widgets/searchBar.dart';
import './business_list_screen.dart';
import '../screens/business_details_screen.dart';
import '../widgets/favorite_item.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
// Override behavior methods and getters like dragDevices
@override
Set<PointerDeviceKind> get dragDevices => {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
};
}

class HomeScreen extends StatefulWidget {
static const routeName = '/home';
@override
State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
Businesses userBusinessesInstance;
Types typesProvider;

void initState() { 
  Types typesProvider = Provider.of<Types>(context, listen: false);
  typesProvider.getTypes(); //load types list 
  userBusinessesInstance = Provider.of<Businesses>(context, listen: false);
  userBusinessesInstance.ClientId = Provider.of<Authentication>(context, listen: false).currentUser.userId;
  userBusinessesInstance.getAllBusinesses();

  userBusinessesInstance.getFavorites();
  userBusinessesInstance.getMyUpComingBookings(); //change the id according to the id of the user
  super.initState();
}

void itemClicked(BuildContext ctx, Business bis) 
{
  Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
    return BusinessDetailsScreen(bis, userBusinessesInstance.ClientId);
    })
  );
}

Widget buildSectionTitle(BuildContext context, String title){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15), 
    width: double.infinity, alignment: Alignment.topRight, height: 30,
    child: Text(title, 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
        ),
  );
}

List<Widget> buildUserAppointmentsList() {
  List<Widget> res = [];
  //userBusinessesInstance.MyBookings.map((appo) 
  if(userBusinessesInstance.MyBookings.isNotEmpty)
  { 
    userBusinessesInstance.MyBookings.forEach((appo) {
      if(!(appo.date.isBefore(DateTime.now())))
      {
        Business bis = userBusinessesInstance.findByID(appo.businessId);
        res.add(WrapInkWell(MyNextItem(appo, bis), () => itemClicked(context, bis)));
      }
    });
  }

  return res;
}

void searchIconClick(BuildContext ctx)
{
  print('clicked');
  Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
    return BusinessListScreen();
    })
  );
}

@override
Widget build(BuildContext context) {
  var size = MediaQuery.of(context).size;
  var PageHeight = size.height;
  var PageWidth = size.width;

  return SingleChildScrollView(
    controller: ScrollController(),
    child: ChangeNotifierProvider.value( //listen to changes in Businesses
      value: typesProvider,
      child: Column(children: [
        SizedBox(height: 20,),

        //seacrh box
        Container(
          height: PageWidth/6, 
          child: SearchBar(() => searchIconClick(context))
        ),
        buildSectionTitle(context, 'התורים הקרובים שלי'),
        
        Container(height: PageHeight*0.35, width: double.infinity, alignment: Alignment.topRight,
          child: Consumer<Businesses>( builder: (_, userBusinessesInstance, __) => 
            userBusinessesInstance.BusinessesList.length < 1 || 
            userBusinessesInstance.MyBookings.length < 1 ? //check if the data is there
              Container(child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 10),
                child: Text("אין תורים להצגה", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16,
                )),
              ),) :
              ListView(padding: const EdgeInsets.all(10), shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                reverse: true,
                children: buildUserAppointmentsList(),
                
              ),
            ),
          ),
          
          buildSectionTitle(context, 'עסקים שאהבתי'),
      
          Container(height: PageHeight*0.3, width: double.infinity, alignment: Alignment.topRight,
            child: 
              Consumer<Businesses>( 
                builder: (_, userBusinessesInstance, __) => 
                  userBusinessesInstance.Favorites.length < 1 ? 
                    Container(child: Padding(
                      padding: const EdgeInsets.only(right: 20, top: 10),
                      child: Text("עדיין לא שמרת עסקים מועדפים", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 16,
                      )),
                    )) :
                    ListView.builder(
                    itemBuilder: (ctx, index) =>  
                      WrapInkWell(
                        FavoriteItem(userBusinessesInstance.Favorites[index]), 
                        () => itemClicked(ctx, userBusinessesInstance.Favorites[index])
                      ),
                    itemCount: userBusinessesInstance.Favorites.length,
                    padding: const EdgeInsets.all(10), 
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal, 
                    physics: const AlwaysScrollableScrollPhysics(), 
                    reverse: true,
                                ),
                  ),
                ),
            ],
          ),
      ),
    );
  }
}