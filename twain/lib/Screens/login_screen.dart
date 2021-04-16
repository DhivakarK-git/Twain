import 'package:flutter/material.dart';
import 'package:twain/constants.dart';
import 'register_screen.dart';
import 'dart:convert';
import 'story_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = false;
  String? _username = '', _password = '';

  Future<http.Response> login() async {
    var auth = 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    return await http.get(Uri.http('192.168.2.2:5000', 'api/resource'),
        headers: <String, String>{'authorization': auth});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                      height: MediaQuery.of(context).size.height / 10,
                    ),
                    Text(
                      'WELCOME BACK!',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: kCastelon),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Login to your account',
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
                        suffixIcon: Icon(Icons.account_circle_outlined,
                            color: kCastelon),
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
                        hintText: 'Password',
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                          child: Icon(
                              _isHidden
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: kCastelon),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Required';
                        } else {
                          RegExp regex =
                              new RegExp(r'^[a-zA-Z0-9!@#\$%\^&*]*$');
                          if (!regex.hasMatch(value))
                            return 'Invalid password';
                          else
                            return null;
                        }
                      },
                      obscureText: !_isHidden,
                      onChanged: (value) => _password = value,
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
                          if (_formKey.currentState!.validate()) {
                            final response = await login();
                            if (response.statusCode == 200) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StoryScreen(_username!, _password!)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: kMatte,
                                  content: Text(
                                    'Invalid Credentials',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        ?.copyWith(color: kCream),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16.0),
                          child: Text(
                            'Login',
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
                          'Don\'t have an account?',
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
                                    builder: (context) => RegisterScreen()));
                          },
                          child: Text(
                            'Register.',
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
      ),
    );
  }
}
