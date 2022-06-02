import 'package:flutter/widgets.dart';

class IconDefinition implements Comparable {
  final IconData iconData;
  final String title;

  IconDefinition(this.iconData, this.title);

  @override
  String toString() => 'IconDefinition{iconData: $iconData, title: $title}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IconDefinition &&
          runtimeType == other.runtimeType &&
          iconData == other.iconData &&
          title == other.title;

  @override
  int get hashCode => iconData.hashCode ^ title.hashCode;

  @override
  int compareTo(other) => title.compareTo(other.title);
}
