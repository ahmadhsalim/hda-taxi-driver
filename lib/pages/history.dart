import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hda_driver/helpers/sentence-case.dart';
import 'package:hda_driver/models/trip-action.dart';
import 'package:hda_driver/resources/driver-resource.dart';
import 'package:hda_driver/resources/misc/paged-collection.dart';
import 'package:hda_driver/widgets/animation-box.dart';
import 'package:hda_driver/widgets/ob-button.dart';
import 'package:intl/intl.dart';

final storage = FlutterSecureStorage();

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final DriverResource _resource = DriverResource();
  bool _loading = true;
  PagedCollection<TripAction> _collection;
  final NumberFormat nf = NumberFormat.currency(name: 'MVR ');

  @override
  initState() {
    super.initState();

    _resource.myHistory(include: [
      'trip.start,trip.dropOffs,trip.charges,trip.customerRating'
    ]).then((value) {
      setState(() {
        _collection = value;
      });
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getEmptyScreen() {
    return Container(
      alignment: Alignment.center,
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimationBox(),
            SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: SizedBox(
                width: 279,
                child: Text('Enter message for empty screen here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFAEAEB2), fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTripCharge(TripAction tripAction) {
    double charges = 0.0;
    if (tripAction.trip.charges.length > 0) {
      tripAction.trip.charges.forEach((c) {
        charges += c.charge;
      });
    }

    return nf.format(charges / 100);
  }

  Widget getList() {
    return SingleChildScrollView(
      child: Column(
        children: _collection.data
            .map((TripAction tripAction) => Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 11,
                        bottom: 11,
                      ),
                      color: Color(0xFFF7F7F7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('dd/MM/yyyy kk:mm')
                              .format(tripAction.createdAt)),
                          Text(getSentenceCaseFromDashed(tripAction.action)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.radio_button_checked,
                                      color: Color(0xFF957806),
                                    ),
                                    SizedBox(width: 13),
                                    Text(tripAction.trip.start.name,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 10.5),
                                    DottedLine(
                                      dashLength: 5,
                                      dashGapLength: 5,
                                      lineThickness: 2,
                                      dashColor: Color(0xFFC8C7CC),
                                      direction: Axis.vertical,
                                      lineLength: 17,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.radio_button_checked,
                                      color: Color(0xFF3F44AB),
                                    ),
                                    SizedBox(width: 13),
                                    Expanded(
                                      child: Text(
                                          tripAction.trip.dropOffs[0].name,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    if (tripAction.trip.customerRating != null)
                                      Text(getTripCharge(tripAction)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          if (tripAction.trip.customerRating == null)
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 4),
                              child: ObButton(
                                text: 'Rate',
                                small: true,
                                onPressed: () {
                                  print('rated');
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
          title: Text(
            'History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF262628),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _collection != null && _collection.data.length > 0
                ? getList()
                : getEmptyScreen(),
      ),
    );
  }
}
