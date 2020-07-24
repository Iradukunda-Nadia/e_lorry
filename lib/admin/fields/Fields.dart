import 'package:flutter/material.dart';
import 'carFields.dart';
import 'truckFields.dart';
import 'truckServefields.dart';
import 'package:flutter/cupertino.dart';

class fieldCats extends StatefulWidget {
  String truckPostForm;
  String carForm;
  String truckSerForm;

  fieldCats({

    this.truckPostForm,
    this.carForm,
    this.truckSerForm,
  });
  @override
  _fieldCatsState createState() => _fieldCatsState();
}

class _fieldCatsState extends State<fieldCats> {
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
            widget.carForm == "created" ? new Offstage():
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
              child: new InkWell(
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new carFields()
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
                            "Car Inspection Form",
                            style: new TextStyle(
                                color: const Color(0xff016836), fontSize: 20.0),
                          )),
                    ),
                  ),
                ),
              ),

            ),

            widget.truckPostForm == "created" ? new  Offstage():
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
              child: new InkWell(
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new truckPostFields()
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
                            "Truck Posttrip Form",
                            style: new TextStyle(
                                color: const Color(0xff016836), fontSize: 20.0),
                          )),
                    ),
                  ),
                ),

              ),
            ),
            widget.truckSerForm == "created" ? new  Offstage():
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
              child: new InkWell(
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new truckSerFields()
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
                            "Truck Service Form",
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
