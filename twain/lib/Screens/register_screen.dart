import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:twain/constants.dart';
import '../constants.dart';
import 'login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _username = '', _email = '', _password1 = '', _password2 = '';

  Future<http.Response> register() async {
    Map data = {
      "username": "$_username",
      "email": "$_email",
      "password": "$_password1"
    };
    return await http.post(Uri.http('192.168.2.2:5000', 'api/users'),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 100,
                  ),
                  Text(
                    'CREATE ACCOUNT',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: kCastelon),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Register your account',
                    style: Theme.of(context)
                        .textTheme
                        .overline
                        ?.copyWith(color: kOpal),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kOpal,
                        shadowColor: kCamblue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.google,
                              color: kCastelon,
                            ),
                            Text(
                              'Sign in with Google',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.89,
                        child: Divider(
                          color: kOpal,
                        ),
                      ),
                      Text(
                        "or",
                        style: Theme.of(context)
                            .textTheme
                            .overline
                            ?.copyWith(color: kOpal),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.89,
                        child: Divider(
                          color: kOpal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: kCamblue),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kPowder,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      hintText: 'Username',
                      suffixIcon:
                          Icon(Icons.account_circle_outlined, color: kCastelon),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required';
                      } else {
                        RegExp regex = new RegExp(r'^[a-zA-Z0-9@\.]*$');
                        if (!regex.hasMatch(value))
                          return 'Invalid username';
                        else
                          return null;
                      }
                    },
                    onChanged: (value) => _username = value,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: kCamblue),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kPowder,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      hintText: 'Email',
                      suffixIcon: Icon(Icons.email_outlined, color: kCastelon),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required';
                      } else {
                        RegExp regex = new RegExp(r'^[a-zA-Z0-9@\.]*$');
                        if (!regex.hasMatch(value))
                          return 'Invalid username';
                        else
                          return null;
                      }
                    },
                    onChanged: (value) => _email = value,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: kCamblue),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kPowder,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      hintText: 'Password',
                      suffixIcon: Icon(
                        Icons.lock_outline,
                        color: kCastelon,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required';
                      } else {
                        RegExp regex = new RegExp(r'^[a-zA-Z0-9!@#\$%\^&*]*$');
                        if (!regex.hasMatch(value))
                          return 'Invalid password';
                        else
                          return null;
                      }
                    },
                    obscureText: true,
                    onChanged: (value) => _password1 = value,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: kCamblue),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kPowder,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      hintText: 'Confirm Password',
                      suffixIcon: Icon(
                        Icons.security_outlined,
                        color: kCastelon,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required';
                      } else {
                        RegExp regex = new RegExp(r'^[a-zA-Z0-9!@#\$%\^&*]*$');
                        if (!regex.hasMatch(value))
                          return 'Invalid password';
                        else
                          return null;
                      }
                    },
                    obscureText: true,
                    onChanged: (value) => _password2 = value,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kMikado,
                        shadowColor: kCamblue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          if (_password1 == _password2) {
                            final response = await register();
                            if (response.statusCode == 201) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            } else
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: kMatte,
                                  content: Text(
                                    'User with Username already exists',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        ?.copyWith(color: kCream),
                                  ),
                                ),
                              );
                          } else
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: kMatte,
                                content: Text(
                                  'Passwords don\'t match',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(color: kCream),
                                ),
                              ),
                            );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Text(
                          'Register',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account already?',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: kCastelon),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          'Login.',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              ?.copyWith(color: kMatte),
                        ),
                      )
                    ],
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
