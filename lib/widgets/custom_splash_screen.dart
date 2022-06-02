import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Widget? _home;
Function? _customFunction;
String? _imagePath;
String? _bgPath;
int? _duration;
CustomSplashType? _runfor;
Color? _backGroundColor;
String? _animationEffect;
double? _logoSize;

enum CustomSplashType { StaticDuration, BackgroundProcess }

Map<dynamic, Widget> _outputAndHome = {};

class CustomSplash extends StatefulWidget {
  CustomSplash(
      {@required String? imagePath,
      @required Widget? home,
      Function? customFunction,
      int? duration,
      CustomSplashType? type,
      Color? backGroundColor = Colors.white,
      String? animationEffect = 'fade-in',
      String? bgPath,
      double? logoSize,
      Map<dynamic, Widget>? outputAndHome}) {
    assert(duration != null);
    assert(home != null);
    assert(imagePath != null);

    _home = home;
    _duration = duration;
    _customFunction = customFunction;
    _imagePath = imagePath;
    _runfor = type;
    _bgPath = bgPath;
    _outputAndHome = outputAndHome!;
    _backGroundColor = backGroundColor;
    _animationEffect = animationEffect;
    _logoSize = logoSize;
  }

  @override
  _CustomSplashState createState() => _CustomSplashState();
}

class _CustomSplashState extends State<CustomSplash>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    if (_duration! < 1000) _duration = 2000;
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration!));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.easeInCirc));
    _animationController!.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController!.reset();
  }

  navigator(home) {
    Get.off(() => home);
  }

  Widget? _buildAnimation() {
    switch (_animationEffect) {
      case 'fade-in':
        {
          return FadeTransition(
              opacity: _animation!,
              child: Center(
                  child: SizedBox(
                      height: _logoSize, child: Image.asset(_imagePath!))));
        }
      case 'zoom-in':
        {
          return ScaleTransition(
              scale: _animation!,
              child: Center(
                  child: SizedBox(
                      height: _logoSize, child: Image.asset(_imagePath!))));
        }
      case 'zoom-out':
        {
          return ScaleTransition(
              scale: Tween(begin: 1.0, end: 0.6).animate(CurvedAnimation(
                  parent: _animationController!, curve: Curves.easeInCirc)),
              child: Center(
                  child: SizedBox(
                      height: _logoSize, child: Image.asset(_imagePath!))));
        }
      case 'top-down':
        {
          return SizeTransition(
              sizeFactor: _animation!,
              child: Center(
                  child: SizedBox(
                      height: _logoSize, child: Image.asset(_imagePath!))));
        }
      case 'zoom-in-out':
        {
          return ScaleTransition(
              scale: Tween(begin: 0.2, end: 0.6).animate(CurvedAnimation(
                  parent: _animationController!, curve: Curves.easeInOut)),
              child: Center(
                  child: SizedBox(
                      height: _logoSize, child: Image.asset(_imagePath!))));
        }

      case 'elastic-in':
        {
          return ScaleTransition(
            scale: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                parent: _animationController!, curve: Curves.elasticOut)),
            child: Center(
              child: Image.asset(
                _imagePath!,
                height: _logoSize,
                width: _logoSize,
              ),
            ),
          );
        }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _runfor == CustomSplashType.BackgroundProcess
        ? Future.delayed(Duration.zero).then((value) {
            var res = _customFunction!();
            Future.delayed(Duration(milliseconds: _duration!)).then((value) {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(
                  builder: (BuildContext context) => _outputAndHome[res]!));
            });
          })
        : Future.delayed(Duration(milliseconds: _duration!)).then((value) {
            Get.to(() => _home);
          });

    return Scaffold(
        backgroundColor: _backGroundColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_bgPath!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: _buildAnimation(),
            ),
          ],
        ));
  }
}
