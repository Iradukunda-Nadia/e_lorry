import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        'time': DateFormat('h:mm a').format(DateTime.now())
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
