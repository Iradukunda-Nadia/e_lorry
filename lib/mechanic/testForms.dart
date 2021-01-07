import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:intl/intl.dart';
import 'material_request.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TestForms extends StatefulWidget {
  String truckNumber;
  String driverName;
  String driverNumber;
  String driverID;
  String turnboy;
  String itemDescription;
  String truckType;
  String fR;
  String fL;
  String bR1;
  String bL1;
  String bR2;
  String bL2;
  String docID;

  final Map<String,dynamic> tyres;

  TestForms({
    this.docID,
    this.fR,
    this.fL,
    this.bR1,
    this.bL1,
    this.bR2,
    this.bL2,
    this.tyres,
    this.truckNumber,
    this.truckType,
    this.driverName,
    this.driverNumber,
    this.driverID,
    this.turnboy,
    this.itemDescription
  });
  @override
  _TestFormsState createState() => _TestFormsState();
}

class _TestFormsState extends State<TestForms> with SingleTickerProviderStateMixin{
  ScrollController _scrollViewController;
  TabController _tabController;
  bool _isVisible = false;



  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _tabController = new TabController(vsync: this, length: 2);
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
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
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
  final frController = TextEditingController();
  final fLController = TextEditingController();
  final bR1Controller = TextEditingController();
  final bR2Controller = TextEditingController();
  final bL1Controller = TextEditingController();
  final bL2Controller = TextEditingController();
  var options = ["Pass", "Fail"];
  Map map = {};
  String inspection;
  String insurance;



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


  Future<List<dynamic>> getBat() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-serve');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Battery'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getDates() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-serve');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Dates'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getFuel() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-serve');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Fuel'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getKm() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-serve');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['KM. when'].toList();
        print(info);
        return info;
      }
    });
  }

  Future<List<dynamic>> getSpecifics() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-serve');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Specifics'].toList();
        print(info);
        return info;
      }
    });
  }
  Future<List<dynamic>> getWheel() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('${userCompany}-serve');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['Wheels'].toList();
        print(info);
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
  Future<void> _loginCommand() async {
    final form = formKey.currentState;

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('posttrip');

      await reference.add({
        "Truck": widget.truckNumber,
        "timestamp" : DateTime.now(),
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
        'inspection': inspection,
        'insurance': insurance,

      });
      print("Second text field: ${frController.text}");
      await Firestore.instance
          .collection("trucks")
          .document(widget.docID)
          .updateData({
        'Front Right': frController.text ==''|| frController.text == null? '': frController.text,
        'Front Left': fLController.text ==''|| fLController.text == null? '': fLController.text,
        'Back Left1': bL1Controller.text ==''|| bL1Controller.text == null? '': bL1Controller.text,
        'Back Right1': bR1Controller.text ==''|| bR1Controller.text == null? '': bR1Controller.text,
        'Back Right2': bR2Controller.text ==''|| bR2Controller.text == null? '': bR2Controller.text,
        'Back Left2': bL2Controller.text ==''|| bL2Controller.text == null? '': bL2Controller.text,

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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){ //<-- headerSliverBuilder
          return <Widget>[
            new SliverAppBar(
              title: new Text("Select Form"),
              centerTitle: true,
              pinned: true,                       //<-- pinned to true
              floating: true,                     //<-- floating to true
              forceElevated: innerBoxIsScrolled,
              backgroundColor: Colors.red[900],//<-- forceElevated to innerBoxIsScrolled
              bottom: new TabBar(
                labelColor: Colors.red[900],
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.only(left: 30, right: 30),
                indicator: BoxDecoration(
                  color: Colors.white,),
                tabs: <Tab>[
                  new Tab(
                    text: "POST TRIP",
                  ),
                  new Tab(
                    text: "SERVICE",
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },

        body: new TabBarView(
          children: <Widget>[
            SingleChildScrollView(
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

                                                          return FormBuilderChoiceChip(
                                                            spacing: 10.0,
                                                            runSpacing: 10.0,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            attribute: snapshot.data[index],
                                                            decoration: InputDecoration(labelText: snapshot.data[index]),
                                                            validators: [FormBuilderValidators.required()],
                                                            options: [
                                                              FormBuilderFieldOption(
                                                                value: 'Pass',child: Text('Pass'),),
                                                              FormBuilderFieldOption(
                                                                value: 'Fail',
                                                                child: Text('Fail'),),

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

                                                          return Column(
                                                            children: [

                                                              FormBuilderChoiceChip(
                                                                attribute: snapshot.data[index],
                                                                spacing: 10.0,
                                                                runSpacing: 10.0,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                ),
                                                                decoration: InputDecoration(
                                                                    labelText: snapshot.data[index],
                                                                    fillColor: Colors.red[900],
                                                                ),
                                                                validators: [FormBuilderValidators.required()],
                                                                options: [
                                                                  FormBuilderFieldOption(
                                                                    value: 'Pass',child: Text('Pass'),),
                                                                  FormBuilderFieldOption(
                                                                    value: 'Fail',
                                                                    child: Text('Fail'),),

                                                                ],
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

                                                          return FormBuilderChoiceChip(
                                                            spacing: 10.0,
                                                            runSpacing: 10.0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            attribute: snapshot.data[index],
                                                            decoration: InputDecoration(labelText: snapshot.data[index]),
                                                            validators: [FormBuilderValidators.required()],
                                                            options: [
                                                              FormBuilderFieldOption(
                                                                value: 'Pass',child: Text('Pass'),),
                                                              FormBuilderFieldOption(
                                                                value: 'Fail',
                                                                child: Text('Fail'),),

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
                                                    child: Column(

                                                      children: [
                                                        new SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        new Text("Brakes",
                                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                                        new SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        ListView.builder(
                                                            padding: const EdgeInsets.only(bottom: 20.0),
                                                            scrollDirection: Axis.vertical,
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: snapshot.data.length,
                                                            itemBuilder: (context, index) {

                                                              return FormBuilderChoiceChip(
                                                                spacing: 10.0,
                                                                runSpacing: 10.0,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10.0),

                                                                ),
                                                                attribute: snapshot.data[index],
                                                                decoration: InputDecoration(labelText: snapshot.data[index]),
                                                                validators: [FormBuilderValidators.required()],
                                                                options: [
                                                                  FormBuilderFieldOption(
                                                                    value: 'Pass',child: Text('Pass'),),
                                                                  FormBuilderFieldOption(
                                                                    value: 'Fail',
                                                                    child: Text('Fail'),),

                                                                ],
                                                              );

                                                            }),
                                                      ],
                                                    ),
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
                                            new Text("Front Suspension",
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

                                                          return FormBuilderChoiceChip(
                                                            spacing: 10.0,
                                                            runSpacing: 10.0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            attribute: snapshot.data[index],
                                                            decoration: InputDecoration(labelText: snapshot.data[index]),
                                                            validators: [FormBuilderValidators.required()],
                                                            options: [
                                                              FormBuilderFieldOption(
                                                                value: 'Pass',child: Text('Pass'),),
                                                              FormBuilderFieldOption(
                                                                value: 'Fail',
                                                                child: Text('Fail'),),

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
                                            new Text("Rear Suspension",
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

                                                          return FormBuilderChoiceChip(
                                                            spacing: 10.0,
                                                            runSpacing: 10.0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            attribute: snapshot.data[index],
                                                            decoration: InputDecoration(labelText: snapshot.data[index]),
                                                            validators: [FormBuilderValidators.required()],
                                                            options: [
                                                              FormBuilderFieldOption(
                                                                value: 'Pass',child: Text('Pass'),),
                                                              FormBuilderFieldOption(
                                                                value: 'Fail',
                                                                child: Text('Fail'),),

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

                                                          return FormBuilderChoiceChip(
                                                            spacing: 10.0,
                                                            runSpacing: 10.0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            attribute: snapshot.data[index],
                                                            decoration: InputDecoration(labelText: snapshot.data[index]),
                                                            validators: [FormBuilderValidators.required()],
                                                            options: [
                                                              FormBuilderFieldOption(
                                                                value: 'Pass',child: Text('Pass'),),
                                                              FormBuilderFieldOption(
                                                                value: 'Fail',
                                                                child: Text('Fail'),),

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

                                                          return FormBuilderChoiceChip(
                                                            spacing: 10.0,
                                                            runSpacing: 10.0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            attribute: snapshot.data[index],
                                                            decoration: InputDecoration(labelText: snapshot.data[index]),
                                                            validators: [FormBuilderValidators.required()],
                                                            options: [
                                                              FormBuilderFieldOption(
                                                                value: 'Pass',child: Text('Pass'),),
                                                              FormBuilderFieldOption(
                                                                value: 'Fail',
                                                                child: Text('Fail'),),

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
                                            new Text("Tyres",
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                            new SizedBox(
                                              height: 10.0,
                                            ),
                                            widget.fR =="" || widget.fR == null ? FormBuilderTextField(
                                              attribute: "Front Right",
                                              controller: frController,
                                              decoration: InputDecoration(
                                                labelText: "Front Right",
                                                floatingLabelBehavior:FloatingLabelBehavior.always,
                                                prefixText: "Serial Number:",
                                              ),
                                            )
                                                :FormBuilderChoiceChip(
                                              spacing: 10.0,
                                              runSpacing: 10.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              attribute: "Front Right",
                                              decoration: InputDecoration(
                                                labelText: 'Front Right Serial number: ${widget.fR}',
                                              ),
                                              options: [
                                                FormBuilderFieldOption(
                                                    value: 'Pass', child: Text('Pass')),
                                                FormBuilderFieldOption(
                                                    value: 'Fail', child: Text('Fail')),
                                              ],
                                            ),
                                            widget.fL ==""|| widget.fL == null? FormBuilderTextField(
                                              attribute: "Front Left",
                                              controller: fLController,
                                              decoration: InputDecoration(
                                                labelText: "Front Left",
                                                floatingLabelBehavior:FloatingLabelBehavior.always,
                                                prefixText: "Serial Number:",
                                              ),
                                            )
                                                :FormBuilderChoiceChip(
                                              spacing: 10.0,
                                              runSpacing: 10.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              attribute: "Front Left",
                                              decoration: InputDecoration(
                                                labelText: 'Front Left Serial number: ${widget.fL}',
                                              ),
                                              options: [
                                                FormBuilderFieldOption(
                                                    value: 'Pass', child: Text('Pass')),
                                                FormBuilderFieldOption(
                                                    value: 'Fail', child: Text('Fail')),
                                              ],
                                            ),
                                            widget.bR1 =="" || widget.bR1 == null? FormBuilderTextField(
                                              attribute: "Rear Right 1",
                                              controller: bR1Controller,
                                              decoration: InputDecoration(
                                                labelText: "Rear Right 1",
                                                floatingLabelBehavior:FloatingLabelBehavior.always,
                                                prefixText: "Serial Number:",
                                              ),
                                            )
                                                :FormBuilderChoiceChip(
                                              spacing: 10.0,
                                              runSpacing: 10.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              attribute: "Rear Right 1",
                                              decoration: InputDecoration(
                                                labelText: 'Rear Right 1 Serial number: ${widget.bR1}',
                                              ),
                                              options: [
                                                FormBuilderFieldOption(
                                                    value: 'Pass', child: Text('Pass')),
                                                FormBuilderFieldOption(
                                                    value: 'Fail', child: Text('Fail')),
                                              ],
                                            ),
                                            widget.bL1 =="" || widget.bL1 == null ?  FormBuilderTextField(
                                              attribute: "Rear Left 1",
                                              controller: bL1Controller,
                                              decoration: InputDecoration(
                                                labelText: "Rear Left 1",
                                                floatingLabelBehavior:FloatingLabelBehavior.always,
                                                prefixText: "Serial Number:",
                                              ),
                                            )
                                                :FormBuilderChoiceChip(
                                              spacing: 10.0,
                                              runSpacing: 10.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              attribute: "Rear Left 1",
                                              decoration: InputDecoration(
                                                labelText: 'Rear Left 1 Serial number: ${widget.bL1}',
                                              ),
                                              options: [
                                                FormBuilderFieldOption(
                                                    value: 'Pass', child: Text('Pass')),
                                                FormBuilderFieldOption(
                                                    value: 'Fail', child: Text('Fail')),
                                              ],
                                            ),
                                            widget.bR2 =="" || widget.bR2 == null? FormBuilderTextField(
                                              attribute: "Rear Right 2",
                                              controller: bR2Controller,
                                              decoration: InputDecoration(
                                                labelText: "Rear Right 2",
                                                floatingLabelBehavior:FloatingLabelBehavior.always,
                                                prefixText: "Serial Number:",
                                              ),
                                            )
                                                :FormBuilderChoiceChip(
                                              spacing: 10.0,
                                              runSpacing: 10.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              attribute: "Rear Right 2",
                                              decoration: InputDecoration(
                                                labelText: 'Rear Right 2 Serial number: ${widget.bR2}',
                                              ),
                                              options: [
                                                FormBuilderFieldOption(
                                                    value: 'Pass', child: Text('Pass')),
                                                FormBuilderFieldOption(
                                                    value: 'Fail', child: Text('Fail')),
                                              ],
                                            ),
                                            widget.bL2 =="" || widget.bL2 == null? FormBuilderTextField(
                                              attribute: "Rear Left 2",
                                              controller: bL2Controller,
                                              decoration: InputDecoration(
                                                labelText: "Rear Left 2",
                                                floatingLabelBehavior:FloatingLabelBehavior.always,
                                                prefixText: "Serial Number:",
                                              ),
                                            )
                                                :FormBuilderChoiceChip(
                                              spacing: 10.0,
                                              runSpacing: 10.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              attribute: "Rear Left 2",
                                              decoration: InputDecoration(
                                                labelText: 'Rear Left 2 Serial number: ${widget.bL2}',
                                              ),
                                              options: [
                                                FormBuilderFieldOption(
                                                    value: 'Pass', child: Text('Pass')),
                                                FormBuilderFieldOption(
                                                    value: 'Fail', child: Text('Fail')),
                                              ],
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

                                                          return FormBuilderChoiceChip(
                                                            spacing: 10.0,
                                                            runSpacing: 10.0,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            attribute: snapshot.data[index],
                                                            decoration: InputDecoration(labelText: snapshot.data[index]),
                                                            validators: [FormBuilderValidators.required()],
                                                            options: [
                                                              FormBuilderFieldOption(
                                                                value: 'Pass',child: Text('Pass'),),
                                                              FormBuilderFieldOption(
                                                                value: 'Fail',
                                                                child: Text('Fail'),),

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
                                                    child: Column(
                                                      children: [
                                                        new SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        new Text("Other",
                                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                                        new SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        ListView.builder(
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
                                                      ],
                                                    ),
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
                                                  child: Column(
                                                    children: [
                                                      new SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      new Text("Dates",
                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                                                      new SizedBox(
                                                        height: 10.0,
                                                      ),
                                                  FormBuilderDateTimePicker(
                                                    initialEntryMode: DatePickerEntryMode.calendar,
                                                    attribute: 'Inspection Date',
                                                    inputType: InputType.date,
                                                    format: DateFormat("yyyy-MM-dd"),firstDate: DateTime.now(),
                                                    valueTransformer: (value) {
                                                      return value.toString().substring(0,10);
                                                    },
                                                    validators: [FormBuilderValidators.required()],
                                                    decoration:
                                                    InputDecoration(labelText: 'Inspection Date'),
                                                    onSaved: (val) => inspection = DateFormat('MM/DD/YYYY').format(val),
                                                  ),
                                                      FormBuilderDateTimePicker(
                                                        initialEntryMode: DatePickerEntryMode.calendar,
                                                        attribute: 'Insurance Expiry',
                                                        inputType: InputType.date,
                                                        format: DateFormat("yyyy-MM-dd"),firstDate: DateTime.now(),
                                                        valueTransformer: (value) {
                                                          return value.toString().substring(0,10);
                                                        },
                                                        validators: [FormBuilderValidators.required()],
                                                        decoration:
                                                        InputDecoration(labelText: 'Insurance Expiry'),
                                                        onSaved: (val) => insurance = DateFormat('MM/DD/YYYY').format(val),
                                                      ),
                                                    ],
                                                  ),
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

            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisSize : MainAxisSize.min,
                  children: <Widget>[
                    FormBuilder(
                      key: _serveKey,
                      // readonly: true,
                      child: Column(
                        mainAxisSize : MainAxisSize.min,
                        children: <Widget>[

                          Card(

                            child: Column(
                              mainAxisSize : MainAxisSize.min,
                              children: [
                                new Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ExpansionTile(title: Text("Dates", style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xff016836),),),
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[

                                            new SizedBox(
                                              height: 10.0,
                                            ),
                                            new FutureBuilder(
                                              future: getDates(),
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
                                                            attribute: snapshot.data[index],
                                                            inputType: InputType.date,
                                                            format: DateFormat("dd-MMM-yyyy"),
                                                            firstDate: DateTime.now(),
                                                            initialEntryMode: DatePickerEntryMode.calendar,
                                                            valueTransformer: (value) {
                                                              return value.toString().substring(0,10);
                                                            },
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
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Card(
                            child: Column(
                              mainAxisSize : MainAxisSize.min,
                              children: [
                                new Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ExpansionTile(title: Text("Battery", style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xff016836),),),
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              new SizedBox(
                                                height: 10.0,
                                              ),
                                              new FutureBuilder(
                                                future: getBat(),
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
                                        ],
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ExpansionTile(title: Text("KM. When", style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xff016836),),),
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              new SizedBox(
                                                height: 10.0,
                                              ),
                                              new FutureBuilder(
                                                future: getKm(),
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
                                        ],
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ExpansionTile(title: Text("Fuel", style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xff016836),),),
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              new SizedBox(
                                                height: 10.0,
                                              ),
                                              new FutureBuilder(
                                                future: getFuel(),
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
                                        ],
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ExpansionTile(title: Text("Wheels", style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xff016836),),),
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              new SizedBox(
                                                height: 10.0,
                                              ),
                                              new FutureBuilder(
                                                future: getWheel(),
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
                                        ],
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ExpansionTile(title: Text("Specifics", style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xff016836),),),
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              new SizedBox(
                                                height: 10.0,
                                              ),
                                              new FutureBuilder(
                                                future: getSpecifics(),
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
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),






                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          child: Text("Submit"),
                          onPressed: () {
                            _serveKey.currentState.save();
                            if (_serveKey.currentState.validate()) {

                              map.addAll(
                                  {

                                    'timestamp' : DateFormat('dd MMM yyyy').format(DateTime.now()),
                                    'month' : DateFormat('MMM').format(DateTime.now()),
                                    'Truck': widget.truckNumber,
                                    'Driver': widget.driverName,
                                    'Number': widget.driverNumber,
                                    'company': userCompany,
                                  }
                              );
                              map.addAll(_serveKey.currentState.value);
                              print(map);
                              _serviceDialog();
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
                            _serveKey.currentState.reset();

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
            )
          ],
          controller: _tabController,
        ),
      ) ,
    );
  }
}


