import 'dart:convert';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:hda_driver/resources/misc/api-client.dart';
import 'package:hda_driver/resources/misc/base-url.dart';
import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/screen-arguments/sign-in-arguments.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hda_driver/widgets/ob-button.dart';
import 'package:http/http.dart';

final storage = FlutterSecureStorage();

class OtpVerifyPage extends StatefulWidget {
  final String mobileNumber;
  final String cookie;
  OtpVerifyPage({Key key, this.mobileNumber, this.cookie}) : super(key: key);

  @override
  _OtpVerifyPageState createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final _key = GlobalKey<ScaffoldState>();

  Identity identity = getIt<Identity>();

  final GlobalKey<FormState> _otpVerifyFormKey = GlobalKey<FormState>();
  TextEditingController otpController;

  bool isOtpValid = true;

  @override
  initState() {
    otpController = TextEditingController();
    super.initState();
  }

  String _otpValidator(String value) {
    setState(() {
      isOtpValid = false;
    });
    if (value == null || value.length == 0) {
      return 'Enter correct code';
    } else {
      setState(() {
        isOtpValid = true;
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

  Future<Response> verifyOtp(String otp) async {
    ApiClient client = ApiClient('taxi');
    Map<String, String> headers = {'cookie': widget.cookie};
    var res = await client.post(
      Uri.http(apiHost, "/auth/driver/verify-otp"),
      body: json.encode({"otp": otp}),
      headers: headers,
    );

    if (res.statusCode == 200) return res;
    return null;
  }

  Widget _buildOtpVerifyButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ObButton(
          text: 'Verify',
          onPressed: () async {
            bool isValid = _otpVerifyFormKey.currentState.validate();

            try {
              if (isValid) {
                Loader.show(context,
                    progressIndicator: CircularProgressIndicator());
                String otp = otpController.text;
                Response res = await verifyOtp(otp);

                if (res != null) {
                  Navigator.pushReplacementNamed(context, signInRoute,
                      arguments: SignInArguments('Registered successfully.'));
                } else {
                  displayDialog(context, "Sign Up", "OTP verification failed.");
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

  Widget _buildResendButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: ObButton(
          color: Colors.white,
          onPressed: () async {},
          text: "Didn't receive OTP? Resend OTP",
        ));
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Enter the OTP sent to ',
          style: TextStyle(fontSize: 16, color: Color(0xFFAEAEB2)),
        ),
        Text(
          "+960 ${widget.mobileNumber}",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ]),
    );
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
        key: _key,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'OTP Verification',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: _otpVerifyFormKey,
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
                          _buildHeader(context),
                          SizedBox(height: 16),
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: Image(image: AssetImage('assets/logo.png')),
                          ),
                          _buildTextField(
                              label: 'OTP Code',
                              isValid: isOtpValid,
                              validator: _otpValidator,
                              controller: otpController),
                          _buildOtpVerifyButton(context),
                          SizedBox(height: 8),
                          _buildResendButton(context),
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
