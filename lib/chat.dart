import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';


var _scaffoldContext;
var currentUserEmail;
class Chat extends StatefulWidget {

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  String name;
  String avatar;
  String userCompany;

  @override
  initState() {
    getStringValue();
    super.initState();
  }

  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user');
      avatar = prefs.getString('avatar');
      currentUserEmail = prefs.getString('user');
      userCompany= prefs.getString('company');
    });

  }

  final TextEditingController _textEditingController =
  new TextEditingController();
  bool _isComposingMessage = false;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Group Chat"),
          backgroundColor: const Color(0xff016836),
          elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new StreamBuilder<QuerySnapshot> (
                  stream: Firestore.instance.collection('messages').where('company', isEqualTo: userCompany)
                      .orderBy('time').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    return snapshot.hasData ? new ListView(
                        reverse: false,
                      children: snapshot.data.documents.map((DocumentSnapshot messageSnapshot) {
                        return new ChatMessageListItem(
                          messageSnapshot: messageSnapshot,
                        );
                      }).toList(),
                    ): const CircularProgressIndicator();

                  },
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration:
                new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              new Builder(builder: (BuildContext context) {
                _scaffoldContext = context;
                return new Container(width: 0.0, height: 0.0);
              })
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border: new Border(
                  top: new BorderSide(
                    color: Colors.grey[200],
                  )))
              : null,
        ));
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });
    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    Firestore.instance.collection('messages')
        .add({
      'text': messageText,
      'imageUrl': imageUrl,
      'senderName': name,
      'senderPhotoUrl': avatar,
      'time': DateTime.now(),
      'company': userCompany,
    });
  }
}


class ChatMessageListItem extends StatelessWidget {
  final DocumentSnapshot messageSnapshot;
  final Animation animation;

  ChatMessageListItem({this.messageSnapshot, this.animation});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: currentUserEmail == messageSnapshot.data['senderName']
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(messageSnapshot.data['senderName'],
                        style: new TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: messageSnapshot.data['imageUrl'] != null
                          ? new Image.network(
                        messageSnapshot.data['imageUrl'],
                        width: 250.0,
                      )
                          : new Text(messageSnapshot.data['text']),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(DateFormat('dd-MMM-yy – kk:mm').format(messageSnapshot.data['time'].toDate()),
                      style: new TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),

    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(messageSnapshot.data['senderName'],
                        style: new TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: messageSnapshot.data['imageUrl'] != null
                          ? new Image.network(
                        messageSnapshot.data['imageUrl'],
                        width: 250.0,
                      )
                          : new Text(messageSnapshot.data['text']),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  new Text(DateFormat('dd-MMM-yy – kk:mm').format(messageSnapshot.data['time'].toDate()),
                      style: new TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
