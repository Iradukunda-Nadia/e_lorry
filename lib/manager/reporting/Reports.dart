import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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



class pTrip extends StatefulWidget {
  @override
  _pTripState createState() => _pTripState();
}

class _pTripState extends State<pTrip> {
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

  _postTrip() async {
    var collectionReference = Firestore.instance.collection('posttrip');
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
    var collectionReference = Firestore.instance.collection('service');
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
                                  "Service report as at: ${DateFormat(' dd MMM yyyy').format(DateTime.now())}",
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
                          stream: Firestore.instance.collection('service').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return new Text('Loading...');
                            return new FittedBox(
                              child: DataTable(
                                columnSpacing: 8,
                                columns: <DataColumn>[

                                  new DataColumn(label: Text('Truck',style: new TextStyle(fontSize: 8, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Inspection \n Date',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Inspection \n Expiry',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Insurance \n Expiry',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Speed \n Gov \n Expiry',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Back tyre \n serial',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Front tyre \n serial',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('spare tyre \n serial',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Battery \n serial \n number',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Date \n purchased',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Battery \n warranty',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Date \n Given',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('1st Tank',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('2nd Tank',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Total litres',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Average \n per km',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Current \n kilometres',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                                  new DataColumn(label: Text('Km \n Oil \n changed',style: new TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
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

          _isLoading ? WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text("Loading ... please wait"),
              content: CircularProgressIndicator(),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog

              ],
            ),
          ): new Container(
            height: 0.0,
            width: 0.0,
          ),
        ],
      ),
    );
  }

  List<DataRow> _createRows(QuerySnapshot snapshot) {

    List<DataRow> newList = snapshot.documents.map((doc) {
      return new DataRow(
          cells: [
            DataCell(Text(doc.data["Truck"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["timestamp"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Inspection Expiry"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Insurance Expiry"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Speed Governor Expiry"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Back tyre serial number"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Front tyre serial number"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Spare tyre serial number"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Battery serial number"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Date purchased"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Battery warranty"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Date Given"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["1st Tank"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["2nd Tank"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Total litres"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Average per kilometre"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Current kilometres"],
              style: new TextStyle(fontSize: 10.0),)),
            DataCell(Text(doc.data["Km when Oil, Gearbox, and Diff oil changed"],
              style: new TextStyle(fontSize: 10.0),)),
          ]);}).toList();

    return newList;
  }

}


class matReport extends StatefulWidget {
  @override
  _matReportState createState() => _matReportState();
}

class _matReportState extends State<matReport> {

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
                          stream: Firestore.instance.collection('requisition').where("status", isEqualTo: "LPO GENERATED" ).snapshots(),
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
