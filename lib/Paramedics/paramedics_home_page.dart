import 'dart:collection';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../main.dart';

class ParamedicsHomePage extends StatefulWidget {
  final String id;
  const ParamedicsHomePage({Key key, this.id}) : super(key: key);

  @override
  _ParamedicsHomePageState createState() => _ParamedicsHomePageState();
}

class _ParamedicsHomePageState extends State<ParamedicsHomePage> {

  bool showmap = false;
  Location location = Location();
  GoogleMapController _controller;
    var mark = HashSet<Marker>();

  LocationData _currentPosition;
  LatLng _initialcameraposition;


  @override
  void initState() {
    getLoc();
    // TODO: implement initState
    super.initState();
  }



  @override
  void dispose() {
    _controller.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: showmap
            ? GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: _initialcameraposition,
            zoom: 15,
          ),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          markers: mark,
        )
            : Container(
          color: Colors.blue.withOpacity(0.1),
          child: Center(
            child: Text("loading . . . . . . ."),
          ),
        ));
  }


  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;



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

      setState(()  {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition.latitude, _currentPosition.longitude);
        showmap = true;
      });
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(_initialcameraposition.latitude, _initialcameraposition.longitude), zoom: 15),
          ),
        );

   updatelocation();



    });
  }

  Future<void> updatelocation() async {

    var request = http.MultipartRequest('POST', Uri.parse(APIA+'medic/update_location'));
    request.fields.addAll({
      'medic_id': widget.id,
      'long': _initialcameraposition.longitude.toString(),
      'alti': _initialcameraposition.latitude.toString()
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

}
