import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hda_driver/helpers/sentence-case.dart';
import 'package:hda_driver/resources/driver-resource.dart';
import 'package:hda_driver/resources/misc/paged-collection.dart';
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
  PagedCollection _collection;
  final NumberFormat nf = NumberFormat.currency(name: 'MVR ');

  @override
  initState() {
    super.initState();

    _resource.myHistory(
        include: ['trip.start,trip.dropOffs,trip.charges']).then((value) {
      print(value);
      _collection = value;
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

  List<Widget> getList() {
    return _collection.data
        .map((e) => Column(
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
                      Text(DateFormat('dd/MM/yyyy kk:mm').format(e.createdAt)),
                      Text(getSentenceCaseFromDashed(e.action)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
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
                          Text(e.trip.start.name),
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
                          Expanded(child: Text(e.trip.dropOffs[0].name)),
                          Text(nf.format(e.trip.charges.length > 0
                              ? e.trip.charges[0].charge ?? 0
                              : 0)),
                        ],
                      )
                    ],
                  ),
                  // child: Row(
                  //   crossAxisAlignment: CrossAxisAlignment.stretch,
                  //   children: [
                  //     Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(
                  //           Icons.radio_button_checked,
                  //           color: Color(0xFF957806),
                  //         ),
                  //         DottedLine(
                  //           dashLength: 5,
                  //           dashGapLength: 5,
                  //           lineThickness: 2,
                  //           dashColor: Color(0xFFC8C7CC),
                  //           direction: Axis.vertical,
                  //           lineLength: 17,
                  //         ),
                  //         Icon(
                  //           Icons.radio_button_checked,
                  //           color: Color(0xFF3F44AB),
                  //         )
                  //       ],
                  //     ),
                  //     Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(e.trip.start.name),
                  //         SizedBox(height: 17),
                  //         Text(e.trip.start.name),
                  //       ],
                  //     ),
                  //     Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(nf.format(e.trip.charges.length > 0
                  //             ? e.trip.charges[0].charge ?? 0
                  //             : 0)),
                  //       ],
                  //     ),
                  //     // Text('MVR ' +
                  //     //     (e.trip.charges.length > 0
                  //     //         ? e.trip.charges[0].charge
                  //     //         : ''))
                  //   ],
                  // ),
                ),
              ],
            ))
        .toList();
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
          title: Center(child: Text('History')),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(children: getList()),
        ),
      ),
    );
  }
}
