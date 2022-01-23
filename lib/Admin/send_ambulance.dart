import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:isaafoukom/Admin/adminhomepage.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class SendAmbulance extends StatefulWidget {
  final String id, longi, altitude;

  const SendAmbulance({
    Key key,
    this.id,
    this.longi,
    this.altitude,
  }) : super(key: key);

  @override
  _SendAmbulanceState createState() => _SendAmbulanceState();
}

class _SendAmbulanceState extends State<SendAmbulance> {
  String uid = null;
  double longitude = null;
  double latitude = null;

  bool loading;

  var start_currentPostion;

  GoogleMapController mapController;
  Location location = Location();

  GoogleMapController _controller;

  List<LatLng> patiens = [];

  Marker marker;
  var mark = HashSet<Marker>();
  bool showmap = false;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    // double zooom = _cntlr.getZoomLevel() as double;

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                double.parse(widget.altitude), double.parse(widget.longi)),
            zoom: 15),
      ),
    );
  }

  Future<void> Pation() async {
    mark.add(
      Marker(
        //  icon: BitmapDescriptor.fromBytes(markerIcon),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(5, 5)), 'assets/images/help22.png'),
        markerId: MarkerId("1"),
        position:
            LatLng(double.parse(widget.altitude), double.parse(widget.longi)),
        infoWindow: InfoWindow(
          title: 'help me',
        ),
      ),
    );
  }

  search() async {
  var request =
        http.Request('POST', Uri.parse(APIA+'list_medics'));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      List<dynamic> tags;
      var tagsJson = json.decode(await response.stream.bytesToString());
      tags = tagsJson != null ? List.from(tagsJson["data"]) : null;

      for (int i = 0; i < tags.length; i++) {
        addMedic(tags[i]);
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    getLoc();

    // TODO: implement initState
    super.initState();
  }



  @override
  void dispose() {
    mapController.dispose();
    _controller.dispose();
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: showmap
            ? GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(widget.altitude),
                      double.parse(widget.longi)),
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
    Pation();
    search();
  }

  Future<void> addMedic(tag) async {
    print(tag.toString());

   var request = http.MultipartRequest(
        'POST', Uri.parse(APIA+'medic/current_location'));
    request.fields.addAll({'medic_id': tag["id"].toString()});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData =
          json.decode(await response.stream.bytesToString())['data'];
      print("responseData       " + responseData.toString());


      BitmapDescriptor ico= await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(5, 5)),
          'assets/images/ambulance22.png');

      setState(()  {
        mark.add(
          Marker(
           icon: ico,
            markerId: MarkerId(tag["id"].toString()),
            position: LatLng(double.parse(responseData['alti'].toString()),
                double.parse(responseData['long'].toString())),
            infoWindow: InfoWindow(
              title: ' ',
              onTap: () {
               sendMedic(widget.id,tag["id"].toString());
              },
            ),
          ),
        );
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> sendMedic(String pat_id, String med_id) async {

    var request = http.MultipartRequest('POST', Uri.parse(APIA+'assign_medic'));
    request.fields.addAll({
      'medic_id': med_id,
      'request_id': pat_id
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      Toast.show(
          "The patient's location has been sent to the nearby ambulance",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Adminhomepage();
          },
        ),
      );


    }
    else {
    print(response.reasonPhrase);
    }


  }
}
