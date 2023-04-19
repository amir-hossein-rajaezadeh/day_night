import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
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
  late AnimationController _switchAnimationController;
  late Animation<Offset> _switchAnimation;
  late final AnimationController _dayAndNightPhotoController;
  late final Animation<Offset> _dayNightPhotoAndVerticalSwitchAnimation;
  bool sunGone = false;
  bool showNightSwitch = false;
  int switchStatus = 0;
  bool moonIsGone = true;
  @override
  void initState() {
    super.initState();
    _switchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _switchAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1.5),
    ).animate(
      CurvedAnimation(
          parent: _switchAnimationController, curve: Curves.bounceOut),
    );

    _dayAndNightPhotoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _dayNightPhotoAndVerticalSwitchAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.1),
    ).animate(CurvedAnimation(
        parent: _dayAndNightPhotoController, curve: Curves.easeInCirc));

    _dayNightPhotoAndVerticalSwitchAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          sunGone = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _switchAnimationController.dispose();
    _dayAndNightPhotoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        top: false,
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
          duration: const Duration(milliseconds: 900),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 0),
                width: width,
                height: 2,
              ),
              SlideTransition(
                position: _dayNightPhotoAndVerticalSwitchAnimation,
                child: Container(
                  height: 200,
                  margin: const EdgeInsets.only(top: 80),
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
                      position: _dayNightPhotoAndVerticalSwitchAnimation,
                      child: Container(
                        height: 200,
                        margin: const EdgeInsets.only(top: 0),
                        child: Image.asset("assets/images/night_moon.png"),
                      ),
                    ),
              switchStatus != 1
                  ? FadeTransition(
                      opacity: _switchAnimationController,
                      child: Text(
                        "Have a Good Day!",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                      ),
                    )
                  : FadeTransition(
                      //
                      opacity: _dayAndNightPhotoController,
                      child: Text(
                        "Have a Sweet Dream!",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                      )),
              Container(
                margin: const EdgeInsets.only(top: 60),
                width: 220,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SlideTransition(
                        position: _dayNightPhotoAndVerticalSwitchAnimation,
                        child: Container(
                          height: 85,
                          margin: const EdgeInsets.only(top: 0),
                          child: Column(
                            children: [
                              Image.asset("assets/images/day_switch_pic.png"),
                              Image.asset("assets/images/night_switch_pic.png")
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SlideTransition(
                        position: _switchAnimation,
                        child: InkWell(
                          onTap: () async {
                            if (switchStatus == 2 || switchStatus == 0) {
                              _switchAnimation = Tween<Offset>(
                                begin: _switchAnimation.value,
                                end: const Offset(-1.8, 0.0),
                              ).animate(
                                CurvedAnimation(
                                    parent: _switchAnimationController,
                                    curve: Curves.bounceOut),
                              );

                              _dayAndNightPhotoController
                                ..reset()
                                ..forward();

                              setState(() {
                                switchStatus = 1;
                              });

                              _switchAnimationController
                                ..reset()
                                ..forward();

                              print("switch is 0 or 2  and  now is 1");
                            } else if (switchStatus == 1) {
                              _switchAnimation = Tween<Offset>(
                                begin: _switchAnimation.value,
                                end: const Offset(0.0, 0.0),
                              ).animate(
                                CurvedAnimation(
                                    parent: _switchAnimationController,
                                    curve: Curves.bounceOut),
                              );

                              _dayAndNightPhotoController.reverse();
                              setState(() {
                                switchStatus = 2;
                              });
                              _switchAnimationController
                                ..reset()
                                ..forward();
                              print("switch is 1 and be 2");
                            }

                            if (switchStatus == 1) {
                              _dayAndNightPhotoController.forward();
                              await Future.delayed(
                                const Duration(milliseconds: 400),
                              );
                              setState(() {
                                showNightSwitch = true;
                              });

                              await Future.delayed(
                                const Duration(milliseconds: 100),
                              );
                              setState(() {
                                moonIsGone = false;
                              });
                            } else {
                              _dayAndNightPhotoController.reverse();
                              setState(() {
                                sunGone = false;
                              });

                              await Future.delayed(
                                const Duration(milliseconds: 130),
                              );
                              setState(() {
                                moonIsGone = true;
                                showNightSwitch = false;
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
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
