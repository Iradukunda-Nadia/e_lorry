import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  String _email;
  String _organization;
  String _phone;
  String _name;
  String _country;
  bool _isLoading;
  String _errorMessage;
  final _formKey = new GlobalKey<FormState>();

  String userCompany;
  String compPhone;
  String compEmail;
  String compLogo;
  String compName;

  getStringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCompany = prefs.getString('company');
      compPhone = prefs.getString('compPhone');
      compEmail = prefs.getString('compEmail');
      compLogo = prefs.getString('compLogo');
      compName = prefs.getString('compName');
    });

  }


  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (validateAndSave()) {

      String username = 'esthernadia70@gmail.com';
      String password = 'iradukunda1995';

      final smtpServer = gmail(username, password);

      // Create our message.
      final message = Message()
        ..from = Address(username, 'Elorry')
        ..recipients.add('esthernadia70@gmail.com')
        ..ccRecipients.addAll(['info@e-lorry.com', 'info@e-lorry.com'])
        ..subject = 'New Request :: 😀 :: ${DateTime.now()}'
        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html = "<h1>Details</h1>\n<p>Name: ${_name} <br> Organization: ${_organization} <br> Email: ${_email} <br> Phone number: ${_phone} <br> Country: ${_country}</p>";

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      // DONE

      var connection = PersistentConnection(smtpServer);
      await connection.close();

      Firestore.instance.runTransaction((Transaction transaction) async {
        CollectionReference reference = Firestore.instance.collection('Applications');

        await reference.add({
          'person': _name,
          'companyName': _organization,
          'email': _email,
          'phone': _phone,
          'status': 'pending',
          'reqDate' :  DateFormat(' dd MMM yyyy').format(DateTime.now())
        });
      });


      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Sent"),
              content: Text("Request sent, We will contact you shortly"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      setState(() {
        _isLoading = false;
        _formKey.currentState.reset();
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff016836),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        )
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                child: new TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 1,
                  autofocus: false,
                  decoration: new InputDecoration(
                      hintText: 'Organization',
                      icon: new Icon(
                        Icons.domain,
                        color: Colors.grey,
                      )),
                  autocorrect: false,
                  validator: (value) => value.isEmpty ? 'Field can\'t be empty' : null,
                  onSaved: (value) => _organization = value.trim(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                child: new TextFormField(
                  textCapitalization: TextCapitalization.sentences,

                  maxLines: 1,
                  autofocus: false,
                  decoration: new InputDecoration(
                      hintText: 'Name',
                      icon: new Icon(
                        Icons.person,
                        color: Colors.grey,
                      )),
                  autocorrect: false,
                  validator: (value) => value.isEmpty ? 'Field can\'t be empty' : null,
                  onSaved: (value) => _name = value.trim(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                child: new TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 1,
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                      hintText: 'Email',
                      icon: new Icon(
                        Icons.email,
                        color: Colors.grey,
                      )),
                  autocorrect: false,
                  validator: (value) => value.isEmpty ? 'Field can\'t be empty' : null,
                  onSaved: (value) => _email = value.trim(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                child: new TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 1,
                  autofocus: false,
                  keyboardType: TextInputType.phone,
                  decoration: new InputDecoration(
                      hintText: 'Mobile',
                      icon: new Icon(
                        Icons.phone,
                        color: Colors.grey,
                      )),
                  autocorrect: false,
                  validator: (value) => value.isEmpty ? 'Field can\'t be empty' : null,
                  onSaved: (value) => _phone = value.trim(),
                ),
              ),

              showErrorMessage(),
              Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    width: 50.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.white,
                      child: new Text("Submit",
                          style: new TextStyle(fontSize: 20.0, color: Colors.red[900])),
                      onPressed: (){
                        validateAndSubmit();
                      },
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red[900],
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: CircleAvatar(
          radius: 60,
          child: Image.asset('assets/log.png'),
        ),
      ),
    );
  }
}
