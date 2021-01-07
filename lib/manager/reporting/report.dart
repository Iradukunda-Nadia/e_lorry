
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lorry/manager/reporting/pdfView.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;
import 'package:shared_preferences/shared_preferences.dart';

reportView(context) async {

  final Document pdf = Document();

  List<Map<String, dynamic>> list = new List();


  Future <List<Map<String, dynamic>>> getService() async{
    List<DocumentSnapshot> templist;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userCompany = prefs.getString('company');


    Query collectionRef = Firestore.instance.collection("partRequest").where('company', isEqualTo: userCompany);
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    templist = collectionSnapshot.documents;
    // <--- ERROR

    list = templist.map((DocumentSnapshot docSnapshot){
      return docSnapshot.data;
    }).toList();

    return list;

  }

  var servicelist = [];

  Future getDocs() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("collection").orderBy('timestamp', descending: true).getDocuments();
    servicelist = querySnapshot.documents;
  }
  List<List<String>> serve = new List();
  serve.add(<String>['Truck', 'Item','Quantity','Supplier 1', 'Price', 'VAT?' , "Supplier 2", "Price", 'VAT?', "Supplier 3", "Price", 'VAT?', "reqDate", 'request by'],);

    final QuerySnapshot result =
    await Firestore.instance.collection("partRequest").where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now())).orderBy('timestamp', descending: true).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    // My list I want to create.

    documents.forEach((snapshot) {
      List<String> recind = <String>[
        snapshot.data['Truck'],
        snapshot.data['Item'],
        snapshot.data['Quantity'],
        snapshot.data['Supplier 1'],
        snapshot.data['quoteOne'],
        snapshot.data['1VAT'],
        snapshot.data['Supplier 2'],
        snapshot.data['quoteTwo'],
        snapshot.data['2VAT'],
        snapshot.data['Supplier 3'],
        snapshot.data['quoteThree'],
        snapshot.data['3VAT'],
        snapshot.data['reqDate'],
        snapshot.data['request by'],
      ];
      serve.add(recind);
    });



  pdf.addPage(MultiPage(
      pageFormat:
      PdfPageFormat.a3.copyWith(marginBottom: 0 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Text('Report',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 0.0 * PdfPageFormat.cm),
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
        Header(
            level: 0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Parts Request Report - ${DateFormat('yyyy-MM-dd').format(DateTime.now())}', textScaleFactor: 2),
                ])),
        Padding(padding: const EdgeInsets.all(10)),
        Table.fromTextArray(context: context, data: serve),
      ]));

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/report.pdf';
  final File file = File(path);
  await file.writeAsBytes(pdf.save());


  return file;
}