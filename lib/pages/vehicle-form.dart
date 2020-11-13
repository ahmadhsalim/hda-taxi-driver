import 'package:hda_driver/models/vehicle-type.dart';
import 'package:hda_driver/models/vehicle.dart';
import 'package:hda_driver/resources/driver-resource.dart';
import 'package:hda_driver/resources/misc/resource-collection.dart';
import 'package:hda_driver/resources/vehicle-type-resource.dart';
import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hda_driver/styles/MainTheme.dart';
import 'package:hda_driver/widgets/ob-button.dart';
import 'package:hda_driver/widgets/text-input.dart';

class VehicleFormPage extends StatefulWidget {
  final String message;
  VehicleFormPage({Key key, this.message}) : super(key: key);

  @override
  _VehicleFormPageState createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  final _key = GlobalKey<ScaffoldState>();
  final VehicleTypeResource vehicleTypeResource = VehicleTypeResource();
  final DriverResource driverResource = DriverResource();
  Identity identity = getIt<Identity>();

  List<VehicleType> vehicleTypes = [];
  bool enableSave = false;

  Vehicle vehicle = Vehicle();
  VehicleType vehicleType;

  @override
  initState() {
    vehicleTypeResource.full().then((ResourceCollection<VehicleType> value) {
      setState(() {
        vehicleTypes = value.data;
        vehicleType =
            vehicleTypes.firstWhere((element) => element.name == 'Car');
        vehicle.vehicleTypeId = vehicleType.id;
      });
    });
    super.initState();
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: ObButton(
          text: 'Save',
          filled: true,
          disabled: !enableSave,
          onPressed: () async {
            try {
              Vehicle result = await driverResource.addVehicle(vehicle);
              if (result != null) {
                Navigator.pushNamed(context, documentUploadRoute);
              }
            } catch (e) {
              print(e);
            }
          },
        ));
  }

  Widget _buildSwitch(
    BuildContext context, {
    String label,
    bool disabled = false,
    bool value = false,
    Function onChanged,
  }) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        label,
        style: TextStyle(color: disabled ? Color(0xFFAEAEB2) : Colors.black),
      ),
      Switch(
        activeColor: MainTheme.primaryColour,
        value: value,
        onChanged: disabled ? null : onChanged,
      ),
    ]);
  }

  List<Widget> _buildVehicleTypeSelector(BuildContext context) {
    return [
      SizedBox(
          height: 28,
          child: Text('Vehicle type', style: TextStyle(fontSize: 16))),
      Container(
        padding: const EdgeInsets.only(left: 12, right: 12),
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F7),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<VehicleType>(
            icon: Icon(Icons.keyboard_arrow_down),
            dropdownColor: Colors.white,
            value: vehicleType,
            items: vehicleTypes.map((e) {
              return DropdownMenuItem<VehicleType>(
                child: Text(e.name),
                value: e,
              );
            }).toList(),
            onChanged: (VehicleType value) {
              setState(() {
                vehicleType = value;
                vehicle.vehicleTypeId = value.id;
              });
            },
          ),
        ),
      ),
    ];
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
          title: Center(
            child: Text(
              'Vehicle Details',
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
                        ..._buildVehicleTypeSelector(context),
                        SizedBox(height: 15),
                        TextInput(
                          label: 'Model',
                          onChanged: (String value) {
                            setState(() {
                              enableSave = true;
                              vehicle.model = value;
                            });
                          },
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: TextInput(
                                label: 'Color',
                                onChanged: (String value) {
                                  setState(() {
                                    enableSave = true;
                                    vehicle.color = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 27),
                            Expanded(
                              child: TextInput(
                                label: 'Manufactured Year',
                                onChanged: (String value) {
                                  setState(() {
                                    enableSave = true;
                                    vehicle.manufacturedYear = int.parse(value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: TextInput(
                                label: 'Board Number',
                                onChanged: (String value) {
                                  setState(() {
                                    enableSave = true;
                                    vehicle.boardNumber = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 27),
                            Expanded(
                              child: TextInput(
                                label: 'Plate Number',
                                onChanged: (String value) {
                                  setState(() {
                                    enableSave = true;
                                    vehicle.plateNumber = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        TextInput(
                          label: 'Max Passengers',
                          onChanged: (String value) {
                            setState(() {
                              enableSave = true;
                              vehicle.seats = int.parse(value);
                            });
                          },
                        ),
                        SizedBox(height: 15),
                        _buildSwitch(
                          context,
                          label: 'Extra Luggage Space',
                          value: vehicle.extraLuggage,
                          onChanged: (value) {
                            setState(() {
                              vehicle.extraLuggage = value;
                              enableSave = true;
                            });
                          },
                        ),
                        _buildSwitch(
                          context,
                          disabled: true,
                          label: 'Accept cash card (coming soon)',
                          value: vehicle.acceptCashCard,
                          onChanged: (value) {
                            setState(() {
                              vehicle.acceptCashCard = value;
                              enableSave = true;
                            });
                          },
                        ),
                        _buildSwitch(
                          context,
                          label: 'Accessiblity for people with immobility',
                          value: vehicle.accessibility,
                          onChanged: (value) {
                            setState(() {
                              vehicle.accessibility = value;
                              enableSave = true;
                            });
                          },
                        ),
                        _buildSwitch(
                          context,
                          label: 'Child seat',
                          value: vehicle.childSeat,
                          onChanged: (value) {
                            setState(() {
                              vehicle.childSeat = value;
                              enableSave = true;
                            });
                          },
                        ),
                        _buildSwitch(
                          context,
                          label: 'Smoking allowed',
                          value: vehicle.smoking,
                          onChanged: (value) {
                            setState(() {
                              vehicle.smoking = value;
                              enableSave = true;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }
}
