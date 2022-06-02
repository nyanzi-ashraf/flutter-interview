import 'package:flutter/material.dart';

class StarCounterWidget extends StatelessWidget {
  final double? value;
  final double? size;
  final Color? color;

  const StarCounterWidget(
      {Key? key,
      this.value = 0,
      this.size = 10,
      this.color = const Color(0xffffd900)})
      : assert(value != null),
        super(key: key);

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= value!) {
      icon = new Icon(
        Icons.star_border,
        color: this.color,
        size: this.size,
      );
    } else if (index > value! - 1 && index < value!) {
      icon = new Icon(
        Icons.star_half,
        color: this.color,
        size: this.size,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: this.color,
        size: this.size,
      );
    }
    return Ink(
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        // return buildStar(context, index);
        return Icon(
          index >= value!
              ? Icons.star_border
              : index > value! - 1 && index < value!
                  ? Icons.star_half
                  : Icons.star,
          color: this.color,
          size: this.size,
        );
      }),
    );
  }
}
