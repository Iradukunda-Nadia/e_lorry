import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lorry/mechanic/material_request.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as Path;
import 'package:photo_view/photo_view.dart';

class fuel extends StatefulWidget {
  @override
  _fuelState createState() => _fuelState();
}

class _fuelState extends State<fuel> {
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
        title: Text("Fuel Approval"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new fuelForm()));
          },
          label: Text ("Request Fuel")),

      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: collectionReference.where('company', isEqualTo: userCompany).where('reqby', isEqualTo: currentUser ).orderBy('timestamp', descending: true).snapshots(),
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
                        subtitle: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  doc.data["date"],
                                  style: new TextStyle(color: Colors.grey, fontSize: 12.0,),
                                )
                              ],
                            ),
                            new Text(
                              doc.data["time"],
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
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

                          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new fStatus(

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
                            userComp: userCompany,
                            newLtrs: doc.data['New Fuel reading'],


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




class fuelForm extends StatefulWidget {
  @override
  _fuelFormState createState() => _fuelFormState();
}

class _fuelFormState extends State<fuelForm> {
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
  String phone;
  String lalji;

  bool isPhone = false;
  bool isLalji = false;


  void _submitCommand() {
    //get state of our Form
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      _loginCommand();
    }
  }
  final FirebaseMessaging _messaging = FirebaseMessaging();
  void _loginCommand() {
    final form = formKey.currentState;

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('fuelRequest');
      String fcmToken = await _messaging.getToken();

      await reference.add({
        "Truck": Item,
        "Current litres": _currLtrs,
        "Requested fuel": lR,
        "Price per liter": ppl,
        "Total": (double.parse(lR)*double.parse(ppl)).toString(),
        "FuelStaion": isLalji != true?_fuelStation: 'Lalji-Nairobi',
        "Till": isLalji != true?_till: 'N/A',
        'Receipent': isPhone == true? _recepient: 'N/A',
        "date" : DateFormat(' yyyy- mm - dd').format(DateTime.now()),
        'timestamp': DateTime.now(),
        "company": userCompany,
        'status': 'pending',
        'reqby':currentUser,
        'time': DateFormat('h:mm a').format(DateTime.now()),
        'token': fcmToken,
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
                    padding: const EdgeInsets.all(3.0),
                    child: FormBuilderChoiceChip(
                      decoration: InputDecoration(
                        labelText: 'Are you refilling at Lalji Nairobi?',
                      ),
                      spacing: 5.0,
                      runSpacing: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      attribute: phone,
                      options: [
                        FormBuilderFieldOption(
                          value: 'Yes',child: Text('Yes'),),
                        FormBuilderFieldOption(
                          value: 'No',child: Text('No'),),
                      ],
                      onSaved: (val) => lalji = val,
                      onChanged: (val){
                        setState(() {
                          lalji = val;
                          if (lalji == 'Yes'){
                            setState(() {
                              isLalji = true;
                            });
                          }else{
                            setState(() {
                              isLalji = false;
                            });
                          }
                        });
                      },
                    ),
                  ),
                  isLalji == true? new Offstage(): Padding(
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




                  isLalji == true? new Offstage(): Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: FormBuilderChoiceChip(
                          decoration: InputDecoration(
                            labelText: 'Payment Method?',
                          ),
                          spacing: 5.0,
                          runSpacing: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          attribute: phone,
                          options: [
                            FormBuilderFieldOption(
                              value: 'Till',child: Text('Till'),),
                            FormBuilderFieldOption(
                              value: 'Paybill',child: Text('Paybill'),),
                            FormBuilderFieldOption(
                              value: 'Phone',
                              child: Text('Phone'),),
                          ],
                          onSaved: (val) => phone = val,
                          onChanged: (val){
                            setState(() {
                              phone = val;
                              if (phone == 'Phone'){
                                setState(() {
                                  isPhone = true;
                                });
                              }
                              else {
                                setState(() {
                                  isPhone = false;
                                });
                              }
                            });
                          },
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

                      isPhone == true? Padding(
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
                            val.isEmpty  ? null : null,
                            onSaved: (val) => _recepient = val,
                          ),
                        ),
                      ):new Offstage(),

                    ],
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

class fStatus extends StatefulWidget {
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
  String userComp;
  String newLtrs;



  fStatus({
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
    this.userComp,
    this.newLtrs

  });
  @override
  _fStatusState createState() => _fStatusState();
}

class _fStatusState extends State<fStatus> {
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
                          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> new postFuelEvidence(

                            truck: widget.truck,
                            docID: widget.itemID,
                            prevReading: widget.currLts,
                            userComp: widget.userComp,



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
                          padding: const EdgeInsets.all(8.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new SizedBox(
                                    width: 5.0,
                                  ),
                                  new Text(
                                    "Total Litres Post Refill ",
                                    style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                  )
                                ],
                              ),
                              new Text(
                                widget.newLtrs,
                                style: new TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => ImageDialog( img: widget.image,)
                            );
                          },

                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.network(
                              widget.image,
                              fit: BoxFit.contain,
                              height: 200.0,
                              width: 200.0,
                            ),
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

class ImageDialog extends StatelessWidget {
  String img;

  ImageDialog ({this.img});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          child: PhotoView(
        imageProvider: NetworkImage(img),
      )
      ),
    );
  }
}

class postFuelEvidence extends StatefulWidget {
  String truck;
  String docID;
  String prevReading;
  String userComp;


  postFuelEvidence({
    this.truck,
    this.docID,
    this.prevReading,
    this.userComp,
  });
  @override
  _postFuelEvidenceState createState() => _postFuelEvidenceState();
}

class _postFuelEvidenceState extends State<postFuelEvidence> {
  String totalL;
  final formKey = GlobalKey<FormState>();
  File _image;
  String _uploadedFileURL;
  bool _isLoading = false;
  double _progress;

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('postFuel_${widget.userComp}/${Path.basename(_image.path)}}');
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
        .collection('refilled')
        .reference()
        .add({
      'Truck': widget.truck,
      'Previous reading': widget.prevReading,
      'New Fuel reading': totalL,
      'image': _uploadedFileURL,
      'status': 'Refilled',
      "date" : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'timestamp': DateTime.now(),
      'company': widget.userComp,


    });

    await Firestore.instance
        .collection('fuelRequest')
        .document(widget.docID)
        .updateData({
      'New Fuel reading': totalL,
      'image': _uploadedFileURL,
      'status': 'Refilled',
      'company': widget.userComp,
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

      body: Stack(
        children: [
          SingleChildScrollView(
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

          _isLoading == true? new Center(
            child: Column(
              children: [
                new CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('uploading...'),
                )
              ],
            ),
          ): new Offstage(),
        ],
      ),
    );
  }
}
