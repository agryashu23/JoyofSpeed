import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ShopNearMeScreen extends StatefulWidget {
  const ShopNearMeScreen({Key? key, required this.latitude ,required this.longitude}) : super(key: key);
  final double latitude;
  final double longitude;

  @override
  State<ShopNearMeScreen> createState() => _ShopNearMeScreenState();
}

class _ShopNearMeScreenState extends State<ShopNearMeScreen> {

  // created controller for displaying Google Maps
  Completer<GoogleMapController> _controller = Completer();

  // given camera position


  // Uint8List? marketimages;
  // List<String> images = ['assets/images/marker.png'];

  // created empty list of markers
  final List<Marker> _markers = [];

  // created list of coordinates of various locations
  final List<LatLng> _latLen = <LatLng>[

    LatLng(25.321684, 82.987289),
    LatLng(25.247570, 83.00784),
    LatLng(25.261386, 82.965778),
    LatLng(24.879999, 74.629997),
    LatLng(16.166700, 74.833298),
    LatLng(12.971599, 77.594563),
  ];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initialize loadData method
    loadData();
  }

  // created method for displaying custom markers according to index
  loadData() async{
    for(int i=0 ;i<_latLen.length; i++){
      // final Uint8List markIcons = await getImages(images[0], 50);

      // makers added according to index
      _markers.add(
          Marker(
            // given marker id
            markerId: MarkerId(i.toString()),
            // given marker icon
            icon: BitmapDescriptor.defaultMarker,
            // given position
            position: _latLen[i],
            infoWindow: InfoWindow(
              // given title for marker
              title: 'Shop: '+i.toString(),
            ),
          )
      );
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition _kGoogle = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 11,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff6ab36),
        // on below line we have given title of app
        title: Text("Choose Shops"),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            // given camera position
            initialCameraPosition: _kGoogle,
            // set markers on google map
            markers: Set<Marker>.of(_markers),
            // on below line we have given map type
            mapType: MapType.normal,
            // on below line we have enabled location
            myLocationEnabled: true,
            circles: {
              Circle( circleId: CircleId('currentCircle'),
                center: LatLng(widget.latitude,widget.longitude),
                radius: 10000,
                fillColor: Colors.blue.shade200.withOpacity(0.5),
                strokeColor:  Colors.blue.shade200.withOpacity(0.1),
              ),
            },
            myLocationButtonEnabled: true,
            // on below line we have enabled compass
            compassEnabled: true,
            // below line displays google map in our app
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
          ),
        ),
      ),
    );
  }
}