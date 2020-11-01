import 'package:flutter_svg/flutter_svg.dart';
import 'package:hda_driver/models/customer.dart';
import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Identity identity = getIt<Identity>();
  final _key = GlobalKey<ScaffoldState>();
  Customer customer;

  @override
  initState() {
    identity.getCurrentCustomer().then((value) {
      setState(() {
        customer = value;
      });
    });

    super.initState();
  }

  Widget _buildProfilePhoto() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 5),
                  blurRadius: 10)
            ]),
        height: 100,
        width: 100,
        // margin: const EdgeInsets.all(18),
        child: Center(
          child: SvgPicture.asset(
            'assets/avatar_placeholder.svg',
            width: 100,
            height: 100,
          ),
        ),
      ), //Image(image: AssetImage('assets/logo.png')),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Text(
          'Edit Profile',
          style: TextStyle(color: Color(0xFF3F44AB), fontSize: 14),
        ),
        onTap: () {
          Navigator.pushNamed(context, editProfileRoute);
        },
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    return [
      Divider(),
      ListTile(
        onTap: () {
          print('History coming soon.');
        },
        trailing: Icon(Icons.chevron_right),
        title: Text(
          'History',
          style: TextStyle(color: Color(0xFF2D2D2D), fontSize: 14),
        ),
      ),
      Divider(),
      ListTile(
        onTap: () {
          print('Notifications coming soon.');
        },
        trailing: Icon(Icons.chevron_right),
        title: Text(
          'Notifications',
          style: TextStyle(color: Color(0xFF2D2D2D), fontSize: 14),
        ),
      ),
      Divider(),
      ListTile(
        onTap: () {
          print('loggin out');
          identity.logout(context);
        },
        trailing: Icon(Icons.chevron_right),
        title: Text(
          'Logout',
          style: TextStyle(color: Color(0xFF909090), fontSize: 14),
        ),
      ),
      Divider(),
    ];
  }

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
          backgroundColor: Colors.white,
          leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
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
                        SizedBox(height: 16),
                        _buildProfilePhoto(),
                        SizedBox(height: 10),
                        _buildEditProfileButton(context),
                        SizedBox(height: 16),
                        ..._buildMenuItems(context),
                        SizedBox(height: 8),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
