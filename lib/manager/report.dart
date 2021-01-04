import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:printing/printing.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';


class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
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

  String appby;
  String prepby;
  String reqComment;
  String itemName;
  String itemQuantity;
  String itemNumber;
  String reqName;
  String reqDate;
  String reqOne;
  String reqTwo;
  String reqThree;
  String reqBrand;
  String reqPrice;
  String reqSupplier;
  String reqStatus;
  int lpolength;
  int servicelength;

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

  int reqlength;

  String matName;
  String matQuantity;
  String matNumber;
  String truckType;
  bool pData = false;
  bool sData = false;
  bool rData = false;
  bool lData = false;
  String today = DateFormat(' dd MMM yyyy').format(DateTime.now()).toString();
  _postTrip() async {
    var collectionReference = Firestore.instance.collection('posttrip').where('company', isEqualTo: userCompany);
    var query = collectionReference.where("date", isEqualTo: today );
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
            pData = true;

          });


        });
      }
    });
    _lpoCheck();
  }

  _lpoCheck() async {
    var collectionReference = Firestore.instance.collection('lpo').where('company', isEqualTo: userCompany);
    var query = collectionReference.where("date", isEqualTo: today );
    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length > 0) {
        querySnapshot.documents.forEach((document)
        async {
          setState(() {
            itemName = document['Item'];
            itemQuantity = document['Quantity'];
            itemNumber = document['lpoNumber'];
            reqPrice = document['Amount'];
            reqDate = document['date'];
            reqSupplier = document['Supplier'];
            appby = document['Approved by'];
            prepby = document['prepared by'];

            lpolength = querySnapshot.documents.length;
            lData = true;

          });


        });
      }
    });
    _serviceCheck();
  }

  _serviceCheck() async {
    var collectionReference = Firestore.instance.collection('service').where('company', isEqualTo: userCompany);
    var query = collectionReference.where("todate", isEqualTo: today );
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
            datePurchased = document["Battery warranty"];
            batterySerial = document["Battery warranty"];
            dateGiven = document["Battery warranty"];
            firstTank = document["Battery warranty"];
            secondTank = document["Battery warranty"];
            totalLitres = document["Battery warranty"];
            averageKm = document["Battery warranty"];
            currentKm = document["Battery warranty"];
            nxtService = document["Battery warranty"];
            kmOil = document["Battery warranty"];
            greasefrontwheel = document["Battery warranty"];
            date = document["Battery warranty"];
            Mechanic = document["Battery warranty"];

            servicelength = querySnapshot.documents.length;

            sData = true;

          });


        });
      }
    });
    _requestCheck();
  }

  _requestCheck() async {
    var collectionReference = Firestore.instance.collection('request').where('company', isEqualTo: userCompany);
    var query = collectionReference.where("date", isEqualTo: today );
    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length > 0) {
        querySnapshot.documents.forEach((document)
        async {
          setState(() {
            truck  = document["Truck"];
            matName  = document["Item"];
            matQuantity  = document["Quantity"];
            matNumber  = document["Truck"];
            truckType  = document["tType"];

            reqlength = querySnapshot.documents.length;
            rData = true;

          });


        });
      }
    });

    setState(() {
      _isLoading = false;
    });

  }

  Future<Uint8List> _getWidgetImage() async {
    final RenderRepaintBoundary boundary =
    _renderObjectKey.currentContext.findRenderObject();
    final ui.Image im = await boundary.toImage();
    final ByteData bytes =
    await im.toByteData(format: ui.ImageByteFormat.rawRgba);
    final file = bytes.buffer.asUint8List();

    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("elorry-report/$today");
    StorageUploadTask upload = firebaseStorageRef.putData(file,);
    StorageTaskSnapshot taskSnapshot=await upload.onComplete;
    String fileUrl= await taskSnapshot.ref.getDownloadURL();

    await Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection(
          'videos');

      await reference.add({
        "report": fileUrl,

        "time": DateTime.now()
      });

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
          pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
          build: (pdf.Context context) {
            return pdf.Center(
              child: pdf.Expanded(
                child: pdf.Image(image),
              ),
            ); // Center
          }));
      // Page

      return document.save();
    });

  }
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    _postTrip();
    getStringValue();
  }

  String userCompany;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
    });
  }
  final _renderObjectKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
          onPressed: () {
            _getWidgetImage();
          },
        ),
        body: new Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            CupertinoScrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
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
                                      "Daily Report",
                                      style: new TextStyle(
                                          fontSize: 18.0, fontWeight: FontWeight.w700),
                                    ),

                                    new Text(
                                      DateFormat(' dd MMM yyyy').format(DateTime.now()),
                                      style: new TextStyle(
                                          fontSize: 18.0, fontWeight: FontWeight.w700),
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



                      pData == false ? new Container(
                        height: 0.0,
                        width: 0.0,
                      )

                          : Card(
                        margin: new EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new SizedBox(
                              height: 5.0,
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: new Text(
                                  "PostTrip",
                                  style: new TextStyle(
                                      fontSize: 18.0, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),

                            new SizedBox(
                              height: 5.0,
                            ),

                            new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Flexible(
                                  child: new ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: ptlength,
                                    itemBuilder: (context, index) {
                                      return new Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Container(
                                            color: Colors.grey,
                                            child: Padding(padding: const EdgeInsets.all(8.0),
                                                child: new Text(truckNo)
                                            ),
                                          ),

                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              GridView.count(
                                                crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 6,
                                                shrinkWrap: true,
                                                padding: EdgeInsets.all(5.0),
                                                children: <Widget>[



                                                  new Card(child: new Container(
                                                    child: new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                            "ENGINE",
                                                            style: new TextStyle(
                                                                fontSize: 10.0, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        engine == null ? Container() :
                                                        new Flexible(
                                                          child: new ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: engine.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              String key = engine.keys.elementAt(index);
                                                              return new Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),

                                                                  new Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          new SizedBox(
                                                                            width: 5.0,
                                                                          ),
                                                                          new Text("$key", style: new TextStyle(
                                                                            fontSize: 10.0,),),
                                                                        ],
                                                                      ),
                                                                      new Text("${engine [key]}", style: new TextStyle(
                                                                        fontSize: 10.0,),),
                                                                    ],
                                                                  ),
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),

                                                  new Card(child: new Container(
                                                    child: new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                            "ELECTRONICS",
                                                            style: new TextStyle(
                                                                fontSize: 10.0, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        electronics == null ? Container() :
                                                        new Flexible(
                                                          child: new ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: electronics.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              String key = electronics.keys.elementAt(index);
                                                              return new Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),

                                                                  new Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          new SizedBox(
                                                                            width: 5.0,
                                                                          ),
                                                                          new Text("$key", style: new TextStyle(
                                                                            fontSize: 10.0,),),
                                                                        ],
                                                                      ),
                                                                      new Text("${electronics [key]}", style: new TextStyle(
                                                                        fontSize: 10.0,),),
                                                                    ],
                                                                  ),
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                                  new Card(child: new Container(
                                                    child: new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                            "BRAKES",
                                                            style: new TextStyle(
                                                                fontSize: 10.0, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        brakes == null ? Container() :
                                                        new Flexible(
                                                          child: new ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: brakes.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              String key = brakes.keys.elementAt(index);
                                                              return new Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),

                                                                  new Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          new SizedBox(
                                                                            width: 5.0,
                                                                          ),
                                                                          new Text("$key", style: new TextStyle(
                                                                            fontSize: 10.0,),),
                                                                        ],
                                                                      ),
                                                                      new Text("${brakes [key]}", style: new TextStyle(
                                                                        fontSize: 10.0,),),
                                                                    ],
                                                                  ),
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                                  new Card(child: new Container(
                                                    child: new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                            "FRONT SUSPENSION",
                                                            style: new TextStyle(
                                                                fontSize: 10.0, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        frontSusp == null ? Container() :
                                                        new Flexible(
                                                          child: new ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: frontSusp.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              String key = frontSusp.keys.elementAt(index);
                                                              return new Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),

                                                                  new Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          new SizedBox(
                                                                            width: 5.0,
                                                                          ),
                                                                          new Text("$key", style: new TextStyle(
                                                                            fontSize: 10.0,),),
                                                                        ],
                                                                      ),
                                                                      new Text("${frontSusp [key]}", style: new TextStyle(
                                                                        fontSize: 10.0,),),
                                                                    ],
                                                                  ),
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                                  new Card(child: new Container(
                                                    child: new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                            "REAR SUSPENSION",
                                                            style: new TextStyle(
                                                                fontSize: 10.0, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        rearSusp == null ? Container() :
                                                        new Flexible(
                                                          child: new ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: rearSusp.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              String key = rearSusp.keys.elementAt(index);
                                                              return new Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),

                                                                  new Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          new SizedBox(
                                                                            width: 5.0,
                                                                          ),
                                                                          new Text("$key", style: new TextStyle(
                                                                            fontSize: 10.0,),),
                                                                        ],
                                                                      ),
                                                                      new Text("${rearSusp [key]}", style: new TextStyle(
                                                                        fontSize: 10.0,),),
                                                                    ],
                                                                  ),
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                                  new Card(child: new Container(
                                                    child: new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                            "WHEEL DETAIL",
                                                            style: new TextStyle(
                                                                fontSize: 10.0, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        wheelDetail == null ? Container() :
                                                        new Flexible(
                                                          child: new ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: wheelDetail.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              String key = wheelDetail.keys.elementAt(index);
                                                              return new Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),

                                                                  new Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          new SizedBox(
                                                                            width: 5.0,
                                                                          ),
                                                                          new Text("$key", style: new TextStyle(
                                                                            fontSize: 10.0,),),
                                                                        ],
                                                                      ),
                                                                      new Text("${wheelDetail [key]}", style: new TextStyle(
                                                                        fontSize: 10.0,),),
                                                                    ],
                                                                  ),
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                                  new Card(child: new Container(
                                                    child: new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                            "CABIN",
                                                            style: new TextStyle(
                                                                fontSize: 10.0, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        cabin == null ? Container() :
                                                        new Flexible(
                                                          child: new ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: cabin.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              String key = cabin.keys.elementAt(index);
                                                              return new Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),

                                                                  new Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          new SizedBox(
                                                                            width: 5.0,
                                                                          ),
                                                                          new Text("$key", style: new TextStyle(
                                                                            fontSize: 10.0,),),
                                                                        ],
                                                                      ),
                                                                      new Text("${cabin [key]}", style: new TextStyle(
                                                                        fontSize: 10.0,),),
                                                                    ],
                                                                  ),
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                                  new Card(child: new Container(
                                                    child: new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                            "BODY",
                                                            style: new TextStyle(
                                                                fontSize: 10.0, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        body == null ? Container() :
                                                        new Flexible(
                                                          child: new ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: body.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              String key = body.keys.elementAt(index);
                                                              return new Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),

                                                                  new Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          new SizedBox(
                                                                            width: 5.0,
                                                                          ),
                                                                          new Text("$key", style: new TextStyle(
                                                                            fontSize: 10.0,),),
                                                                        ],
                                                                      ),
                                                                      new Text("${body [key]}", style: new TextStyle(
                                                                        fontSize: 10.0,),),
                                                                    ],
                                                                  ),
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                                  new Card(child: new Container(
                                                    child: new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                            "SAFETY",
                                                            style: new TextStyle(
                                                                fontSize: 10.0, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        safety == null ? Container() :
                                                        new Flexible(
                                                          child: new ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: safety.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              String key = safety.keys.elementAt(index);
                                                              return new Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),

                                                                  new Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          new SizedBox(
                                                                            width: 5.0,
                                                                          ),
                                                                          new Text("$key", style: new TextStyle(
                                                                            fontSize: 10.0,),),
                                                                        ],
                                                                      ),
                                                                      new Text("${safety [key]}", style: new TextStyle(
                                                                        fontSize: 10.0,),),
                                                                    ],
                                                                  ),
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                                  new Card(child: new Container(
                                                    child: new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                            "FRONT WHEELS",
                                                            style: new TextStyle(
                                                                fontSize: 10.0, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        frontWheels == null ? Container() :
                                                        new Flexible(
                                                          child: new ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: frontWheels.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              String key = frontWheels.keys.elementAt(index);
                                                              return new Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),

                                                                  new Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          new SizedBox(
                                                                            width: 5.0,
                                                                          ),
                                                                          new Text("$key", style: new TextStyle(
                                                                            fontSize: 10.0,),),
                                                                        ],
                                                                      ),
                                                                      new Text("${frontWheels [key]}", style: new TextStyle(
                                                                        fontSize: 10.0,),),
                                                                    ],
                                                                  ),
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                                  new Card(child: new Container(
                                                    child: new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                            "BACK WHEELS",
                                                            style: new TextStyle(
                                                                fontSize: 10.0, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        backWheels == null ? Container() :
                                                        new Flexible(
                                                          child: new ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: backWheels.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              String key = backWheels.keys.elementAt(index);
                                                              return new Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),

                                                                  new Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          new SizedBox(
                                                                            width: 5.0,
                                                                          ),
                                                                          new Text("$key", style: new TextStyle(
                                                                            fontSize: 10.0,),),
                                                                        ],
                                                                      ),
                                                                      new Text("${backWheels [key]}", style: new TextStyle(
                                                                        fontSize: 10.0,),),
                                                                    ],
                                                                  ),
                                                                  new SizedBox(
                                                                    height: 5.0,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                                  new Card(
                                                    child: new Container(
                                                      margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                                                      child: new Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          new SizedBox(
                                                            height: 5.0,
                                                          ),

                                                          new Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              new Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                  new Text(
                                                                    "Truck",
                                                                    style: new TextStyle(color: Colors.black, fontSize: 10.0,),
                                                                  )
                                                                ],
                                                              ),
                                                              new Text(
                                                                truckNo,
                                                                style: new TextStyle(
                                                                    fontSize: 10.0,
                                                                    color: Colors.indigo,
                                                                    fontWeight: FontWeight.w700),
                                                              ),
                                                            ],
                                                          ),
                                                          new SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          new Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              new Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                  new Text(
                                                                    "Evaluation Date",
                                                                    style: new TextStyle(color: Colors.black, fontSize: 10.0,),
                                                                  )
                                                                ],
                                                              ),
                                                              new Text(
                                                                evaluationDate,
                                                                style: new TextStyle(
                                                                    fontSize: 10.0,
                                                                    color: Colors.indigo,
                                                                    fontWeight: FontWeight.w700),
                                                              ),
                                                            ],
                                                          ),


                                                          new SizedBox(
                                                            height: 5.0,
                                                          ),

                                                          new Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              new Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                  new Text(
                                                                    "Insurance Expiry",
                                                                    style: new TextStyle(color: Colors.black, fontSize: 10.0,),
                                                                  )
                                                                ],
                                                              ),
                                                              new Text(
                                                                insurance,
                                                                style: new TextStyle(
                                                                    fontSize: 10.0,
                                                                    color: Colors.indigo,
                                                                    fontWeight: FontWeight.w700),
                                                              ),
                                                            ],
                                                          ),

                                                          new SizedBox(
                                                            height: 5.0,
                                                          ),

                                                          new Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              new Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                  new Text(
                                                                    "Greasing@KM",
                                                                    style: new TextStyle(color: Colors.black, fontSize: 10.0,),
                                                                  )
                                                                ],
                                                              ),
                                                              new Text(
                                                                greasing,
                                                                style: new TextStyle(
                                                                    fontSize: 10.0,
                                                                    color: Colors.indigo,
                                                                    fontWeight: FontWeight.w700),
                                                              ),
                                                            ],
                                                          ),

                                                          comment != null?
                                                          new Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              new Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: <Widget>[
                                                                  new SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                  new Text(
                                                                    "Comment",
                                                                    style: new TextStyle(color: Colors.black, fontSize: 10.0,),
                                                                  )
                                                                ],
                                                              ),
                                                              new Text(
                                                                comment,
                                                                style: new TextStyle(
                                                                    fontSize: 10.0,
                                                                    color: Colors.indigo,
                                                                    fontWeight: FontWeight.w700),
                                                              ),
                                                            ],
                                                          ): new Offstage(),





                                                          new SizedBox(
                                                            height: 5.0,
                                                          ),


                                                          new SizedBox(
                                                            height: 10.0,
                                                          ),


                                                        ],
                                                      ),
                                                    ),
                                                  ),




                                                ],// Replace
                                              ),
                                            ],
                                          ),


                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),





                          ],
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),


                      sData == false ? new Container(
                        height: 0.0,
                        width: 0.0,
                      )

                          :new Card(
                        child: new Container(
                          margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            mainAxisSize:MainAxisSize.min,
                            children: <Widget>[
                              Flexible(

                                child: new ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: servicelength,
                                    itemBuilder: (context, index) {
                                      return new Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new SizedBox(
                                            height: 5.0,
                                          ),

                                          Center(
                                            child: new Text(
                                              "Service",
                                              style: new TextStyle(
                                                  fontSize: 18.0, fontWeight: FontWeight.w700),
                                            ),
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  new Text(
                                                    "Truck",
                                                    style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                                  )
                                                ],
                                              ),
                                              new Text(
                                                truck,
                                                style: new TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                          new SizedBox(
                                            height: 5.0,
                                          ),
                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  new Text(
                                                    "Driver",
                                                    style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                                  )
                                                ],
                                              ),
                                              new Text(
                                                truckDriver,
                                                style: new TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),


                                          new SizedBox(
                                            height: 5.0,
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  new Text(
                                                    "Driver number",
                                                    style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                                  )
                                                ],
                                              ),
                                              new Text(
                                                driverNumber,
                                                style: new TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),

                                          new SizedBox(
                                            height: 5.0,
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  new Text(
                                                    "Inspection Expiry",
                                                    style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                                  )
                                                ],
                                              ),
                                              new Text(
                                                truckExpiry,
                                                style: new TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),





                                          new SizedBox(
                                            height: 5.0,
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  new Text(
                                                    "Insurance Expiry",
                                                    style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                                  )
                                                ],
                                              ),
                                              new Text(
                                                truckInsurance,
                                                style: new TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),

                                          new SizedBox(
                                            height: 5.0,
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  new Text(
                                                    "Speed Governor Expiry",
                                                    style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                                  )
                                                ],
                                              ),
                                              new Text(
                                                speedGov,
                                                style: new TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),

                                          new SizedBox(
                                            height: 5.0,
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  new Text(
                                                    "Back tyre serial number",
                                                    style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                                  )
                                                ],
                                              ),
                                              new Text(
                                                backTyre,
                                                style: new TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),

                                          new SizedBox(
                                            height: 5.0,
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  new Text(
                                                    "Front tyre serial number",
                                                    style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                                  )
                                                ],
                                              ),
                                              new Text(
                                                frontTyre,
                                                style: new TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),

                                          new SizedBox(
                                            height: 5.0,
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  new Text(
                                                    "Spare tyre serial number",
                                                    style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                                  )
                                                ],
                                              ),
                                              new Text(
                                                spareTyre,
                                                style: new TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),

                                          new SizedBox(
                                            height: 5.0,
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  new Text(
                                                    "Battery warranty",
                                                    style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                                  )
                                                ],
                                              ),
                                              new Text(
                                                batWarranty,
                                                style: new TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),





                                          new SizedBox(
                                            height: 10.0,
                                          ),


                                        ],
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),


                      lData == false ? new Container(
                        height: 0.0,
                        width: 0.0,
                      )

                          :new Card(
                        child: new Container(
                          margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(

                                child: new ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: lpolength,
                                    itemBuilder: (context, index) {
                                      return new Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new SizedBox(
                                            height: 5.0,
                                          ),

                                          Center(
                                            child: new Text(
                                              "LPO",
                                              style: new TextStyle(
                                                  fontSize: 18.0, fontWeight: FontWeight.w700),
                                            ),
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  new Image.asset(
                                                    'assets/elog.jpg',
                                                    fit: BoxFit.contain,
                                                    height: 30.0,
                                                    width: 70.0,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  new Text(
                                                    "Cell: +254-705-617118",
                                                    style: new TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  new Text(
                                                    "Email: info@elogisticsltd.com",
                                                    style: new TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          new SizedBox(
                                            height: 10.0,
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      new Text(
                                                        "PIN NO: PO51399991D",
                                                        style: new TextStyle(
                                                            fontSize: 11.0,
                                                            fontWeight: FontWeight.w700),
                                                      ),

                                                      new Text(
                                                        "VAT NO: 466644",
                                                        style: new TextStyle(
                                                            fontSize: 11.0,
                                                            fontWeight: FontWeight.w700),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  new Text(
                                                    "LPO NO: ",
                                                    style: new TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  new Text(
                                                    itemNumber,
                                                    style: new TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          new SizedBox(
                                            height: 20.0,
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      new Text(
                                                        "To: ${reqSupplier}",
                                                        style: new TextStyle(
                                                          fontSize: 11.0,
                                                          fontWeight: FontWeight.w700,
                                                          decoration: TextDecoration.underline,),
                                                      ),

                                                      new Text(
                                                        reqDate,
                                                        style: new TextStyle(
                                                          fontSize: 11.0,
                                                          fontWeight: FontWeight.w700,
                                                          decoration: TextDecoration.underline,),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  new Text(
                                                    reqDate,
                                                    style: new TextStyle(
                                                      fontSize: 11.0,
                                                      fontWeight: FontWeight.w700,
                                                      decoration: TextDecoration.underline,),
                                                  ),

                                                ],
                                              ),
                                            ],
                                          ),


                                          new SizedBox(
                                            height: 5.0,
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: new Table(
                                              border: TableBorder.all(),
                                              defaultVerticalAlignment: TableCellVerticalAlignment.top,
                                              children: <TableRow>[
                                                ///First table row with 3 children
                                                TableRow(children: <Widget>[
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      width: 50.0,
                                                      color: Colors.grey,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          "QUANTITY",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 5.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      color: Colors.grey,
                                                      width: 50.0,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          "UNIT",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 5.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      color: Colors.grey,
                                                      width: 50.0,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          "DESCRIPTION",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 5.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      color: Colors.grey,
                                                      width: 50.0,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          "AMOUNT",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 5.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                ///Second table row with 3 children
                                                TableRow(children: <Widget>[
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      width: 50.0,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          itemQuantity,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 6.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      width: 50.0,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          "1",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 6.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      width: 50.0,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          itemName,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 6.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      width: 50.0,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          reqPrice,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 6.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),

                                                TableRow(children: <Widget>[
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      width: 50.0,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          "",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 6.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      width: 50.0,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          "",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 6.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      width: 50.0,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          "Total:",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 6.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      margin: EdgeInsets.all(2),
                                                      width: 50.0,
                                                      height: 30.0,
                                                      child: Center(
                                                        child: Text(
                                                          reqPrice,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 6.0,),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                ]),


                                              ],
                                            ),
                                          ),

                                          new SizedBox(
                                            height: 20.0,
                                          ),

                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  new SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      new Text(
                                                        "Prepared by: ${prepby}",
                                                        style: new TextStyle(
                                                          fontSize: 11.0,
                                                          fontWeight: FontWeight.w700,
                                                          decoration: TextDecoration.underline,),
                                                      ),

                                                      new Text(
                                                        "Approved by:${appby}",
                                                        style: new TextStyle(
                                                          fontSize: 11.0,
                                                          fontWeight: FontWeight.w700,
                                                          decoration: TextDecoration.underline,),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  new Text(
                                                    "Date:${reqDate}",
                                                    style: new TextStyle(
                                                      fontSize: 11.0,
                                                      fontWeight: FontWeight.w700,
                                                      decoration: TextDecoration.underline,),
                                                  ),

                                                ],
                                              ),
                                            ],
                                          ),





                                          new SizedBox(
                                            height: 10.0,
                                          ),


                                        ],
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      new SizedBox(
                        height: 10.0,
                      ),


                      rData == false ? new Container(
                        height: 0.0,
                        width: 0.0,
                      )

                          : Card(
                        margin: new EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Column(
                          mainAxisSize : MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new SizedBox(
                              height: 5.0,
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: new Text(
                                  "Material request",
                                  style: new TextStyle(
                                      fontSize: 18.0, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),

                            new SizedBox(
                              height: 5.0,
                            ),

                            new Column(
                              mainAxisSize : MainAxisSize.min,
                              children: <Widget>[
                                new Flexible(
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      Column(
                                        children: <Widget>[
                                          GridView.builder(
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3),
                                              shrinkWrap: true,
                                              itemCount: reqlength,
                                              itemBuilder: (context, index)  {
                                                return new Card(child: new Container(
                                                  child: new Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          new Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: <Widget>[
                                                              new SizedBox(
                                                                width: 5.0,
                                                              ),
                                                              new Text(
                                                                "Item requested",
                                                                style: new TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? 10.0 : 14.0,),
                                                              )
                                                            ],
                                                          ),
                                                          new Text(
                                                            matName,
                                                            style: new TextStyle(
                                                                fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? 8.0 : 14.0,
                                                                color: Colors.indigo,
                                                                fontWeight: FontWeight.w700),
                                                          ),
                                                        ],
                                                      ),
                                                      new SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      new Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          new Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: <Widget>[
                                                              new SizedBox(
                                                                width: 5.0,
                                                              ),
                                                              new Text(
                                                                "Quantity",
                                                                style: new TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? 10.0 : 14.0,),
                                                              )
                                                            ],
                                                          ),
                                                          new Text(
                                                            matQuantity,
                                                            style: new TextStyle(
                                                                fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? 8.0 : 14.0,
                                                                color: Colors.indigo,
                                                                fontWeight: FontWeight.w700),
                                                          ),
                                                        ],
                                                      ),
                                                      new SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      new Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          new Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: <Widget>[
                                                              new SizedBox(
                                                                width: 5.0,
                                                              ),
                                                              new Text(
                                                                "Truck",
                                                                style: new TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? 10.0 : 14.0,),
                                                              )
                                                            ],
                                                          ),
                                                          new Text(
                                                            matNumber,
                                                            style: new TextStyle(
                                                                fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? 8.0 : 14.0,
                                                                color: Colors.indigo,
                                                                fontWeight: FontWeight.w700),
                                                          ),
                                                        ],
                                                      ),



                                                    ],
                                                  ),
                                                ),
                                                );
                                              }
                                          ),
                                        ],
                                      ),


                                    ],
                                  ),
                                ),
                              ],
                            ),





                          ],
                        ),
                      ),


                      SizedBox(
                        height: 10.0,
                      ),




                    ],
                  ),
                ),
              ),),
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
        )
    );
  }

}
