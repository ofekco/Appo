import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsView extends StatefulWidget {
  double lat;
  double long;
  
  GoogleMapsView(this.lat, this.long);

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(32.565656, 34.773102),
    zoom: 10,
  );
  
  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};


  void _onMapCreated(GoogleMapController controller) {
      setState(() {
        _markers.add(
        Marker(
          markerId: MarkerId("id-1"),
          position: LatLng(widget.lat, widget.long)
        ));
      });
  }

  @override
    Widget build(BuildContext context) {
      return GoogleMap(  
        mapType: MapType.normal,  
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.lat, widget.long),
            zoom: 20,
          ),
        markers: _markers,
        zoomControlsEnabled: true,
      );
    }
}

