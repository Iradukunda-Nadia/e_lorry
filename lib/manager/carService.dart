import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class carService extends StatefulWidget {
  @override
  _carServiceState createState() => _carServiceState();
}

class _carServiceState extends State<carService> {
  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("cars").where('company', isEqualTo: userCompany).getDocuments();
    return qn.documents;

  }
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
          title: Text("SELECT CAR"),
          backgroundColor: Colors.red[900],
        ),

        body: Container(
          child: new Column(
            children: <Widget>[

              new Flexible(
                child: FutureBuilder(
                    future: getUsers(),
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading... Please wait"),
                        );
                      }else{
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return new GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new SeviceDates(

                                  truckNumber: snapshot.data[index].data["plate"],
                                  driverName: snapshot.data[index].data["driver"],
                                  driverNumber: snapshot.data[index].data["phone"],
                                  driverID: snapshot.data[index].data["ID"],


                                )));
                              },
                              child: new Card(
                                child: Stack(
                                  alignment: FractionalOffset.topLeft,
                                  children: <Widget>[
                                    new ListTile(
                                      leading: new CircleAvatar(
                                          backgroundColor: Colors.red[900],
                                          child: new Icon(Icons.directions_car)
                                      ),
                                      title: new Text("${snapshot.data[index].data["plate"]}",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18.0,
                                            color: Colors.red[900]),),
                                      subtitle: new Text("Driver : ${snapshot.data[index].data["driver"]}",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.0,
                                            color: Colors.grey),),
                                    ),

                                  ],
                                ),
                              ),
                            );

                          },
                        );

                      }
                    }),)
            ],
          ),
        )

    );
  }
}

class SeviceDates extends StatefulWidget {

  String truckNumber;
  String driverName;
  String driverNumber;
  String driverID;
  String itemDescription;

  SeviceDates({

    this.truckNumber,
    this.driverName,
    this.driverNumber,
    this.driverID,
    this.itemDescription
  });

  @override
  _SeviceDatesState createState() => _SeviceDatesState();
}

CollectionReference collectionReference =
Firestore.instance.collection("carService");

class _SeviceDatesState extends State<SeviceDates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red[900],),
      body: StreamBuilder<QuerySnapshot>(
          stream: collectionReference.where("plate", isEqualTo:
          widget.truckNumber).orderBy("timestamp", descending: true).snapshots(),
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
                      title: Text("Service Date: ${doc.data['timestamp'].toString()}"),

                      onTap: () async {

                        Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new FormDetails(


                            details: Map<String, dynamic>.from(doc.data)


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

class FormDetails extends StatefulWidget {


  final Map<String,dynamic> details;

  FormDetails({
    this.details,

  });



  @override
  _FormDetailsState createState() => _FormDetailsState();
}

class _FormDetailsState extends State<FormDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text("Item Detail"),
        centerTitle: true,
        backgroundColor: Colors.red[900],
      ),

      body: new Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          new Container(
            height: 200.0,
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
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
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
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[

                      widget.details == null ? Container() :
                      new Flexible(
                        child: new ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.details.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.details.keys.elementAt(index);
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("$key"),
                                  subtitle: new Text("${widget.details[key].toString()}"),
                                ),
                                new Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),),

              ],
            ),
          ),
        ],
      ),
    );
  }
}