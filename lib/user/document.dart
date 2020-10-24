import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class prevLpo extends StatefulWidget {
  @override
  _prevLpoState createState() => _prevLpoState();
}

class _prevLpoState extends State<prevLpo> {
  CollectionReference collectionReference =
  Firestore.instance.collection("lpo");

  DocumentSnapshot _currentDocument;
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
      appBar: AppBar(
        title: Text("LPO"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: collectionReference.where('company', isEqualTo: userCompany).orderBy('date', descending: true).snapshots(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Waiting For Data..."),
              );
            }if (snapshot.hasData == false){
              return Center(
                child: Text("There are no pending requests"),);
            }else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data.documents[index];
                  return Card(
                    child: ListTile(
                      title: Text(doc.data['Item']),
                      subtitle: Text(doc.data['date'].toString()),
                      trailing: new Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(3.0),
                        child: IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: null),
                      ),
                      onTap: () async {
                        setState(() {
                          _currentDocument = doc;
                        });

                        Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new lpoDetail(


                          itemName: doc.data['Item'],
                          itemQuantity: doc.data['Quantity'],
                          itemNumber: doc.data['lpoNumber'],
                          reqPrice:  doc.data['Amount'],
                          reqDate:  doc.data['date'],
                          reqSupplier: doc.data['Supplier'],
                          appby: doc.data['Approved by'],
                          prepby: doc.data['prepared by'],


                        )));
                      },
                    ),
                  );

                },
              );

            }
          }),

    );

  }
}


class lpoDetail extends StatefulWidget {
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

  lpoDetail({

    this.appby,
    this.prepby,
    this.reqStatus,
    this.reqComment,
    this.itemName,
    this.itemQuantity,
    this.itemNumber,
    this.reqName,
    this.reqDate,
    this.reqOne,
    this.reqTwo,
    this.reqThree,
    this.reqBrand,
    this.reqPrice,
    this.reqSupplier

  });


  @override
  _lpoDetailState createState() => _lpoDetailState();
}

class _lpoDetailState extends State<lpoDetail> {
  final _renderObjectKey = GlobalKey<ScaffoldState>();
  TextEditingController lpoNumber = new TextEditingController();
  TextEditingController company = new TextEditingController();
  TextEditingController date = new TextEditingController();
  TextEditingController att = new TextEditingController();
  TextEditingController terms = new TextEditingController();
  TextEditingController prepared = new TextEditingController();
  TextEditingController confirm = new TextEditingController();
  TextEditingController approve = new TextEditingController();
  String name2;
  String pw2;
  int prevLpo;
  int Lpo;
  String name;


  Future getAccounts() async {
    Firestore.instance.collection('lpo')
        .orderBy("date", descending: true).limit(1) // new entries first, date is one the entries btw
        .snapshots()
        .listen((QuerySnapshot querySnapshot){
      querySnapshot.documents.forEach((document)
      {
        setState(() {
          prevLpo = document['lpoNumber'];
          Lpo = prevLpo++;
        });
      });
    }
    );
  }

String userCompany;
  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user');
      userCompany = prefs.getString('company');
    });

  }

  Future<Uint8List> _getWidgetImage() async {
    try {
      RenderRepaintBoundary boundary =
      _renderObjectKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      debugPrint(bs64.length.toString());
      return pngBytes;
    } catch (exception) {}
  }



  Future<void> _printScreen() async {

    final RenderRepaintBoundary boundary =
    _renderObjectKey.currentContext.findRenderObject();
    final ui.Image im = await boundary.toImage(pixelRatio: 5.0);
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

  void _showQRandPrint() {
    _getWidgetImage().then((img) async {
      final pdf = new PdfDocument();
      final page = new PdfPage(pdf, pageFormat: PdfPageFormat(75.0, 100.0));
      final g = page.getGraphics();

      PdfImage image = new PdfImage(
          pdf,
          image: img,
          width: 75,
          height: 100);
      g.drawImage(image, 0.0, 0.0);

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    });


  }

  void _sharePdf() {
    _getWidgetImage().then((img) async {
      final pdf = new PdfDocument();
      final page = new PdfPage(pdf, pageFormat: PdfPageFormat(75.0, 100.0));
      final g = page.getGraphics();

      PdfImage image = new PdfImage(
          pdf,
          image: img,
          width: 75,
          height: 100);
      g.drawImage(image, 0.0, 0.0);

      await Printing.sharePdf(bytes: pdf.save(), filename: 'my-document.pdf');
    });


  }


  initState() {
    getStringValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat(' dd MMM yyyy').format(now);
    return Scaffold(
      body: new Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          new Container(
            height: 100.0,
            decoration: new BoxDecoration(
              color: Colors.grey.withAlpha(50),
              borderRadius: new BorderRadius.only(
                bottomRight: new Radius.circular(100.0),
                bottomLeft: new Radius.circular(100.0),
              ),
            ),
          ),
          new SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
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
                          child: new Text(
                            "Details",
                            style: new TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        new SizedBox(
                          height: 5.0,
                        ),

                      ],
                    ),
                  ),
                ),
                RepaintBoundary(
                  key: _renderObjectKey,
                  child: new Card(
                    child: new Container(
                      margin: new EdgeInsets.only(left: 10.0, right: 10.0),
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
                                    widget.itemNumber,
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
                                        "To: ${widget.reqSupplier}",
                                        style: new TextStyle(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,),
                                      ),

                                      new Text(
                                        widget.reqDate,
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
                                    widget.reqDate,
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
                                          widget.itemQuantity,
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
                                          widget.itemName,
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
                                          widget.reqPrice,
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
                                          widget.reqPrice,
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
                                        "Prepared by: ${widget.prepby}",
                                        style: new TextStyle(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,),
                                      ),

                                      new Text(
                                        "Approved by:${widget.appby}",
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
                                    "Date:${widget.reqDate}",
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
                            height: 20.0,
                          ),


                        ],
                      ),
                    ),
                  ),
                ),

                new SizedBox(
                  height: 20.0,
                ),

                RaisedButton(
                  child: const Text('Print'),
                  onPressed: (){_printScreen();},
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}