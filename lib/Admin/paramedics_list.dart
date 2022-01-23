import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'track_ambulance.dart';

class ParamedicsList extends StatefulWidget {
  const ParamedicsList({Key key}) : super(key: key);

  @override
  _ParamedicsListState createState() => _ParamedicsListState();
}

class _ParamedicsListState extends State<ParamedicsList> {
  @override
  void initState() {
    get_list();
  }

  @override
  void dispose() {}

  List<dynamic> tags;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.1),
      body: SingleChildScrollView(
          child: Column(
        children: [
          tags != null
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: tags.length,
                    itemBuilder: (context, index) => new ParamedicRow(
                      index: index,
                      id: tags[index]["id"].toString(),
                    ),
                  ),
                )
              : Container(
                  color: Colors.blue.withOpacity(0.1),
                  child: Center(
                    child: Text(" there is no Paramedics"),
                  ),
                )
        ],
      )),
    );
  }

  Future<void> get_list() async {
    try {
          var request = http.Request('POST', Uri.parse(APIA+'list_medics'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var tagsJson = json.decode(await response.stream.bytesToString());
        setState(() {
          tags = tagsJson != null ? List.from(tagsJson["data"]) : null;
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {}
  }
}

class ParamedicRow extends StatelessWidget {
  final index;
  final String id;

  ParamedicRow({this.index, this.id});

  @override
  Widget build(BuildContext context) {
    final ParamedicCardContent = new Container(
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
                    "Track ambulance ",
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
                              return TrackAmbulance(id: id);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    final ParamedicCard = new Container(
      child: ParamedicCardContent,
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
          ParamedicCard,
        ],
      ),
    );
  }
}
