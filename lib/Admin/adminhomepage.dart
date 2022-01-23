import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:isaafoukom/Admin/paramedics_list.dart';
import 'package:isaafoukom/Admin/send_ambulance.dart';
import 'package:isaafoukom/Admin/track_ambulance.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../mapscreen.dart';

class Adminhomepage extends StatefulWidget {
  @override
  _AdminhomepageState createState() => _AdminhomepageState();
}

class _AdminhomepageState extends State<Adminhomepage> {


  @override
  void initState() {
    get_list();
  }

  @override
  void dispose() {

    super.dispose();
  }



  List<dynamic> tags;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.1),
      body: SingleChildScrollView(
          child: Column(
            children: [

             tags != null
              ?
              Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: tags.length,
                    itemBuilder: (context, index) => new PationRow(
                      index: index,
                      id: tags[index]["id"].toString(),
                      longi: tags[index]["longi"].toString(),
                      altitude: tags[index]["altitude"].toString(),
                    ),

                  ),
                )
              : Container(
                  color: Colors.blue.withOpacity(0.1),
                  child: Center(
                    child: Text(" there is no emergency all"),
                  ),
                ),
            Card(
            child: Container(
              height: MediaQuery.of(context).size.height *0.15,
              width:MediaQuery.of(context).size.width *0.50 ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(" track ",style: TextStyle(fontSize: 20),),
                  IconButton(
                    icon: Icon(Icons.directions,size: 50,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ParamedicsList();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  void get_list() {
      try {
        setState(() async {
   var request = http.Request('POST',
              Uri.parse(APIA+'list_location_notserviced'));

          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {
            var tagsJson = json.decode(await response.stream.bytesToString());
            setState(() {
              tags = tagsJson != null ? List.from(tagsJson["data"]) : null;
              print(tags);
            });
          } else {
            print(response.reasonPhrase);
          }
        });
      } catch (e) {}

  }
}

class PationRow extends StatelessWidget {
  final index;
  String id, longi, altitude;

  PationRow({this.index, this.id, this.longi, this.altitude});

  @override
  Widget build(BuildContext context) {
    final pationCardContent = new Container(
      child: new Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              (index + 1).toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            new Image.asset(
              'assets/images/first_aid.png',
            ),
            Container(
              width: 10,
            ),
            Row(
              children: [
                new Container(
                  child: Text(
                    "Send emergency ",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                new Container(
                  child: Material(
                    child: new IconButton(
                      color: Color(0xff0254f5),
                      iconSize: MediaQuery.of(context).size.height * 0.05,
                      icon: Icon(Icons.directions),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SendAmbulance(
                                  id: id, longi: longi, altitude: altitude);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    final pationCard = new Container(
      child: pationCardContent,
      height: 110.0,
      decoration: new BoxDecoration(
        color: new Color(0xFFFFFFFF),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(10.0),
      ),
    );

    return new Container(
      margin: EdgeInsets.all(15.0),
      child: new Column(
        children: <Widget>[
          pationCard,
        ],
      ),
    );
  }
}
