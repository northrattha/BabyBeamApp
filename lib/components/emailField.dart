import 'package:flutter/material.dart';

import '../myStyle.dart';

class emailField extends StatelessWidget {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Container(
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: orangeBackGroundColor,
            prefixIcon: Icon(Icons.person, color: orangeButtonColor),
            hintText: 'อีเมล',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            // labelText: 'อีเมล',
          ),
          onSaved: (String value) {
            // emailstr = value.trim();
          },
          validator: (String email) {
            if (!((email.contains('@')) && (email.contains('.')))) {
              return 'Please Check Your Email';
            } else {
              return null;
            }
          }),
    );
  
  }
}