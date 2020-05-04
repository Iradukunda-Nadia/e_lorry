import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:intl/intl.dart';
import 'material_request.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class vehicleService extends StatefulWidget {



  String truckNumber;
  String driverName;
  String driverNumber;
  String driverID;
  String turnboy;
  String itemDescription;
  String truckType;

  vehicleService({

    this.truckNumber,
    this.truckType,
    this.driverName,
    this.driverNumber,
    this.driverID,
    this.turnboy,
    this.itemDescription
  });

  @override
  _vehicleServiceState createState() => _vehicleServiceState();
}

class _vehicleServiceState extends State<vehicleService> {
  Map<String,dynamic> fields ;

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
    _myActivity = '';
    _postTrip();
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



  _postTrip() async {
    var collectionReference = Firestore.instance.collection('posttrip');
    var query = collectionReference.where("company", isEqualTo: "elorry" );
    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length > 0) {
        querySnapshot.documents.forEach((document)
        async {
          setState(() {
            fields = Map<String, dynamic>.from(document["engine"]);

          });


        });
      }
    });
  }


  Future<List<dynamic>> getList() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('elorry-veh');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['fields'].toList();
        print('#');
        print(info); //this line prints [aa, aghshs, fffg, fug, ghh, fggg, ghhh]
        print(info.length); //this line prints 7
        return info;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vehicle"), backgroundColor: Colors.red[900],),
      body: new SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize : MainAxisSize.min,
              children: <Widget>[

                new Card(
                  child: Stack(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize : MainAxisSize.min,
                          children: <Widget>[
                            new SizedBox(
                              height: 10.0,
                            ),
                            new Text("Service",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

                            new SizedBox(
                              height: 10.0,
                            ),



                            new Flexible(
                              child: new FutureBuilder(
                                future: getList(),
                                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return Center(
                                      child: ListView.builder(
                                          padding: const EdgeInsets.only(bottom: 20.0),
                                          scrollDirection: Axis.vertical,
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index) {
                                            return DropDownFormField(
                                              titleText: snapshot.data[index],
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
                                            );
                                          }),
                                    );
                                  }
                                },
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

    );
  }
}

