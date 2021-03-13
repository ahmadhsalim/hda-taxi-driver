import 'dart:io';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/resources/driver-resource.dart';
import 'package:hda_driver/resources/file-resource.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/image-select-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hda_driver/widgets/ob-button.dart';
import 'package:hda_driver/widgets/profile-photo.dart';

final storage = FlutterSecureStorage();

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Identity identity = getIt<Identity>();

  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController mobileNumberController;
  TextEditingController emailController;
  File profilePhoto;

  double profilePhotoProgress = 0;
  bool profilePhotoUploading = false;
  bool isUntouched = true;

  bool isNameValid = true;
  bool isMobileNumberValid = true;
  bool isEmailValid = true;

  @override
  initState() {
    identity.getCurrentDriver().then((value) {
      setState(() {
        profilePhoto = value.profilePhotoFile;
        Driver driver = value;
        nameController = TextEditingController(text: driver.name);
        mobileNumberController = TextEditingController(text: driver.mobile);
        emailController = TextEditingController(text: driver.email);
      });
    });

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

  String _emailValidator(String value) {
    setState(() {
      isEmailValid = false;
    });
    if (value == null || value.length == 0) {
      return 'Email is required';
    } else {
      setState(() {
        isEmailValid = true;
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
    bool readOnly: false,
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
          readOnly: readOnly,
          onChanged: (value) {
            setState(() {
              isUntouched = false;
            });
          },
          decoration:
              _buildInputDecoration(prefixText: prefixText, valid: isValid),
          validator: validator,
          controller: controller,
        )),
      ],
    );
  }

  Future<bool> update(String name, String mobile, String email) async {
    DriverResource resource = DriverResource();

    return await resource
        .updateMe(Driver(name: name, mobile: mobile, email: email));
  }

  Widget _buildUpdateButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ObButton(
          text: 'Update',
          filled: true,
          fontWeight: FontWeight.w500,
          disabled: isUntouched,
          onPressed: () async {
            bool isValid = _profileFormKey.currentState.validate();

            try {
              if (isValid) {
                Loader.show(context,
                    progressIndicator: CircularProgressIndicator());
                String name = nameController.text;
                String mobile = mobileNumberController.text;
                String email = emailController.text;

                bool success = await update(name, mobile, email);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Updated',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    duration: Duration(seconds: 3),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Update failed.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.red[700],
                  ));
                }
              }
            } catch (e) {} finally {
              try {
                Loader.hide();
              } catch (e) {
                print('error hiding loader');
              }
            }
          },
        ));
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
        child: profilePhoto == null
            ? Center(child: ProfilePhoto(identity.getDriver().profilePhotoFile))
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(profilePhoto),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 94,
                      height: 94,
                      child: profilePhotoProgress == null
                          ? SizedBox.shrink()
                          : CircularProgressIndicator(
                              value: profilePhotoProgress,
                              strokeWidth: 8,
                              valueColor:
                                  AlwaysStoppedAnimation(Color(0x669E9E9E)),
                            ),
                    ),
                  ),
                  profilePhotoProgress == null
                      ? SizedBox.shrink()
                      : Center(
                          child: Text(
                            "${profilePhotoProgress.toInt()}%",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ],
              ),
      ), //Image(image: AssetImage('assets/logo.png')),
    );
  }

  Future upload() async {
    FileResource fileResource = FileResource(identity.getToken());
    String filename = await fileResource.fileUpload(
      profilePhoto,
      (int sentBytes, int totalBytes) {
        setState(() {
          profilePhotoProgress = sentBytes * 100 / totalBytes;
        });
      },
    );
    DriverResource resource = DriverResource();
    Driver driver = Driver(profilePhoto: filename);
    await resource.updateDocuments(driver);
    await identity.fetchProfilePhoto();
    setState(() {});
  }

  Widget _buildPhotoUpload(context) {
    return Center(
      child: InkWell(
        child: Text(
          'Update image',
          style: TextStyle(color: Color(0xFF3F44AB), fontSize: 14),
        ),
        onTap: () async {
          imageSelect(context, (File photo) async {
            if (photo != null) {
              setState(() {
                profilePhoto = photo;
                profilePhotoUploading = true;
              });
              await upload();

              setState(() {
                profilePhotoUploading = false;
                profilePhotoProgress = null;
                isUntouched = false;
              });
            }
          });
        },
      ),
    );
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: _profileFormKey,
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
                          _buildProfilePhoto(),
                          SizedBox(height: 10),
                          _buildPhotoUpload(context),
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
                              readOnly: true,
                              isValid: isMobileNumberValid,
                              validator: _mobileNumberValidator,
                              controller: mobileNumberController),
                          SizedBox(height: 16),
                          _buildTextField(
                              label: 'Email',
                              isValid: isEmailValid,
                              validator: _emailValidator,
                              controller: emailController),
                          _buildUpdateButton(context),
                          SizedBox(height: 8),
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
