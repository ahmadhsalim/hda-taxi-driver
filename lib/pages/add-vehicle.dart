import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hda_driver/widgets/animation-box.dart';
import 'package:hda_driver/widgets/ob-button.dart';

class AddVehiclePage extends StatefulWidget {
  final String message;
  AddVehiclePage({Key key, this.message}) : super(key: key);

  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _key = GlobalKey<ScaffoldState>();

  Identity identity = getIt<Identity>();

  Widget _buildGetStartedButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: ObButton(
          text: 'Get started',
          filled: true,
          onPressed: () async {
            Navigator.pushReplacementNamed(context, vehicleFormRoute);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Your Vehicle',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimationBox(),
                    SizedBox(
                      height: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quam viverra nunc volutpat, nibh vestibulum, eu ut cras. In felis netus neque vitae.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFAEAEB2), fontSize: 16)),
                    ),
                  ]),
            ),
            _buildGetStartedButton(context),
          ],
        ),
      ),
    );
  }
}
