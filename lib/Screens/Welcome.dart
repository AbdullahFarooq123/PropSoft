import 'package:flashchat/Screens/Login.dart';
import 'package:flashchat/Constants.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController psController;
  late AnimationController propSoftController;
  late AnimationController futureSoftController;
  late AnimationController scaleOutAnimationController;
  late AnimationController windowAnimationController;
  late AnimationController fadeAndScaleOutAnimationController;
  late AnimationController rotateAnimationController;
  late AnimationController scaleInAnimationController;

  late Animation psAnimation;
  late Animation propSoftAnimation;
  late Animation futureSoftAnimation;
  late Animation scaleOutAnimation;
  late Animation windowAnimation;
  late Animation fadeAndScaleOutAnimation;
  late Animation rotateAnimation;
  late Animation scaleInAnimation;

  final int removeDuration = 300;
  final int psDuration = 2000;
  final int propSoftDuration = 1000;
  final int futureSoftDuration = 2000;
  late int scaleOutAnimationDuration;
  late int windowAnimationDuration;
  late int fadeAndScaleOutAnimationDuration;
  late int rotateAnimationDuration;
  late int scaleInAnimationDuration;
  int delay = 250;
  bool showPropSoft = false;

  @override
  initState() {
    super.initState();
    initializeControllers();
    initializeAnimations();
    startAnimations();
  }

  @override
  dispose() {
    psController.dispose();
    propSoftController.dispose();
    futureSoftController.dispose();
    scaleOutAnimationController.dispose();
    fadeAndScaleOutAnimationController.dispose();
    rotateAnimationController.dispose();
    scaleInAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Stack(
        children: [
          Positioned(
            child: Transform.rotate(
              angle: (rotateAnimation.value * 2),
              child: Center(
                child: Container(
                  height: (mediaSize.height -
                      scaleOutAnimation.value * (mediaSize.height * 0.90)),
                  width: (mediaSize.width -
                      scaleOutAnimation.value * (mediaSize.width * 0.88)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(scaleOutAnimation.value * 10)),
                    color: backgroundColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: Transform.rotate(
              angle: (rotateAnimation.value * 2),
              child: Transform.scale(
                scale: scaleInAnimation.value * 100,
                child: Center(
                  child: Container(
                    height: (mediaSize.height -
                        scaleOutAnimation.value * (mediaSize.height * 0.90)),
                    width: (mediaSize.width -
                        scaleOutAnimation.value * (mediaSize.width * 0.88)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(scaleOutAnimation.value * 10)),
                      color: backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: Center(
              child: Container(
                height: (windowAnimation.value *
                        (mediaSize.height - (mediaSize.height * 0.90))) -
                    (fadeAndScaleOutAnimation.value *
                        (windowAnimation.value *
                            (mediaSize.height - (mediaSize.height * 0.90)))),
                width: (mediaSize.width -
                        scaleOutAnimation.value * (mediaSize.width * 0.88)) -
                    (fadeAndScaleOutAnimation.value *
                        (mediaSize.width -
                            scaleOutAnimation.value *
                                (mediaSize.width * 0.88))),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: psAnimation.value * mediaSize.height * 0.13,
                      width: psAnimation.value * mediaSize.width * 0.21,
                      child: Image.asset('images/propSoft logo.png'),
                      // color: Colors.black,
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: ((mediaSize.height / 2) - mediaSize.height * 0.13) +
                mediaSize.height * 0.155,
            left: ((mediaSize.width / 2) - mediaSize.width * 0.27) +
                mediaSize.width * 0.24,
            child: Visibility(
              visible: showPropSoft,
              child: SizedBox(
                height: mediaSize.height * 0.05,
                width: mediaSize.width * 0.29,
                // color: Colors.black,
                child: Image.asset('images/prop soft.png'),
              ),
            ),
          ),
          Positioned(
            top: ((mediaSize.height / 2) - mediaSize.height * 0.13) +
                mediaSize.height * 0.15,
            left: (((mediaSize.width / 2) - mediaSize.width * 0.27) +
                    mediaSize.width * 0.24) +
                propSoftAnimation.value * (mediaSize.width * 0.29),
            child: Visibility(
              visible: showPropSoft,
              child: Container(
                height: mediaSize.height * 0.05,
                width: mediaSize.width * 0.29,
                color: backgroundColor,
              ),
            ),
          ),
          Positioned(
            top: (mediaSize.height) - (mediaSize.height * 0.05),
            left: (mediaSize.width) - (mediaSize.width * 0.27),
            child: Visibility(
              visible: showPropSoft,
              child: Opacity(
                opacity: futureSoftAnimation.value,
                child: SizedBox(
                  height: mediaSize.height * 0.04,
                  width: mediaSize.width * 0.27,
                  // color: Colors.black,
                  child: Image.asset('images/futureSoft.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initializeControllers() {
    scaleOutAnimationDuration = windowAnimationDuration =
        fadeAndScaleOutAnimationDuration =
            rotateAnimationDuration = scaleInAnimationDuration = removeDuration;
    psController = AnimationController(
      duration: Duration(milliseconds: psDuration),
      vsync: this,
    );
    propSoftController = AnimationController(
      duration: Duration(milliseconds: propSoftDuration),
      vsync: this,
    );
    futureSoftController = AnimationController(
      duration: Duration(milliseconds: futureSoftDuration),
      vsync: this,
    );
    scaleOutAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: scaleOutAnimationDuration));
    windowAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: windowAnimationDuration));
    fadeAndScaleOutAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: fadeAndScaleOutAnimationDuration));
    rotateAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: rotateAnimationDuration));
    scaleInAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: scaleInAnimationDuration));
  }

  void initializeAnimations() {
    psAnimation =
        CurvedAnimation(parent: psController, curve: Curves.bounceOut);
    propSoftAnimation =
        CurvedAnimation(parent: propSoftController, curve: Curves.bounceIn);
    futureSoftAnimation =
        CurvedAnimation(parent: futureSoftController, curve: Curves.easeIn);
    scaleOutAnimation = CurvedAnimation(
        parent: scaleOutAnimationController, curve: Curves.easeInExpo);
    windowAnimation = CurvedAnimation(
        parent: windowAnimationController, curve: Curves.easeInExpo);
    fadeAndScaleOutAnimation = CurvedAnimation(
        parent: fadeAndScaleOutAnimationController, curve: Curves.easeOut);
    rotateAnimation = CurvedAnimation(
        parent: rotateAnimationController, curve: Curves.easeInQuart);
    scaleInAnimation = CurvedAnimation(
        parent: scaleInAnimationController, curve: Curves.easeInQuart);
  }

  void startAnimations() {
    psController.forward();
    psController.addListener(() {
      setState(() {
        if (psController.isCompleted) {
          showPropSoft = true;
          propSoftController.forward();
          futureSoftController.forward();
        }
      });
    });
    propSoftController.addListener(() {
      setState(() {});
    });
    futureSoftController.addListener(() {
      setState(() {
        if (futureSoftController.isCompleted &&
            propSoftController.isCompleted) {
          Future.delayed(const Duration(seconds: 1), () {
            propSoftController.reverseDuration = Duration(milliseconds: delay);
            futureSoftController.reverseDuration =
                Duration(milliseconds: delay);
            psController.reverseDuration = Duration(milliseconds: delay);
            propSoftController.reverse();
            futureSoftController.reverse();
            Future.delayed(Duration(milliseconds: delay), () {
              showPropSoft = false;
              psController.reverse();
            });
            Future.delayed(Duration(milliseconds: delay * 2), () {
              // hideStack = true;
              scaleOutAnimationController.forward();
            });
          });
        }
      });
    });
    scaleOutAnimationController.addListener(() {
      setState(() {
        if (scaleOutAnimationController.isCompleted) {
          windowAnimationController.forward();
        }
      });
    });
    windowAnimationController.addListener(() {
      setState(() {
        if (windowAnimationController.isCompleted) {
          Future.delayed(Duration(milliseconds: delay), () {
            fadeAndScaleOutAnimationController.forward();
          });
        }
      });
    });
    fadeAndScaleOutAnimationController.addListener(() {
      setState(() {
        if (fadeAndScaleOutAnimationController.isCompleted) {
          rotateAnimationController.forward();
          Future.delayed(Duration(milliseconds: delay), () {
            scaleInAnimationController.forward();
          });
        }
      });
    });
    rotateAnimationController.addListener(() {
      setState(() {});
    });
    scaleInAnimationController.addListener(() {
      setState(() {
        if (scaleInAnimation.isCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginScreen(),
            ),
          );
        }
      });
    });
  }
}
