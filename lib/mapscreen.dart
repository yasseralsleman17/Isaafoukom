import 'package:flutter/material.dart';
import 'package:isaafoukom/Welcome/welcome_screen.dart';
import 'package:isaafoukom/main.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Mapscreen extends StatefulWidget {


  final String report;


  const Mapscreen({
    Key key,
    this.report,
  }) : super(key: key);


  @override
  _MapscreenState createState() => _MapscreenState();
}

class _MapscreenState extends State<Mapscreen> {
  LocationData _currentPosition;
  GoogleMapController mapController;
  Location location = Location();

  GoogleMapController _controller;
  LatLng _initialcameraposition;

  bool next = false;

  @override
  void initState() {
    getLoc();
    // TODO: implement initState
    super.initState();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    location.onLocationChanged.listen((l) {

      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 12),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: SafeArea(
          child: Container(
            color: Colors.blue.withOpacity(0.1),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.84,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Stack(
                      children: [
                        _initialcameraposition == null
                            ? Container()
                            : GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _initialcameraposition,
                          ),
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.10,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Center(
                      child: !next
                          ? Container()
                          : Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.95,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40),
                            color: Color(0xFF2A66EC),
                            onPressed: () async {
                              var request = http.MultipartRequest(
                                  'POST',
                                  Uri.parse(APIA+'add_location'));


                              request.fields.addAll({
                                'altitude': _initialcameraposition
                                    .latitude
                                    .toString(),
                                'longi': _initialcameraposition.longitude
                                    .toString(),
                                'report': widget.report
                              });

                              http.StreamedResponse response =
                              await request.send();

                              if (response.statusCode == 200) {
                                print(await response.stream
                                    .bytesToString());
                                Toast.show("An emergency has been sent, wait for the ambulance to arrive ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return WelcomeScreen();
                                    },
                                  ),
                                );

                              } else {
                                print(response.reasonPhrase);
                              }
                            },
                            child: Text(
                              "Send emergency call",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    location.onLocationChanged.listen((LocationData currentLocation) {



      if (!mounted) return;

      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition.latitude, _currentPosition.longitude);
        next = true;
      });
    });
  }
}