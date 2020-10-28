import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:intl/intl.dart';
import 'material_request.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Car extends StatefulWidget {
  String truckNumber;
  String driverName;
  String driverNumber;
  String driverID;
  String itemDescription;
  String truckType;

  Car({

    this.truckNumber,
    this.truckType,
    this.driverName,
    this.driverNumber,
    this.driverID,
    this.itemDescription
  });
  @override
  _CarState createState() => _CarState();
}


class _CarState extends State<Car> {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey();
  GlobalKey<FormBuilderState> _Key = GlobalKey();
  GlobalKey<FormBuilderState> _ExKey = GlobalKey();
  GlobalKey<FormBuilderState> _IntKey = GlobalKey();
  GlobalKey<FormBuilderState> _wKey = GlobalKey();
  GlobalKey<FormBuilderState> _uvKey = GlobalKey();
  GlobalKey<FormBuilderState> _uhKey = GlobalKey();
  GlobalKey<FormBuilderState> _oKey = GlobalKey();
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  List<TextEditingController> _controllers = new List();
  var options = ["Pass", "Fail"];

  Future<List<dynamic>> getExterior() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-veh');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Exterior'].toList();
        print(info);
        return info;
      }
    });
  }
  Future<List<dynamic>> getInterior() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-veh');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Interior'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getWheels() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-veh');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Wheels'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getHood() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-veh');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Under Hood'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getUndervehicle() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-veh');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Under Vehicle'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getOther() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-veh');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Other'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getdates() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-veh');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['dates'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getSig() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-veh');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['sig'].toList();
        print(info); //this line prints 7
        return info;
      }
    });
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
      appBar: AppBar(title: Text("Vehicle"), backgroundColor: Colors.red[900],),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
                mainAxisSize : MainAxisSize.min,
                children: <Widget>[
                  FormBuilder(
                    key: _fbKey,
                    // readonly: true,
                    child: Column(
                      mainAxisSize : MainAxisSize.min,
                      children: <Widget>[

                        Card(

                          child: Column(
                            mainAxisSize : MainAxisSize.min,
                            children: [
                              new Flexible(

                                child: FormBuilder(
                                  key: _ExKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        new SizedBox(
                                          height: 10.0,
                                        ),
                                        new Text("Exterior",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                        new SizedBox(
                                          height: 10.0,
                                        ),
                                        new FutureBuilder(
                                          future: getExterior(),
                                          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Offstage();
                                            }
                                            if (!snapshot.hasData) {
                                              return Offstage();
                                            }
                                            else {
                                              return Center(
                                                child: ListView.builder(
                                                    padding: const EdgeInsets.only(bottom: 20.0),
                                                    scrollDirection: Axis.vertical,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: snapshot.data.length,
                                                    itemBuilder: (context, index) {

                                                      return FormBuilderDropdown(
                                                        attribute: snapshot.data[index],
                                                        decoration: InputDecoration(labelText: snapshot.data[index]),
                                                        // initialValue: 'Male',
                                                        hint: Text('Pass / Fail'),
                                                        validators: [FormBuilderValidators.required()],
                                                        items: [
                                                          DropdownMenuItem(
                                                            value: 'Pass',
                                                            child: Text('Pass'),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: 'Fail',
                                                            child: Text('Fail'),
                                                          ),
                                                        ],
                                                      );

                                                    }),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                        Card(

                          child: Column(
                            mainAxisSize : MainAxisSize.min,
                            children: [
                              new Flexible(
                                  child: FormBuilder(
                                    key: _IntKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          new SizedBox(
                                            height: 10.0,
                                          ),
                                          new Text("Interior",
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                          new SizedBox(
                                            height: 10.0,
                                          ),
                                          new FutureBuilder(
                                            future: getInterior(),
                                            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Offstage();
                                              }
                                              if (!snapshot.hasData) {
                                                return Offstage();
                                              }
                                              else {
                                                return Center(
                                                  child: ListView.builder(
                                                      padding: const EdgeInsets.only(bottom: 20.0),
                                                      scrollDirection: Axis.vertical,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot.data.length,
                                                      itemBuilder: (context, index) {

                                                        return FormBuilderDropdown(
                                                          attribute: snapshot.data[index],
                                                          decoration: InputDecoration(labelText: snapshot.data[index]),
                                                          // initialValue: 'Male',
                                                          hint: Text('Pass / Fail'),
                                                          validators: [FormBuilderValidators.required()],
                                                          items: [
                                                            DropdownMenuItem(
                                                              value: 'Pass',
                                                              child: Text('Pass'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Fail',
                                                              child: Text('Fail'),
                                                            ),
                                                          ],
                                                        );

                                                      }),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        Card(

                          child: Column(
                            mainAxisSize : MainAxisSize.min,
                            children: [
                              new Flexible(
                                  child: FormBuilder(
                                    key: _wKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          new SizedBox(
                                            height: 10.0,
                                          ),
                                          new Text("Wheels",
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                          new SizedBox(
                                            height: 10.0,
                                          ),
                                          new FutureBuilder(
                                            future: getWheels(),
                                            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }
                                              if (!snapshot.hasData) {
                                                return Offstage();
                                              }
                                              else {
                                                return Center(
                                                  child: ListView.builder(
                                                      padding: const EdgeInsets.only(bottom: 20.0),
                                                      scrollDirection: Axis.vertical,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot.data.length,
                                                      itemBuilder: (context, index) {

                                                        return FormBuilderDropdown(
                                                          attribute: snapshot.data[index],
                                                          decoration: InputDecoration(labelText: snapshot.data[index]),
                                                          // initialValue: 'Male',
                                                          hint: Text('Pass / Fail'),
                                                          validators: [FormBuilderValidators.required()],
                                                          items: [
                                                            DropdownMenuItem(
                                                              value: 'Pass',
                                                              child: Text('Pass'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Fail',
                                                              child: Text('Fail'),
                                                            ),
                                                          ],
                                                        );

                                                      }),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        Card(

                          child: Column(
                            mainAxisSize : MainAxisSize.min,
                            children: [
                              new Flexible(
                                  child: FormBuilder(
                                    key: _uvKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          new SizedBox(
                                            height: 10.0,
                                          ),
                                          new Text("Under Vehicle",
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                          new SizedBox(
                                            height: 10.0,
                                          ),
                                          new FutureBuilder(
                                            future: getUndervehicle(),
                                            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Offstage();
                                              }
                                              if (!snapshot.hasData) {
                                                return Offstage();
                                              }
                                              else {
                                                return Center(
                                                  child: ListView.builder(
                                                      padding: const EdgeInsets.only(bottom: 20.0),
                                                      scrollDirection: Axis.vertical,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot.data.length,
                                                      itemBuilder: (context, index) {

                                                        return FormBuilderDropdown(
                                                          attribute: snapshot.data[index],
                                                          decoration: InputDecoration(labelText: snapshot.data[index]),
                                                          // initialValue: 'Male',
                                                          hint: Text('Pass / Fail'),
                                                          validators: [FormBuilderValidators.required()],
                                                          items: [
                                                            DropdownMenuItem(
                                                              value: 'Pass',
                                                              child: Text('Pass'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Fail',
                                                              child: Text('Fail'),
                                                            ),
                                                          ],
                                                        );

                                                      }),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),

                        Card(

                          child: Column(
                            mainAxisSize : MainAxisSize.min,
                            children: [
                              new Flexible(
                                  child: FormBuilder(
                                    key: _uhKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          new SizedBox(
                                            height: 10.0,
                                          ),
                                          new Text("Under Hood",
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                          new SizedBox(
                                            height: 10.0,
                                          ),
                                          new FutureBuilder(
                                            future: getHood(),
                                            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Offstage();
                                              }
                                              if (!snapshot.hasData) {
                                                return Offstage();
                                              }
                                              else {
                                                return Center(
                                                  child: ListView.builder(
                                                      padding: const EdgeInsets.only(bottom: 20.0),
                                                      scrollDirection: Axis.vertical,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot.data.length,
                                                      itemBuilder: (context, index) {

                                                        return FormBuilderDropdown(
                                                          attribute: snapshot.data[index],
                                                          decoration: InputDecoration(labelText: snapshot.data[index]),
                                                          // initialValue: 'Male',
                                                          hint: Text('Pass / Fail'),
                                                          validators: [FormBuilderValidators.required()],
                                                          items: [
                                                            DropdownMenuItem(
                                                              value: 'Pass',
                                                              child: Text('Pass'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Fail',
                                                              child: Text('Fail'),
                                                            ),
                                                          ],
                                                        );

                                                      }),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        Card(

                          child: Column(
                            mainAxisSize : MainAxisSize.min,
                            children: [
                              new Flexible(
                                  child: FormBuilder(
                                    key: _oKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          new SizedBox(
                                            height: 10.0,
                                          ),
                                          new Text("Other",
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                          new SizedBox(
                                            height: 10.0,
                                          ),
                                          new FutureBuilder(
                                            future: getOther(),
                                            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Offstage();
                                              }
                                              if (!snapshot.hasData) {
                                                return Offstage();
                                              }
                                              else {
                                                return Center(
                                                  child: ListView.builder(
                                                      padding: const EdgeInsets.only(bottom: 20.0),
                                                      scrollDirection: Axis.vertical,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot.data.length,
                                                      itemBuilder: (context, index) {

                                                        return FormBuilderDropdown(
                                                          attribute: snapshot.data[index],
                                                          decoration: InputDecoration(labelText: snapshot.data[index]),
                                                          // initialValue: 'Male',
                                                          hint: Text('Pass / Fail'),
                                                          validators: [FormBuilderValidators.required()],
                                                          items: [
                                                            DropdownMenuItem(
                                                              value: 'Pass',
                                                              child: Text('Pass'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Fail',
                                                              child: Text('Fail'),
                                                            ),
                                                          ],
                                                        );

                                                      }),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),

                        Card(

                          child: Column(
                            mainAxisSize : MainAxisSize.min,
                            children: [
                              new Flexible(
                                child: FormBuilder(
                                  key: _Key,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        new SizedBox(
                                          height: 10.0,
                                        ),
                                        new Text("Dates",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                        new SizedBox(
                                          height: 10.0,
                                        ),
                                        new FutureBuilder(
                                          future: getdates(),
                                          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }
                                            if (!snapshot.hasData) {
                                              return Offstage();
                                            }
                                            else {
                                              return Center(
                                                child: ListView.builder(
                                                    padding: const EdgeInsets.only(bottom: 20.0),
                                                    scrollDirection: Axis.vertical,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: snapshot.data.length,
                                                    itemBuilder: (context, index) {

                                                      return FormBuilderDateTimePicker(
                                                        initialEntryMode: DatePickerEntryMode.calendar,
                                                        attribute: snapshot.data[index],
                                                        inputType: InputType.date,
                                                        format: DateFormat("yyyy-MM-dd"),
                                                        decoration:
                                                        InputDecoration(labelText: snapshot.data[index]),
                                                      );

                                                    }),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),




                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        child: Text("Submit"),
                        onPressed: () {
                          _fbKey.currentState.save();
                          _ExKey.currentState.save();
                          _IntKey.currentState.save();
                          _uhKey.currentState.save();
                          _uvKey.currentState.save();
                          _wKey.currentState.save();
                          _oKey.currentState.save();
                          _Key.currentState.save();


                          if (_ExKey.currentState.validate()&&
                              _IntKey.currentState.validate()&&
                              _uhKey.currentState.validate()&&
                              _uvKey.currentState.validate()&&
                              _wKey.currentState.validate()&&
                              _oKey.currentState.validate()&&
                              _Key.currentState.validate()) {
                            print(_fbKey.currentState.value);

                            Firestore.instance
                                .collection('carService')
                                .add({

                              "Exterior": _ExKey.currentState.value,
                              "Interior": _IntKey.currentState.value,
                              "Under Vehicle": _uvKey.currentState.value,
                              "Under Hood": _uhKey.currentState.value,
                              "Wheels": _wKey.currentState.value,
                              "Other": _oKey.currentState.value,
                              "Dates": _Key.currentState.value,
                              'Inspection Date': DateFormat('MMM yyyy').format(DateTime.now()),



                            });

                            _fbKey.currentState.reset();
                            _ExKey.currentState.reset();
                            _IntKey.currentState.reset();
                            _uhKey.currentState.reset();
                            _uvKey.currentState.reset();
                            _wKey.currentState.reset();
                            _oKey.currentState.reset();
                            _Key.currentState.reset();

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text("Your data has been saved"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
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
                        },
                      ),
                      MaterialButton(
                        child: Text("Reset"),
                        onPressed: () {
                          _fbKey.currentState.reset();
                          _ExKey.currentState.reset();
                          _IntKey.currentState.reset();
                          _uhKey.currentState.reset();
                          _uvKey.currentState.reset();
                          _wKey.currentState.reset();
                          _oKey.currentState.reset();
                          _Key.currentState.reset();
                        },
                      ),
                    ],
                  )
                ],
              ),
          ),
        ),
      ),
    );
  }
}
/**/
