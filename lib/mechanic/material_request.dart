import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class matRequest extends StatefulWidget {


  String truckNo;
  String driverName;
  String truckType;

  matRequest(
      {this.truckNo,
        this.driverName,
      this.truckType});

  @override
  _matRequestState createState() => _matRequestState();
}

final formKey = GlobalKey<FormState>();
final scaffoldKey = GlobalKey<ScaffoldState>();

//We have two private fields here
String _material;
String _quantity;
String _name;
String _truck;
String _radiator;
var mask = new MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });





class _matRequestState extends State<matRequest> {
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
      CollectionReference reference = Firestore.instance.collection('request');

      await reference.add({
        "Truck": widget.truckNo,
        "Item": Item,
        "Quantity": _quantity,
        "Name": _name,
        "tType": widget.truckType,
        "status": "pending",
        "date" : DateFormat(' dd MMM yyyy').format(DateTime.now()),
        "company": userCompany,
      });
    }).then((result) =>

        _showRequest());

  }

  void _showRequest() {
    // flutter defined function
    final form = formKey.currentState;
    form.reset();
    var context;
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


  DocumentSnapshot currentCategory;
  TextEditingController categoryController = new TextEditingController();
  String categoryname;

  var _mySelection;




  @override
  void initState() {
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

  List<DropdownMenuItem<String>> dropDownItems;
  String selectedItem;
  String Item;
  List<String> itemName= [];



  void _dropdownList() {
    var collectionReference = Firestore.instance.collection('consumable');
    var query = collectionReference.where("type", isEqualTo: widget.truckType );
    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length == 0) {
        final snack = SnackBar(
          content: Text('no Items'),
        );
        scaffoldKey.currentState.showSnackBar(snack);
      } else {
        querySnapshot.documents.forEach((document)
        async {

         itemName.add(document['item'].toString());

        });
      }
    });
  }

  void changedDropDownItem(String selectedSize) {
    setState(() {
      selectedItem = selectedSize;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Material requisition"),
      ),
      body: new SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[

                new SizedBox(
                  height: 10.0,
                ),
                new Text(widget.truckNo,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                new SizedBox(
                  height: 10.0,
                ),

                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                SizedBox(
                  height: 60.0,
                  child:  new StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection("consumable").where("type", isEqualTo: widget.truckType ).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return new Text("Please wait");
                        var length = snapshot.data.documents.length;
                        DocumentSnapshot ds = snapshot.data.documents[length - 1];
                        return new DropdownButton(
                          items: snapshot.data.documents.map((
                              DocumentSnapshot document) {
                            return DropdownMenuItem(
                                value: document.data["item"],
                                child: new Text(document.data["item"]));
                          }).toList(),
                          value: Item,
                          onChanged: (value) {
                            print(value);

                            setState(() {
                              Item = value;
                            });
                          },
                          hint: new Text("Select Item"),
                          style: TextStyle(color: Colors.black),

                        );
                      }
                  ),
                ),

                Item == "other"?
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Container(
                    child: TextFormField(
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFUIDisplay'
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(

                          errorStyle: TextStyle(color: Colors.red),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          labelText: 'Other',
                          labelStyle: TextStyle(
                              fontSize: 11
                          )
                      ),
                      validator: (val) =>
                      val.isEmpty  ? 'Enter Item' : null,
                      onSaved: (val) => Item = val,
                    ),
                  ),
                ): new Offstage(),
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
                          labelText: 'Quantity',
                          labelStyle: TextStyle(
                              fontSize: 11
                          )
                      ),
                      validator: (val) =>
                      val.isEmpty  ? 'Enter Quantity' : null,
                      onSaved: (val) => _quantity = val,
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
                          labelText: 'Name of person requesting',
                          labelStyle: TextStyle(
                              fontSize: 11
                          )
                      ),
                      validator: (val) =>
                      val.isEmpty  ? 'Enter a valid value' : null,
                      onSaved: (val) => _name = val,
                    ),
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
        ),
      ),
    );
  }
}

Widget productDropDown(
    {String textTitle,
      String selectedItem,
      List<DropdownMenuItem<String>> dropDownItems,
      ValueChanged<String> changedDropDownItems}) {
  textTitle == null ? textTitle = "Enter Title" : textTitle;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Text(
          textTitle,
          style:
          new TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(color: Colors.white),
              borderRadius: new BorderRadius.all(new Radius.circular(4.0))),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: new DropdownButtonHideUnderline(
                child: new DropdownButton(
                  value: selectedItem,
                  items: dropDownItems,
                  onChanged: changedDropDownItems,
                )),
          ),
        ),
      ),
    ],
  );
}

List<DropdownMenuItem<String>> buildAndGetDropDownItems(List size) {
  List<DropdownMenuItem<String>> items = new List();
  for (String size in size) {
    items.add(new DropdownMenuItem(value: size, child: new Text(size)));
  }
  return items;
}