import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class TrackAmbulance extends StatefulWidget {
  final String id;

  const TrackAmbulance({Key key, this.id}) : super(key: key);

  @override
  _TrackAmbulanceState createState() => _TrackAmbulanceState();
}

class _TrackAmbulanceState extends State<TrackAmbulance> {
  double longitude = null;
  double latitude = null;

  bool loading;

  GoogleMapController mapController;
  Location location = Location();

  GoogleMapController _controller;

  Marker marker;
  var mark = HashSet<Marker>();
  bool showmap = false;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(21.44, 39.22), zoom: 12),
      ),
    );
  }

  Timer timer;

  @override
  void initState() {

    getLoc();
    getParamedic();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: showmap
            ? GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(21.44, 39.22),
                  zoom: 15,
                ),
                onMapCreated: _onMapCreated,
                markers: mark,
              )
            : Container(
                color: Colors.blue.withOpacity(0.1),
                child: Center(
                  child: Text("loading . . . . . . ."),
                ),
              ));
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

    setState(() {
      showmap = true;
    });
  }

  Future<void> getParamedic() async {
    try {
          var request = http.MultipartRequest('POST', Uri.parse(APIA+'medic/current_location'));
      request.fields.addAll({'medic_id': widget.id});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseData =
        json.decode(await response.stream.bytesToString())['data'];

          longitude = double.parse(responseData['long'].toString());
          latitude = double.parse(responseData['alti'].toString());

        BitmapDescriptor ic = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(5, 5)),
            'assets/images/ambulance22.png');
        mark.clear();
        mark.add(
          Marker(
            icon: ic,
            markerId: MarkerId("1"),
            position: LatLng(latitude, longitude),
          ),
        );
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
          ),
        );
        setState(() {});

      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {}

    timer = Timer(Duration(milliseconds: 5000), () async {
         getParamedic();
    });
  }
}
