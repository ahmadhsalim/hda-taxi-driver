import 'dart:io';

import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/resources/driver-resource.dart';
import 'package:hda_driver/resources/file-resource.dart';
import 'package:hda_driver/resources/vehicle-type-resource.dart';
import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/image-select-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hda_driver/widgets/ob-button.dart';
import 'package:hda_driver/widgets/text-input.dart';

class LegalDocumentsUploadPage extends StatefulWidget {
  final String message;
  LegalDocumentsUploadPage({Key key, this.message}) : super(key: key);

  @override
  _LegalDocumentsUploadPageState createState() =>
      _LegalDocumentsUploadPageState();
}

class _LegalDocumentsUploadPageState extends State<LegalDocumentsUploadPage> {
  final _key = GlobalKey<ScaffoldState>();
  final VehicleTypeResource vehicleTypeResource = VehicleTypeResource();
  Identity identity = getIt<Identity>();

  bool enableSubmit = false;

  String nameOnDriversLicense;
  String licenseNumber;
  File profilePhoto;
  File licenseFront;
  File licenseBack;

  double profilePhotoUpload;
  double licenseFrontUpload;
  double licenseBackUpload;

  @override
  initState() {
    super.initState();
  }

  Widget _buildProfilePhotoButton(BuildContext context) {
    return Center(
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              if (profilePhotoUpload != null) return;

              imageSelect(context, (File photo) {
                if (photo != null) {
                  setState(() {
                    profilePhoto = photo;
                  });
                }
              });
            },
            child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: profilePhoto == null
                    ? Icon(
                        Icons.add_circle,
                        size: 24,
                        color: Color(0xFF3F44AB),
                      )
                    : Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
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
                              child: profilePhotoUpload == null
                                  ? SizedBox.shrink()
                                  : CircularProgressIndicator(
                                      value: profilePhotoUpload,
                                      strokeWidth: 8,
                                      valueColor: AlwaysStoppedAnimation(
                                          Color(0x669E9E9E)),
                                    ),
                            ),
                          ),
                          profilePhotoUpload == null
                              ? SizedBox.shrink()
                              : Center(
                                  child: Text(
                                    "${profilePhotoUpload.toInt()}%",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        ],
                      )),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 146,
            child: Text(
              'Please upoad a recent self-portrait.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF1B2234)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentButton(BuildContext context,
      {File image, String label, Function onSelect, double progress}) {
    return InkWell(
      onTap: () => imageSelect(context, (File photo) {
        onSelect(photo);
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label),
          Container(
            margin: const EdgeInsets.only(top: 9),
            height: 93,
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F7),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: image == null
                ? Icon(
                    Icons.add_circle,
                    size: 24,
                    color: Color(0xFF3F44AB),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        progress == null
                            ? SizedBox.shrink()
                            : Align(
                                alignment: Alignment.bottomCenter,
                                child: LinearProgressIndicator(
                                  minHeight: 5,
                                  value: progress,
                                  backgroundColor: Colors.transparent,
                                  valueColor:
                                      AlwaysStoppedAnimation(Color(0xAA9E9E9E)),
                                ),
                              ),
                        progress == null
                            ? SizedBox.shrink()
                            : Center(
                                child: Text(
                                  "${progress.toInt()}%",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> uploadFiles() async {
    FileResource fileResource = FileResource(identity.getToken());
    Future<String> profilePhotoRes =
        fileResource.fileUpload(profilePhoto, (int sentBytes, int totalBytes) {
      setState(() {
        profilePhotoUpload = sentBytes * 100 / totalBytes;
      });
    });

    Future<String> licenseFrontRes =
        fileResource.fileUpload(licenseFront, (int sentBytes, int totalBytes) {
      setState(() {
        licenseFrontUpload = sentBytes * 100 / totalBytes;
      });
    });
    Future<String> licenseBackRes =
        fileResource.fileUpload(licenseBack, (int sentBytes, int totalBytes) {
      setState(() {
        licenseBackUpload = sentBytes * 100 / totalBytes;
      });
    });

    return await Future.wait([
      profilePhotoRes,
      licenseFrontRes,
      licenseBackRes,
    ]);
  }

  Future<bool> save(List<String> filenames) {
    DriverResource resource = DriverResource();
    Driver driver = Driver(
      profilePhoto: filenames[0],
      nameOnDriversLicense: nameOnDriversLicense,
      driversLicenseNumber: licenseNumber,
      licenseFrontPhoto: filenames[1],
      licenseBackPhoto: filenames[2],
    );
    return resource.updateDocuments(driver);
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: ObButton(
          text: 'Submit',
          filled: true,
          disabled: !enableSubmit,
          onPressed: () async {
            try {
              List<String> res = await uploadFiles();
              bool success = await save(res);

              if (success) {
                Navigator.pushNamedAndRemoveUntil(context,
                    vehicleReviewingRoute, (Route<dynamic> route) => false);
              } else {
                throw Error();
              }
            } catch (e) {
              print(e);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Unable to save. Try again.',
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Center(
            child: Text(
              'Legal Documents',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildProfilePhotoButton(context),
                        SizedBox(height: 30),
                        TextInput(
                          label: 'Name on driver license',
                          onChanged: (String value) {
                            nameOnDriversLicense = value;
                            if (nameOnDriversLicense != null &&
                                licenseNumber != null &&
                                profilePhoto != null &&
                                licenseFront != null &&
                                licenseBack != null) {
                              enableSubmit = true;
                            }
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 15),
                        TextInput(
                          label: 'Driver license number',
                          onChanged: (String value) {
                            licenseNumber = value;
                            if (nameOnDriversLicense != null &&
                                licenseNumber != null &&
                                profilePhoto != null &&
                                licenseFront != null &&
                                licenseBack != null) {
                              enableSubmit = true;
                            }
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDocumentButton(
                                context,
                                label: 'License front side',
                                image: licenseFront,
                                progress: licenseFrontUpload,
                                onSelect: (File image) {
                                  if (licenseFrontUpload != null) return;

                                  if (image != null) {
                                    licenseFront = image;
                                    if (nameOnDriversLicense != null &&
                                        licenseNumber != null &&
                                        profilePhoto != null &&
                                        licenseFront != null &&
                                        licenseBack != null) {
                                      enableSubmit = true;
                                    }
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 27),
                            Expanded(
                              child: _buildDocumentButton(
                                context,
                                label: 'License back side',
                                image: licenseBack,
                                progress: licenseBackUpload,
                                onSelect: (File image) {
                                  if (licenseBackUpload != null) return;

                                  if (image != null) {
                                    licenseBack = image;
                                    if (nameOnDriversLicense != null &&
                                        licenseNumber != null &&
                                        profilePhoto != null &&
                                        licenseFront != null &&
                                        licenseBack != null) {
                                      enableSubmit = true;
                                    }
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }
}
