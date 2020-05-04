import 'package:e_lorry/admin/adminHome.dart';
import 'package:e_lorry/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'mechanic/vehicle.dart';
import 'user/user.dart';
import 'admin/Admin.dart';
import 'manager/manager.dart';
import 'mechanic/mech.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  List<Color> _backgroundColor;
  Color _iconColor;
  Color _textColor;
  List<Color> _actionContainerColor;
  Color _borderContainer;
  bool colorSwitched = false;
  var logoImage;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //We have two private fields here
  String _email;
  String _uid;
  String _password;
  String name1;
  String pw1;
  String name2;
  String pw2;
  String name3;
  String pw3;
  String name4;
  String pw4;
  String avatar;
  String id;
  String user;



  Future getMechanic() async {
    var snapshot = Firestore.instance.collection('users')
        .document('user1')
        .get();
    snapshot.then((data) {
      setState(() {
        name1 = data['name'];
        pw1 = data['password'];
      });
    });
  }

  Future getAccounts() async {
    var snapshot = Firestore.instance.collection('users')
        .document('user2')
        .get();
    snapshot.then((data) {
      setState(() {
        name2 = data['name'];
        pw2 = data['password'];
      });
      print(user);
    });
  }
  Future getManager() async {
    var snapshot = Firestore.instance.collection('users')
        .document('user3')
        .get();
    snapshot.then((data) {
      setState(() {
        name3 = data['name'];
        pw3 = data['password'];
      });
    });
  }

  Future getAdmin() async {
    var snapshot = Firestore.instance.collection('users')
        .document('user4')
        .get();
    snapshot.then((data) {
      setState(() {
        name4 = data['name'];
        pw4 = data['password'];
      });
    });
  }




  void _submitCommand() {
    //get state of our Form
    final form = formKey.currentState;

    //`validate()` validates every FormField that is a descendant of this Form,
    // and returns true if there are no errors.
    if (form.validate()) {
      //`save()` Saves every FormField that is a descendant of this Form.
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _loginCommand();
    }
  }




  _loginCommand() async {
    var collectionReference = Firestore.instance.collection('userID');
    var query = collectionReference.where("uid", isEqualTo: _email ).where('pw', isEqualTo: _password);
    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length == 0) {
        final snack = SnackBar(
          content: Text('invallid login details'),
        );
        scaffoldKey.currentState.showSnackBar(snack);
      } else {
        querySnapshot.documents.forEach((document)
        async {

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('user', document['name']);
            setState(() {
              id = document['dept'];

            });


            if( id == "Manager" ) {
              _messaging.subscribeToTopic('manager');
              _messaging.subscribeToTopic('all');
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new Manager()
              ));
            }
            if(id == "Accounts" ) {
              _messaging.subscribeToTopic('puppies');
              _messaging.subscribeToTopic('all');
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new User()
              ));

            }

            if(id == "Mechanic" ) {
              _messaging.subscribeToTopic('mech');
              _messaging.subscribeToTopic('all');
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new Mech()
              ));

            }

            if(id == "Admin") {
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new adminHome()
              ));

            }

        });
      }
    });
  }

  void changeTheme() async {
    if (colorSwitched) {
      setState(() {
        logoImage = 'assets/wallet.png';
        _backgroundColor = [
          Color.fromRGBO(252, 214, 0, 1),
          Color.fromRGBO(251, 207, 6, 1),
          Color.fromRGBO(250, 197, 16, 1),
          Color.fromRGBO(249, 161, 28, 1),
        ];
        _iconColor = Colors.white;
        _textColor = Color.fromRGBO(253, 211, 4, 1);
        _borderContainer = Color.fromRGBO(34, 58, 90, 0.2);
        _actionContainerColor = [
          Color.fromRGBO(47, 75, 110, 1),
          Color.fromRGBO(43, 71, 105, 1),
          Color.fromRGBO(39, 64, 97, 1),
          Color.fromRGBO(34, 58, 90, 1),
        ];
      });
    } else {
      setState(() {
        logoImage = 'assets/images/wallet_logo.png';
        _borderContainer = Color.fromRGBO(252, 233, 187, 1);
        _backgroundColor = [
          Color.fromRGBO(249, 249, 249, 1),
          Color.fromRGBO(241, 241, 241, 1),
          Color.fromRGBO(233, 233, 233, 1),
          Color.fromRGBO(222, 222, 222, 1),
        ];
        _iconColor = Colors.black;
        _textColor = Colors.black;
        _actionContainerColor = [
          Color.fromRGBO(255, 212, 61, 1),
          Color.fromRGBO(255, 212, 55, 1),
          Color.fromRGBO(255, 211, 48, 1),
          Color.fromRGBO(255, 211, 43, 1),
        ];
      });
    }
  }


  @override
  void initState() {
    changeTheme();
    getMechanic();
    getAccounts();
    getAdmin();
    getManager();
    super.initState();
    _messaging.getToken().then((token) {
      print(token);
    });
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );


    setState(() {
      logoImage = 'assets/log02.png';
      _borderContainer = Color.fromRGBO(252, 233, 187, 1);
      _backgroundColor = [
        Color.fromRGBO(255, 180, 0, 1),
        Color.fromRGBO(255, 201, 0, 1),
        Color.fromRGBO(255, 206, 26, 1),
        Color.fromRGBO(255, 215, 118, 1),
      ];
      _iconColor = Colors.white;
      _textColor = Colors.white;
      _actionContainerColor = [
        Color.fromRGBO(199, 21, 21, 1),
        Color.fromRGBO(239, 36, 36, 1),
        Color.fromRGBO(247, 60, 60, 1),
        Color.fromRGBO(255, 36, 36, 1),
      ];
    });
  }

  final FirebaseMessaging _messaging = FirebaseMessaging();


  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: GestureDetector(
            onLongPress: () {},
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Image.asset(
                      logoImage,
                      fit: BoxFit.contain,
                      height: 180.0,
                      width: 380.0,
                    ),
                  ),

                  Column(
                    children: <Widget>[
                      Container(
                        height: 410.0,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),

                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10,10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                              color: const Color(0xff016836),

                                ),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
                                    child: Container(
                                      child: Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 18),)
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    child: Container(
                                      child: TextFormField(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'SFUIDisplay'
                                        ),
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(color: Colors.white),
                                            filled: true,
                                            fillColor: Colors.white.withOpacity(0.1),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: new BorderSide(color: Colors.white70),
                                            ),
                                            labelText: 'Username',
                                            prefixIcon: Icon(Icons.person_outline),
                                            labelStyle: TextStyle(
                                                fontSize: 15
                                            )
                                        ),
                                        textCapitalization: TextCapitalization.sentences,
                                        validator: (val) =>
                                        val.isEmpty  ? 'Enter a valid Username' : null,
                                        onSaved: (val) => _email = val,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                    child: Container(
                                      child: TextFormField(
                                        obscureText: true,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'SFUIDisplay'
                                        ),
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(color: Colors.white),
                                            filled: true,
                                            fillColor: Colors.white.withOpacity(0.1),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: new BorderSide(color: Colors.white70),
                                            ),
                                            labelText: 'Password',
                                            prefixIcon: Icon(Icons.lock_outline),
                                            labelStyle: TextStyle(
                                                fontSize: 15
                                            )
                                        ),
                                        validator: (val) =>
                                        val.length < 4 ? 'Your password is too Password too short..' : null,
                                        onSaved: (val) => _password = val,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                                    child: MaterialButton(
                                      onPressed: _submitCommand,
                                      child: Text('SIGN IN',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'SFUIDisplay',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      color: Colors.white,
                                      elevation: 16.0,
                                      minWidth: 400,
                                      height: 50,
                                      textColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                        child: new Text(
                                            "New user? Sign up here",
                                            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.white60)),
                                        onPressed: (){
                                          Navigator.of(context).push(new MaterialPageRoute(
                                            builder: (BuildContext context) => new Signup()
                                        ));
                                        }
                                     ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}