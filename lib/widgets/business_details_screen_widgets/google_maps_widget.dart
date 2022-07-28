import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsView extends StatefulWidget {
  double lat;
  double long;

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(32.065374, 34.773102),
    zoom: 10,
  );
  
  GoogleMapsView(this.lat, this.long);

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
        initialCameraPosition: GoogleMapsView._initialPosition,
        markers: _markers,
        zoomControlsEnabled: true,
      );
    }
}

