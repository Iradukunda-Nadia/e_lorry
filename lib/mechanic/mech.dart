import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat.dart';
import 'Forms.dart';
import 'car.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'truck.dart';
import 'PTform.dart';

class Mech extends StatefulWidget {
  @override
  _MechState createState() => _MechState();
}

class _MechState extends State<Mech> {
  initState() {
    // TODO: implement initState
    super.initState();
    getStringValue();

  }

  String userCompany;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
    });

  }
  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("trucks").where('company', isEqualTo: userCompany).orderBy('plate').getDocuments();
    return qn.documents;

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("SELECT TRUCK"),
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

      body: Container(
        child: new Column(
          children: <Widget>[

            new Flexible(
              child: FutureBuilder(
                  future: getUsers(),
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text("Loading... Please wait"),
                      );
                    }if (snapshot.data == null){
                      return Center(
                          child: Text("The are no saved trucks"),);
                    }else{
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          String counter = (index+1).toString();
                          return new GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new TruckForms(

                                truckNumber: snapshot.data[index].data["plate"],
                                driverName: snapshot.data[index].data["driver"],
                                driverNumber: snapshot.data[index].data["phone"],
                                driverID: snapshot.data[index].data["ID"],
                                turnboy: snapshot.data[index].data["turnboy"],
                                truckType: snapshot.data[index].data["type"],


                              )));
                            },
                            child: new Card(
                              child: Stack(
                                alignment: FractionalOffset.topLeft,
                                children: <Widget>[
                                  new ListTile(
                                    leading: new CircleAvatar(
                                      backgroundColor: Colors.red[900],
                                      child:new Text(counter,style: new TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0,
                                          color: Colors.white),),
                                    ),
                                    title: new Text("${snapshot.data[index].data["plate"]}",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18.0,
                                          color: Colors.red[900]),),
                                    subtitle: new Text("Driver : ${snapshot.data[index].data["driver"]}",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0,
                                          color: Colors.grey),),
                                  ),

                                ],
                              ),
                            ),
                          );

                        },
                      );

                    }
                  }),)
          ],
        ),
      )
    );
  }
}

class carsList extends StatefulWidget {
  @override
  _carsListState createState() => _carsListState();
}

class _carsListState extends State<carsList> {
  initState() {
    // TODO: implement initState
    super.initState();
    getStringValue();

  }

  String userCompany;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
    });

  }
  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("cars").where('company', isEqualTo: userCompany).orderBy('plate').getDocuments();
    return qn.documents;

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("SELECT CAR"),
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

        body: Container(
          child: new Column(
            children: <Widget>[

              new Flexible(
                child: FutureBuilder(
                    future: getUsers(),
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading... Please wait"),
                        );
                      }if (snapshot.data == null){
                        return Center(
                          child: Text("The are no saved trucks"),);
                      }else{
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            String counter = (index+1).toString();
                            return new GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new Car(

                                  truckNumber: snapshot.data[index].data["plate"],
                                  driverName: snapshot.data[index].data["driver"],
                                  driverNumber: snapshot.data[index].data["phone"],
                                  driverID: snapshot.data[index].data["ID"],
                                  truckType: snapshot.data[index].data["type"],


                                )));
                              },
                              child: new Card(
                                child: Stack(
                                  alignment: FractionalOffset.topLeft,
                                  children: <Widget>[
                                    new ListTile(
                                      leading: new CircleAvatar(
                                          backgroundColor: Colors.red[900],
                                          child: new Text(counter,style: new TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.0,
                                              color: Colors.white),),
                                      ),
                                      title: new Text("${snapshot.data[index].data["plate"]}",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18.0,
                                            color: Colors.red[900]),),
                                      subtitle: new Text("Driver : ${snapshot.data[index].data["driver"]}",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.0,
                                            color: Colors.grey),),
                                    ),

                                  ],
                                ),
                              ),
                            );

                          },
                        );

                      }
                    }),)
            ],
          ),
        )
    );
  }
}





