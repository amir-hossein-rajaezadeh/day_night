import 'dart:math' show pi;

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late Animation<Offset> _mainAnimation;

  int switchStatus = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-1.25, 0.0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );

    _mainAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.5),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              if (switchStatus != 1)
                const Color(0xFFADD478)
              else
                const Color(0xFF1B2139),
              if (switchStatus != 1)
                const Color(0xFF2F7775)
              else
                const Color(0xFF8581FF),
            ],
          )),
          width: width,
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                width: switchStatus != 1 ? 200 : 0,
                top: switchStatus != 1 ? 120 : 100,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: Image.asset("assets/images/sun_cloud.png"),
                ),
              ),
              // switchStatus != 1
              //     ? Container(
              //         margin: const EdgeInsets.only(top: 180),
              //         child: Image.asset("assets/images/sun_cloud.png"),
              //       )
              //     : Container(
              //         margin: const EdgeInsets.only(top: 180),
              //         child: Image.asset("assets/images/night_moon.png"),
              //       ),
              Container(
                margin: const EdgeInsets.only(top: 164),
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
                          onTap: () {
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
                              setState(() {
                                switchStatus = 2;
                              });
                              _animationController
                                ..reset()
                                ..forward();
                              print("switch is 1 and be 2");
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
