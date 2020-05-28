import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:intl/intl.dart';
import 'material_request.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class Car extends StatefulWidget {
  @override
  _CarState createState() => _CarState();
}


class _CarState extends State<Car> {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey();
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;

  Future<List<dynamic>> getList() async {
    var firestore = Firestore.instance;

    DocumentReference docRef = firestore.collection('field').document('elorry-veh');

    return docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['fields'].toList();
        print('#');
        print(info); //this line prints [aa, aghshs, fffg, fug, ghh, fggg, ghhh]
        print(info.length); //this line prints 7
        return info;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vehicle"), backgroundColor: Colors.red[900],),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
                mainAxisSize : MainAxisSize.min,
                children: <Widget>[
                  FormBuilder(
                    key: _fbKey,
                    // readonly: true,
                    child: Column(
                      mainAxisSize : MainAxisSize.min,
                      children: <Widget>[


                        FormBuilderDateTimePicker(
                          attribute: "date",
                          inputType: InputType.date,
                          format: DateFormat("yyyy-MM-dd"),
                          decoration:
                          InputDecoration(labelText: "Appointment Time"),
                        ),



                        new Flexible(
                          child: new FutureBuilder(
                            future: getList(),
                            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                return Center(
                                  child: ListView.builder(
                                      padding: const EdgeInsets.only(bottom: 20.0),
                                      scrollDirection: Axis.vertical,
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {

                                        return FormBuilderDropdown(
                                          attribute: "name",
                                          decoration: InputDecoration(labelText: snapshot.data[index]),
                                          // initialValue: 'Male',
                                          hint: Text('Pass/Fail'),
                                          validators: [FormBuilderValidators.required()],
                                          items: [
                                            DropdownMenuItem(
                                              value: 'Pass',
                                              child: Text('Pass'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Fail',
                                              child: Text('Fail'),
                                            ),

                                          ],

                                          /**/

                                        );

                                      }),
                                );
                              }
                            },
                          ),
                        ),

                        FormBuilderDropdown(
                          attribute: "gender",
                          decoration: InputDecoration(labelText: "Gender"),
                          // initialValue: 'Male',
                          hint: Text('Select Gender'),
                          validators: [FormBuilderValidators.required()],
                          items: [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other'),
                            ),
                          ],
                        ),

                        FormBuilderDropdown(
                          attribute: "engine",
                          decoration: InputDecoration(labelText: "enginer"),
                          // initialValue: 'Male',
                          hint: Text('Pass/Fail'),
                          validators: [FormBuilderValidators.required()],
                          items: [
                            DropdownMenuItem(
                              value: 'Pass',
                              child: Text('Pass'),
                            ),
                            DropdownMenuItem(
                              value: 'Fail',
                              child: Text('Fail'),
                            ),
                          ],
                        ),



                        FormBuilderSignaturePad(
                          decoration: InputDecoration(labelText: "Signature"),
                          attribute: "signature",
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        child: Text("Submit"),
                        onPressed: () {
                          _fbKey.currentState.save();
                          if (_fbKey.currentState.validate()) {
                            print(_fbKey.currentState.value);
                          }
                        },
                      ),
                      MaterialButton(
                        child: Text("Reset"),
                        onPressed: () {
                          _fbKey.currentState.reset();
                        },
                      ),
                    ],
                  )
                ],
              ),
          ),
        ),
      ),
    );
  }
}
/**/






















































































































































