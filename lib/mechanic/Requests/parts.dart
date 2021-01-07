import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../chat.dart';

class parts extends StatefulWidget {
  @override
  _partsState createState() => _partsState();
}

class _partsState extends State<parts> {
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
  Firestore.instance.collection("partRequest");

  DocumentSnapshot _currentDocument;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text("Part Requests"),
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
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new partRequest()));
          },
          label: Text ("Request A Part")),

      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: collectionReference.where('company', isEqualTo: userCompany).where('request by', isEqualTo: currentUser ).orderBy('timestamp', descending: true).snapshots(),
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
                      Text("Looks like you haven't made any Requests Yet."),
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
                        title: Text(doc.data["Item"], style: new TextStyle(color: Colors.black),),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.data["Truck"],style: new TextStyle(color: Colors.black),),
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
                                      doc.data["date"],
                                      style: new TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                                new Text(
                                  doc.data["time"],
                                  style: new TextStyle(

                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
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

                          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new reqDetail(

                            itemName: doc.data["Item"],
                            itemQuantity: doc.data["Quantity"],
                            itemNumber: doc.data["Truck"],
                            reqName: doc.data["request by"],
                            reqDate: doc.data["date"],
                            brand1: doc.data["Supplier 1"],
                            reqOne: doc.data["quoteOne"],
                            brand2: doc.data["Supplier 2"],
                            reqTwo: doc.data["quoteTwo"],
                            brand3: doc.data["Supplier 3"],
                            reqThree: doc.data["quoteThree"],
                            reqBrand: doc.data["brand"],
                            reqPrice: doc.data["price"],
                            reqSupplier: doc.data["supplier"],
                            reqComment: doc.data["comment"],
                            approvedQuote: doc.data["approvedQuote"],
                            approvedPrice: doc.data["price"],
                            reqStatus: doc.data["status"],
                            ID: doc.documentID,


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

class partRequest extends StatefulWidget {
  @override
  _partRequestState createState() => _partRequestState();
}

class _partRequestState extends State<partRequest> {
  final formKey = GlobalKey<FormState>();
  String Item;
  String part;
  String quantity;
  String fsn;
  String fsp;
  String fVAT;
  String ssn;
  String ssp;
  String sVAT;
  String tsn;
  String tsp;
  String tVAT;

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
      CollectionReference reference = Firestore.instance.collection('partRequest');

      await reference.add({
        "Truck": Item,
        "date" : DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "Item": part,
        "Quantity": quantity,
        "Supplier 1" : fsn,
        "quoteOne" : fsp,
        '1VAT': fVAT,
        "Supplier 2" : ssn,
        "quoteTwo" : ssp,
        '2VAT': sVAT,
        "Supplier 3" : tsn,
        "quoteThree" : tsp,
        '3VAT':tVAT ,
        "reqDate" : DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "company": userCompany,
        'status': 'pending',
        'request by':currentUser,
        'time': DateFormat('h:mm a').format(DateTime.now()),
        'timestamp': DateTime.now()
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
        title: Text('PART REQUEST FORM'),
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
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFUIDisplay'
                      ),
                      decoration: InputDecoration(

                          errorStyle: TextStyle(color: Colors.red),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          labelText: 'Part Name',
                          labelStyle: TextStyle(
                              fontSize: 11
                          )
                      ),
                      validator: (val) =>
                      val.isEmpty  ? 'Field cannot be empty' : null,
                      onSaved: (val) => part = val,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Container(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
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
                      val.isEmpty  ? 'Field cannot be empty' : null,
                      onSaved: (val) => quantity = val,
                    ),
                  ),
                ),
                ListTile(
                  leading: new CircleAvatar(
                    backgroundColor: Colors.red[900],
                    child: new Text('1',style: new TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                        color: Colors.white),),
                  ),
                  title: Padding(
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
                            labelText: '1st Supplier Name',
                            labelStyle: TextStyle(
                                fontSize: 11
                            )
                        ),
                        validator: (val) =>
                        val.isEmpty  ? 'Field cannot be empty' : null,
                        onSaved: (val) => fsn = val,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    children: [
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
                                labelText: '1st Supplier Price',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Field cannot be empty' : null,
                            onSaved: (val) => fsp = val,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormBuilderChoiceChip(
                          decoration: InputDecoration(
                            labelText: 'Includes VAT ?',
                          ),
                          spacing: 10.0,
                          runSpacing: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          attribute: fVAT,
                          options: [
                            FormBuilderFieldOption(
                              value: 'Yes',child: Text('Yes'),),
                            FormBuilderFieldOption(
                              value: 'No',
                              child: Text('No'),),
                          ],
                          onSaved: (val) => fVAT = val,
                        ),
                      ),
                    ],
                  ),

                ),
                ListTile(
                  leading: new CircleAvatar(
                    backgroundColor: Colors.red[900],
                    child: new Text('2',style: new TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                        color: Colors.white),),
                  ),
                  title: Padding(
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
                            labelText: '2nd Supplier Name',
                            labelStyle: TextStyle(
                                fontSize: 11
                            )
                        ),
                        validator: (val) =>
                        val.isEmpty  ? 'Field cannot be empty' : null,
                        onSaved: (val) => ssn = val,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    children: [
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
                                labelText: '2nd Supplier Price',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Field cannot be empty' : null,
                            onSaved: (val) => ssp = val,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormBuilderChoiceChip(
                          decoration: InputDecoration(
                            labelText: 'Includes VAT ?',
                          ),
                          spacing: 10.0,
                          runSpacing: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          attribute: sVAT,
                          options: [
                            FormBuilderFieldOption(
                              value: 'Yes',child: Text('Yes'),),
                            FormBuilderFieldOption(
                              value: 'No',
                              child: Text('No'),),
                          ],
                          onSaved: (val) => sVAT = val,
                        ),
                      ),
                    ],
                  ),

                ),
                ListTile(
                  leading: new CircleAvatar(
                    backgroundColor: Colors.red[900],
                    child: new Text('3',style: new TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                        color: Colors.white),),
                  ),
                  title: Padding(
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
                            labelText: '3rd Supplier Name',
                            labelStyle: TextStyle(
                                fontSize: 11
                            )
                        ),
                        validator: (val) =>
                        val.isEmpty  ? 'Field cannot be empty' : null,
                        onSaved: (val) => tsn = val,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    children: [
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
                                labelText: '3rd Supplier Price',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Field cannot be empty' : null,
                            onSaved: (val) => tsp = val,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormBuilderChoiceChip(
                          decoration: InputDecoration(
                            labelText: 'Includes VAT ?',
                          ),
                          spacing: 10.0,
                          runSpacing: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          attribute: tVAT,
                          options: [
                            FormBuilderFieldOption(
                              value: 'Yes',child: Text('Yes'),),
                            FormBuilderFieldOption(
                              value: 'No',
                              child: Text('No'),),
                          ],
                          onSaved: (val) => tVAT = val,
                        ),
                      ),
                    ],
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
          ),
        ),
      ),
    );
  }
}


class reqDetail extends StatefulWidget {
  String reqComment;
  String ID;
  String approvedby;
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
  String reqStatus;
  String brand1;
  String brand2;
  String brand3;
  String sample;
  String approvedQuote;
  String approvedPrice;

  reqDetail({

    this.reqStatus,
    this.approvedPrice,
    this.ID,
    this.approvedby,
    this.reqComment,
    this.itemName,
    this.itemQuantity,
    this.itemNumber,
    this.reqName,
    this.reqDate,
    this.reqOne,
    this.reqTwo,
    this.reqThree,
    this.reqBrand,
    this.brand1,
    this.brand2,
    this.brand3,
    this.reqPrice,
    this.reqSupplier,
    this.approvedQuote,
    this.sample,

  });
  @override
  _reqDetailState createState() => _reqDetailState();
}

class _reqDetailState extends State<reqDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text("Item Detail"),
        centerTitle: true,
        backgroundColor: Colors.red[900],
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
                  height: 50.0,
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

                      ],
                    ),
                  ),
                ),
                new Card(
                  child: new Container(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                          height: 10.0,
                        ),


                      ],
                    ),
                  ),
                ),

                new SizedBox(
                  height: 10.0,
                ),

                widget.reqStatus == "Manager Comment"?
                new Card(
                  child: new Container(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Text("Comment", style: TextStyle(fontSize: 12 , color: Colors.grey),),
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Text(widget.reqComment, style: TextStyle(fontSize: 15, color: Colors.grey)),

                        new SizedBox(
                          height: 10.0,
                        ),

                        MaterialButton(
                          child: Text('comment',
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
                          ), onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ): new Offstage(),

                widget.reqStatus == "Approved"?
                new Card(
                  child: new Container(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 10.0,
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
                                  "Final Approved Brand",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.approvedQuote,
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
                                  "Final approved price",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.approvedPrice,
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


                      ],
                    ),
                  ),
                ): new Offstage(),


              ],
            ),
          ),
        ],
      ),
    );
  }
}