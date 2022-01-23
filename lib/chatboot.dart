import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:isaafoukom/Welcome/welcome_screen.dart';
import 'dart:convert';

import 'package:isaafoukom/mapscreen.dart';
import 'package:isaafoukom/main.dart';

class Chatboot extends StatefulWidget {
  Chatboot({Key key}) : super(key: key);

  @override
  _ChatbootState createState() => _ChatbootState();
}

class _ChatbootState extends State<Chatboot> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  String report=" ";

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void Response(responseData) async {
    report+=responseData +" \n";
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: responseData,
      name: "اسعافكم",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _handleSubmitted(String text) async {
    report+=text +" \n";
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "you",
      type: true,
    );
    var request = http.MultipartRequest(
        'POST', Uri.parse(APIA+'messanger'));
    request.fields.addAll({'query': text});

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseData =
          json.decode(await response.stream.bytesToString())['data'];
      setState(() {
        _messages.insert(0, message);
      });
      Response(responseData);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("your helping bot"),
        actions: [
          IconButton(
            icon: Icon(Icons.medical_services),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Mapscreen(report: report);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blue.withOpacity(0.1),
        child: new Column(children: <Widget>[
          new Flexible(
              child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          )),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ]),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(
          child: new Text('B'),
          backgroundColor: Color(0xFF013358),
        ),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                // width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: Color(0xFF98CDF6),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(29),
                      topRight: Radius.circular(29)),
                ),
                child: Container(
                    width: text.length > 30 ? 200 : null,
                    child: new Text(
                      text,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(0xFF1888DE),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(29),
                      topLeft: Radius.circular(29)),
                ),
                child: Container(
                    width: text.length > 30 ? 200 : null,
                    child: new Text(
                      text,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(
          child: new Text(
            this.name[0],
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFF013358),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
