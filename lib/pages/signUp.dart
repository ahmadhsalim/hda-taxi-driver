import 'dart:convert';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:hda_driver/resources/misc/api-client.dart';
import 'package:hda_driver/config/variables.dart';
import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/screen-arguments/otp-verify-arguments.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hda_driver/widgets/ob-button.dart';
import 'package:http/http.dart';

final storage = FlutterSecureStorage();

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Identity identity = getIt<Identity>();

  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController mobileNumberController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;

  bool isNameValid = true;
  bool isMobileNumberValid = true;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;

  @override
  initState() {
    nameController = TextEditingController(text: '');
    mobileNumberController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    confirmPasswordController = TextEditingController(text: '');
    super.initState();
  }

  String _nameValidator(String value) {
    setState(() {
      isNameValid = false;
    });
    if (value == null || value.length == 0) {
      return 'Name is required';
    } else {
      setState(() {
        isNameValid = true;
      });
      return null;
    }
  }

  String _mobileNumberValidator(String value) {
    setState(() {
      isMobileNumberValid = false;
    });
    if (value == null || value.length == 0) {
      return 'Mobile number is required';
    } else {
      setState(() {
        isMobileNumberValid = true;
      });
      return null;
    }
  }

  String _passwordValidator(String value) {
    setState(() {
      isPasswordValid = false;
    });
    if (value == null || value.length == 0) {
      return 'Password is required';
    } else {
      setState(() {
        isPasswordValid = true;
      });
      return null;
    }
  }

  String _confirmPasswordValidator(String value) {
    setState(() {
      isConfirmPasswordValid = false;
    });
    if (value == null || value.length == 0) {
      return 'Confirm password is required';
    } else if (value != passwordController.text) {
      return 'Passwords do not match';
    } else {
      setState(() {
        isConfirmPasswordValid = true;
      });
      return null;
    }
  }

  InputDecoration _buildInputDecoration({String prefixText, bool valid: true}) {
    Color color = valid ? Color(0xFFF2F2F7) : Color(0xFFFFF1F1);
    Color errorColor = Color(0xFFFF3C3C);

    OutlineInputBorder border = OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)));

    OutlineInputBorder errorBorder = OutlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)));
    return InputDecoration(
        prefixText: prefixText,
        filled: true,
        fillColor: color,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder);
  }

  Widget _buildTextField({
    String label,
    Function validator,
    TextEditingController controller,
    String prefixText,
    bool obscureText: false,
    bool isValid: true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
            height: 28, child: Text(label, style: TextStyle(fontSize: 16))),
        SizedBox(
            child: TextFormField(
          obscureText: obscureText,
          style: TextStyle(fontSize: 14),
          decoration:
              _buildInputDecoration(prefixText: prefixText, valid: isValid),
          validator: validator,
          controller: controller,
        )),
      ],
    );
  }

  Future<Response> register(
    String name,
    String mobile,
    String password,
    String confirmPassword,
  ) async {
    ApiClient client = ApiClient('taxi');

    Map map = {
      "name": name,
      "mobile": mobile,
      "password": password,
      "confirmPassword": confirmPassword
    };
    var res = await client.post(
      Uri.http(apiHost, "/auth/driver/signup"),
      body: json.encode(map),
    );

    if (res.statusCode == 200) return res;
    return null;
  }

  Widget _buildSignupButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ObButton(
          text: 'Sign Up',
          onPressed: () async {
            bool isValid = _signupFormKey.currentState.validate();

            try {
              if (isValid) {
                Loader.show(context,
                    progressIndicator: CircularProgressIndicator());
                String name = nameController.text;
                String mobile = mobileNumberController.text;
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;
                Response res =
                    await register(name, mobile, password, confirmPassword);

                if (res != null) {
                  String cookie = res.headers['set-cookie'];
                  if (cookie != null) {
                    int index = cookie.indexOf(';');
                    if (index > -1) cookie = cookie.substring(0, index);
                  }
                  Navigator.pushNamed(context, verifyOtpRoute,
                      arguments: OtpVerifyArguments(mobile, cookie));
                } else {
                  displayDialog(context, "Sign Up", "Unable to register.");
                }
              }
            } catch (e) {
              print(e);
            } finally {
              if (isValid) Loader.hide();
            }
          },
        ));
  }

  Widget _buildAlreadyRegisteredButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: ObButton(
          filled: false,
          onPressed: () async {
            Navigator.pop(context);
          },
          text: "Already have an account?",
        ));
  }

  // Widget _buildHeader(BuildContext context) {
  //   return Padding(
  //       padding: const EdgeInsets.only(top: 20, bottom: 20),
  //       child: Text(
  //         'Sign Up',
  //         textAlign: TextAlign.center,
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  //       ));
  // }

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
      statusBarColor: Colors.grey[400],
    ));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: _signupFormKey,
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
                          // _buildHeader(context),
                          SizedBox(height: 16),
                          _buildTextField(
                              label: 'Name',
                              isValid: isNameValid,
                              validator: _nameValidator,
                              controller: nameController),
                          SizedBox(height: 16),
                          _buildTextField(
                              label: 'Mobile Number',
                              prefixText: '+960 ',
                              isValid: isMobileNumberValid,
                              validator: _mobileNumberValidator,
                              controller: mobileNumberController),
                          SizedBox(height: 16),
                          _buildTextField(
                              label: 'Password',
                              obscureText: true,
                              isValid: isPasswordValid,
                              validator: _passwordValidator,
                              controller: passwordController),
                          SizedBox(height: 16),
                          _buildTextField(
                              label: 'Confirm Password',
                              obscureText: true,
                              isValid: isConfirmPasswordValid,
                              validator: _confirmPasswordValidator,
                              controller: confirmPasswordController),
                          _buildSignupButton(context),
                          SizedBox(height: 8),
                          _buildAlreadyRegisteredButton(context),
                          _buildFooterText(context),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
