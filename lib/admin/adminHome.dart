import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lorry/admin/Admin.dart';
import 'package:e_lorry/admin/appUsers.dart';
import 'package:e_lorry/admin/carDetails.dart';
import 'package:e_lorry/chat.dart';
import 'package:e_lorry/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'emails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fields/carFields.dart';
import 'fields/Fields.dart';
class adminHome extends StatefulWidget {
  @override
  _adminHomeState createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  initState() {
    // TODO: implement initState
    super.initState();
    getStringValue();
    _formCheck();

  }

  String userCompany;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
    });

  }
  bool _created = true;
  String state;
  String truckPostForm;
  String truckSerForm;
  String carForm;
  _formCheck() async {

    var collectionReference = Firestore.instance.collection('companies');
    var query = collectionReference.where("company", isEqualTo: userCompany );
    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length > 0) {
        querySnapshot.documents.forEach((document)
        async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('carForm', document['carForm']);
          prefs.setString('truckPT', document['truckPostForm']);
          prefs.setString('truckSer', document['truckSerForm']);
          setState(() {
            truckPostForm = document['truckPostForm'];
            carForm = document['carForm'];
            truckSerForm = document['truckSerForm'];

          });


          if( carForm != "created" ) {
            setState(() {
              _created = false;
            });
          }
          if( truckPostForm != "created" ) {
            setState(() {
              _created = false;
            });
          }
          if( truckSerForm != "created" ) {
            setState(() {
              _created = false;
            });
          }

        });
      }
    });
  }
  Logout()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    new LoginScreen()), (Route<dynamic> route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff016836),
      appBar: new AppBar(
        title: new Text("App Admin"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: const Color(0xff016836),
      ),
      //drawer: new Drawer(),
      body: Stack(
        children: [
          Positioned(
              bottom: 20,
              left: 300,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PopupMenuButton(
                        icon: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: new Icon(Icons.exit_to_app,
                              color: Colors.red[900],)),
                        onSelected: (String value) {
                          switch (value) {
                            case 'Logout':
                              Logout();
                              break;
                          // Other cases for other menu options
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: "Logout",
                            child: Row(
                              children: <Widget>[
                                Text("Logout"),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                new SizedBox(
                  height: 20.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    new GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (context) => AppUsers()));
                      },
                      child: new CircleAvatar(
                        maxRadius: 70.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.person),
                            new SizedBox(
                              height: 10.0,
                            ),
                            new Text("App Users"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                new SizedBox(
                  height: 20.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (context) => Admin()));
                      },
                      child: new CircleAvatar(
                        maxRadius: 70.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.local_shipping),
                            new SizedBox(
                              height: 10.0,
                            ),
                            new Text("Trucks"),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (context) => CarsList()));
                      },
                      child: new CircleAvatar(
                        maxRadius: 70.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.directions_car),
                            new SizedBox(
                              height: 10.0,
                            ),
                            new Text("Cars"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                new SizedBox(
                  height: 20.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (context) => Chat()));
                      },
                      child: new CircleAvatar(
                        maxRadius: 70.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.chat),
                            new SizedBox(
                              height: 10.0,
                            ),
                            new Text("Group chat"),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (context) => reportEmails()));
                      },
                      child: new CircleAvatar(
                        maxRadius: 70.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.notifications_active),
                            new SizedBox(
                              height: 10.0,
                            ),
                            new Text("Emails"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                new SizedBox(
                  height: 10.0,
                ),

                _created == true ?
                Offstage(): Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                  child: new InkWell(
                    onTap: () {
                      Navigator.of(context).push(new CupertinoPageRoute(
                          builder: (BuildContext context) => new fieldCats(
                            truckPostForm: truckPostForm,
                            carForm: carForm,
                            truckSerForm: truckSerForm,
                          )));
                    },
                    child: new Container(
                      height: 60.0,
                      margin: new EdgeInsets.only(top: 5.0),
                      child: new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Container(
                          margin: new EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 2.0),
                          height: 60.0,
                          decoration: new BoxDecoration(
                              color: Colors.green,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0))),
                          child: new Center(
                              child: new Text(
                                "Create Mechanic Form fields",
                                style: new TextStyle(
                                    color: const Color(0xffffffff),),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),

          ),
        ],
      ),
    );
  }
}