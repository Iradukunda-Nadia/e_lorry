import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_lorry/reuse.dart';

class CarsList extends StatefulWidget {
  @override
  _CarsListState createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {
  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("cars").where('company', isEqualTo: userCompany).orderBy('plate').getDocuments();
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
          title: Text("Cars List"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
          onPressed: () {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new addCar()
            ));
          },
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
                          child: Text("The are no saved Cars"),);
                      }else{
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return new GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new carDetails(

                                  truckNumber: snapshot.data[index].data["plate"],
                                  driverName: snapshot.data[index].data["driver"],
                                  driverNumber: snapshot.data[index].data["phone"],
                                  driverID: snapshot.data[index].data["ID"],
                                  itemID: snapshot.data[index].documentID,
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
                                          child: new Icon(Icons.directions_car)
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

class carDetails extends StatefulWidget {
  String itemID;
  String truckNumber;
  String driverName;
  String driverNumber;
  String driverID;
  String itemDescription;
  String truckType;

  carDetails({

    this.truckType,
    this.itemID,
    this.truckNumber,
    this.driverName,
    this.driverNumber,
    this.driverID,
    this.itemDescription
  });

  @override
  _carDetailsState createState() => _carDetailsState();
}

class _carDetailsState extends State<carDetails> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _truck;
  String _driver;
  String _driverNo;
  String _driverID;
  String _truckType;





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
      'plate': _truck,
      'driver': _driver,
      'phone': _driverNo,
      'ID': _driverID,
      'type': _truckType,

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
              },
            ),
          ],
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Details"),
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
                                    labelText: 'Number Plate',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue:widget.truckNumber,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _truck = val,
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
                                    labelText: 'Driver',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue: widget.driverName,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _driver = val,
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
                                    labelText: 'Driver Phone Number',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue: widget.driverNumber,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _driverNo = val,
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
                                    labelText: 'Driver ID',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue: widget.driverID,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _driverID = val,
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


class addCar extends StatefulWidget {
  @override
  _addCarState createState() => _addCarState();
}

class _addCarState extends State<addCar> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _truck2;
  String _driver2;
  String _driverNo2;
  String _driverID2;
  String _turnBoy2;
  String _truckType;
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
      _AddData();
    }
  }

  _AddData() async {
    final form = formKey.currentState;

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection("cars");

      await reference.add({
        'plate': _truck2,
        'driver': _driver2,
        'phone': _driverNo2,
        'ID': _driverID2,
        'turnboy': _turnBoy2,
        'type': _truckType,
        'company': userCompany,

      });
    }).then((result) =>

        _showRequest());
  }

  void _showRequest() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Data has been added"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Car"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: new Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[

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
                                    labelText: 'Number Plate',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _truck2 = val,
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
                                    labelText: 'Driver',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _driver2 = val,
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
                                    labelText: 'Driver Number',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _driverNo2 = val,
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
                                    labelText: 'Driver ID',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _driverID2 = val,
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
                                    labelText: 'Turn Boy',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _turnBoy2 = val,
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
                                    labelText: 'Type/Model',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _truckType = val,
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