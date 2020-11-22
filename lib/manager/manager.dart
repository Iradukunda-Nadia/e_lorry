import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lorry/manager/carService.dart';
import 'package:e_lorry/manager/report.dart';
import 'package:e_lorry/manager/reporting/Reports.dart';
import 'package:e_lorry/manager/reporting/report.dart';
import 'package:e_lorry/user/document.dart';
import 'package:e_lorry/user/post_trip.dart';
import 'package:e_lorry/user/truck_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_lorry/login.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chat.dart';

class Manager extends StatefulWidget {
  @override
  _ManagerState createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

//We have two private fields here
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
        title: Text("Manager"),
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
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/lo.png",
                    fit: BoxFit.contain,
                    height: 100.0,
                    width: 300.0,
                  ),
                  Text("Manager"),
                ],
              ),
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
                child: new Icon(Icons.assignment,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Report"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new repDiv()));
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
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new LoginScreen()));
              },
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
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
    });

  }
  CollectionReference collectionReference =
  Firestore.instance.collection("requisition");

  DocumentSnapshot _currentDocument;

  _updateData() async {
    await Firestore.instance
        .collection('request')
        .document(_currentDocument.documentID)
        .updateData({'status': "checked"});
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: collectionReference.where('company', isEqualTo: userCompany).snapshots(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading... Please wait"),
              );
            } if (snapshot.data == null){
              return Center(
                child: Text("The are no pending requests"),);
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data.documents[index];
                      return Card(
                        child: ListTile(
                          title: Text(doc.data["Item"]),
                          subtitle: Text(doc.data["Truck"]),
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

                            Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new Approval(

                              itemID: doc.documentID,
                              itemName: doc.data["Item"],
                              itemQuantity: doc.data["Quantity"],
                              itemNumber: doc.data["Truck"],
                              reqName: doc.data["Name"],
                              reqDate: doc.data["date"].toString().substring(0,10),
                              reqOne: doc.data["quoteOne"],
                              reqTwo: doc.data["quoteTwo"],
                              reqThree: doc.data["quoteThree"],
                              reqBrand: doc.data["brand"],
                              reqPrice: doc.data["price"],
                              reqSupplier: doc.data["supplier"],
                              brand1: doc.data["supplier"],
                              brand2: doc.data["supplier"],
                              brand3: doc.data["supplier"],
                              status: doc.data["status"],


                            )));
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

class Approval extends StatefulWidget {

  String itemID;
  String itemName;
  String itemQuantity;
  String itemNumber;
  String reqName;
  String reqDate;
  String reqOne;
  String reqTwo;
  String reqThree;
  String reqBrand;
  String reqPrice;
  String reqSupplier;
  String status;
  String brand1;
  String brand2;
  String brand3;

  Approval({

    this.brand3,
    this.brand2,
    this.brand1,
    this.itemName,
    this.itemID,
    this.itemQuantity,
    this.itemNumber,
    this.reqName,
    this.reqDate,
    this.reqOne,
    this.reqTwo,
    this.reqThree,
    this.reqBrand,
    this.reqPrice,
    this.status,
    this.reqSupplier

  });

  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {



  final formKey = GlobalKey<FormState>();
  final fKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _comment;
  String appQuote;

  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserEmail = prefs.getString('user');
    });

  }

  void _approveCommand() {
    //get state of our Form
    final form = formKey.currentState;
      form.save();
      _updateStatus();
      _sendApproval();

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
      'approvedQuote': appQuote,
        });
  }

  void _sendApproval() {
    final form = formKey.currentState;
    form.reset();
    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new Manager()
    ));
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
        .collection('requisition')
        .document(widget.itemID)
        .updateData({'status': "Manager Comment"});
  }

  _updateComment() async {
    await Firestore.instance
        .collection('requisition')
        .document(widget.itemID)
        .updateData({
      'comment': _comment,
        });
  }



  void _showRequest() {
    _updateData();
    // flutter defined function
    final form = formKey.currentState;
    form.reset();
    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new Manager()
    ));

  }

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
                                  "Item Requested",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.itemName,
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
                                  "Truck",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.itemNumber,
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
                                  "Requested by",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.reqName,
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
                                  "Request date",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.reqDate,
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
                                  "1st Quote",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.reqOne,
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
                                  "Brand",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.brand1,
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
                                  "2nd Quote",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.reqTwo,
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
                                  "Brand",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.brand2,
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
                                  "3rd Quote",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.reqThree,
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
                                  "Brand",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.brand3,
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
                                  "Brand",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.reqBrand,
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
                                  "Final negotiated price",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.reqPrice,
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
                                  "Final approved supplier",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.reqSupplier,
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
                widget.status != "Approved"?
                new Card(
                  child: new Container(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 5.0,
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new SizedBox(
                                    width: 5.0,
                                  ),
                                  MaterialButton(
                                    onPressed: (){
                                      showCupertinoDialog(
                                          context: context,
                                          builder:  (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          content: Form(
                                            key: formKey,
                                            child: Column(
                                              children: <Widget>[

                                                new SizedBox(
                                                  height: 10.0,
                                                ),
                                                new Text("Comment",
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                                new SizedBox(
                                                  height: 10.0,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                  child: Container(
                                                    child: TextFormField(
                                                      keyboardType: TextInputType.multiline,
                                                      maxLines: null,
                                                      textCapitalization: TextCapitalization.sentences,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'SFUIDisplay'
                                                      ),
                                                      decoration: InputDecoration(

                                                          errorStyle: TextStyle(color: Colors.red),
                                                          filled: true,
                                                          fillColor: Colors.white.withOpacity(0.1),
                                                          labelText: 'Comment',
                                                          labelStyle: TextStyle(
                                                              fontSize: 11
                                                          )
                                                      ),
                                                      validator: (val) =>
                                                      val.isEmpty  ? 'Required' : null,
                                                      onSaved: (val) => _comment = val,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            new RaisedButton(
                                              color: Colors.grey,
                                              elevation: 16.0,
                                              child: new Text("Comment"),
                                              onPressed: () {
                                                _submitCommand();
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                      );
                                    },
                                    child: Text('Reject with Comment',
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
                                    ),
                                  ),
                                ],
                              ),
                              MaterialButton(
                                onPressed: (){
                                  showCupertinoDialog(
                                      context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        content: FormBuilder(
                                          key: fKey,
                                          child: Column(
                                            children: [
                                              new FormBuilderDropdown(
                                                attribute: "gender",
                                                decoration: InputDecoration(labelText: "Gender"),
                                                // initialValue: 'Male',
                                                hint: Text('Select Gender'),
                                                validators: [FormBuilderValidators.required()],
                                                items: ['${widget.brand1} - ${widget.reqOne}', '${widget.brand2} ${widget.reqTwo}', '${widget.brand3} ${widget.reqThree}']
                                                    .map((quotes) => DropdownMenuItem(
                                                    value: quotes,
                                                    child: Text("$quotes")
                                                )).toList(),

                                                onSaved: (val) => appQuote = val,
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          // usually buttons at the bottom of the dialog
                                          new FlatButton(
                                            child: new Text("Approve"),
                                            onPressed: () {
                                              _approveCommand();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text('Approve Quote',
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
                                ),
                              ),
                            ],
                          ),
                        ),
                        new SizedBox(
                          height: 5.0,
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
