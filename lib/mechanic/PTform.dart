import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:intl/intl.dart';
import 'material_request.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Inspection extends StatefulWidget {
  String truckNumber;
  String driverName;
  String driverNumber;
  String driverID;
  String turnboy;
  String itemDescription;
  String truckType;

  Inspection({

    this.truckNumber,
    this.truckType,
    this.driverName,
    this.driverNumber,
    this.driverID,
    this.turnboy,
    this.itemDescription
  });
  @override
  _InspectionState createState() => _InspectionState();
}

class _InspectionState extends State<Inspection> {

  bool _isVisible = false;

  void initState() {
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

  GlobalKey<FormBuilderState> _serveKey = GlobalKey();

  GlobalKey<FormBuilderState> _engKey = GlobalKey();
  GlobalKey<FormBuilderState> _eleKey = GlobalKey();
  GlobalKey<FormBuilderState> _brKey = GlobalKey();
  GlobalKey<FormBuilderState> _frKey = GlobalKey();
  GlobalKey<FormBuilderState> _reKey = GlobalKey();
  GlobalKey<FormBuilderState> _wdKey = GlobalKey();
  GlobalKey<FormBuilderState> _caKey = GlobalKey();
  GlobalKey<FormBuilderState> _boKey = GlobalKey();
  GlobalKey<FormBuilderState> _saKey = GlobalKey();
  GlobalKey<FormBuilderState> _wKey = GlobalKey();
  GlobalKey<FormBuilderState> _oKey = GlobalKey();
  GlobalKey<FormBuilderState> _daKey = GlobalKey();
  GlobalKey<FormBuilderState> _coKey = GlobalKey();
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  List<TextEditingController> _controllers = new List();
  var options = ["Pass", "Fail"];
  Map map = {};



  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  Future<List<dynamic>> getEngine() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Engine'].toList();
        print(info);
        return info;
      }
    });
  }
  Future<List<dynamic>> getElectronics() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Electronics'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getBrakes() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Brakes'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getFsusp() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Front suspension'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getRsusp() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Rear suspension'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getOther() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

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

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Dates'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getWheeldetails() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Wheel details'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getCabin() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Cabin'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getBody() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Body'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getSafety() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Safety'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getWheels() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-truck');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Wheels'].toList();
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
                  CollectionReference reference = Firestore.instance.collection('service');

                  await reference.add(Map<String, dynamic>.from(map));
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
    _serveKey.currentState.reset();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Your data has been saved"),
          content: new Text("Do you want to Request any Material?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new  matRequest(
                      truckNo: widget.truckNumber,
                      driverName: widget.driverName,
                      truckType: widget.truckType,

                    )
                )
                );
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


  void _showDialog() {
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
                _loginCommand();

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
  void _loginCommand() {
    final form = formKey.currentState;

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('posttrip');

      await reference.add({
        "Truck": widget.truckNumber,
        "timestamp" : DateFormat('dd MMM yyyy').format(DateTime.now()),
        "date" : DateFormat('dd MMM yyyy').format(DateTime.now()),
        "Engine": _engKey.currentState.value,
        "Electronics": _eleKey.currentState.value,
        "Brakes": _brKey.currentState.value,
        "Front suspension": _frKey.currentState.value,
        "Rear suspension": _reKey.currentState.value,
        "Wheel Details": _wdKey.currentState.value,
        "Cabin": _caKey.currentState.value,
        "Body": _boKey.currentState.value,
        "Safety": _saKey.currentState.value,
        "Wheels": _wKey.currentState.value,
        "Other": _oKey.currentState.value,
        "Dates": _daKey.currentState.value,
        "Comment": _coKey.currentState.value,
        "company": userCompany,

      });
    }).then((result) =>

        _showRequest());

  }

  void _showRequest() {
    _engKey.currentState.reset();
    _eleKey.currentState.reset();
    _brKey.currentState.reset();
    _frKey.currentState.reset();
    _reKey.currentState.reset();
    _wdKey.currentState.reset();
    _caKey.currentState.reset();
    _boKey.currentState.reset();
    _saKey.currentState.reset();
    _wKey.currentState.reset();
    _oKey.currentState.reset();
    _daKey.currentState.reset();
    _coKey.currentState.reset();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Your data has been saved"),
          content: new Text("Do you want to Request any Material?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new  matRequest(
                      truckNo: widget.truckNumber,
                      driverName: widget.driverName,
                      truckType: widget.truckType,

                    )
                )
                );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspection Form',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.red[900],
      ),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisSize : MainAxisSize.min,
            children: <Widget>[
              FormBuilder(
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
                                key: _engKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new Text("Engine",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new FutureBuilder(
                                        future: getEngine(),
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
                                key: _eleKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new Text("Electronics",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new FutureBuilder(
                                        future: getElectronics(),
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
                                key: _brKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new Text("Brakes",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new FutureBuilder(
                                        future: getBrakes(),
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
                                key: _frKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new Text("Front suspension",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new FutureBuilder(
                                        future: getFsusp(),
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
                                key: _reKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new Text("Rear suspension",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new FutureBuilder(
                                        future: getRsusp(),
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
                                key: _wdKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new Text("Wheel details",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new FutureBuilder(
                                        future: getWheeldetails(),
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
                                key: _caKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new Text("Cabin",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new FutureBuilder(
                                        future: getCabin(),
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
                                key: _boKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new Text("Body",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new FutureBuilder(
                                        future: getBody(),
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
                                key: _saKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new Text("Safety",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                      new SizedBox(
                                        height: 10.0,
                                      ),
                                      new FutureBuilder(
                                        future: getSafety(),
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

                                                    return FormBuilderTextField(
                                                      attribute: snapshot.data[index],
                                                      decoration: InputDecoration(labelText: snapshot.data[index]),
                                                      validators: [FormBuilderValidators.required()],
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
                              key: _daKey,
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
                                                    format: DateFormat("yyyy-MM-dd"),firstDate: DateTime.now(),
                                                    valueTransformer: (value) {
                                                      return value.toString().substring(0,10);
                                                    },
                                                    validators: [FormBuilderValidators.required()],
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


                    Card(
                      child: new Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Container(
                          child: FormBuilder(
                            key: _coKey,
                            child: FormBuilderTextField(
                              attribute: "Comment",
                              decoration: InputDecoration(labelText: "Any Comment?"),
                            ),
                          ),
                        ),
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
                      _engKey.currentState.save();
                      _eleKey.currentState.save();
                      _brKey.currentState.save();
                      _frKey.currentState.save();
                      _reKey.currentState.save();
                      _wdKey.currentState.save();
                      _caKey.currentState.save();
                      _boKey.currentState.save();
                      _saKey.currentState.save();
                      _wKey.currentState.save();
                      _oKey.currentState.save();
                      _daKey.currentState.save();
                      _coKey.currentState.save();


                      if (_engKey.currentState.validate()&&
                          _eleKey.currentState.validate()&&
                          _brKey.currentState.validate()&&
                          _frKey.currentState.validate()&&
                          _reKey.currentState.validate()&&
                          _wdKey.currentState.validate()&&
                          _caKey.currentState.validate()&&
                          _boKey.currentState.validate()&&
                          _saKey.currentState.validate()&&
                          _wKey.currentState.validate()&&
                          _oKey.currentState.validate()&&
                          _coKey.currentState.validate()&&
                          _daKey.currentState.validate()) {

                        _showDialog();

                      }
                    },
                    textColor: Colors.white,
                    elevation: 16.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    color: Colors.red[900],
                  ),
                  MaterialButton(
                    child: Text("Reset"),
                    onPressed: () {
                      _engKey.currentState.reset();
                      _eleKey.currentState.reset();
                      _brKey.currentState.reset();
                      _frKey.currentState.reset();
                      _reKey.currentState.reset();
                      _wdKey.currentState.reset();
                      _caKey.currentState.reset();
                      _boKey.currentState.reset();
                      _saKey.currentState.reset();
                      _wKey.currentState.reset();
                      _oKey.currentState.reset();
                      _daKey.currentState.reset();
                      _coKey.currentState.reset();

                    },
                    textColor: Colors.red[900],
                    elevation: 16.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
