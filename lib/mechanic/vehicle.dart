import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:intl/intl.dart';
import 'material_request.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mech.dart';


class vehicleService extends StatefulWidget {
  @override
  _vehicleServiceState createState() => _vehicleServiceState();
}

class _vehicleServiceState extends State<vehicleService> {
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
      backgroundColor: Colors.red[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text("Vehicle Type", style: new TextStyle(
        color: Colors.white, fontSize: 30.0),),
            new SizedBox(
              height: 10.0,
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
              child: new InkWell(
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new Mech()
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
                            "Trucks",
                            style: new TextStyle(
                                color: Colors.red[900], fontSize: 20.0),
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
                      builder: (BuildContext context) => new carsList()
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
                            "Cars",
                            style: new TextStyle(
                                color: Colors.red[900], fontSize: 20.0),
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
