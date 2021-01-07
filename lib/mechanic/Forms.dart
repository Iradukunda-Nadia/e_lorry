import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:intl/intl.dart';
import 'material_request.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:e_lorry/reuse.dart';


class ServiceForm extends StatefulWidget {



  String truckNumber;
  String driverName;
  String driverNumber;
  String driverID;
  String turnboy;
  String itemDescription;
  String truckType;

  ServiceForm({

    this.truckNumber,
    this.truckType,
    this.driverName,
    this.driverNumber,
    this.driverID,
    this.turnboy,
    this.itemDescription
  });

  @override
  _ServiceFormState createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> with SingleTickerProviderStateMixin{

  ScrollController _scrollViewController;
  TabController _tabController;
  bool _isVisible = false;

  String _email;
  String _password;
  String _gasket;
  String _hose;
  String _mounts;
  String _fanbelt;
  String _radiator;
  String _flywheel;
  String _injpump;
  String _myActivity;
  String _frenol;
  String _start;
  String _fullLights;
  String _dimLights;
  String _tailLights;
  String _indicators;
  String _brakeLights;
  String _parkingLights;
  String _batteries;
  String _charging;
  String _wiper;
  String _horn;
  String _reverse;
  String _booster;
  String _linings;
  String _handbreaks;
  String _springBracket;
  String _steering;
  String _gear;
  String _rod;
  String _kingpins;
  String _wheelBearings;
  String _shock;
  String _springs;
  String _uBolts;
  String _propellers;
  String _exhaust;
  String _oilSeals;
  String _treads;
  String _studs;
  String _spanner;
  String _mounting;
  String _lighting;
  String _seats;
  String _door;
  String _windscreen;
  String _gauges;
  String _mudguard;
  String _chive;
  String _cargo;
  String _painting;
  String _fueltank;
  String _padLock;
  String _lifeSaver;
  String _fireextinguisher;
  String _faidkit;
  String _reflector;
  String _speedGovernor;
  String _insu;
  String _insp;
  String _batteriesWarranty;
  String _greasing;
  String _diff;
  String _frontLeft;
  String _frontRight;
  String _backLL;
  String _backLR;
  String _backRL;
  String _backRR;




  bool autovalidate = true;

  String _inspection;
  String _insurance;
  String _speedgov;
  String _bktyre;
  String _frtyre;
  String _sptyre;
  String _batwarranty;
  String _purchase;
  String _batserial;
  String _first;
  String _second;
  String _ttliters;
  String _avg;
  String _current;
  String _nxt;
  String _given;
  String _oil;
  String _grease;
  String _breaks;
  String _caps;
  String _mirror;
  String _multi;
  String _padlock;
  String _firstaid;
  String _triangle;
  String _fire;
  String _date;
  String _date2;
  String _comment;


  TextEditingController pInsu = TextEditingController();
  TextEditingController pInsp = TextEditingController();
  TextEditingController sInsp = TextEditingController();
  TextEditingController sInsu = TextEditingController();
  TextEditingController sge = TextEditingController();
  TextEditingController nex = TextEditingController();
  TextEditingController pd = TextEditingController();
  TextEditingController dg = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var mask = new MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

  @override


  void _saveService() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _given = dg.text;
        _nxt = nex.text;
        _insurance = sInsu.text;
        _inspection = sInsp.text;
        _purchase = pd.text;
        _speedGovernor = sge.text;



      });
      _serviceDialog();
    }
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

                  await reference.add({
                    "Truck": widget.truckNumber,
                    "Driver": widget.driverName,
                    "Number": widget.driverNumber,
                    "Inspection Expiry": _inspection,
                    "Insurance Expiry": _insurance,
                    "Speed Governor Expiry":_speedGovernor,
                    "Back tyre serial number":_bktyre,
                    "Front tyre serial number": _frtyre,
                    "Spare tyre serial number": _sptyre,
                    "Battery warranty": _batwarranty,
                    "Date purchased": _purchase,
                    "Battery serial number": _batserial,
                    "Date Given": _given,
                    "1st Tank": _first,
                    "2nd Tank": _second,
                    "Total litres": _ttliters,
                    "Average per kilometre": _avg,
                    "Current kilometres": _current,
                    "Next service": _nxt,
                    "Km when Oil, Gearbox, and Diff oil changed": _oil,
                    "Grease frontwheel": _grease,
                    "timestamp" : DateFormat('MMM yyyy').format(DateTime.now()),
                    "date":_date2,
                    "Service by" : "Mechanic",
                  });
                }).then((result) =>

                    _showRequest());


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

  void _serviceCommand() {
    final form = formKey.currentState;

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('service');

      await reference.add({
        "Truck": widget.truckNumber,
        "Driver": widget.driverName,
        "Number": widget.driverNumber,
        "Inspection Expiry": sInsp.text,
        "Insurance Expiry": sInsu.text,
        "Speed Governor Expiry": sge.text,
        "Back tyre serial number":_bktyre,
        "Front tyre serial number": _frtyre,
        "Spare tyre serial number": _sptyre,
        "Battery warranty": _batwarranty,
        "Date purchased": pd.text,
        "Battery serial number": _batserial,
        "Date Given": dg.text,
        "1st Tank": _first,
        "2nd Tank": _second,
        "Total litres": _ttliters,
        "Average per kilometre": _avg,
        "Current kilometres": _current,
        "Next service": nex.text,
        "Km when Oil, Gearbox, and Diff oil changed": _oil,
        "Grease frontwheel": _grease,
        "timestamp" : DateFormat('dd MMM yyyy').format(DateTime.now()),
        "date":_date2,
        "todate" : DateFormat(' dd MMM yyyy').format(DateTime.now()),
        "Service by" : "Mechanic",
      });
    }).then((result) =>

        _showRequest());

  }

  void _submitCommand() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _insu = pInsu.text;
        _insp = pInsp.text;



      });
      _showDialog();
    }
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



  Map<dynamic, dynamic> engine = <dynamic, dynamic>{
    'Score': 1.0,
    'completion': false,
  };

  void _loginCommand() {
    final form = formKey.currentState;

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('posttrip');

      await reference.add({
        "Truck": widget.truckNumber,
        "Insurance Expiry": _insu,
        "Inspection": _insp,
        "Greasing at KM": _greasing,
        "Comment": _comment,
        "timestamp" : DateFormat('dd MMM yyyy').format(DateTime.now()),
        "date" : DateFormat('dd MMM yyyy').format(DateTime.now()),
        "engine" : {
          "Gasket": _gasket,
          "Hose pipe": _hose,
          "Engine Mounts": _mounts,
          "Fan belt and blades":_fanbelt,
          "Radiator": _radiator,
          "Injector Pump": _injpump,
        },
        "electronics" : {
          "Frenol": _frenol,
          "Starting and stoping": _start,
          "Full lights": _fullLights,
          "Dim lights":_dimLights,
          "Tail lights": _tailLights,
          "Indicators": _indicators,
          "Brake Lights": _brakeLights,
          "Parking Lights": _parkingLights,
          "Batteries and terminals": _batteries,
          "Charging system": _charging,
          "Wiper arm blades": _wiper,
          "Horn": _horn,
          "Reverse bazaar": _reverse,
        },
        "brakes" : {
          "Brake booster": _booster,
          "Brake Linings": _linings,
          "Hand brakes": _handbreaks,
          "Return spring brackets":_springBracket,
        },
        "front suspension" : {
          "Steering": _steering,
          "Gear system": _gear,
          "Rod ends and draglink": _rod,
          "King pins":_kingpins,
          "Wheel Bearings":_wheelBearings,
          "Shock Absorbers":_shock,
        },
        "rear suspension" : {
          "Springs": _springs,
          "U-bolts": _uBolts,
          "Propellers, center bolt, diff": _propellers,
          "Exhaust system":_exhaust,
        },
        "wheel details" : {
          "Oil seals": _oilSeals,
          "Tyre treads": _treads,
          "Studs and a lug nuts": _studs,
          "Spare wheel, spanner , jack":_exhaust,
        },
        "cabin" : {
          "Mounting": _mounting,
          "Lighting": _lighting,
          "Seats": _seats,
          "Doors, locks, multilocks":_door,
          "Windscreen and sidemirrors":_windscreen,
          "All gauges functional":_gauges,
          "Mudguard":_mudguard,
        },
        "body" : {
          "Chive reflectors": _chive,
          "Cargo": _cargo,
          "Painting": _painting,
          "Fuel Tank":_fueltank,
          "Padlocks":_padLock,
        },
        "safety" : {
          "Life saver": _lifeSaver,
          "Fire Extinguisher": _fireextinguisher,
          "First Aid Kit": _faidkit,
          "Reflector Jacket and helmet":_reflector,
          "Speed governor":_speedGovernor,
        },
        "frontWheels" : {
          "FrontRight": _frontRight,
          "FrontLeft": _frontLeft,
        },
        "backWheels" : {
          "BackRight- Right": _backRR,
          "BackRight- Left": _backRL,
          "BackLeft- Right": _backLR,
          "BackLeft -Left":_backLL,
        },

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
          title: new Text("Your data has been saved"),
          content: new Text("Do you want to Request any Material?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("YES"),
              onPressed: () {
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
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _tabController = new TabController(vsync: this, length: 2);
    _myActivity = '';
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("field").getDocuments();
    return qn.documents;

  }

  CollectionReference collectionReference =
  Firestore.instance.collection("field");

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
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
            new SingleChildScrollView(
        child: SafeArea(
          child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[

          new Card(
                child: Stack(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("ENGINE",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                          new SizedBox(
                            height: 10.0,
                          ),
                          DropDownFormField(
                            titleText: 'Gasket',
                            hintText: 'Pass/Fail',
                            value: _gasket,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _gasket = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _gasket = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Hose pipe',
                            hintText: 'Pass/Fail',
                            value: _hose,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _hose = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _hose = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Engine Mounts',
                            hintText: 'Pass/Fail',
                            value: _mounts,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _mounts = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _mounts = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Fan Belt and Blades',
                            hintText: 'Pass/Fail',
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            value: _fanbelt,
                            onSaved: (value) {
                              setState(() {
                                _fanbelt = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _fanbelt = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Radiator',
                            hintText: 'Pass/Fail',
                            value: _radiator,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _radiator = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _radiator = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Injector Pump',
                            hintText: 'Pass/Fail',
                            value: _injpump,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _injpump = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _injpump = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                        ],
                      ),
                    ),


                  ],
                ),
              ),

              new Card(
                child: Stack(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("ELECTRONICS",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                          new SizedBox(
                            height: 10.0,
                          ),
                          DropDownFormField(
                            titleText: 'Frenol',
                            hintText: 'Pass/Fail',
                            value: _frenol,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _frenol = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _frenol = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Starting/Stopping',
                            hintText: 'Pass/Fail',
                            value: _start,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _start = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _start = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Full Lights',
                            hintText: 'Pass/Fail',
                            value: _fullLights,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _fullLights = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _fullLights = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Dim Lights',
                            hintText: 'Pass/Fail',
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            value: _dimLights,
                            onSaved: (value) {
                              setState(() {
                                _dimLights = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _dimLights = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Tail Lights',
                            hintText: 'Pass/Fail',
                            value: _tailLights,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _tailLights = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _tailLights = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Indicators',
                            hintText: 'Pass/Fail',
                            value: _indicators,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _indicators = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _indicators = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Brake Lights',
                            hintText: 'Pass/Fail',
                            value: _brakeLights,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _brakeLights = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _brakeLights = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),


                          DropDownFormField(
                            titleText: 'Parking Lights',
                            hintText: 'Pass/Fail',
                            value: _parkingLights,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _parkingLights = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _parkingLights = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Batteries & Terminals',
                            hintText: 'Pass/Fail',
                            value: _batteries,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _batteries = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _batteries = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Charging System',
                            hintText: 'Pass/Fail',
                            value: _charging,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _charging = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _charging = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Wiper and arm blades',
                            hintText: 'Pass/Fail',
                            value: _wiper,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _wiper = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _wiper = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Horn',
                            hintText: 'Pass/Fail',
                            value: _horn,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _horn = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _horn = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Reverse Bazzaar',
                            hintText: 'Pass/Fail',
                            value: _reverse,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _reverse = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _reverse = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                        ],
                      ),
                    ),


                  ],
                ),
              ),
              new Card(
                child: Stack(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("BRAKES",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                          new SizedBox(
                            height: 10.0,
                          ),
                          DropDownFormField(
                            titleText: 'Brake Booster',
                            hintText: 'Pass/Fail',
                            value: _booster,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _booster = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _booster = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Brake Linings',
                            hintText: 'Pass/Fail',
                            value: _linings,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _linings = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _linings = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Hand Brakes',
                            hintText: 'Pass/Fail',
                            value: _handbreaks,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _handbreaks = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _handbreaks = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Return spring bracket',
                            hintText: 'Pass/Fail',
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            value: _springBracket,
                            onSaved: (value) {
                              setState(() {
                                _springBracket = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _springBracket = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),



                        ],
                      ),
                    ),


                  ],
                ),
              ),
              new Card(
                child: Stack(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("FRONT SUSPENSION",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                          new SizedBox(
                            height: 10.0,
                          ),
                          DropDownFormField(
                            titleText: 'Steering',
                            hintText: 'Pass/Fail',
                            value: _steering,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _steering = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _steering = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Gear System',
                            hintText: 'Pass/Fail',
                            value: _gear,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _gear = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _gear = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Rod ends and Draglink',
                            hintText: 'Pass/Fail',
                            value: _rod,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _rod = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _rod = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'King Pins',
                            hintText: 'Pass/Fail',
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            value: _kingpins,
                            onSaved: (value) {
                              setState(() {
                                _kingpins = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _kingpins = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Wheel  bearings',
                            hintText: 'Pass/Fail',
                            value: _wheelBearings,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _wheelBearings = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _wheelBearings = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Shock absorbers',
                            hintText: 'Pass/Fail',
                            value: _shock,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _shock = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _shock = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),


                        ],
                      ),
                    ),


                  ],
                ),
              ),

              new Card(
                child: Stack(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("REAR SUSPENSION",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                          new SizedBox(
                            height: 10.0,
                          ),
                          DropDownFormField(
                            titleText: 'Springs',
                            hintText: 'Pass/Fail',
                            value: _springs,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _springs = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _springs = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'U-Bolts',
                            hintText: 'Pass/Fail',
                            value: _uBolts,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _uBolts = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _uBolts = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Propellers, Centerbolt, Diff',
                            hintText: 'Pass/Fail',
                            value: _propellers,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _propellers = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _propellers = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Exhaust Systems',
                            hintText: 'Pass/Fail',
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            value: _exhaust,
                            onSaved: (value) {
                              setState(() {
                                _exhaust = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _exhaust = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),


                        ],
                      ),
                    ),


                  ],
                ),
              ),
              new Card(
                child: Stack(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("WHEELS DETAIL",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                          new SizedBox(
                            height: 10.0,
                          ),
                          DropDownFormField(
                            titleText: 'Oil Seals',
                            hintText: 'Pass/Fail',
                            value: _oilSeals,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _oilSeals = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _oilSeals = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Tyre treads not less than 3mm',
                            hintText: 'Pass/Fail',
                            value: _treads,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _treads = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _treads = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Studs and lug nuts',
                            hintText: 'Pass/Fail',
                            value: _studs,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _studs = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _studs = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Spare wheel,spanner, jack',
                            hintText: 'Pass/Fail',
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            value: _spanner,
                            onSaved: (value) {
                              setState(() {
                                _spanner = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _spanner = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),


                        ],
                      ),
                    ),


                  ],
                ),
              ),

              new Card(
                child: Stack(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("CABIN",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                          new SizedBox(
                            height: 10.0,
                          ),
                          DropDownFormField(
                            titleText: 'Mounting',
                            hintText: 'Pass/Fail',
                            value: _mounting,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _mounting = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _mounting = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Tyre treads not less than 3mm',
                            hintText: 'Pass/Fail',
                            value: _lighting,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _lighting = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _lighting = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Seats',
                            hintText: 'Pass/Fail',
                            value: _seats,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _seats = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _seats = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Door, door locks and multi locks',
                            hintText: 'Pass/Fail',
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            value: _door,
                            onSaved: (value) {
                              setState(() {
                                _door = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _door = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Windscreen and side mirrors',
                            hintText: 'Pass/Fail',
                            value: _windscreen,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _windscreen = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _windscreen = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'All gauges functional',
                            hintText: 'Pass/Fail',
                            value: _gauges,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _gauges = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _gauges = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Mud guard',
                            hintText: 'Pass/Fail',
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            value: _mudguard,
                            onSaved: (value) {
                              setState(() {
                                _mudguard = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _mudguard = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),


                        ],
                      ),
                    ),


                  ],
                ),
              ),
              new Card(
                child: Stack(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("BODY",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                          new SizedBox(
                            height: 10.0,
                          ),
                          DropDownFormField(
                            titleText: 'Chive reflectors',
                            hintText: 'Pass/Fail',
                            value: _chive,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _chive = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _chive = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Cargo space clean and not leaking',
                            hintText: 'Pass/Fail',
                            value: _cargo,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _cargo = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _cargo = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Painting',
                            hintText: 'Pass/Fail',
                            value: _painting,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _painting = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _painting = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Fuel Tank',
                            hintText: 'Pass/Fail',
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            value: _fueltank,
                            onSaved: (value) {
                              setState(() {
                                _fueltank = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _fueltank = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Padlocks',
                            hintText: 'Pass/Fail',
                            value: _padLock,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _padLock = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _padLock = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                        ],
                      ),
                    ),


                  ],
                ),
              ),

              new Card(
                child: Stack(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("SAFETY BELTS",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                          new SizedBox(
                            height: 10.0,
                          ),
                          DropDownFormField(
                            titleText: 'Triangle / Lifesavers',
                            hintText: 'Pass/Fail',
                            value: _lifeSaver,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _lifeSaver = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _lifeSaver = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Fire Extinguisher',
                            hintText: 'Pass/Fail',
                            value: _fireextinguisher,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _fireextinguisher = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _fireextinguisher = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'First aid Kit',
                            hintText: 'Pass/Fail',
                            value: _faidkit,
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _faidkit = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _faidkit = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),

                          DropDownFormField(
                            titleText: 'Reflector jacket, helmet',
                            hintText: 'Pass/Fail',
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            value: _reflector,
                            onSaved: (value) {
                              setState(() {
                                _reflector = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _reflector = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          DropDownFormField(
                            titleText: 'Speed Governor',
                            hintText: 'Pass/Fail',
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                            },
                            value: _speedGovernor,
                            onSaved: (value) {
                              setState(() {
                                _speedGovernor = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _speedGovernor = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Pass",
                                "value": "Pass",
                              },
                              {
                                "display": "Fail",
                                "value": "Fail",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),


                        ],
                      ),
                    ),


                  ],
                ),
              ),
              new SizedBox(
                height: 10.0,
              ),
              new Text("WHEELS",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

              new SizedBox(
                height: 10.0,
              ),
              new Card(
                child: Stack(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("FRONT WHEELS",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                          new SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    hintText: 'serial number',
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Front right',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Required' : null,
                                onSaved: (val) => _frontRight = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    hintText: 'serial number',
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Front left',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Required' : null,
                                onSaved: (val) => _frontLeft = val,
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),


                  ],
                ),
              ),
              new Card(
                child: Stack(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("BACK WHEELS",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                          new SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    hintText: 'serial number',
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Back Left - left',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Required' : null,
                                onSaved: (val) => _backLL = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    hintText: 'serial number',
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Back left- right',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Required' : null,
                                onSaved: (val) => _backLR = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    hintText: 'serial number',
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Back Right- left',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Required' : null,
                                onSaved: (val) => _backRL = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    hintText: 'serial number',
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Back Right- right',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Required' : null,
                                onSaved: (val) => _backRR = val,
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),


                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Container(
                  child: TextFormField(
                    controller: pInsu,
                    decoration: InputDecoration(
                      labelText: "Insurance expiry",
                      hintText: "Enter Date",),
                    onTap: () async{
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = await showDatePicker(
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100));

                      pInsu.text = DateFormat(' dd MMM yyyy').format(date);},),

                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Container(
                  child: TextFormField(
                    controller: pInsp,
                    decoration: InputDecoration(
                      labelText: "Next inspection",
                      hintText: "Enter Date",),
                    onTap: () async{
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = await showDatePicker(
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100));

                      pInsp.text = DateFormat(' dd MMM yyyy').format(date);},),
                ),
              ),


              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Container(
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SFUIDisplay'
                    ),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        labelText: 'Batteries Warranty',
                        labelStyle: TextStyle(
                            fontSize: 11
                        )
                    ),
                    validator: (val) =>
                    val.isEmpty  ? 'Required' : null,
                    onSaved: (val) => _batteriesWarranty = val,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Container(
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SFUIDisplay'
                    ),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        labelText: 'Servicing and greasing @km',
                        labelStyle: TextStyle(
                            fontSize: 11
                        )
                    ),
                    validator: (val) =>
                    val.isEmpty  ? 'Required' : null,
                    onSaved: (val) => _greasing = val,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Container(
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SFUIDisplay'
                    ),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        labelText: 'Diff oil change',
                        labelStyle: TextStyle(
                            fontSize: 11
                        )
                    ),
                    validator: (val) =>
                    val.isEmpty  ? 'Required' : null,
                    onSaved: (val) => _diff = val,
                  ),
                ),
              ),

              RaisedButton(
                child: Text('Do you have a comment?'),
                onPressed: showToast,
              ),

              Visibility (
                visible: _isVisible,
                child: Card(
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Container(
                      child: TextFormField(
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay'
                        ),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            labelText: 'comment',
                            labelStyle: TextStyle(
                                fontSize: 11
                            )
                        ),
                        validator: (val) =>
                        val.isEmpty  ? null : null,
                        onSaved: (val) => _comment = val,
                      ),
                    ),
                  ),
                ),
              ),

              new SizedBox(
                height: 10.0,
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
            new SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                       ExpansionTile(title: Text("Dates"),
                         children: <Widget>[
                           Padding(
                             padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                             child: Container(
                               child: TextFormField(
                                 controller: sInsp,
                                 decoration: InputDecoration(
                                   labelText: "Insp expiry",
                                   hintText: "Enter Date",),
                                 onTap: () async{
                                   DateTime date = DateTime(1900);
                                   FocusScope.of(context).requestFocus(new FocusNode());

                                   date = await showDatePicker(
                                       context: context,
                                       initialDate:DateTime.now(),
                                       firstDate:DateTime(1900),
                                       lastDate: DateTime(3000));

                                   sInsp.text = DateFormat(' MM/DD/YYYY').format(date);},),
                             ),
                           ),
                           Padding(
                             padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                             child: Container(
                               child: TextFormField(
                                 controller: sInsu,
                                 decoration: InputDecoration(
                                   labelText: "Insurance expiry",
                                   hintText: "Enter Date",),
                                 onTap: () async{
                                   DateTime date = DateTime(1900);
                                   FocusScope.of(context).requestFocus(new FocusNode());

                                   date = await showDatePicker(
                                       context: context,
                                       initialDate:DateTime.now(),
                                       firstDate:DateTime(1900),
                                       lastDate: DateTime(3000));

                                   sInsu.text = DateFormat(' dd MMM yyyy').format(date);},),
                             ),
                           ),

                           Padding(
                             padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                             child: Container(
                               child: TextFormField(
                                 controller: sge,
                                 decoration: InputDecoration(
                                   labelText: "Speed Governor expiry",
                                   hintText: "Enter Date",),
                                 onTap: () async{
                                   DateTime date = DateTime(1900);
                                   FocusScope.of(context).requestFocus(new FocusNode());

                                   date = await showDatePicker(
                                       context: context,
                                       initialDate:DateTime.now(),
                                       firstDate:DateTime(1900),
                                       lastDate: DateTime(3000));

                                   sge.text = DateFormat(' dd MMM yyyy').format(date);},),
                             ),
                           ),
                           Padding(
                             padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                             child: Container(
                               child: TextFormField(
                                 controller: nex,
                                 decoration: InputDecoration(
                                   labelText: "Next Service",
                                   hintText: "Enter Date",),
                                 onTap: () async{
                                   DateTime date = DateTime(1900);
                                   FocusScope.of(context).requestFocus(new FocusNode());

                                   date = await showDatePicker(
                                       context: context,
                                       initialDate:DateTime.now(),
                                       firstDate:DateTime(1900),
                                       lastDate: DateTime(3000));

                                   nex.text = DateFormat(' dd MMM yyyy').format(date);},),
                             ),
                           ),
                         ],
                       ),

                      ExpansionTile(title: Text("Wheels"),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(

                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Front-Left serial number',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _bktyre = val,
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
                                    labelText: 'Front-Right serial number',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                              ),
                            ),
                          ),
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
                                    labelText: 'Back Left - left serial number',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
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
                                    labelText: 'Back Left- right serial number',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
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
                                    labelText: 'Back Right- left Serial number',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _frtyre = val,
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
                                    labelText: 'Back Right -left serial number',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _bktyre = val,
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
                                    labelText: 'Spare tyre Serial Number',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _sptyre = val,
                              ),
                            ),
                          ),
                        ],
                      ),

                      ExpansionTile(title: Text("Battery"),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(

                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Battery Waranty',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _batwarranty = val,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Container(
                              child: TextFormField(
                                controller: pd,
                                decoration: InputDecoration(
                                  labelText: "Purchase Date",
                                  hintText: "Enter Date",),
                                onTap: () async{
                                  DateTime date = DateTime(1900);
                                  FocusScope.of(context).requestFocus(new FocusNode());

                                  date = await showDatePicker(
                                      context: context,
                                      initialDate:DateTime.now(),
                                      firstDate:DateTime(1900),
                                      lastDate: DateTime(3000));

                                  pd.text = DateFormat(' dd MMM yyyy').format(date);},),
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
                                    labelText: 'Battery serial number',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _batserial = val,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Container(
                              child: TextFormField(
                                controller: dg,
                                decoration: InputDecoration(
                                  labelText: "Date Given",
                                  hintText: "Enter Date",),
                                onTap: () async{
                                  DateTime date = DateTime(1900);
                                  FocusScope.of(context).requestFocus(new FocusNode());

                                  date = await showDatePicker(
                                      context: context,
                                      initialDate:DateTime.now(),
                                      firstDate:DateTime(1900),
                                      lastDate: DateTime(3000));

                                  dg.text = DateFormat(' dd MMM yyyy').format(date);},),
                            ),
                          ),
                        ],
                      ),

                      ExpansionTile(title: Text("Fuel"),
                      children: <Widget>[
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
                                  labelText: '1st Tank',
                                  labelStyle: TextStyle(
                                      fontSize: 11
                                  )
                              ),
                              validator: (val) =>
                              val.isEmpty  ? 'Enter a valid value' : null,
                              onSaved: (val) => _first = val,
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
                                  labelText: '2nd Tank',
                                  labelStyle: TextStyle(
                                      fontSize: 11
                                  )
                              ),
                              validator: (val) =>
                              val.isEmpty  ? 'Enter a valid value' : null,
                              onSaved: (val) => _second = val,
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
                                  labelText: 'Total Liters',
                                  labelStyle: TextStyle(
                                      fontSize: 11
                                  )
                              ),
                              validator: (val) =>
                              val.isEmpty  ? 'Enter a valid value' : null,
                              onSaved: (val) => _ttliters = val,
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
                                  labelText: 'Average per Kilometre',
                                  labelStyle: TextStyle(
                                      fontSize: 11
                                  )
                              ),
                              validator: (val) =>
                              val.isEmpty  ? 'Enter a valid value' : null,
                              onSaved: (val) => _avg = val,
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
                                  labelText: 'Current Kilometres',
                                  labelStyle: TextStyle(
                                      fontSize: 11
                                  )
                              ),
                              validator: (val) =>
                              val.isEmpty  ? 'Enter a valid value' : null,
                              onSaved: (val) => _current = val,
                            ),
                          ),
                        ),
                      ],),

                      ExpansionTile(title: Text("KM. when"),
                        children: <Widget>[
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
                                    labelText: 'oil changed',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _oil = val,
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
                                    labelText: 'Gearbox oil changed',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _oil = val,
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
                                    labelText: 'Diff oil changed',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _oil = val,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(title: Text("Specifics"),
                        children: <Widget>[
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
                                    labelText: 'Greasefront wheel',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _grease = val,
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
                                    labelText: 'Brake system check',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _breaks = val,
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
                                    labelText: 'Fuel Caps',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _caps = val,
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
                                    labelText: 'Side mirrors',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _mirror = val,
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
                                    labelText: 'Multi-lock',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _multi = val,
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
                                    labelText: 'Padlock',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _padlock = val,
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
                                    labelText: 'Firstaid Box',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _firstaid = val,
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
                                    labelText: 'Triangle',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _triangle = val,
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
                                    labelText: 'Fire Extinguisher',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? 'Enter a valid value' : null,
                                onSaved: (val) => _fire = val,
                              ),
                            ),
                          ),
                        ],
                      ),









                      new SizedBox(
                        height: 10.0,
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                        child: MaterialButton(
                          onPressed: () {
                            _saveService();
                          },
                          child: Text('SAVE FORM',
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
          ],
          controller: _tabController,
        ),
      ),

    );
  }
}

