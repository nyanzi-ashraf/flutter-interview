import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'icons_map.dart';

class FaCustomIcon {
  static IconData getFontAwesomeIcon(String? iconName) {
    if (iconName == '') {
      return FontAwesomeIcons.questionCircle;
    }
    var list = iconName!.split(' ');
    if (list.length == 1) {
      iconName = list[0];
    }
    if (list.length >= 2) {
      iconName = list[1];
    }
    iconName = iconName.replaceAll('fa-', '');
    iconName = iconName.replaceAll('-', '');

    final filteredIcons = icons.where((icon) {
      return icon.title
          .toLowerCase()
          .replaceAll('-', '')
          .contains(iconName!.toLowerCase());
    }).toList();
    if (filteredIcons.isEmpty) {
      return FontAwesomeIcons.questionCircle;
    } else {
      return filteredIcons[0].iconData;
    }
  }
}
