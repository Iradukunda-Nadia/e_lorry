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


import 'package:json_table/json_table.dart';

class pTrip extends StatefulWidget {
  @override
  _pTripState createState() => _pTripState();
}

class _pTripState extends State<pTrip> {
  String filePath;
  Map<String,dynamic> engine ;
  Map<String,dynamic> electronics;
  Map<String,dynamic> brakes;
  Map<String,dynamic> frontSusp;
  Map<String,dynamic> rearSusp;
  Map<String,dynamic> wheelDetail;
  Map<String,dynamic> cabin;
  Map<String,dynamic> body;
  Map<String,dynamic> safety;
  Map<String,dynamic> frontWheels;
  Map<String,dynamic> backWheels;
  String truckNo;
  String evaluationDate;
  String inspection;
  String insurance;
  String greasing;
  String comment;
  String gasket;
  String hosepipe;
  String engineMounts;
  String fanBelt;
  String  radiator;
  String  injectorPump;
  int ptlength;
  bool _isLoading;

  String truck;
  String truckDriver;
  String driverNumber;
  String truckExpiry;
  String truckInsurance;
  String speedGov;
  String backTyre;
  String frontTyre;
  String spareTyre;
  String batWarranty;
  String datePurchased;
  String batterySerial;
  String dateGiven;
  String firstTank;
  String secondTank;
  String totalLitres;
  String averageKm;
  String currentKm;
  String nxtService;
  String kmOil;
  String greasefrontwheel;
  String date;
  String Mechanic;
  int servicelength;
  bool sData = false;

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/data.csv';
    return File('$path/data.csv').create();
  }



  _postTrip() async {
    var collectionReference = Firestore.instance.collection('posttrip').where('company', isEqualTo: userCompany);
    var query = collectionReference;
    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length > 0) {
        querySnapshot.documents.forEach((document)
        async {
          setState(() {
            engine = Map<String, dynamic>.from(document["engine"]);
            electronics = Map<String, dynamic>.from(document["electronics"]);
            brakes = Map<String, dynamic>.from(document["brakes"]);
            frontSusp = Map<String, dynamic>.from(document["front suspension"]);
            rearSusp = Map<String, dynamic>.from(document["rear suspension"]);
            wheelDetail = Map<String, dynamic>.from(document["wheel details"]);
            cabin = Map<String, dynamic>.from(document["cabin"]);
            body = Map<String, dynamic>.from(document["body"]);
            safety = Map<String, dynamic>.from(document["safety"]);
            frontWheels = Map<String, dynamic>.from(document["frontWheels"]);
            backWheels = Map<String, dynamic>.from(document["backWheels"]);
            truckNo = document["Truck"];
            gasket = document["Gasket"];
            hosepipe = document["Hose pipe"];
            engineMounts = document["Engine Mounts"];
            fanBelt = document["Fan belt and blades"];
            radiator = document["Radiator"];
            injectorPump = document["Injector Pump"];
            evaluationDate = document["date"];
            inspection = document["Inspection"];
            insurance = document["Insurance Expiry"];
            greasing = document["Greasing at KM"];
            comment = document["Comment"];
            ptlength = querySnapshot.documents.length;

          });
          setState(() {
            _isLoading = false;
          });


        });
      }
    });
  }


  _serviceCheck() async {
    var collectionReference = Firestore.instance.collection('service').where('company', isEqualTo: userCompany);
    var query = collectionReference;
    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length > 0) {
        querySnapshot.documents.forEach((document)
        async {
          setState(() {
            truck  = document["Truck"];
            truckDriver = document["Driver"];
            driverNumber = document["Number"];
            truckExpiry = document["Inspection Expiry"];
            truckInsurance = document["Insurance Expiry"];
            speedGov = document["Speed Governor Expiry"];
            backTyre = document["Back tyre serial number"];
            frontTyre = document["Front tyre serial number"];
            spareTyre = document["Spare tyre serial number"];
            batWarranty = document["Battery warranty"];
            datePurchased = document["Date purchased"];
            batterySerial = document["Battery serial number"];
            dateGiven = document["Date Given"];
            firstTank = document["1st Tank"];
            secondTank = document["2nd Tank"];
            totalLitres = document["Total litres"];
            averageKm = document["Average per kilometre"];
            currentKm = document["Current kilometres"];
            nxtService = document["Next service"];
            kmOil = document["Km when Oil, Gearbox, and Diff oil changed"];
            greasefrontwheel = document["Grease frontwheel"];
            date = document["todate"];
            Mechanic = document["Service by"];

            servicelength = querySnapshot.documents.length;

            sData = true;

          });

          setState(() {
            _isLoading = false;
          });


        });
      }
    });
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    _serviceCheck();
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

  Future<void> _printScreen() async {
    final RenderRepaintBoundary boundary =
    _renderObjectKey.currentContext.findRenderObject();
    final ui.Image im = await boundary.toImage();
    final ByteData bytes =
    await im.toByteData(format: ui.ImageByteFormat.rawRgba);
    print('Print Screen ${im.width}x${im.height} ...');



    final bool result =
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) {
      final pdf.Document document = pdf.Document();

      final PdfImage image = PdfImage(document.document,
          image: bytes.buffer.asUint8List(),
          width: im.width,
          height: im.height);

      document.addPage(pdf.Page(
          pageFormat: format,
          build: (pdf.Context context) {
            return pdf.Center(
              child: pdf.Expanded(
                child: pdf.Image(image),
              ),
            ); // Center
          })); // Page

      return document.save();
    });

  }

  String fileP;

  Future<String> get _localP async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localF async {
    final path = await _localP;
    fileP = '$path/data.csv';
    return File('$path/data.csv').create();
  }
  List<Map<dynamic, dynamic>> list = new List();

  Future <List<Map<dynamic, dynamic>>> getService() async{
    List<DocumentSnapshot> templist;


    CollectionReference collectionRef = Firestore.instance.collection("service");
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

    List<List<dynamic>> listGen = new List();
    List<DocumentSnapshot> temp;


    CollectionReference collectionRef = Firestore.instance.collection("service");
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    temp = collectionSnapshot.documents; // <--- ERROR

    listGen = List<List<dynamic>>.from(
      temp.map<dynamic>(
            (dynamic item) => item,
      ),
    );

    File f = await _localF;
    var csv = const ListToCsvConverter().convert(listGen);
    f.writeAsString(csv);

    return listGen;


  }

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(jsonFile);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.print),
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
                paginationRowCount: 10,
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

  Future<void> _printScreen() async {
    final RenderRepaintBoundary boundary =
    _renderObjectKey.currentContext.findRenderObject();
    final ui.Image im = await boundary.toImage();
    final ByteData bytes =
    await im.toByteData(format: ui.ImageByteFormat.rawRgba);
    print('Print Screen ${im.width}x${im.height} ...');



    final bool result =
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) {
      final pdf.Document document = pdf.Document();

      final PdfImage image = PdfImage(document.document,
          image: bytes.buffer.asUint8List(),
          width: im.width,
          height: im.height);

      document.addPage(pdf.Page(
          pageFormat: format,
          build: (pdf.Context context) {
            return pdf.Center(
              child: pdf.Expanded(
                child: pdf.Image(image),
              ),
            ); // Center
          })); // Page

      return document.save();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.print),
        //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
        onPressed: () {
          _printScreen();
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
            DataCell(Text(doc.data["brand"],
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
            Padding(
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
                            "Service",
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
                            "Material request",
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
