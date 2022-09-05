import '../models/consts.dart';
class Location_Helper {

  static String getLocationPreviewImage({double latitude, double longtitude}) 
  {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longtitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longtitude&key=$GOOGLE_API_KEY';
  }
}