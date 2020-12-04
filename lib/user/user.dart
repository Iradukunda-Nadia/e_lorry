import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:e_lorry/manager/carService.dart';
import 'package:e_lorry/user/document.dart';
import 'package:e_lorry/user/post_trip.dart';
import 'package:e_lorry/user/requisition.dart';
import 'package:e_lorry/user/truck_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:e_lorry/login.dart';

import '../chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
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

class Requests extends StatefulWidget {

  String itemName;
  String itemQuantity;
  String itemNumber;
  String truckType;
  String company;
  String person;
  String userName;


  Requests({

    this.truckType,
    this.person,
    this.company,
    this.itemName,
    this.itemQuantity,
    this.itemNumber,
    this.userName,
  });

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

//We have two private fields here
  String _material;
  String _quantity;
  String _name;
  String _truck;
  String _date;
  String _quoteOne;
  String _quoteTwo;
  String _quoteThree;
  String _brand;
  String _brand2;
  String _brand3;
  String _price;
  String _supplier;
  String _sample;
  Map<String,dynamic> price;

  var mask = new MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

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
      CollectionReference reference = Firestore.instance.collection('requisition');

      await reference.add({
        "Truck": widget.itemNumber,
        "Item": widget.itemName,
        "Quantity": widget.itemQuantity,
        "Name": widget.userName,
        "date" : DateFormat(' dd MMM yyyy').format(DateTime.now()),
        "quoteOne" : _quoteOne,
        "quoteTwo" : _quoteTwo,
        "quoteThree" : _quoteThree,
        "brand1" : _brand,
        "brand2" : _brand2,
        "brand3" : _brand3,
        "price" : _price,
        "supplier" : _supplier,
        "reqDate" : DateTime.now(),
        "status" : "pending",
        "company": widget.company,
        "sample": _sample
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



  _getPrevPrice() async {

    var query = Firestore.instance.collection("consumable").where('company', isEqualTo: widget.company).where("type", isEqualTo: widget.truckType ).where("item", isEqualTo: widget.itemName );
    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length == 0) {
        final snack = SnackBar(
          content: Text('No price data'),
        );
        scaffoldKey.currentState.showSnackBar(snack);
      } else {
        querySnapshot.documents.forEach((document)
        async {

          setState(() {
            price = Map<String, dynamic>.from(document.data["price"]);
          });

        });
      }
    });
  }
  TextEditingController dated = TextEditingController();

  String radioItem = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPrevPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Material Requsition"), backgroundColor: Colors.red[900],),

      body: new SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
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
                                  "Item requested",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.itemName,
                              style: new TextStyle(
                                  fontSize: 14.0,
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
                                  "Quantity",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.itemQuantity,
                              style: new TextStyle(
                                  fontSize: 14.0,
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
                                  fontSize: 14.0,
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
                                  "Requested by",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.person,
                              style: new TextStyle(
                                  fontSize: 14.0,
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
                                  "Date",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              DateFormat(' dd MMM yyyy').format(DateTime.now()),
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),

                        new Text(
                          "Previous price",
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.indigo,
                              fontWeight: FontWeight.w700),
                        ),
                        price == null ? Container() :
                        new Flexible(
                          fit: FlexFit.loose,
                          child: SizedBox(
                            height: 200.0,
                            child: new ListView.builder(
                              shrinkWrap: true,
                              itemCount: price.length,
                              itemBuilder: (BuildContext context, int index) {
                                String key = price.keys.elementAt(index);
                                return new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new ListTile(
                                      title: new Text("$key",style: TextStyle(fontSize: 10),),
                                      subtitle: new Text("${price[key]}" ,style: TextStyle(fontSize: 8),),
                                    ),
                                    new Divider(
                                      height: 2.0,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                        ),

                      ],
                    ),
                  ),
                ),
              ),



              new Form(
                key: formKey,
                child: Column(
                  children: <Widget>[

                    new SizedBox(
                      height: 10.0,
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
                              labelText: '1st Qoute',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _quoteOne = val,
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
                              labelText: 'Brand',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _brand = val,
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
                              labelText: '2nd Quote',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _quoteTwo = val,
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
                              labelText: 'Brand',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _brand2 = val,
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
                              labelText: '3rd Quote',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _quoteThree = val,
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
                              labelText: 'Brand',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _brand3 = val,
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[

                        RadioListTile(
                          groupValue: radioItem,
                          title: Text('Yes'),
                          value: 'Yes',
                          onChanged: (val) {
                            setState(() {
                              radioItem = val;
                              _sample = radioItem;
                            });
                          },
                        ),

                        RadioListTile(
                          groupValue: radioItem,
                          title: Text('No'),
                          value: 'No',
                          onChanged: (val) {
                            setState(() {
                              radioItem = val;
                              _sample = radioItem;
                            });
                          },
                        ),

                      ],
                    ),
                  ),




                    Padding(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                      child: MaterialButton(
                        onPressed: _submitCommand,
                        child: Text('SAVE',
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
      ),
    );
  }
}
