import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lorry/manager/carService.dart';
import 'package:e_lorry/user/post_trip.dart';
import 'package:e_lorry/user/requisition.dart';
import 'package:e_lorry/user/truck_service.dart';
import 'package:e_lorry/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chat.dart';
import '../login.dart';
import 'document.dart';

class Accounts extends StatefulWidget {
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  initState() {
    // TODO: implement initState
    super.initState();
    getStringValue();

  }

  String userCompany;
  String currentUser;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
      currentUser = prefs.getString('user');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MATERIALS REQUESTED"),
        centerTitle: true,
        backgroundColor: Colors.red[900],
        actions: <Widget>[

          new Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              new IconButton(icon: new Icon(Icons.chat,
                color: Colors.white,)
                  , onPressed: (){
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new Chat()
                    ));
                  }),

            ],
          )
        ],
      ),

      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/lo.png",
                    fit: BoxFit.contain,
                    height: 100.0,
                    width: 300.0,
                  ),
                  Text("Accounts"),
                ],
              ),
            ),

            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(Icons.receipt,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Requests"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new Requisition()));
              },
            ),

            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(Icons.directions_car,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Truck Post Trip"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new Post()));
              },
            ),

            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(Icons.settings,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Truck Service"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new truckService()));
              },
            ),

            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(Icons.directions_car,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Car Sevice"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new carService()));
              },
            ),

            new Divider(),

            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(Icons.settings,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("LPO"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new prevLpo()));
              },
            ),

            new Divider(),
            new ListTile(
                trailing: new CircleAvatar(
                  child: new Icon(Icons.subdirectory_arrow_left,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Logout"),
                onTap: ()async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('email');
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new LoginScreen()
                  ));
                }
            ),


          ],
        ),
      ),
      body: Items(),
    );
  }
}

class Items extends StatefulWidget {
  @override
  _ItemsState createState() => _ItemsState();
}


class _ItemsState extends State<Items> {
  initState() {
    // TODO: implement initState
    super.initState();
    getStringValue();

  }

  String userCompany;
  String currentUser;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
      currentUser = prefs.getString('user');
    });

  }

  CollectionReference collectionReference =
  Firestore.instance.collection("request");

  DocumentSnapshot _currentDocument;

  _updateData() async {
    await Firestore.instance
        .collection('request')
        .document(_currentDocument.documentID)
        .updateData({'status': "checked"});
  }


  String radioItem = '';


  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: collectionReference.where('company', isEqualTo: userCompany).orderBy("date", descending: true).snapshots(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading... Please wait"),
              );
            }if (snapshot.hasData == false){
              return Center(
                child: Text("There are no pending requests"),);
            }else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data.documents[index];
                  return Card(
                    child: ListTile(
                      title: Text(doc.data['Item']),
                      subtitle: Text(doc.data['Truck']),
                      trailing: new Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red[900])
                        ),
                        child: Text(doc.data['status'], style: TextStyle(color: Colors.red[900]),),
                      ),
                      onTap: () async {
                        setState(() {
                          _currentDocument = doc;
                        });



                        if (doc.data['status'] != 'checked'){
                          _updateData();
                          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new Requests(

                            itemName: doc.data["Item"],
                            person: doc.data["Name"],
                            itemQuantity: doc.data["Quantity"],
                            itemNumber: doc.data["Truck"],
                            truckType: doc.data["tType"],
                            company: userCompany,
                            userName: currentUser,


                          )));
                        }


                      },
                    ),
                  );

                },
              );

            }
          }),

    );

  }
}
