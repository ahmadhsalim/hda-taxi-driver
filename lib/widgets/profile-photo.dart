import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePhoto extends StatelessWidget {
  final File photo;

  ProfilePhoto(this.photo);

  @override
  Widget build(BuildContext context) {
    return photo == null
        ? SvgPicture.asset('assets/avatar_placeholder.svg')
        : ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(photo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
  }
}
