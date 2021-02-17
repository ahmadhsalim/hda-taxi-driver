import 'dart:convert';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:hda_driver/resources/misc/api-client.dart';
import 'package:hda_driver/config/variables.dart';
import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/navigator-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hda_driver/widgets/ob-button.dart';

final storage = FlutterSecureStorage();

class SignInPage extends StatefulWidget {
  final String message;
  SignInPage({Key key, this.message}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _key = GlobalKey<ScaffoldState>();

  bool _hidePassword = true;

  Identity identity = getIt<Identity>();

  final GlobalKey<FormState> _signinFormKey = GlobalKey<FormState>();
  TextEditingController mobileNumberController;
  TextEditingController passwordController;

  @override
  initState() {
    mobileNumberController = TextEditingController(text: '7888588');
    passwordController = TextEditingController(text: 'password');

    super.initState();
  }

  String _mobileNumberValidator(String value) {
    if (value == null || value.length == 0) {
      return 'Mobile number is required';
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

  InputDecoration _buildInputDecoration({String prefixText}) {
    Color color = Color(0xFFF2F2F7);
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
        errorBorder: errorBorder);
  }

  Widget _buildMobileNumber() {
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

  Widget _buildPassword() {
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

  Future<String> attemptSignIn(String mobileNumber, String password) async {
    ApiClient client = ApiClient('taxi');
    var res = await client.post(
      Uri.http(apiHost, "/auth/driver/signin"),
      body: json.encode({"mobile": mobileNumber, "password": password}),
    );

    if (res.statusCode == 200) return res.body;
    return null;
  }

  Widget _buildSigninButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ObButton(
          text: 'Sign In',
          filled: true,
          onPressed: () async {
            bool isValid = _signinFormKey.currentState.validate();
            try {
              if (isValid) {
                Loader.show(context,
                    progressIndicator: CircularProgressIndicator());
                String mobileNumber = mobileNumberController.text;
                String password = passwordController.text;
                var jwt = await attemptSignIn(mobileNumber, password);

                if (jwt != null) {
                  await identity.authenticateJwt(json.decode(jwt)["token"]);
                  goToStart(context);
                } else {
                  displayDialog(context, "Sign in",
                      "Incorrect mobile number or password");
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

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: ObButton(
          filled: false,
          onPressed: () async {},
          text: "Forgot password?",
        ));
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return ObButton(
      filled: false,
      onPressed: () async {
        Navigator.pushNamed(context, signUpRoute);
      },
      text: "Create an account",
    );
  }

  // Widget _buildHeader(BuildContext context) {
  //   return Padding(
  //       padding: const EdgeInsets.only(top: 20, bottom: 20),
  //       child: Text(
  //         'Sign In',
  //         textAlign: TextAlign.center,
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  //       ));
  // }

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

    if (widget.message != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            widget.message,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          duration: Duration(seconds: 3),
          // backgroundColor: MainTheme.primaryColour,
        ));
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Sign In',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: _signinFormKey,
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
                          // SizedBox(height: 16),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Image(image: AssetImage('assets/logo.png')),
                          ),
                          SizedBox(height: 16),
                          _buildMobileNumber(),
                          SizedBox(height: 16),
                          _buildPassword(),
                          _buildSigninButton(context),
                          _buildForgotPasswordButton(context),
                          _buildCreateAccountButton(context),
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
