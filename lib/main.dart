import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

List<Color> changeBackgroundColor(int switchStatus) {
  Color color1;
  Color color2;

  if (switchStatus != 1) {
    color1 = const Color(0xFFADD478);
  } else {
    color1 = const Color(0xFF1B2139);
  }

  if (switchStatus != 1) {
    color2 = const Color(0xFF2F7775);
  } else {
    color2 = const Color(0xFF8581FF);
  }

  return [color1, color2];
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late Animation<Offset> _mainAnimation;
  late final AnimationController _controller;
  late final AnimationController _controller2;

  late final Animation<Offset> _offsetAnimation;
  late final Animation<Offset> _offsetAnimation2;
  bool sunGone = false;
  int switchStatus = 0;
  bool moonIsGone = true;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1.5),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );

    _mainAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.5),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.9),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCirc));
    _offsetAnimation2 = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.2),
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeInCirc));

    _offsetAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          sunGone = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // var _color = getRandomColor(switchStatus);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: AnimatedContainer(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: changeBackgroundColor(switchStatus),
            ),
          ),
          width: width,
          height: height,
          duration: const Duration(milliseconds: 1500),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 0),
                width: width,
                height: 2,
                color: Colors.white,
              ),
              SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  height: 200,
                  margin: const EdgeInsets.only(top: 40),
                  child: sunGone
                      ? null
                      : Image.asset("assets/images/sun_cloud.png"),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                width: width,
                height: 2,
                color: Colors.transparent,
              ),
              moonIsGone
                  ? Container(
                      height: 200,
                    )
                  : SlideTransition(
                      position: _offsetAnimation2,
                      child: Container(
                        height: 200,
                        margin: const EdgeInsets.only(top: 0),
                        child: Image.asset("assets/images/night_moon.png"),
                      ),
                    ),
              Container(
                margin: const EdgeInsets.only(top: 0),
                child: Text(
                  switchStatus != 1
                      ? "Have a Good Day!"
                      : "Have a Sweet Dream!",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 0),
                width: 220,
                height: 82,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                          switchStatus != 1
                              ? "assets/images/day_switch_pic.png"
                              : "assets/images/night_switch_pic.png",
                          fit: BoxFit.cover),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SlideTransition(
                        position: _animation,
                        child: InkWell(
                          onTap: () async {
                            if (switchStatus == 2 || switchStatus == 0) {
                              _animation = Tween<Offset>(
                                begin: _animation.value,
                                end: const Offset(-1.42, 0.0),
                              ).animate(
                                CurvedAnimation(
                                    parent: _animationController,
                                    curve: Curves.bounceOut),
                              );
                              _mainAnimation = Tween<Offset>(
                                begin: _mainAnimation.value,
                                end: const Offset(0, -0.5),
                              ).animate(
                                CurvedAnimation(
                                    parent: _animationController,
                                    curve: Curves.ease),
                              );

                              _controller
                                ..reset()
                                ..forward();

                              setState(() {
                                switchStatus = 1;
                              });

                              _animationController
                                ..reset()
                                ..forward();

                              print("switch is 0 or 2  and  now is 1");
                            } else if (switchStatus == 1) {
                              _animation = Tween<Offset>(
                                begin: _animation.value,
                                end: const Offset(0.0, 0.0),
                              ).animate(
                                CurvedAnimation(
                                    parent: _animationController,
                                    curve: Curves.bounceOut),
                              );

                              _mainAnimation = Tween<Offset>(
                                begin: _mainAnimation.value,
                                end: const Offset(0.0, 0.0),
                              ).animate(
                                CurvedAnimation(
                                    parent: _animationController,
                                    curve: Curves.ease),
                              );

                              _controller.reverse();
                              setState(() {
                                switchStatus = 2;
                              });
                              _animationController
                                ..reset()
                                ..forward();
                              print("switch is 1 and be 2");
                            }

                            if (switchStatus == 1) {
                              _controller2.forward();
                              await Future.delayed(
                                const Duration(milliseconds: 985),
                              );
                              setState(() {
                                moonIsGone = false;
                              });
                            } else {
                              print("hereeee");
                              _controller.reverse();
                              _controller2.reverse();
                              setState(() {
                                sunGone = false;
                              });

                              await Future.delayed(
                                const Duration(milliseconds: 100),
                              );
                              setState(() {
                                moonIsGone = true;
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 18),
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white.withOpacity(0.80),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
