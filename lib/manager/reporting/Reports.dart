import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
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

class pTrip extends StatefulWidget {
  @override
  _pTripState createState() => _pTripState();
}

class _pTripState extends State<pTrip> {
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
    return File('/storage/emulated/0/Download/${DateFormat('MMM yyyy').format(DateTime.now())}Service.csv').create();
  }
  List<Map<dynamic, dynamic>> list = new List();

  Future <List<Map<dynamic, dynamic>>> getService() async{
    List<DocumentSnapshot> templist;


    Query collectionRef = Firestore.instance.collection("service").where('company', isEqualTo: userCompany);
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


    Query collectionRef = Firestore.instance.collection('service').where('company', isEqualTo: userCompany);
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


class cService extends StatefulWidget {
  @override
  _cServiceState createState() => _cServiceState();
}

class _cServiceState extends State<cService> {
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
    return File('/storage/emulated/0/Download/${DateFormat('MMM yyyy').format(DateTime.now())}carService.csv').create();
  }
  List<Map<dynamic, dynamic>> list = new List();

  Future <List<Map<dynamic, dynamic>>> getService() async{
    List<DocumentSnapshot> templist;


    Query collectionRef = Firestore.instance.collection("carService").where('company', isEqualTo: userCompany);
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


    Query collectionRef = Firestore.instance.collection('carService').where('company', isEqualTo: userCompany);
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
              Text("Elorry Car Service report")
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



class matReport extends StatefulWidget {
  @override
  _matReportState createState() => _matReportState();
}

class _matReportState extends State<matReport> {

  final _renderObjectKey = GlobalKey<ScaffoldState>();
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

  String fileP;

  Future<String> get _localP async {
    final directory = await getExternalStorageDirectory();
    return directory.absolute.path;
  }
  Future<File> get _localF async {
    final path = await _localP;
    fileP = '/storage/emulated/0/Download/data.csv';
    return File('/storage/emulated/0/Download/${DateFormat('MMM yyyy').format(DateTime.now())}MatRequest.csv').create();
  }

  getCsv() async {
    List<Map<String, dynamic>> dlist = new List();

    List<List<dynamic>> listGen = new List();
    List<DocumentSnapshot> temp;


    Query collectionRef = Firestore.instance.collection('requisition').where("status", isEqualTo: "LPO GENERATED" ).where('company', isEqualTo: userCompany);
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
      body: new Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SingleChildScrollView(
            child: RepaintBoundary(
              key: _renderObjectKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new SizedBox(
                    height: 50.0,
                  ),
                  new Card(
                    child: new Container(
                      margin: new EdgeInsets.only(left: 5.0, right: 5.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Column(
                              children: <Widget>[
                                new Text(
                                  "Materials Requested as at: ${DateFormat(' dd MMM yyyy').format(DateTime.now())}",
                                  style: new TextStyle(
                                      fontSize: 12.0, fontWeight: FontWeight.w700),
                                ),



                              ],
                            ),
                          ),
                          new SizedBox(
                            height: 10.0,
                          ),

                        ],
                      ),
                    ),
                  ),

                  new Card(
                    child: Column(
                      mainAxisSize:MainAxisSize.min,
                      children: <Widget>[
                        new StreamBuilder(
                          stream: Firestore.instance.collection('requisition').where("status", isEqualTo: "LPO GENERATED" ).where('company', isEqualTo: userCompany).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return new Text('Loading...');
                            return new FittedBox(
                              child: DataTable(
                                columnSpacing: 8,
                                columns: <DataColumn>[

                                  new DataColumn(label: Text('Date',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),)),
                                  new DataColumn(label: Text('Truck',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),)),
                                  new DataColumn(label: Text('Item',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),)),
                                  new DataColumn(label: Text('Brand',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),)),
                                  new DataColumn(label: Text('Price',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),)),
                                  new DataColumn(label: Text('Quantity',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),)),
                                  new DataColumn(label: Text('LPO \n Date',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),)),
                                  new DataColumn(label: Text('LPO \n Generated \n By',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),)),
                                ],
                                rows: _createRows(snapshot.data),

                              ),
                            );
                          },
                        ),
                      ],
                    ),

                  )

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  List<DataRow> _createRows(QuerySnapshot snapshot) {

    List<DataRow> newList = snapshot.documents.map((doc) {
      return new DataRow(
          cells: [
            DataCell(Text(doc.data["reqDate"],
              style: new TextStyle(fontSize: 8.0),)),
            DataCell(Text(doc.data["Truck"],
              style: new TextStyle(fontSize: 8.0),)),
            DataCell(Text(doc.data["Item"],
              style: new TextStyle(fontSize: 8.0),)),
            DataCell(Text(doc.data["approvedQuote"],
              style: new TextStyle(fontSize: 8.0),)),
            DataCell(Text(doc.data["price"],
              style: new TextStyle(fontSize: 8.0),)),
            DataCell(Text(doc.data["Quantity"],
              style: new TextStyle(fontSize: 8.0),)),
            DataCell(Text(doc.data["lpoDate"],
              style: new TextStyle(fontSize: 8.0),)),
            DataCell(Text(doc.data["prepared by"],
              style: new TextStyle(fontSize: 8.0),)),
          ]);}).toList();

    return newList;
  }

}


class repDiv extends StatefulWidget {
  @override
  _repDivState createState() => _repDivState();
}

class _repDivState extends State<repDiv> {

  initState() {
    // TODO: implement initState
    super.initState();
    getStringValue();
    getCserv ();
    getTserv();

  }

  String userCompany;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
    });

  }

  bool tServe = false;
  bool cServe = false;

  getTserv () async{
  final CollectionReference dbtServe = Firestore.instance.collection('service');

  QuerySnapshot _query = await dbtServe
      .where('company', isEqualTo: userCompany)
      .getDocuments();

  if (_query.documents.length > 0) {
  setState(() {
    tServe = true;
  });
  }
}

  getCserv () async{
    final CollectionReference dbcServe = Firestore.instance.collection('carService');

    QuerySnapshot _query = await dbcServe
        .where('company', isEqualTo: userCompany)
        .getDocuments();

    if (_query.documents.length > 0) {
      setState(() {
        cServe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff016836),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60.0,
              child: new Icon(Icons.assignment,
                color: const Color(0xff016836),
                size: 50.0,
              ),
            ),
            new SizedBox(
              height: 10.0,
            ),
            cServe == false ? new Offstage() :Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
              child: new InkWell(
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new cService()
                  ));
                },
                child: new Container(
                  height: 60.0,
                  margin: new EdgeInsets.only(top: 5.0),
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Container(
                      margin: new EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 2.0),
                      height: 60.0,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20.0))),
                      child: new Center(
                          child: new Text(
                            "Car Service History report",
                            style: new TextStyle(
                                color: const Color(0xff016836), fontSize: 20.0),
                          )),
                    ),
                  ),
                ),
              ),

            ),
            tServe == false ? new Offstage() :Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
              child: new InkWell(
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new pTrip()
                  ));
                },
                child: new Container(
                  height: 60.0,
                  margin: new EdgeInsets.only(top: 5.0),
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Container(
                      margin: new EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 2.0),
                      height: 60.0,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20.0))),
                      child: new Center(
                          child: new Text(
                            "Service History Report",
                            style: new TextStyle(
                                color: const Color(0xff016836), fontSize: 20.0),
                          )),
                    ),
                  ),
                ),
              ),

            ),

            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
              child: new InkWell(
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new matReport()
                  ));
                },
                child: new Container(
                  height: 60.0,
                  margin: new EdgeInsets.only(top: 5.0),
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Container(
                      margin: new EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 2.0),
                      height: 60.0,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20.0))),
                      child: new Center(
                          child: new Text(
                            "Material request Report",
                            style: new TextStyle(
                                color: const Color(0xff016836), fontSize: 20.0),
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
