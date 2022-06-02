import 'package:flutter/material.dart';

class ElasticIn extends StatefulWidget {
  final Key? key;
  final Widget? child;
  final Duration? duration;
  final Duration? delay;
  final Function(AnimationController)? controller;
  final bool? manualTrigger;
  final bool? animate;
  final bool? infinite;

  ElasticIn(
      {this.key,
      @required this.child,
      this.duration = const Duration(milliseconds: 1300),
      this.delay = const Duration(milliseconds: 0),
      this.controller,
      this.infinite = false,
      this.manualTrigger = false,
      this.animate = true})
      : super(key: key) {
    if (manualTrigger == true && controller == null) {
      throw FlutterError('If you want to use manualTrigger:true, \n\n'
          'Then you must provide the controller property, that is a callback like:\n\n'
          ' ( controller: AnimationController) => yourController = controller \n\n');
    }
  }

  @override
  _ElasticInState createState() => _ElasticInState();
}

/// StateClass, where the magic happens
class _ElasticInState extends State<ElasticIn>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  bool disposed = false;
  Animation<double>? bouncing;
  Animation<double>? opacity;
  @override
  void dispose() {
    disposed = true;
    controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this);

    opacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller!, curve: Interval(0, 0.45)));

    bouncing = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller!, curve: Curves.elasticOut));

    if (!widget.manualTrigger! && widget.animate!) {
      Future.delayed(widget.delay!, () {
        if (!disposed) {
          (widget.infinite!) ? controller!.repeat() : controller?.forward();
        }
      });
    }

    if (widget.controller is Function) {
      widget.controller!(controller!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate! && widget.delay!.inMilliseconds == 0) {
      controller?.forward();
    }

    return AnimatedBuilder(
        animation: controller!,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: bouncing!.value,
            child: Opacity(
              opacity: opacity!.value,
              child: widget.child,
            ),
          );
        });
  }
}
