import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:joy_of_speed/screens/class/location.dart';


class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {

  List<Locations> locations = [];
  String status = '';
  Prediction? place;
  Placemark? places;
  String? _currentAddress;
  LatLng? _currentPosition;
  // Position? _currentPosition;
  String googleApikey = "AIzaSyC1A7zM67k09UeHvPcf0DJo_OHcx9pdwQc";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(25.2620319, 82.9858812);
  String location = "Search Location";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search Location"),
          backgroundColor: Color(0xfff6ab36),
        ),
        body: Stack(
            children:[
              GoogleMap( //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                initialCameraPosition: CameraPosition( //innital position in map
                  target: startLocation, //initial position
                  zoom: 15.0, //initial zoom level
                ),
                mapType: MapType.normal, //map type
                onMapCreated: (controller) { //method called when map is created
                  setState(() {
                    mapController = controller;
                  });
                },
              ),
              // Align(
              //     alignment: Alignment.topCenter,
              //     child: SearchMapPlaceWidget(
              //       hasClearButton: true,
              //       apiKey: googleApikey,
              //       bgColor: Colors.white,
              //       textColor: Colors.black,
              //       placeType: PlaceType.address,
              //       placeholder: "Enter the location",
              //       onSelected: (Place place)async{
              //         Geolocation? geolocation = await place.geolocation;
              //         mapController!.animateCamera(CameraUpdate.newLatLng(geolocation!.coordinates));
              //         mapController!.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds,0));
              //
              //       },
              //
              //     )
              //
              // ),




              //search autoconplete input
              Positioned(  //search input bar
                  top:10,
                  child: InkWell(
                      onTap: () async {
                        place = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: googleApikey,
                            mode: Mode.overlay,
                            language: 'en',
                            radius: 1000000,
                            types: [""],
                            strictbounds: false,
                            components: [Component(Component.country, 'in')],
                            //google_map_webservice package
                            onError: (err){
                              print(err);
                            }
                        );

                        if(place != null){
                          setState(() {
                            location = place!.description.toString();
                          });

                          //form google_maps_webservice package
                          GoogleMapsPlaces plist = GoogleMapsPlaces(apiKey:googleApikey,
                            apiHeaders: await GoogleApiHeaders().getHeaders(),
                            //from google_api_headers package
                          );
                          String placeid = place!.placeId ?? "0";
                          PlacesDetailsResponse detail = await plist.getDetailsByPlaceId(place!.placeId.toString());
                          final lat = detail.result.geometry!.location.lat;
                          final lang = detail.result.geometry!.location.lng;
                          _currentPosition = LatLng(lat, lang);
                          var newlatlang = LatLng(lat, lang);
                          await placemarkFromCoordinates(
                              lat, lang)
                              .then((List<Placemark> placemarks) {
                            places = placemarks[0];
                            setState(() async{
                              _currentAddress =
                              '${places!.name}, ${places!.street}, ${places!.subLocality},';
                              // joy.addDirections();
                            });
                          }).catchError((e) {
                            debugPrint(e);
                          });
                          setState(() {
                            mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 18)));

                          });
                          //move map camera to selected place with animation
                        }

                      },
                      child:Padding(
                        padding: EdgeInsets.all(15),
                        child: Card(
                          child: Container(
                              padding: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width - 40,
                              child: ListTile(
                                title:Text(location, style: TextStyle(fontSize: 18),),
                                trailing: Icon(Icons.search),
                                dense: true,
                              )
                          ),
                        ),
                      )
                  )
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: (){

                    Navigator.pop(context, {
                      'latitude':_currentPosition!.latitude,
                      'longitude':_currentPosition!.longitude,
                      'postalCode':places!.postalCode, 'address':_currentAddress,'area': places!.subAdministrativeArea,'aArea': places!.administrativeArea,
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom:20.h),
                    alignment: Alignment.center,
                    height: 40.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ),
                ),
              ),
            ]
        )
    );
  }
}
