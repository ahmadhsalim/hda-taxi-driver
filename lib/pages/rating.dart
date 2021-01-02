import 'package:flutter_svg/flutter_svg.dart';
import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hda_driver/services/trip-service.dart';
import 'package:hda_driver/widgets/ob-button.dart';
import 'package:hda_driver/widgets/profile-photo.dart';

final storage = FlutterSecureStorage();

class RatingPage extends StatefulWidget {
  final TripService tripService;
  RatingPage({Key key, this.tripService}) : super(key: key);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  Identity identity = getIt<Identity>();
  int _rating = 0;
  TextEditingController _commentsController;

  OutlineInputBorder commentBorder = OutlineInputBorder(
    borderSide: BorderSide(
        color: Color(0xFFEFEFF2), width: 1, style: BorderStyle.solid),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  @override
  initState() {
    _commentsController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  Widget showPicture(rating) {
    Widget image;
    if (_rating >= rating) {
      image = SvgPicture.asset(
        'assets/star.svg',
        width: 44,
        height: 44,
      );
    } else {
      image = SvgPicture.asset(
        'assets/star-grey.svg',
        width: 44,
        height: 44,
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: image,
    );
  }

  @override
  Widget build(BuildContext context) {
    Trip trip = widget.tripService.getTrip();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          // leading: IconButton(
          //     color: Colors.black,
          //     icon: Icon(Icons.arrow_back),
          //     onPressed: () => Navigator.pop(context)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                child: Material(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'LATER',
                        style: TextStyle(
                            color: Color(0xFF707070),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    onTap: () {
                      bool canPop = Navigator.canPop(context);
                      if (canPop) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          homeRoute,
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  margin: const EdgeInsets.all(16),
                  width: 95,
                  height: 95,
                  child: ProfilePhoto(trip.customer.profilePhotoFile)),
              Text(trip.customer.name, style: TextStyle(fontSize: 17)),
              SizedBox(height: 40),
              Text('How was your trip?', style: TextStyle(fontSize: 24)),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  'Your feedback will help improve driving experience.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Color(0xFF8A8A8F)),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: showPicture(1),
                    onTap: () {
                      setState(() {
                        _rating = 1;
                      });
                    },
                  ),
                  GestureDetector(
                    child: showPicture(2),
                    onTap: () {
                      setState(() {
                        _rating = 2;
                      });
                    },
                  ),
                  GestureDetector(
                    child: showPicture(3),
                    onTap: () {
                      setState(() {
                        _rating = 3;
                      });
                    },
                  ),
                  GestureDetector(
                    child: showPicture(4),
                    onTap: () {
                      setState(() {
                        _rating = 4;
                      });
                    },
                  ),
                  GestureDetector(
                    child: showPicture(5),
                    onTap: () {
                      setState(() {
                        _rating = 5;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 32),
                child: TextFormField(
                  maxLines: 3,
                  controller: _commentsController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFefeff4),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      enabledBorder: commentBorder,
                      focusedBorder: commentBorder,
                      focusedErrorBorder: commentBorder,
                      errorBorder: commentBorder,
                      hintText: 'Additional Comments',
                      hintStyle:
                          TextStyle(color: Color(0xFFc8c7cc), fontSize: 17)),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ObButton(
                        text: 'Rate Passenger',
                        filled: true,
                        disabled: _rating == 0,
                        onPressed: () {
                          widget.tripService
                              .rateCustomer(_rating, _commentsController.text);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            homeRoute,
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
