import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/models/location.dart';
import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/resources/driver-resource.dart';
import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/screen-arguments/rating-arguments.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/location-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:hda_driver/services/socket-service.dart';
import 'package:hda_driver/services/trip-service.dart';
import 'package:hda_driver/styles/MainTheme.dart';
import 'package:hda_driver/widgets/animation-box.dart';
import 'package:hda_driver/widgets/ob-button.dart';
import 'package:hda_driver/widgets/profile-photo.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

enum HomeState { offline, online, accepting, pickUp, onTrip }

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double waitingDuration = 30000;
  final NumberFormat nf = NumberFormat.currency(name: 'MVR ');

  final Identity _identity = getIt<Identity>();
  final SocketService _socket = SocketService();
  final DriverResource _driverResource = DriverResource();
  final TripService _tripService = TripService();
  Completer<GoogleMapController> _controller;
  CameraPosition _currentPosition = LocationService.defaultPosition;
  Driver _driver;
  bool _onOffLoading = false;
  bool _isAccepting = false;
  bool _isPickDrop = false;
  double _waitingIndication = 0;

  double _earnedToday = 0.0;
  double _totalMissed = 0.0;
  double _totalCompleted = 0.0;
  double _averageRating = 0.0;

  HomeState _pageState = HomeState.offline;
  Timer _timer;

  @override
  void initState() {
    _socket.initialize();
    _tripService.clearTrip();
    _controller = Completer();
    _driver = _identity.getDriver();
    _pageState = HomeState.offline;
    _loadStats();

    if (_driver.onDuty) {
      _socket.listen(socketListener);
      _pageState = HomeState.online;
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _disposeMapController();
    _socket.dispose();

    super.dispose();
  }

  Future<void> _disposeMapController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  void socketListener(event) async {
    var data = Map<String, dynamic>.from(json.decode(event));
    if (data.containsKey('channel') && data['channel'] == 'trip-request') {
      await loadTrip(data['tripId']);
      showTimer();
    }
  }

  void _loadStats() async {
    var stats = await _driverResource.getStats();
    setState(() {
      _earnedToday = double.parse(stats['earnedtoday']) / 100;
      _averageRating = double.parse(stats['averaterating']);
      _totalCompleted = double.parse(stats['totalcompleted']);
      _totalMissed = double.parse(stats['totalmissed']);
    });
  }

  showTimer() {
    _waitingIndication = 0;
    _timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      if (_waitingIndication >= waitingDuration) {
        timer.cancel();
        return acceptTimeout();
      }

      setState(() {
        _waitingIndication += 100;
      });
    });
  }

  Future acceptTimeout() async {
    await _tripService.missed();
    setState(() {
      _pageState = HomeState.online;
    });
  }

  Future loadTrip(id) async {
    await _tripService.loadTrip(id);
    setState(() {
      _pageState = HomeState.accepting;
    });
  }

  onOffSwitch(bool value) async {
    if (_onOffLoading) return;

    setState(() {
      _onOffLoading = true;
      _tripService.clearTrip();
    });
    try {
      var result;
      if (value) {
        result = await _driverResource.online();
        LocationService.getCurrentLocation().then((Position position) {
          setState(() {
            _currentPosition = LocationService.getCameraPosition(position);
          });
        });
      } else {
        result = await _driverResource.offline();
      }

      if (result != null) {
        setState(() {
          _driver.onDuty = value;
          if (_driver.onDuty)
            _pageState = HomeState.online;
          else
            _pageState = HomeState.offline;
        });
      }
    } catch (e) {} finally {
      setState(() {
        _onOffLoading = false;
      });
    }
  }

  String getTitle() {
    return _pageState == HomeState.offline ? 'Your Offline' : 'Accepting Jobs';
  }

  Widget displayItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          Center(
            child: Text(
              subtitle,
              style: TextStyle(fontSize: 15, color: Color(0xFF707070)),
            ),
          ),
        ],
      ),
    );
  }

  Widget offlineDisplay(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimationBox(),
            Padding(
              padding: const EdgeInsets.only(
                top: 36,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quam viverra nunc volutpat, nibh vestibulum, eu ut cras. In felis netus neque vitae.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFAEAEB2), fontSize: 16),
              ),
            ),
          ]),
    );
  }

  Widget onlineDisplay(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      initialCameraPosition: _currentPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller?.complete(controller);
      },
    );
  }

  Widget stats() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 89,
            color: Color.fromARGB(255, 247, 247, 247),
            child: displayItem(nf.format(_earnedToday), 'Earned Today'),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            displayItem(_totalCompleted.toStringAsFixed(1) + '%', 'Acceptance'),
            displayItem(_averageRating.toStringAsFixed(1) + '%', 'Ratings'),
            displayItem(_totalMissed.toStringAsFixed(1) + '%', 'Cancellation'),
          ]),
        ],
      ),
    );
  }

  Widget incoming() {
    Trip trip = _tripService.getTrip();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: _waitingIndication / waitingDuration,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(MainTheme.primaryColour),
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 16),
              Container(
                margin: const EdgeInsets.all(16),
                width: 50,
                height: 50,
                child: ProfilePhoto(trip.customer.profilePhotoFile),
              ),
              SizedBox(width: 16),
              Text(
                '4.9',
                style: TextStyle(fontSize: 15, color: Color(0xFF707070)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child:
                    SvgPicture.asset('assets/star.svg', height: 16, width: 16),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text('3 min', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 16),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 13),
                  child: Column(
                    children: [
                      Icon(
                        Icons.radio_button_checked,
                        color: Color(0xFFF7E28D),
                      ),
                      DottedLine(
                        dashLength: 5,
                        dashGapLength: 5,
                        lineThickness: 2,
                        dashColor: Color(0xFFC8C7CC),
                        direction: Axis.vertical,
                        lineLength: 30,
                      ),
                      Icon(
                        Icons.radio_button_checked,
                        color: Color(0xFF3F44AB),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 3),
                    Text(
                      'PICK-UP',
                      style: TextStyle(color: Color(0xFF707070), fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      trip.start.name,
                      style: TextStyle(fontSize: 14),
                    ),
                    Divider(
                      thickness: 1,
                      height: 16,
                      color: Colors.black,
                    ),
                    Text(
                      'DROP-OFF',
                      style: TextStyle(color: Color(0xFF707070), fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      trip.getDropOff().name,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 15),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 30),
            child: ObButton(
              text: 'Accept Job',
              onPressed: () async {
                if (_isAccepting) return;

                setState(() {
                  _isAccepting = true;
                });
                bool accepted = await _tripService.acceptJob();
                if (!accepted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red[400],
                    content: Text(
                      'Trip not accepted.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    duration: Duration(seconds: 3),
                  ));
                  _pageState = HomeState.accepting;
                } else {
                  _pageState = HomeState.pickUp;
                  _timer?.cancel();
                }
                setState(() {
                  _isAccepting = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget onTrip() {
    Trip trip = _tripService.getTrip();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntrinsicHeight(
          // padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                width: 50,
                height: 50,
                child: ProfilePhoto(trip.customer.profilePhotoFile),
              ),
              Center(
                child: Text(
                  '4.9',
                  style: TextStyle(fontSize: 15, color: Color(0xFF707070)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child:
                    SvgPicture.asset('assets/star.svg', height: 16, width: 16),
              ),
              Spacer(),
              RawMaterialButton(
                shape: CircleBorder(),
                padding: const EdgeInsets.all(15),
                highlightColor: Colors.transparent,
                highlightElevation: 0,
                constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                child: SvgPicture.asset(
                  'assets/call.svg',
                  width: 34,
                  height: 34,
                ),
                onPressed: () async {
                  String url = 'tel://${trip.customer.mobile}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Unable to open dialer.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      duration: Duration(seconds: 3),
                    ));
                  }
                },
              ),
              RawMaterialButton(
                shape: CircleBorder(),
                padding: const EdgeInsets.all(15),
                highlightColor: Colors.transparent,
                highlightElevation: 0,
                constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                child: SvgPicture.asset(
                  'assets/chat.svg',
                  width: 34,
                  height: 34,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: ObButton(
            text: _pageState == HomeState.pickUp ? 'Pick Up' : 'Drop Off',
            onPressed: () async {
              if (_isPickDrop) return;

              setState(() {
                _isPickDrop = true;
              });
              switch (_pageState) {
                case HomeState.pickUp:
                  await _tripService.pickUp();
                  _pageState = HomeState.onTrip;
                  break;
                default:
                  await _tripService.complete();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    ratingRoute,
                    (Route<dynamic> route) => false,
                    arguments: RatingArguments(_tripService),
                  );
                  break;
              }
              setState(() {
                _isPickDrop = false;
              });
            },
          ),
        ),
        _pageState == HomeState.pickUp
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: ObButton(
                  text: 'Cancel',
                  filled: false,
                  textColor: Color(0xFF707070),
                  onPressed: () async {
                    await _tripService.cancel();
                    setState(() {
                      _pageState = HomeState.online;
                    });
                  },
                ),
              )
            : SizedBox(height: 8)
      ],
    );
  }

  Widget route() {
    if (_pageState == HomeState.pickUp || _pageState == HomeState.onTrip) {
      Trip trip = _tripService.getTrip();

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            // padding: EdgeInsets.only(top: 15),
            color: MainTheme.primaryColour,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 16, right: 13),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.radio_button_checked,
                          color: Color(0xFFF7E28D)),
                      DottedLine(
                        dashLength: 5,
                        dashGapLength: 5,
                        lineThickness: 2,
                        dashColor: Color(0xFFC8C7CC),
                        direction: Axis.vertical,
                        lineLength: 30,
                      ),
                      Icon(Icons.radio_button_checked, color: Colors.white),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 3),
                        Text(
                          'PICK-UP',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          trip.start.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'DROP-OFF',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          trip.getDropOff().name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Center(
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/navigate_map.svg',
                        width: 42,
                        height: 42,
                      ),
                      iconSize: 42,
                      onPressed: () async {
                        String url;
                        Location dest = trip.start;
                        if (_pageState == HomeState.onTrip)
                          dest = trip.dropOffs[0];

                        if (Platform.isIOS) {
                          url =
                              "https://maps.apple.com/?daddr=${dest.latitude},${dest.longitude}&dirflg=car";
                          // "https://maps.apple.com/?saddr=${trip.start.latitude},${trip.start.longitude}&daddr=${dest.latitude},${dest.longitude}&dirflg=car";
                        } else {
                          url =
                              "https://www.google.com/maps/dir/?api=1&destination=${dest.latitude},${dest.longitude}";
                          // "https://www.google.com/maps/dir/?api=1&origin=${trip.start.latitude},${trip.start.longitude}&destination=${trip.dropOffs[0].latitude},${trip.dropOffs[0].longitude}";
                        }
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.navigation),
                //   color: Colors.white,
                // )
              ],
            ),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget showBottomBar() {
    switch (_pageState) {
      case HomeState.accepting:
        return incoming();
        break;
      case HomeState.pickUp:
      case HomeState.onTrip:
        return onTrip();
      default:
        return stats();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_driver == null)
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xAA9E9E9E)),
        ),
      );

    return Scaffold(
      body: Container(
        margin: MediaQuery.of(context).padding,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                  left: 16, top: 10, bottom: 10, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => null,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 5),
                              blurRadius: 10)
                        ],
                        image: DecorationImage(
                          image: FileImage(_identity.getProfilePhoto()),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Text(getTitle(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                  Switch(
                    activeColor: MainTheme.primaryColour,
                    value: _driver.onDuty,
                    onChanged: _onOffLoading ? null : onOffSwitch,
                  ),
                ],
              ),
            ),
            _onOffLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation(Colors.grey[300]),
                  )
                : SizedBox.shrink(),
            Expanded(
              child: Stack(
                children: [
                  _pageState == HomeState.offline
                      ? offlineDisplay(context)
                      // : SizedBox.expand(),
                      : onlineDisplay(context),
                  route(),
                ],
              ),
            ),
            showBottomBar(),
          ],
        ),
      ),
    );
  }
}
