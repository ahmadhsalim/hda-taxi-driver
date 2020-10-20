import 'dart:convert';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:hda_app/resources/misc/api-client.dart';
import 'package:hda_app/resources/misc/base-url.dart';
import 'package:hda_app/routes/constants.dart';
import 'package:hda_app/services/identity-service.dart';
import 'package:hda_app/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hda_app/styles/MainTheme.dart';
import 'package:hda_app/widgets/ob-button.dart';

final storage = FlutterSecureStorage();

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _hidePassword = true;

  Identity identity = getIt<Identity>();

  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController mobileNumberController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;

  @override
  initState() {
    super.initState();
  }

  String _nameValidator(String value) {
    if (value == null || value.length == 0) {
      return 'Name is required';
    } else {
      return null;
    }
  }

  String _mobileNumberValidator(String value) {
    if (value == null || value.length == 0) {
      return 'Username is required';
    } else {
      return null;
    }
  }

  String _passwordValidator(String value) {
    if (value == null || value.length == 0) {
      return 'Password is required';
    } else {
      return null;
    }
  }

  String _confirmPasswordValidator(String value) {
    if (value == null || value.length == 0) {
      return 'Password is required';
    } else if (value != passwordController.text) {
      return 'Password do not match';
    } else {
      return null;
    }
  }

  InputDecoration _buildInputDecoration({String prefixText}) {
    return InputDecoration(
      prefixText: prefixText,
      filled: true,
      fillColor: Color(0xFFF2F2F7),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF2F2F7), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF2F2F7), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
            height: 28, child: Text('Name', style: TextStyle(fontSize: 16))),
        SizedBox(
            height: 48,
            child: TextFormField(
              style: TextStyle(fontSize: 14),
              decoration: _buildInputDecoration(prefixText: '+960 '),
              validator: _nameValidator,
              controller: nameController,
            ))
      ],
    );
  }

  Widget _buildMobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
            height: 28,
            child: Text('Mobile Number', style: TextStyle(fontSize: 16))),
        SizedBox(
            height: 48,
            child: TextFormField(
              style: TextStyle(fontSize: 14),
              decoration: _buildInputDecoration(prefixText: '+960 '),
              validator: _mobileNumberValidator,
              controller: mobileNumberController,
            ))
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
            height: 28,
            child: Text('Password', style: TextStyle(fontSize: 16))),
        SizedBox(
            height: 48,
            child: TextFormField(
              obscureText: _hidePassword,
              style: TextStyle(fontSize: 14),
              decoration: _buildInputDecoration(),
              validator: _passwordValidator,
              controller: passwordController,
            )),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
            height: 28,
            child: Text('Confirm Password', style: TextStyle(fontSize: 16))),
        SizedBox(
            height: 48,
            child: TextFormField(
              obscureText: _hidePassword,
              style: TextStyle(fontSize: 14),
              decoration: _buildInputDecoration(),
              validator: _confirmPasswordValidator,
              controller: confirmPasswordController,
            )),
      ],
    );
  }

  Future<String> attemptLogIn(String username, String password) async {
    ApiClient client = ApiClient('taxi');
    var res = await client.post(Uri.http(apiHost, "/auth/customer/signin"),
        body: {"mobile": username, "password": password});

    if (res.statusCode == 200) return res.body;
    return null;
  }

  Widget _buildSignupButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ObButton(
          text: 'Sign Up',
          onPressed: () async {
            Loader.show(context,
                progressIndicator: CircularProgressIndicator());
            if (_signupFormKey.currentState.validate()) {
              String username = mobileNumberController.text;
              String password = passwordController.text;
              var jwt = await attemptLogIn(username, password);

              if (jwt != null) {
                await identity.authenticateJwt(json.decode(jwt)["token"]);
                Navigator.pushReplacementNamed(context, homeRoute);
              } else {
                displayDialog(
                    context, "Sign in", "Incorrect username or password");
              }
            }

            Loader.hide();
          },
        ));
  }

  Widget _buildAlreadyRegisteredButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: ObButton(
          color: Colors.white,
          onPressed: () async {},
          text: "Already have an account?",
        ));
  }

  Widget _buildFooterText(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          'By tapping "Sign Up", you agree to our Terms of Service, Privacy Policy and Cookie Policy.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14, color: Color.fromARGB(255, 200, 199, 204)),
        ));
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MainTheme.primaryColour,
    ));

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Scaffold(
            //      resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
                child: Form(
              key: _signupFormKey,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  height: MediaQuery.of(context).size.height - 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(height: 20),
                              _buildNameField(),
                              SizedBox(height: 16),
                              _buildMobileField(),
                              SizedBox(height: 16),
                              _buildPasswordField(),
                              SizedBox(height: 16),
                              _buildConfirmPasswordField(),
                              _buildSignupButton(context),
                              _buildAlreadyRegisteredButton(context),
                              _buildFooterText(context),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ))));
  }
}
