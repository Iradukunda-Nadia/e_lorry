import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lorry/mechanic/material_request.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as Path;

class fuelRequest extends StatefulWidget {
  @override
  _fuelRequestState createState() => _fuelRequestState();
}

class _fuelRequestState extends State<fuelRequest> {

  final formKey = GlobalKey<FormState>();
  String Item;
  String userCompany;
  String currentUser;


  initState() {
    // TODO: implement initState
    super.initState();
    getStringValue();
    lR = '0';
    ppl ='0';

  }

  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
      currentUser = prefs.getString('user');
    });

  }

  String _currLtrs;
  String _quantity;
  String ppl;
  String tL;
  String lR;
  String _fuelStation;
  String _till;
  String _recepient;

  TextEditingController currltrs = new TextEditingController();
  var ltrsReq = new TextEditingController();
  var pricePer = new TextEditingController();
  var total = new TextEditingController();


  void _submitCommand() {
    //get state of our Form
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      _loginCommand();
    }
  }

  void _loginCommand() {
    final form = formKey.currentState;

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('fuelRequest');

      await reference.add({
        "Truck": Item,
        "Current litres": _currLtrs,
        "Requested fuel": lR,
        "Price per liter": ppl,
        "Total": (double.parse(lR)*double.parse(ppl)).toString(),
        "FuelStaion": _fuelStation,
        "Till": _till,
        'Receipent': _recepient,
        "date" : DateFormat(' yyyy- mm - dd').format(DateTime.now()),
        'timestamp': DateTime.now(),
        "company": userCompany,
        'status': 'pending',
        'reqby':currentUser,
      });
    }).then((result) =>

        _showRequest());

  }

  void _showRequest() {
    // flutter defined function
    final form = formKey.currentState;
    form.reset();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Your request has been sent"),
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
        title: Text('FUEL REQUEST FORM'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  SizedBox(
                    height: 60.0,
                    child:  new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection("trucks").where('company', isEqualTo: userCompany).orderBy('plate').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return new Text("Please wait");
                          var length = snapshot.data.documents.length;
                          DocumentSnapshot ds = snapshot.data.documents[length - 1];
                          return new DropdownButton(
                            items: snapshot.data.documents.map((
                                DocumentSnapshot document) {
                              return DropdownMenuItem(
                                  value: document.data["plate"],
                                  child: new Text(document.data["plate"]));
                            }).toList(),
                            value: Item,
                            onChanged: (value) {
                              print(value);

                              setState(() {
                                Item = value;
                              });
                            },
                            hint: new Text("Select Vehicle"),
                            style: TextStyle(color: Colors.black),

                          );
                        }
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Container(
                      child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay'
                        ),
                        decoration: InputDecoration(

                            errorStyle: TextStyle(color: Colors.red),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            suffixText: 'LITRES',
                            labelText: 'Litres in Tank(s) as per MYRIAD',
                            labelStyle: TextStyle(
                                fontSize: 11
                            )
                        ),
                        validator: (val) =>
                        val.isEmpty  ? 'Field cannot be empty' : null,
                        onSaved: (val) => _currLtrs = val,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Container(
                      child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay'
                        ),
                        decoration: InputDecoration(

                            errorStyle: TextStyle(color: Colors.red),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            labelText: 'Litres Requesting?',
                            suffixText: 'LITRES',
                            labelStyle: TextStyle(
                                fontSize: 11
                            )
                        ),
                        validator: (val) =>
                        val.isEmpty  ? 'Field cannot be empty' : null,
                        onSaved: (val) => lR = val,
                        onChanged: (val){
                          setState(() {
                            lR = val;
                          });
                        },

                      ),
                    ),
                  ),




                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Container(
                      child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay'
                        ),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            suffixText: '(KSH)',
                            labelText: 'Price Per Litre',
                            labelStyle: TextStyle(
                                fontSize: 11
                            )
                        ),
                        validator: (val) =>
                        val.isEmpty  ? 'Field cannot be empty' : null,
                        onSaved: (val) => ppl = val,
                        onChanged: (val){
                          setState(() {
                            ppl = val;
                          });
                        },
                      ),
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: ListTile(
                      title: Text('Total (KSH)', style: TextStyle(fontSize: 11),),
                      subtitle:  Text(lR == '' || ppl == '' ? '...':(double.parse(lR)*double.parse(ppl)).toString()),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Container(
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay'
                        ),
                        decoration: InputDecoration(

                            errorStyle: TextStyle(color: Colors.red),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            labelText: 'Fuel Station Name',
                            labelStyle: TextStyle(
                                fontSize: 11
                            )
                        ),
                        validator: (val) =>
                        val.isEmpty  ? 'Field cannot be empty' : null,
                        onSaved: (val) => _fuelStation = val,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Container(
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay'
                        ),
                        decoration: InputDecoration(

                            errorStyle: TextStyle(color: Colors.red),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            labelText: 'Till Number/ Paybill/ Phone number',
                            labelStyle: TextStyle(
                                fontSize: 11
                            )
                        ),
                        validator: (val) =>
                        val.isEmpty  ? 'Field cannot be empty' : null,
                        onSaved: (val) => _till = val,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Container(
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay'
                        ),
                        decoration: InputDecoration(

                            errorStyle: TextStyle(color: Colors.red),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            labelText: 'Recepient Name',
                            labelStyle: TextStyle(
                                fontSize: 11
                            )
                        ),
                        validator: (val) =>
                        val.isEmpty  ? 'Field cannot be empty' : null,
                        onSaved: (val) => _recepient = val,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                    child: MaterialButton(
                      onPressed: _submitCommand,
                      child: Text('Submit',
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
            )
        ),
      ),
    );
  }
}

class FRequests extends StatefulWidget {
  String type;

  FRequests ({
    this.type,
});

  @override
  _FRequestsState createState() => _FRequestsState();
}

class _FRequestsState extends State<FRequests> {
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
  Firestore.instance.collection("fuelRequest");

  DocumentSnapshot _currentDocument;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text("Fuel Requests"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new fuelRequest()));
          },
          label: Text ("Request Fuel")),

      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: collectionReference.where('company', isEqualTo: userCompany).where('reqby', isEqualTo: currentUser ).snapshots(),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Waiting For Data..."),
                );
              } if ( snapshot.data == null ){
                print('no data');
                return Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 100,
                          child: Image.asset('assets/empty.png'),
                        ),
                      ),
                      Text("No requests here"),
                    ],
                  ),);

              }
              else{
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data.documents[index];
                    return Card(
                      child: ListTile(
                        title: Text(doc.data["Truck"]),
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

                          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new fuelStatus(

                            truck: doc.data["Truck"],
                            currLts: doc.data["Current litres"],
                            date: doc.data["date"],
                            ppl: doc.data["Price per liter"],
                            recepient: doc.data["Receipent"],
                            reqFuel: doc.data["Requested fuel"],
                            till: doc.data["Till"],
                            total: doc.data["Total"],
                            fStation: doc.data["FuelStaion"],
                            status: doc.data["status"],
                            reqBy: doc.data["reqby"],
                            image: doc.data["image"],
                            itemID: doc.documentID,


                          )));
                        },
                      ),
                    );

                  },
                );

              }
            }),

      ),
    );
  }
}

class fuelStatus extends StatefulWidget {
  String currLts;
  String reqFuel;
  String ppl;
  String total;
  String fStation;
  String till;
  String recepient;
  String date;
  String status;
  String truck;
  String reqBy;
  String itemID;
  String image;



  fuelStatus({
    this.currLts,
    this.truck,
    this.reqFuel,
    this.recepient,
    this.ppl,
    this.total,
    this.fStation,
    this.till,
    this.date,
    this.status,
    this.reqBy,
    this.itemID,
    this.image,

  });

  @override
  _fuelStatusState createState() => _fuelStatusState();
}

class _fuelStatusState extends State<fuelStatus> {
  final formKey = GlobalKey<FormState>();
  final fKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _comment;
  String appQuote;
  String appPrice;
  String currentUserEmail;

  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserEmail = prefs.getString('user');
    });

  }

  void _approveCommand() {
    //get state of our Form
    _updateStatus();
    _show();

  }

  @override
  initState() {
    getStringValue();
    super.initState();
  }

  _updateStatus() async {
    await Firestore.instance
        .collection('requisition')
        .document(widget.itemID)
        .updateData({
      'status': "Approved",
      'comment': "Approved",
      'approved by': currentUserEmail,
    });
  }

  void _sendApproval() {
    final form = fKey.currentState;
    form.reset();

  }

  void _submitCommand() {
    //get state of our Form
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _updateComment();
      _updateData();
      _showRequest();

    }
  }

  _updateData() async {
    await Firestore.instance
        .collection('fuelRequest')
        .document(widget.itemID)
        .updateData({'status': "Manager Comment"});
  }

  _updateComment() async {
    await Firestore.instance
        .collection('fuelRequest')
        .document(widget.itemID)
        .updateData({
      'comment': _comment,
    });
  }

  void _show() {
    // flutter defined function
    final form = formKey.currentState;
    form.reset();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Your Have Approved this request"),
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

  void _showRequest() {
    _updateData();
    // flutter defined function
    final form = formKey.currentState;
    form.reset();


  }
  String radioItem = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text("Item Detail"),
        centerTitle: true,
      ),

      body: new Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          new Container(
            height: 200.0,
            decoration: new BoxDecoration(
              color: Colors.grey.withAlpha(50),
              borderRadius: new BorderRadius.only(
                bottomRight: new Radius.circular(100.0),
                bottomLeft: new Radius.circular(100.0),
              ),
            ),
          ),
          new SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                new SizedBox(
                  height: 20.0,
                ),
                new Card(
                  child: new Container(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: new Text(
                            "Details",
                            style: new TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        new SizedBox(
                          height: 5.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Truck",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.truck,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        new SizedBox(
                          height: 5.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Current Litres",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.currLts,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),


                        new SizedBox(
                          height: 5.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Fuel Requested",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.reqFuel,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),

                        new SizedBox(
                          height: 5.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Price Per Litre",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.ppl,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),





                        new SizedBox(
                          height: 5.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Total",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.total,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Fuel Station",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.fStation,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        new SizedBox(
                          height: 5.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Till /Paybill/ Phone",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.till,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Recepient",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.recepient,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),

                        new SizedBox(
                          height: 5.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Date",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.date,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),




                        new SizedBox(
                          height: 10.0,
                        ),

                        new Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red[900])
                          ),
                          child: Text(widget.status, style: TextStyle(color: Colors.red[900]),),
                        ),


                      ],
                    ),
                  ),
                ),

                new SizedBox(
                  height: 10.0,
                ),
                widget.status == "Approved"?
                new Card(
                  child: new Container(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 5.0,
                        ),



                        MaterialButton(
                          child: Text('Fill Post fuel Evidence',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'SFUIDisplay',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Colors.white,
                          elevation: 16.0,
                          height: 50,
                          textColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ), onPressed: () {
                          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> new postFuel(

                            truck: widget.truck,
                            docID: widget.itemID,



                          )));
                        },
                        ),
                      ],
                    ),
                  ),
                ): new Offstage(),
                new SizedBox(
                  height: 10.0,
                ),
                widget.status == "Refilled"?
                new Card(
                  child: new Container(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: Image.network(
                            widget.image,
                            fit: BoxFit.contain,
                            height: 200.0,
                            width: 200.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ): new Offstage(),

                new SizedBox(
                  height: 5.0,
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }
}




class postFuel extends StatefulWidget {
  String truck;
  String docID;


  postFuel({
    this.truck,
    this.docID,
  });

  @override
  _postFuelState createState() => _postFuelState();
}

class _postFuelState extends State<postFuel> {
  String totalL;
  final formKey = GlobalKey<FormState>();
  File _image;
  String _uploadedFileURL;
  bool _isLoading = false;
  double _progress;

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    uploadTask.events.listen((event) {
      setState(() {
        _isLoading = true;
        _progress = event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble();
      });
    }).onError((error) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(error.toString()), backgroundColor: Colors.red,) );
    });

    uploadTask.onComplete.then((snapshot) {
      setState(() {
        _isLoading = false;
      });
    });
    StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;

    String url = await downloadUrl.ref.getDownloadURL();
    setState(() {
      _uploadedFileURL = url;
    });
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      _updateComment();
    }


  }

  _updateComment() async {

    await Firestore.instance
        .collection('fuelRequest')
        .document(widget.docID)
        .updateData({
      'New Fuel reading': totalL,
      'image': _uploadedFileURL,
      'status': 'Refilled'
    }).then((result) =>

        _showRequest());

  }

  void _showRequest() {
    // flutter defined function
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

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Fuel Evidence'),
      ),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.truck),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Container(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                          ),
                          decoration: InputDecoration(

                              errorStyle: TextStyle(color: Colors.red),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelText: 'Total Litres In tank Post Refill',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Field cannot be empty' : null,
                          onSaved: (val) => totalL = val,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          _image != null
                              ? Image.asset(
                            _image.path,
                            height: 150,
                          )
                              : Container(height: 150),
                          _image == null
                              ? RaisedButton(
                            child: Text('Upload image of Pump Reading'),
                            onPressed: chooseFile,
                            color: Colors.cyan,
                          )
                              : Container(),
                        ],
                      )
                    ),

                    _image != null
                        ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                      child: Text('Submit'),
                      onPressed: uploadFile,
                      color: Colors.red[900],
                    ),
                        )
                        : Container(),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
