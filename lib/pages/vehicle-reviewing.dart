import 'package:hda_driver/models/vehicle.dart';
import 'package:hda_driver/resources/driver-resource.dart';
import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hda_driver/widgets/animation-box.dart';
import 'package:hda_driver/widgets/ob-button.dart';

class VehicleReviewingPage extends StatefulWidget {
  final String message;
  final Vehicle vehicle;
  VehicleReviewingPage({Key key, this.message, this.vehicle}) : super(key: key);

  @override
  _VehicleReviewingPageState createState() => _VehicleReviewingPageState();
}

class _VehicleReviewingPageState extends State<VehicleReviewingPage> {
  final _key = GlobalKey<ScaffoldState>();

  Identity identity = getIt<Identity>();
  bool isPending = true;
  DriverResource resource = DriverResource();

  @override
  initState() {
    super.initState();
    if (widget.vehicle?.status == 'rejected') {
      isPending = false;
    }
  }

  String _getTitle() {
    return isPending ? "We've received your request." : "We're sorry.";
  }

  String _getMessage() {
    return isPending
        ? 'Our team will review your request and notify you very soon.'
        : "There was a problem processing your request.";
  }

  Widget _getButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: ObButton(
          text: 'Re-Submit',
          filled: true,
          onPressed: () async {
            bool cancelled = await resource.cancelVehicle(widget.vehicle.id);
            if (cancelled) {
              Navigator.pushNamedAndRemoveUntil(
                  context, vehicleFormRoute, (Route<dynamic> route) => false);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Unable to load. Try again.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                duration: Duration(seconds: 3),
              ));
            }
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
              'Reviewing',
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
                  // Container(
                  //     height: 183,
                  //     width: 183,
                  //     decoration: BoxDecoration(
                  //         color: Color(0xFFE4E4E4),
                  //         borderRadius: BorderRadius.all(Radius.circular(23)))),
                  SizedBox(height: 25),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12, left: 16, right: 16),
                    child: SizedBox(
                      width: 300,
                      child: Text(_getTitle(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF242E42), fontSize: 26)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12, left: 16, right: 16),
                    child: SizedBox(
                      width: 279,
                      child: Text(_getMessage(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFAEAEB2), fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            isPending ? SizedBox.shrink() : _getButton(context),
          ],
        ),
      ),
    );
  }
}
