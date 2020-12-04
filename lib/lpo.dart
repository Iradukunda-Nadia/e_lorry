
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:printing/printing.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const directoryName = 'lpo';

class lpoForm extends StatefulWidget {
  String appby;
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
  String docID;
  String appQuote;

  lpoForm({

    this.appby,
    this.docID,
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
    this.reqSupplier,
    this.appQuote,

  });


  @override
  _lpoFormState createState() => _lpoFormState();
}

class _lpoFormState extends State<lpoForm> {
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
  String prevLpo;
  int Lpo;
  String name;
  String lpoString;
  DateTime now = DateTime.now();
  String formattedDate;
  int prev;

  CollectionReference collectionReference =
  Firestore.instance.collection("requisition");

  DocumentSnapshot _currentDocument;


  _updateData() async {
    await Firestore.instance
        .collection('requisition')
        .document(widget.docID)
        .updateData({'status': "LPO GENERATED"});
    await Firestore.instance
        .collection('requisition')
        .document(widget.docID)
        .updateData({
          'lpoDate': DateFormat(' dd MMM yyyy').format(DateTime.now()),
          "prepared by" : name,
        });
    await Firestore.instance
        .collection('lponumber')
        .document(userCompany)
        .updateData({
      'number': Lpo,
    });
  }



  Future getAccounts() async {
   Firestore.instance.collection('lponumber').where('company', isEqualTo: userCompany).limit(1) // new entries first, date is one the entries btw
        .snapshots()
       .listen((QuerySnapshot querySnapshot){
    querySnapshot.documents.forEach((document)
    {
      setState(() {
        prev = document['number'];
        Lpo = prev+1;
        lpoString = Lpo.toString();
      });
    });
    }
    );
  }

  String userCompany;
  String compPhone;
  String compEmail;
  String compLogo;
  String compName;

  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user');
      userCompany = prefs.getString('company');
      compPhone = prefs.getString('compPhone');
      compEmail = prefs.getString('compEmail');
      compLogo = prefs.getString('compLogo');
      compName = prefs.getString('compName');
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
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('lpo');

      await reference.add({
        "Item": widget.itemName,
        "lpoNumber": lpoString,
        "Quantity": widget.itemQuantity,
        "Amount": widget.reqPrice,
        "date" : DateFormat(' dd MMM yyyy').format(now),
        "prepared by" : name,
        "Approved by" : widget.appby,
        "Supplier" : widget.appQuote,
        "company" : userCompany,

      });
    });

    _updateData();
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
    getAccounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                  new Image.network(
                                    compLogo,
                                    fit: BoxFit.contain,
                                    height: 30.0,
                                    width: 70.0,
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  new Text(
                                    "Cell: $compPhone",
                                    style: new TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  new Text(
                                    "Email: $compEmail",
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
                                    lpoString,
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
                                        "Date:${formattedDate}",
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
                                    "Date:${formattedDate}",
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
                                          "Brand and Price",
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
                                        "Prepared by: ${name}",
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
                                    "Date:${formattedDate}",
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

Widget productTextField(
    {String textTitle,
      String textHint,
      double height,
      TextEditingController controller,
      TextInputType textType}) {
  textTitle == null ? textTitle = "Enter Title" : textTitle;
  textHint == null ? textHint = "Enter Hint" : textHint;
  height == null ? height = 50.0 : height;
  //height !=null

  return Row(
    //mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Text(
          textTitle,
          style:
          new TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      new Flexible(
        fit: FlexFit.loose,
        child: new Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: new Container(
          height: height,
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(color: Colors.white),
              borderRadius: new BorderRadius.all(new Radius.circular(4.0))),
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: new TextField(
              controller: controller,
              keyboardType: textType == null ? TextInputType.text : textType,
              maxLines: 4,
              decoration: new InputDecoration(

                  border: InputBorder.none, hintText: textHint),
            ),
          ),
        ),
      ),)
    ],
  );
}

Widget sign(
    {String textTitle,
      String textHint,
      double height,
      TextEditingController controller,
      TextInputType textType}) {
  textTitle == null ? textTitle = "Enter Title" : textTitle;
  textHint == null ? textHint = "Enter Hint" : textHint;
  height == null ? height = 50.0 : height;
  //height !=null

  return Column(
    //mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Text(
          textTitle,
          style:
          new TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      Flexible(
        fit: FlexFit.loose,
        child: new Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: new Container(
            height: height,
            decoration: new BoxDecoration(
                color: Colors.white,
                border: new Border.all(color: Colors.white),
                borderRadius: new BorderRadius.all(new Radius.circular(4.0))),
            child: new Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: new TextField(
                controller: controller,
                keyboardType: textType == null ? TextInputType.text : textType,
                maxLines: 4,
                decoration: new InputDecoration(
                    border: InputBorder.none, hintText: textHint),
              )
            ),
          ),
        ),
      )
    ],
  );
}
