import 'package:e_lorry/login.dart';
import 'package:e_lorry/mechanic/testForms.dart';
import 'package:e_lorry/user/fuelRequest.dart';
import 'package:e_lorry/user/requisition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat.dart';
import 'Forms.dart';
import 'car.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'truck.dart';
import 'PTform.dart';
import 'Requests/fuel.dart';
import 'Requests/parts.dart';

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
  String currentUser;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
      currentUser = prefs.getString('user');
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
      drawer: Drawer(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(currentUser),
                  ),
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
              title: new Text("Fuel Requests"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new fuel()));
              },
            ),
            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(Icons.receipt,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Part Requests"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new parts()));
              },
            ),

            new Divider(),

            new ListTile(
                trailing: new CircleAvatar(
                  child: new Icon(Icons.edit_attributes,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Edit Tyre Serials"),
                onTap: ()async {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new editTyre()
                  ));
                }
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
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  new LoginScreen()), (Route<dynamic> route) => false);
                }
            ),

          ],
        ),
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
                              Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new TestForms(

                                truckNumber: snapshot.data[index].data["plate"],
                                driverName: snapshot.data[index].data["driver"],
                                driverNumber: snapshot.data[index].data["phone"],
                                driverID: snapshot.data[index].data["ID"],
                                turnboy: snapshot.data[index].data["turnboy"],
                                truckType: snapshot.data[index].data["type"],
                                fR: snapshot.data[index].data["Front Right"],
                                fL: snapshot.data[index].data["Front Left"],
                                bL1: snapshot.data[index].data["Rear Left1"],
                                bL2: snapshot.data[index].data["Rear Left2"],
                                bR1: snapshot.data[index].data["Rear Right1"],
                                bR2: snapshot.data[index].data["Rear Right2"],
                                docID: snapshot.data[index].documentID,
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



class editTyre extends StatefulWidget {
  @override
  _editTyreState createState() => _editTyreState();
}

class _editTyreState extends State<editTyre> {
  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("trucks").where('company', isEqualTo: userCompany).orderBy('plate').getDocuments();
    return qn.documents;

  }



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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Trucks List"),
          backgroundColor: Colors.red[900],
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
                                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new TruckDetails(

                                  truckNumber: snapshot.data[index].data["plate"],
                                  fR: snapshot.data[index].data["Front Right"],
                                  fL: snapshot.data[index].data["Front Left"],
                                  bL1: snapshot.data[index].data["Rear Left1"],
                                  bL2: snapshot.data[index].data["Rear Left2"],
                                  bR1: snapshot.data[index].data["Rear Right1"],
                                  bR2: snapshot.data[index].data["Rear Right2"],
                                  docID: snapshot.data[index].documentID,

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

class TruckDetails extends StatefulWidget {
  String itemID;
  String truckNumber;
  String driverName;
  String driverNumber;
  String driverID;
  String turnboy;
  String turnboyID;
  String turnboyNumber;
  String itemDescription;
  String truckType;
  String docID;
  String fR;
  String fL;
  String bR1;
  String bL1;
  String bR2;
  String bL2;


  TruckDetails({
    this.fR,
    this.fL,
    this.bR1,
    this.bL1,
    this.bR2,
    this.bL2,

    this.truckType,
    this.docID,
    this.itemID,
    this.truckNumber,
    this.driverName,
    this.driverNumber,
    this.driverID,
    this.turnboy,
    this.turnboyID,
    this.turnboyNumber,
    this.itemDescription
  });
  @override
  _TruckDetailsState createState() => _TruckDetailsState();
}
class _TruckDetailsState extends State<TruckDetails> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _truck;
  String _driver;
  String _driverNo;
  String _driverID;
  String _turnBoy;
  String _turnBoyID;
  String _turnBoyNumber;

  String fL;
  String fR;
  String bL1;
  String bR1;
  String bL2;
  String bR2;





  void _submitCommand() {
    //get state of our Form
    final form = formKey.currentState;

    //`validate()` validates every FormField that is a descendant of this Form,
    // and returns true if there are no errors.
    if (form.validate()) {
      //`save()` Saves every FormField that is a descendant of this Form.
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _updateData();
    }
  }

  _updateData() async {
    await Firestore.instance
        .collection("trucks")
        .document(widget.itemID)
        .updateData({
      'Front Right': fR,
      'Front Left': fL,
      'Back Left1': bL1,
      'Back Right1': bR1,
      'Back Right2': bR2,
      'Back Left2': bL2,

    }).then((result) =>

        _showPopUp());
  }

  void _showPopUp() {
    final form = formKey.currentState;
    form.reset();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Data has been updated"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("close"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );

      },
    );
  }
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Truck Details"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: new Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              new Container(
                height: 200.0,
                decoration: new BoxDecoration(
                  color: Colors.grey.withAlpha(50),
                  borderRadius: new BorderRadius.only(
                    bottomRight: new Radius.circular(20.0),
                    bottomLeft: new Radius.circular(20.0),
                  ),
                ),
              ),
              new Card(child: new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:MainAxisSize.min,
                  children: <Widget>[
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Front Right',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue:widget.fR,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => fR = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Front Left',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue: widget.fL,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => fL = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Back Right1',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue: widget.bR1,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => bR1 = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Back Left 1',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue: widget.bL1,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => bL1 = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Back Right 2',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue: widget.bR2,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => bR2 = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Back Left 2',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue: widget.bL2,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => bL2 = val,
                              ),
                            ),
                          ),


                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                            child: MaterialButton(
                              onPressed: _submitCommand,
                              child: Text('Update',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'SFUIDisplay',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.white,
                              elevation: 16.0,
                              minWidth: 400,
                              height: 50,
                              textColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                          ),





                        ],
                      ),
                    ),

                  ],
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }
}

