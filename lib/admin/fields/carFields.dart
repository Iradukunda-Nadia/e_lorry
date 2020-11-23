import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class carFields extends StatefulWidget {
  @override
  _carFieldsState createState() => _carFieldsState();
}

class _carFieldsState extends State<carFields> {
  bool readOnly = false;

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

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _newformField = GlobalKey<FormBuilderState>();

  void _serviceDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Once you save you can not change anything"),
          content: new Text("Do you want to continue?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop();
                Firestore.instance.runTransaction((Transaction transaction) async {

                  CollectionReference ref = Firestore.instance
                      .collection('companies');

                  QuerySnapshot eventsQuery =  await ref.where('company', isEqualTo: userCompany).getDocuments();

                  eventsQuery.documents.forEach((msgDoc) {
                    msgDoc.reference.updateData({'carForm': 'created'});
                  });

                  await Firestore.instance.collection('field')
                      .document('${userCompany}-veh')
                      .setData(_fbKey.currentState.value);
                }).then((result) =>

                    _goRequest());


              },
            ),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _goRequest() {
    setState(() {
      readOnly = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Your data has been saved"),
          content: new Text("Do you want to add any fields?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                _newField();
              },
            ),
            new FlatButton(
              child: new Text("NO"),
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

  String cat;
  var field = TextEditingController();



  void _newField() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) =>
            Material(
              child: CupertinoActionSheet(
                title: Text(
                    "Enter your new form field"),
                message: Form(
                  key: _newformField,
                  child: Column(
                    children: <Widget>[

                      new SizedBox(
                        height: 10.0,
                      ),
                      CupertinoTextField(
                        controller: field,
                        placeholder: 'Enter field',
                      ),


                      SizedBox( height: 10.0,),
                      DropDownFormField(
                        titleText: 'Select Category',
                        hintText: 'Category',
                        value: cat,
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          }
                        },
                        onSaved: (value) {
                          setState(() {
                            cat = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            cat = value;
                          });
                        },
                        dataSource: [
                          {
                            "display": "Exterior",
                            "value": "Exterior",
                          },
                          {
                            "display": "Interior",
                            "value": "Interior",
                          },
                          {
                            "display": "Under Hood",
                            "value": "Under Hood",
                          },
                          {
                            "display": "Under Vehicle",
                            "value": "Under Vehicle",
                          },
                          {
                            "display": "Wheels",
                            "value": "Wheels",
                          },
                          {
                            "display": "Dates",
                            "value": "dates",
                          },

                        ],
                        textField: 'display',
                        valueField: 'value',
                      ),


                    ],
                  ),
                ),
                actions: <Widget>[
                  CupertinoButton(
                    child: Text("Add"),
                    onPressed: () async{

                      _addTodb();

                    },


                  ),
                  new FlatButton(
                    child: new Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            )
    );
  }

  void _addTodb() async {
    await Firestore.instance
        .collection("field")
        .document('${userCompany}-veh')
        .updateData({
      cat : FieldValue.arrayUnion([field.text])
    });

    _newformField.currentState.reset();
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Your data has been saved"),
          content: new Text("Add another field?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                _newField();
              },
            ),
            new FlatButton(
              child: new Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text("Are you sure??"),
        content: new Text('Once you close you cannot add more fields'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Continue Editing'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Finish'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: Text("Car Form Fields"), centerTitle: true,),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilder(
                  readOnly: readOnly,
                  key: _fbKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Flexible(
                          child: StreamBuilder(
                              stream: Firestore.instance.collection('field').document('elorry-veh').snapshots(),
                              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                var userDocument = snapshot.data;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new Text("Select Form Fields",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new FormBuilderCheckboxList(
                                        decoration:
                                        InputDecoration(labelText: "Car Exterior"),
                                        attribute: "Exterior",
                                        options:  userDocument['Exterior']
                                            .map<FormBuilderFieldOption>(
                                              (val) => FormBuilderFieldOption(
                                            value: val,
                                            child: Text(val,),
                                          ),
                                        )
                                            .toList(),
                                      ),
                                      new FormBuilderCheckboxList(
                                        decoration:
                                        InputDecoration(labelText: "Interior"),
                                        attribute: "Interior",
                                        options:  userDocument['Interior']
                                            .map<FormBuilderFieldOption>(
                                              (val) => FormBuilderFieldOption(
                                            value: val,
                                            child: Text(val,),
                                          ),
                                        )
                                            .toList(),
                                      ),

                                      new FormBuilderCheckboxList(
                                        decoration:
                                        InputDecoration(labelText: "Wheels"),
                                        attribute: "Wheels",
                                        options:  userDocument['Wheels']
                                            .map<FormBuilderFieldOption>(
                                              (val) => FormBuilderFieldOption(
                                            value: val,
                                            child: Text(val,),
                                          ),
                                        )
                                            .toList(),
                                      ),
                                      new FormBuilderCheckboxList(
                                        decoration:
                                        InputDecoration(labelText: "Under Vehicle"),
                                        attribute: "Under Vehicle",
                                        options:  userDocument['Under Vehicle']
                                            .map<FormBuilderFieldOption>(
                                              (val) => FormBuilderFieldOption(
                                            value: val,
                                            child: Text(val,),
                                          ),
                                        )
                                            .toList(),
                                      ),

                                      new FormBuilderCheckboxList(
                                        decoration:
                                        InputDecoration(labelText: "Under Hood"),
                                        attribute: "Under Hood",
                                        options:  userDocument['Under Hood']
                                            .map<FormBuilderFieldOption>(
                                              (val) => FormBuilderFieldOption(
                                            value: val,
                                            child: Text(val,),
                                          ),
                                        )
                                            .toList(),
                                      ),


                                      new FormBuilderCheckboxList(
                                        decoration:
                                        InputDecoration(labelText: "Dates"),
                                        attribute: "Dates",
                                        options:  userDocument['dates']
                                            .map<FormBuilderFieldOption>(
                                              (val) => FormBuilderFieldOption(
                                            value: val,
                                            child: Text(val,),
                                          ),
                                        )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          )
                      ),



                      Row(
                        children: <Widget>[
                          MaterialButton(
                            child: Text("Submit"),
                            onPressed: () {
                              if (_fbKey.currentState.saveAndValidate()) {
                                print(_fbKey.currentState.value);
                                _serviceDialog();

                              }
                            },
                          ),
                          MaterialButton(
                            child: Text("Reset"),
                            onPressed: () {
                              _fbKey.currentState.reset();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

