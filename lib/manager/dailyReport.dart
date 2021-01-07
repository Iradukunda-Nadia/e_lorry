import 'package:e_lorry/manager/reporting/Reports.dart';
import 'package:e_lorry/manager/reporting/pdfView.dart';
import 'package:e_lorry/user/document.dart';
import 'package:e_lorry/user/post_trip.dart';
import 'package:e_lorry/user/truck_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

import 'package:printing/printing.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:json_table/json_table.dart';

import '../login.dart';
import 'carService.dart';

class dailyRep extends StatefulWidget {
  @override
  _dailyRepState createState() => _dailyRepState();
}

class _dailyRepState extends State<dailyRep>  with SingleTickerProviderStateMixin {

  TabController controller;
  String jsonFile;
  String userCompany;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
    });
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    controller = new TabController(length: 2, vsync: this);
    getStringValue();
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: const Color(0xff016836),
        centerTitle: true,
        title: Text(
          "Daily Activity Reports",
          textAlign: TextAlign.center,
        ),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/lo.png",
                    fit: BoxFit.contain,
                    height: 100.0,
                    width: 300.0,
                  ),
                  Text("Manager"),
                ],
              ),
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
                child: new Icon(Icons.assignment,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Report"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new repDiv()));
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
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  new LoginScreen()), (Route<dynamic> route) => false);
                }
            ),




          ],
        ),
      ),
      body: new TabBarView(
        physics: NeverScrollableScrollPhysics(),
        // Add tabs as widgets
        children: <Widget>[new PdfViewerPage(formType: 'fuel',),  new PdfViewerPage(formType: 'parts',) ],
        // set the controller
        controller: controller,
      ),
      // Set the bottom navigation bar
      bottomNavigationBar: new Material(
        // set the color of the bottom navigation bar
        color: const Color(0xff016836),
        // set the tab bar as the child of bottom navigation bar
        child: new TabBar(

          tabs: <Tab>[
            new Tab(
              text: 'Fuel',// set icon to the tab
              icon: new Icon(Icons.format_color_fill),
            ),
            new Tab(
              text: 'Parts',
              icon: new Icon(Icons.settings),
            ),

          ],
          // setup the controller
          controller: controller,
        ),
      ),
    );
  }
}

class dailyFuel extends StatefulWidget {
  @override
  _dailyFuelState createState() => _dailyFuelState();
}

class _dailyFuelState extends State<dailyFuel> {
  String filePath;

  @override
  initState() {
    // TODO: implement initState
    super.initState();

    getStringValue();
    getService();
  }
  bool toggle = true;

  String jsonFile;
  String userCompany;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
    });

  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  final _renderObjectKey = GlobalKey<ScaffoldState>();



  String fileP;

  Future<String> get _localP async {
    final directory = await getExternalStorageDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localF async {
    final path = await _localP;
    fileP = '/storage/emulated/0/Download/data.csv';
    return File('/storage/emulated/0/Download/${DateFormat('MMM yyyy').format(DateTime.now())}fuelRequest.csv').create();
  }
  List<Map<dynamic, dynamic>> list = new List();

  Future <List<Map<dynamic, dynamic>>> getService() async{
    List<DocumentSnapshot> templist;


    Query collectionRef = Firestore.instance.collection('fuelRequest');
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    templist = collectionSnapshot.documents; // <--- ERROR

    list = templist.map((DocumentSnapshot docSnapshot){
      return docSnapshot.data;
    }).toList();

    setState(() {
      jsonFile = jsonEncode(list);

    });

    return list;

  }



  getCsv() async {
    List<Map<String, dynamic>> dlist = new List();

    List<List<dynamic>> listGen = new List();
    List<DocumentSnapshot> temp;


    Query collectionRef =Firestore.instance.collection('fuelRequest').where('company', isEqualTo: userCompany).where('timestamp',isEqualTo: DateTime.now());
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    temp = collectionSnapshot.documents; // <--- ERROR

    dlist = temp.map((DocumentSnapshot docSnapshot){
      return docSnapshot.data;
    }).toList();

    await Permission.storage.request().isGranted;

    File f = await _localF;
    var csv = mapListToCsv(dlist);
    f.writeAsString(csv);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("File downloaded Succefully"),
          content: new Text("It is located in the Download folder"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String mapListToCsv(List<Map<String, dynamic>> mapList,
      {ListToCsvConverter converter}) {
    if (mapList == null) {
      return null;
    }
    converter ??= const ListToCsvConverter();
    var data = <List>[];
    var keys = <String>[];
    var keyIndexMap = <String, int>{};

    // Add the key and fix previous records
    int _addKey(String key) {
      var index = keys.length;
      keyIndexMap[key] = index;
      keys.add(key);
      for (var dataRow in data) {
        dataRow.add(null);
      }
      return index;
    }

    for (var map in mapList) {
      // This list might grow if a new key is found
      var dataRow = List(keyIndexMap.length);
      // Fix missing key
      map.forEach((key, value) {
        var keyIndex = keyIndexMap[key];
        if (keyIndex == null) {
          // New key is found
          // Add it and fix previous data
          keyIndex = _addKey(key);
          // grow our list
          dataRow = List.from(dataRow, growable: true)..add(value);
        } else {
          dataRow[keyIndex] = value;
        }
      });
      data.add(dataRow);
    }
    return converter.convert(<List>[]
      ..add(keys)
      ..addAll(data));
  }

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(jsonFile);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Row(children: [
          new Icon(Icons.file_download),
          SizedBox(width: 5.0,),
          new Text('Download Report')
        ],),
        //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
        onPressed: () {
          getCsv();
        },
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            children: [
              JsonTable(
                json,
                showColumnToggle: true,
                allowRowHighlight: true,
                rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                paginationRowCount: 8,
                onRowSelect: (index, map) {
                  print(index);
                  print(map);
                },
              ),
              SizedBox(
                height: 40.0,
              ),
              Text("Fuel Request report")
            ],
          ),
        ),
      ),
    );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  }
}

class dailyParts extends StatefulWidget {
  @override
  _dailyPartsState createState() => _dailyPartsState();
}

class _dailyPartsState extends State<dailyParts> {
  String filePath;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getStringValue();
    getService();
  }
  bool toggle = true;

  String jsonFile;
  String userCompany;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
    });

  }

  @override
  dispose(){
    super.dispose();
  }

  final _renderObjectKey = GlobalKey<ScaffoldState>();



  String fileP;

  Future<String> get _localP async {
    final directory = await getExternalStorageDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localF async {
    final path = await _localP;
    fileP = '/storage/emulated/0/Download/data.csv';
    return File('/storage/emulated/0/Download/${DateFormat('MMM yyyy').format(DateTime.now())}partRequest.csv').create();
  }
  List<Map<dynamic, dynamic>> list = new List();

  Future <List<Map<dynamic, dynamic>>> getService() async{
    List<DocumentSnapshot> templist;


    Query collectionRef = Firestore.instance.collection('partRequest').where('company', isEqualTo: userCompany);
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    templist = collectionSnapshot.documents; // <--- ERROR

    list = templist.map((DocumentSnapshot docSnapshot){
      return docSnapshot.data;
    }).toList();

    setState(() {
      jsonFile = jsonEncode(list);

    });

    return list;

  }



  getCsv() async {
    List<Map<String, dynamic>> dlist = new List();

    List<List<dynamic>> listGen = new List();
    List<DocumentSnapshot> temp;


    Query collectionRef = Firestore.instance.collection('partRequest').where('company', isEqualTo: userCompany).where('timestamp',isEqualTo: DateTime.now());;
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    temp = collectionSnapshot.documents; // <--- ERROR

    dlist = temp.map((DocumentSnapshot docSnapshot){
      return docSnapshot.data;
    }).toList();

    await Permission.storage.request().isGranted;

    File f = await _localF;
    var csv = mapListToCsv(dlist);
    f.writeAsString(csv);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("File downloaded Succefully"),
          content: new Text("It is located in the Download folder"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String mapListToCsv(List<Map<String, dynamic>> mapList,
      {ListToCsvConverter converter}) {
    if (mapList == null) {
      return null;
    }
    converter ??= const ListToCsvConverter();
    var data = <List>[];
    var keys = <String>[];
    var keyIndexMap = <String, int>{};

    // Add the key and fix previous records
    int _addKey(String key) {
      var index = keys.length;
      keyIndexMap[key] = index;
      keys.add(key);
      for (var dataRow in data) {
        dataRow.add(null);
      }
      return index;
    }

    for (var map in mapList) {
      // This list might grow if a new key is found
      var dataRow = List(keyIndexMap.length);
      // Fix missing key
      map.forEach((key, value) {
        var keyIndex = keyIndexMap[key];
        if (keyIndex == null) {
          // New key is found
          // Add it and fix previous data
          keyIndex = _addKey(key);
          // grow our list
          dataRow = List.from(dataRow, growable: true)..add(value);
        } else {
          dataRow[keyIndex] = value;
        }
      });
      data.add(dataRow);
    }
    return converter.convert(<List>[]
      ..add(keys)
      ..addAll(data));
  }

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(jsonFile);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Row(children: [
          new Icon(Icons.file_download),
          SizedBox(width: 5.0,),
          new Text('Download Report')
        ],),
        //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
        onPressed: () {
          getCsv();
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            children: [
              json == null ?
              Center(
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
                    Text("OOPS!! There is no activity to report"),
                  ],
                ),)
                  : JsonTable(
                json,
                showColumnToggle: true,
                allowRowHighlight: true,
                rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                paginationRowCount: 8,
                onRowSelect: (index, map) {
                  print(index);
                  print(map);
                },
              ),
              SizedBox(
                height: 40.0,
              ),
              Text("Parts Request report")
            ],
          ),
        ),
      ),
    );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  }
}





class dailyPtrip extends StatefulWidget {
  @override
  _dailyPtripState createState() => _dailyPtripState();
}

class _dailyPtripState extends State<dailyPtrip> {
  String filePath;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,

    ]);
    getStringValue();
    getService();
  }
  bool toggle = true;

  String jsonFile;
  String userCompany;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
    });

  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  final _renderObjectKey = GlobalKey<ScaffoldState>();



  String fileP;

  Future<String> get _localP async {
    final directory = await getExternalStorageDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localF async {
    final path = await _localP;
    fileP = '/storage/emulated/0/Download/data.csv';
    return File('/storage/emulated/0/Download/${DateFormat('MMM yyyy').format(DateTime.now())}PostTrip.csv').create();
  }
  List<Map<dynamic, dynamic>> list = new List();

  Future <List<Map<dynamic, dynamic>>> getService() async{
    List<DocumentSnapshot> templist;


    Query collectionRef = Firestore.instance.collection("posttrip").where('company', isEqualTo: userCompany);
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    templist = collectionSnapshot.documents; // <--- ERROR

    list = templist.map((DocumentSnapshot docSnapshot){
      return docSnapshot.data;
    }).toList();

    setState(() {
      jsonFile = jsonEncode(list);

    });

    return list;

  }



  getCsv() async {
    List<Map<String, dynamic>> dlist = new List();

    List<List<dynamic>> listGen = new List();
    List<DocumentSnapshot> temp;


    Query collectionRef = Firestore.instance.collection('posttrip').where('company', isEqualTo: userCompany);
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    temp = collectionSnapshot.documents; // <--- ERROR

    dlist = temp.map((DocumentSnapshot docSnapshot){
      return docSnapshot.data;
    }).toList();

    await Permission.storage.request().isGranted;

    File f = await _localF;
    var csv = mapListToCsv(dlist);
    f.writeAsString(csv);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("File downloaded Succefully"),
          content: new Text("It is located in the Download folder"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String mapListToCsv(List<Map<String, dynamic>> mapList,
      {ListToCsvConverter converter}) {
    if (mapList == null) {
      return null;
    }
    converter ??= const ListToCsvConverter();
    var data = <List>[];
    var keys = <String>[];
    var keyIndexMap = <String, int>{};

    // Add the key and fix previous records
    int _addKey(String key) {
      var index = keys.length;
      keyIndexMap[key] = index;
      keys.add(key);
      for (var dataRow in data) {
        dataRow.add(null);
      }
      return index;
    }

    for (var map in mapList) {
      // This list might grow if a new key is found
      var dataRow = List(keyIndexMap.length);
      // Fix missing key
      map.forEach((key, value) {
        var keyIndex = keyIndexMap[key];
        if (keyIndex == null) {
          // New key is found
          // Add it and fix previous data
          keyIndex = _addKey(key);
          // grow our list
          dataRow = List.from(dataRow, growable: true)..add(value);
        } else {
          dataRow[keyIndex] = value;
        }
      });
      data.add(dataRow);
    }
    return converter.convert(<List>[]
      ..add(keys)
      ..addAll(data));
  }

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(jsonFile);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Row(children: [
          new Icon(Icons.file_download),
          SizedBox(width: 5.0,),
          new Text('Download Report')
        ],),
        //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
        onPressed: () {
          getCsv();
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            children: [
              JsonTable(
                json,
                showColumnToggle: true,
                allowRowHighlight: true,
                rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                paginationRowCount: 8,
                onRowSelect: (index, map) {
                  print(index);
                  print(map);
                },
              ),
              SizedBox(
                height: 40.0,
              ),
              Text("Elorry Service report")
            ],
          ),
        ),
      ),
    );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  }
}


