import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:login_page/home_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  PhoneNumber phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                ],
                validator: (value) {
                  return value.length >= 3
                      ? null
                      : "First name must be 3 characters or more";
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.person), hintText: "First name"),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                ],
                validator: (value) {
                  return value.length > 0 ? null : "Last name is mandatory.";
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.person), hintText: "Last name"),
              ),
              SizedBox(
                height: 30,
              ),
              IntlPhoneField(
                initialCountryCode: "IN",
                onChanged: (value) {
                  phone = value;
                },
              ),
              SizedBox(
                height: 70,
              ),
              MaterialButton(
                height: 50.0,
                minWidth: 300.0,
                color: Colors.blue,
                onPressed: () {
                  if (_loginFormKey.currentState.validate()) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
