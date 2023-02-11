import 'dart:convert';
import 'package:flashchat/Classes/API.dart';
import 'package:flashchat/Classes/AwesomeDialogue.dart';
import 'package:flashchat/Widgets/AppLogo.dart';
import 'package:flashchat/Widgets/CustomButton.dart';
import 'package:flashchat/Widgets/CustomTextField.dart';
import 'package:flashchat/Widgets/ProgressHud.dart';
import 'package:flashchat/Widgets/SoftwareHouseLogo.dart';
import 'package:flashchat/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final double opacity = 0.5;

  bool showPassword = false;
  bool rememberMe = false;
  bool animationEnded = false;
  bool runRemove = false;
  bool loading = false;

  late final AnimationController scaleOutAnimationController;
  late final AnimationController rotateAnimationController;
  late final AnimationController loginContainerAnimationController;
  late final AnimationController propSoftAnimationController;
  late final AnimationController welcomeAnimationController;
  late final AnimationController descriptionAnimationController;
  late final AnimationController emailBoxDisplayAnimationController;
  late final AnimationController passwordBoxDisplayAnimationController;
  late final AnimationController emailBoxSizeAnimationController;
  late final AnimationController passwordBoxSizeAnimationController;
  late final AnimationController showPasswordEyeAnimationController;
  late final AnimationController rememberMeAnimationController;
  late final AnimationController loginAnimationController;
  late final AnimationController futureSoftAnimationController;

  late final Animation scaleOutAnimation;
  late final Animation rotateAnimation;
  late final Animation loginContainerAnimation;
  late final Animation propSoftAnimation;
  late final Animation welcomeAnimation;
  late final Animation descriptionAnimation;
  late final Animation emailBoxDisplayAnimation;
  late final Animation passwordBoxDisplayAnimation;
  late final Animation emailBoxSizeAnimation;
  late final Animation passwordBoxSizeAnimation;
  late final Animation showPasswordEyeAnimation;
  late final Animation rememberMeAnimation;
  late final Animation loginAnimation;
  late final Animation futureSoftAnimation;

  final int scaleOutAnimationDuration = 750;
  final int loginContainerAnimationDuration = 500;
  final int propSoftAnimationDuration = 500;
  final int welcomeAnimationDuration = 500;
  final int descriptionAnimationDuration = 500;
  final int emailBoxDisplayAnimationDuration = 500;
  final int passwordBoxDisplayAnimationDuration = 500;
  final int emailBoxSizeAnimationDuration = 500;
  final int passwordBoxSizeAnimationDuration = 500;
  final int showPasswordEyeAnimationDuration = 500;
  final int rememberMeAnimationDuration = 500;
  final int loginAnimationDuration = 500;
  final int futureSoftAnimationDuration = 500;

  @override
  void initState() {
    super.initState();
    initializeControllers();
    initializeAnimations();
    startForwardAnimations();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    return CustomModalProgress(
      inAsyncCall: loading,
      icon: const Icon(Icons.access_time_filled, color: Colors.white,),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: Stack(
              children: [
                Visibility(
                  visible: !animationEnded,
                  child: Positioned(
                    child: Container(
                      width: mediaSize.width,
                      height: mediaSize.height,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          opacity: 0.5,
                          image: AssetImage("images/background.jpg"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !animationEnded,
                  child: Positioned(
                    top: ((mediaSize.height - (mediaSize.height * 4)) / 2) +
                        (mediaSize.height * 4 / 2 * rotateAnimation.value),
                    left: ((mediaSize.width - (mediaSize.width * 4)) / 2) +
                        (mediaSize.width * 4 / 2 * rotateAnimation.value),
                    child: Transform.rotate(
                      angle: scaleOutAnimation.value,
                      child: Container(
                        height:
                            (mediaSize.height * 4 * scaleOutAnimation.value),
                        width: (mediaSize.width * 4 * scaleOutAnimation.value),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(scaleOutAnimation.value * 100)),
                          color: backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !animationEnded,
                  child: Positioned(
                    top: (mediaSize.width * 0.30) / 2 -
                        (((mediaSize.width * 0.30) / 2) *
                            propSoftAnimation.value),
                    left: (mediaSize.width * 0.30) / 2 -
                        (((mediaSize.width * 0.30) / 2) *
                            propSoftAnimation.value),
                    child: AppLogo(
                        mediaSize: mediaSize,
                        percentLogoSize: 0.30 * propSoftAnimation.value,
                        url: 'images/propSoft full logo.png',
                        backgroundColor: backgroundColor.withOpacity(opacity)),
                  ),
                ),
                Visibility(
                  visible: !animationEnded,
                  child: Positioned(
                    top: mediaSize.height * 0.168,
                    left: ((mediaSize.width * 0.606) -
                            (welcomeAnimation.value * 100))
                        .toDouble(),
                    child: Text(
                      'Welcome,',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color:
                              Colors.white.withOpacity(welcomeAnimation.value)),
                    ),
                  ),
                ),
                Visibility(
                  visible: !animationEnded,
                  child: Positioned(
                    top: mediaSize.height * 0.212,
                    left: ((mediaSize.width * 0.607) -
                            (descriptionAnimation.value * 100))
                        .toDouble(),
                    child: Text(
                      'Sign in to continue',
                      style: TextStyle(
                          color: Colors.white
                              .withOpacity(descriptionAnimation.value)),
                    ),
                  ),
                ),
                Visibility(
                  visible: !animationEnded,
                  child: Positioned(
                    top: mediaSize.height -
                        ((mediaSize.height * 0.64) *
                            loginContainerAnimation.value),
                    child: Container(
                      width: mediaSize.width * 0.985,
                      height: loginContainerAnimation.value *
                          mediaSize.height *
                          0.600,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              (25 * loginContainerAnimation.value).toDouble()),
                          topRight: Radius.circular(
                              (25 * loginContainerAnimation.value).toDouble()),
                        ),
                        color: backgroundColor.withOpacity(opacity),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !animationEnded,
                  child: Positioned(
                    top: (mediaSize.height * 0.530) -
                        ((mediaSize.height * 0.087) /
                                2 *
                                emailBoxDisplayAnimation.value)
                            .toDouble(),
                    left: (mediaSize.width * 0.0995) -
                        ((mediaSize.width * 0.180) /
                                2 *
                                emailBoxDisplayAnimation.value)
                            .toDouble(),
                    child: SizedBox(
                      height: ((mediaSize.height * 0.087) *
                              emailBoxDisplayAnimation.value)
                          .toDouble(),
                      width: ((mediaSize.width * 0.180) *
                                  emailBoxDisplayAnimation.value)
                              .toDouble() +
                          ((mediaSize.width - 52) *
                              0.93 *
                              emailBoxSizeAnimation.value),
                      child: CustomTextField(
                        labelText: null,
                        onChanged: (value) {},
                        widthPercentage: 0.93,
                        heightPercentage: 0.075,
                        prefixIcon: Icon(
                          Icons.email,
                          color: foregroundColor1,
                          size: ((mediaSize.width + mediaSize.height) *
                                  0.02 *
                                  emailBoxDisplayAnimation.value)
                              .toDouble(),
                        ),
                        readOnly: true,
                        textFieldColor: Colors.black,
                        secondaryColors: foregroundColor2
                            .withOpacity(emailBoxDisplayAnimation.value),
                        textColor: Colors.white,
                        suffixIcon: null,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        autoFocus: false,
                        controller: null,
                        focusNode: null,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !animationEnded,
                  child: Positioned(
                    top: (mediaSize.height * 0.6182) -
                        ((mediaSize.height * 0.0872) /
                                2 *
                                emailBoxDisplayAnimation.value)
                            .toDouble(),
                    left: (mediaSize.width * 0.0995) -
                        ((mediaSize.width * 0.180) /
                                2 *
                                passwordBoxDisplayAnimation.value)
                            .toDouble(),
                    child: SizedBox(
                      width: ((mediaSize.width * 0.180) *
                                  passwordBoxDisplayAnimation.value)
                              .toDouble() +
                          ((mediaSize.width - 52) *
                              0.93 *
                              passwordBoxSizeAnimation.value),
                      height: ((mediaSize.height * 0.0872) *
                              passwordBoxDisplayAnimation.value)
                          .toDouble(),
                      child: CustomTextField(
                        labelText: null,
                        onChanged: (value) {},
                        widthPercentage: 0.93,
                        heightPercentage: 0.075,
                        readOnly: true,
                        prefixIcon: Icon(Icons.lock,
                            color: foregroundColor1,
                            size: ((mediaSize.width + mediaSize.height) *
                                    0.02 *
                                    passwordBoxDisplayAnimation.value)
                                .toDouble()),
                        textFieldColor: Colors.black,
                        secondaryColors: foregroundColor2
                            .withOpacity(passwordBoxSizeAnimation.value),
                        textColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye_rounded,
                            color: foregroundColor1,
                            size: ((mediaSize.width + mediaSize.height) *
                                    0.02 *
                                    showPasswordEyeAnimation.value)
                                .toDouble(),
                          ),
                          onPressed: () {},
                        ),
                        hintText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        autoFocus: false,
                        controller: null,
                        focusNode: null,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !animationEnded,
                  child: Positioned(
                    top: mediaSize.height * 0.6617,
                    left: (mediaSize.width * 0.923 -
                            (rememberMeAnimation.value *
                                mediaSize.width *
                                0.4267))
                        .toDouble(),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                            side: BorderSide(
                                color: Colors.white
                                    .withOpacity(rememberMeAnimation.value)),
                          ),
                          Text(
                            'Remember me?',
                            style: TextStyle(
                                color: Colors.white
                                    .withOpacity(rememberMeAnimation.value)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !animationEnded,
                  child: Positioned(
                    top: (mediaSize.height * 0.748) -
                        (((0.05 * mediaSize.height) / 2) *
                            loginAnimation.value),
                    left: (mediaSize.width * 0.5) -
                        (((0.35 * mediaSize.width) / 2) * loginAnimation.value),
                    child: CustomButton(
                      mediaSize: mediaSize,
                      onPressed: () {},
                      buttonChild: const Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      percentHeight: 0.05 * loginAnimation.value,
                      percentWidth: 0.35 * loginAnimation.value,
                      borderRadius: BorderRadius.all(Radius.circular(
                          (0.05 * loginAnimation.value) +
                              (0.35 * loginAnimation.value) * 30)),
                      buttonColor: Colors.green,
                      margin: null,
                      padding: null,
                    ),
                  ),
                ),
                Visibility(
                  visible: !animationEnded,
                  child: Positioned(
                    top: mediaSize.height * 0.92,
                    right: (-(mediaSize.width * 0.2470) +
                            futureSoftAnimation.value * 95)
                        .toDouble(),
                    child: SoftwareHouseLogo(
                      mediaSize: mediaSize,
                      percentHeight: 0.04,
                      percentWidth: 0.25,
                      url: 'images/futureSoft.png',
                    ),
                  ),
                ),
                Visibility(
                  visible: animationEnded,
                  child: Container(
                    width: mediaSize.width,
                    height: mediaSize.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.5,
                        image: AssetImage("images/background.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: mediaSize.height * 0.96,
                        width: mediaSize.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppLogo(
                                    mediaSize: mediaSize,
                                    percentLogoSize: 0.30,
                                    url: 'images/propSoft full logo.png',
                                    backgroundColor:
                                        backgroundColor.withOpacity(opacity)),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: (mediaSize.height * 0.40) / 2 -
                                          (mediaSize.width * 0.30) / 2,
                                      left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Welcome,',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Sign in to continue',
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: mediaSize.width,
                              height: mediaSize.height * 0.60,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25)),
                                color: backgroundColor.withOpacity(opacity),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomTextField(
                                          labelText: null,
                                          onChanged: (value) {},
                                          widthPercentage: 0.93,
                                          heightPercentage: 0.075,
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color: foregroundColor1,
                                          ),
                                          readOnly: false,
                                          textFieldColor: Colors.black,
                                          secondaryColors: foregroundColor2,
                                          textColor: Colors.white,
                                          suffixIcon: null,
                                          hintText: 'Email',
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          obscureText: false,
                                          autoFocus: false,
                                          controller: emailController,
                                          focusNode: emailFocus,
                                        ),
                                        CustomTextField(
                                          labelText: null,
                                          onChanged: (value) {},
                                          widthPercentage: 0.93,
                                          heightPercentage: 0.075,
                                          readOnly: false,
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: foregroundColor1,
                                          ),
                                          textFieldColor: Colors.black,
                                          secondaryColors: foregroundColor2,
                                          textColor: Colors.white,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              Icons.remove_red_eye_rounded,
                                              color: showPassword
                                                  ? Colors.blue
                                                  : foregroundColor1,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                showPassword = !showPassword;
                                              });
                                            },
                                          ),
                                          hintText: 'Password',
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: !showPassword,
                                          autoFocus: false,
                                          controller: passwordController,
                                          focusNode: passwordFocus,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Checkbox(
                                                value: rememberMe,
                                                onChanged: (value) {
                                                  setState(() {
                                                    rememberMe = value!;
                                                    emailFocus.unfocus();
                                                    passwordFocus.unfocus();
                                                  });
                                                },
                                                side: const BorderSide(
                                                    color: Colors.white),
                                                checkColor: Colors.white,
                                              ),
                                              const Text(
                                                'Remember me?',
                                              ),
                                            ],
                                          ),
                                        ),
                                        CustomButton(
                                          mediaSize: mediaSize,
                                          onPressed: () async {
                                            emailFocus.unfocus();
                                            passwordFocus.unfocus();
                                            setState(() {
                                              loading = true;
                                            });
                                            try {
                                              final response = await API.getLoginResponse(username: emailController.text, password: passwordController.text);
                                              processLogin(response);
                                            } catch (socketException) {
                                              setState(() {
                                                loading = false;
                                              });
                                              AwesomeDialogueBox
                                                  .showDialogueWithoutCancel(
                                                      title:
                                                          'Server Connection Failed!',
                                                      dialogType:
                                                          DialogType.ERROR,
                                                      context: context,
                                                      btnColor: Colors.red,
                                                      btnText: 'OK',
                                                      btnIcon: Icons.cancel,
                                                      duration:
                                                          errorMsgDuration);
                                            }
                                          },
                                          buttonChild: const Text(
                                            'Login',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          percentHeight: 0.05,
                                          percentWidth: 0.35,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular((0.05 *
                                                      loginAnimation.value) +
                                                  (0.35 *
                                                          loginAnimation
                                                              .value) *
                                                      30)),
                                          buttonColor: Colors.green,
                                          margin: null,
                                          padding: null,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SoftwareHouseLogo(
                                          mediaSize: mediaSize,
                                          percentHeight: 0.04,
                                          percentWidth: 0.25,
                                          url: 'images/futureSoft.png',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void processLogin(Response response) async {
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      if (rememberMe) {
        final file = await localFile(credentialsFileName);
        file.writeAsStringSync(jsonEncode({
          'username': emailController.text,
          'password': passwordController.text,
        }));
      }
      startReverseAnimations(response);
    } else if (jsonDecode(response.body)['title']
        .toString()
        .contains('Unauthorized')) {
      AwesomeDialogueBox.showDialogueWithoutCancel(
          title: 'User not found',
          dialogType: DialogType.ERROR,
          context: context,
          btnColor: Colors.red,
          btnText: 'OK',
          btnIcon: Icons.cancel,
          duration: errorMsgDuration);
    } else if (jsonDecode(response.body)['title']
        .toString()
        .contains('One or more validation errors occurred.')) {
      AwesomeDialogueBox.showDialogueWithoutCancel(
          title: 'Incorrect Username or password',
          dialogType: DialogType.ERROR,
          context: context,
          btnColor: Colors.red,
          btnText: 'OK',
          btnIcon: Icons.cancel,
          duration: errorMsgDuration);
    }
  }

  void initializeAnimations() {
    scaleOutAnimation = CurvedAnimation(
        parent: scaleOutAnimationController, curve: Curves.linear);
    rotateAnimation = CurvedAnimation(
        parent: rotateAnimationController, curve: Curves.linear);
    loginContainerAnimation = CurvedAnimation(
        parent: loginContainerAnimationController, curve: Curves.easeInOutCirc);
    propSoftAnimation = CurvedAnimation(
        parent: propSoftAnimationController, curve: Curves.easeInOutCirc);
    welcomeAnimation = CurvedAnimation(
        parent: welcomeAnimationController, curve: Curves.decelerate);
    descriptionAnimation = CurvedAnimation(
        parent: descriptionAnimationController, curve: Curves.decelerate);
    emailBoxDisplayAnimation = CurvedAnimation(
        parent: emailBoxDisplayAnimationController, curve: Curves.decelerate);
    passwordBoxDisplayAnimation = CurvedAnimation(
        parent: passwordBoxDisplayAnimationController,
        curve: Curves.decelerate);
    emailBoxSizeAnimation = CurvedAnimation(
        parent: emailBoxSizeAnimationController, curve: Curves.decelerate);
    passwordBoxSizeAnimation = CurvedAnimation(
        parent: passwordBoxSizeAnimationController, curve: Curves.decelerate);
    showPasswordEyeAnimation = CurvedAnimation(
        parent: showPasswordEyeAnimationController, curve: Curves.decelerate);
    rememberMeAnimation = CurvedAnimation(
        parent: rememberMeAnimationController, curve: Curves.decelerate);
    loginAnimation = CurvedAnimation(
        parent: loginAnimationController, curve: Curves.elasticOut);
    futureSoftAnimation = CurvedAnimation(
        parent: futureSoftAnimationController, curve: Curves.elasticInOut);
  }

  void initializeControllers() {
    scaleOutAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: scaleOutAnimationDuration));
    rotateAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: scaleOutAnimationDuration));
    loginContainerAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: loginContainerAnimationDuration));
    propSoftAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: propSoftAnimationDuration));
    welcomeAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: welcomeAnimationDuration));
    descriptionAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: descriptionAnimationDuration));
    emailBoxDisplayAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: emailBoxDisplayAnimationDuration));
    passwordBoxDisplayAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: emailBoxDisplayAnimationDuration));
    emailBoxSizeAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: emailBoxSizeAnimationDuration));
    passwordBoxSizeAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: passwordBoxSizeAnimationDuration));
    showPasswordEyeAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: showPasswordEyeAnimationDuration));
    rememberMeAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: rememberMeAnimationDuration));
    loginAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: loginAnimationDuration));
    futureSoftAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: futureSoftAnimationDuration));
  }

  void startForwardAnimations() {
    scaleOutAnimationController.reverse(from: 1);
    rotateAnimationController.forward();
    rotateAnimationController.addListener(() {
      setState(() {});
    });
    scaleOutAnimationController.addListener(() {
      setState(() {
        if (!scaleOutAnimationController.isAnimating && !runRemove) {
          loginContainerAnimationController.forward();
          Future.delayed(const Duration(milliseconds: 100), () {
            propSoftAnimationController.forward();
          });
        }
      });
    });
    loginContainerAnimationController.addListener(() {
      setState(() {
        if (loginContainerAnimationController.isCompleted && !runRemove) {
          emailBoxDisplayAnimationController.forward();
          Future.delayed(const Duration(milliseconds: 100), () {
            passwordBoxDisplayAnimationController.forward();
          });
        }
      });
    });
    propSoftAnimationController.addListener(() {
      setState(() {
        if (propSoftAnimationController.isCompleted && !runRemove) {
          welcomeAnimationController.forward();
          Future.delayed(const Duration(milliseconds: 100), () {
            descriptionAnimationController.forward();
          });
        }
      });
    });
    welcomeAnimationController.addListener(() {
      setState(() {});
    });
    descriptionAnimationController.addListener(() {
      setState(() {});
    });
    emailBoxDisplayAnimationController.addListener(() {
      setState(() {
        if (emailBoxDisplayAnimationController.isCompleted && !runRemove) {
          emailBoxSizeAnimationController.forward();
        }
      });
    });
    passwordBoxDisplayAnimationController.addListener(() {
      setState(() {
        if (passwordBoxDisplayAnimationController.isCompleted && !runRemove) {
          passwordBoxSizeAnimationController.forward();
          rememberMeAnimationController.forward();
          loginAnimationController.forward();
          futureSoftAnimationController.forward();
        }
      });
    });
    emailBoxSizeAnimationController.addListener(() {
      setState(() {});
    });
    passwordBoxSizeAnimationController.addListener(() {
      setState(() {
        if (passwordBoxSizeAnimationController.isCompleted && !runRemove) {
          showPasswordEyeAnimationController.forward();
        }
      });
    });
    showPasswordEyeAnimationController.addListener(() {
      setState(() {});
    });
    rememberMeAnimationController.addListener(() {
      setState(() {});
    });
    loginAnimationController.addListener(() {
      setState(() {});
    });
    futureSoftAnimationController.addListener(() {
      setState(() {
        if (futureSoftAnimationController.isCompleted && !runRemove) {
          // futureSoftAnimationController.clearListeners();
          animationEnded = true;
          runRemove = true;
        }
      });
    });
  }

  void startReverseAnimations(Response response) {
    loginContainerAnimationController.duration =
        const Duration(milliseconds: 250);
    scaleOutAnimationController.duration = const Duration(milliseconds: 500);
    rotateAnimationController.duration = const Duration(milliseconds: 500);
    propSoftAnimationController.duration = const Duration(milliseconds: 250);
    welcomeAnimationController.duration = const Duration(milliseconds: 250);
    descriptionAnimationController.duration = const Duration(milliseconds: 250);
    emailBoxSizeAnimationController.duration =
        const Duration(milliseconds: 250);
    emailBoxDisplayAnimationController.duration =
        const Duration(milliseconds: 250);
    passwordBoxDisplayAnimationController.duration =
        const Duration(milliseconds: 250);
    passwordBoxSizeAnimationController.duration =
        const Duration(milliseconds: 250);
    showPasswordEyeAnimationController.duration =
        const Duration(milliseconds: 250);
    rememberMeAnimationController.duration = const Duration(milliseconds: 250);
    loginAnimationController.duration = const Duration(milliseconds: 250);
    futureSoftAnimationController.duration = const Duration(milliseconds: 250);
    futureSoftAnimationController.addListener(() {
      setState(() {});
    });
    rememberMeAnimationController.addListener(() {
      setState(() {});
    });
    showPasswordEyeAnimationController.addListener(() {
      setState(() {
        if (showPasswordEyeAnimationController.value == 0.0) {
          passwordBoxSizeAnimationController.reverse(from: 1);
          Future.delayed(const Duration(milliseconds: 25), () {
            emailBoxSizeAnimationController.reverse(from: 1);
          });
        }
      });
    });
    emailBoxSizeAnimationController.addListener(() {
      setState(() {});
    });
    passwordBoxSizeAnimationController.addListener(() {
      setState(() {
        if (passwordBoxSizeAnimationController.value == 0.0) {
          passwordBoxDisplayAnimationController.reverse(from: 1);
          emailBoxDisplayAnimationController.reverse(from: 1);
        }
      });
    });
    passwordBoxDisplayAnimationController.addListener(() {
      setState(() {});
    });
    emailBoxDisplayAnimationController.addListener(() {
      setState(() {
        if (emailBoxDisplayAnimationController.value == 0.0) {
          descriptionAnimationController.reverse(from: 1);
          Future.delayed(const Duration(milliseconds: 25), () {
            welcomeAnimationController.reverse(from: 1);
          });
        }
      });
    });
    descriptionAnimationController.addListener(() {
      setState(() {});
    });
    welcomeAnimationController.addListener(() {
      setState(() {
        if (welcomeAnimationController.value == 0.0) {
          propSoftAnimationController.reverse(from: 1);
          Future.delayed(const Duration(milliseconds: 25), () {
            loginContainerAnimationController.reverse(from: 1);
          });
        }
      });
    });
    propSoftAnimationController.addListener(() {
      setState(() {});
    });
    rotateAnimationController.addListener(() {
      setState(() {});
    });
    scaleOutAnimationController.addListener(() {
      setState(() {
        if (scaleOutAnimationController.value == 1.0) {
          Navigator.pushReplacementNamed(
            context,
            'MyLeads screen',
            arguments: json.decode(response.body)['token'],
          );
        }
      });
    });
    loginContainerAnimationController.addListener(() {
      setState(() {
        if (loginContainerAnimationController.value == 0.0) {
          scaleOutAnimationController.forward();
          rotateAnimationController.reverse(from: 1);
        }
      });
    });
    loginAnimationController.addListener(() {
      setState(() {});
    });

    futureSoftAnimationController.reverse(from: 1);
    rememberMeAnimationController.reverse(from: 1);
    loginAnimationController.reverse(from: 1);
    showPasswordEyeAnimationController.reverse(from: 1);
    setState(() {
      animationEnded = false;
      runRemove = true;
    });
  }

  void disposeControllers() {
    loginContainerAnimationController.dispose();
    scaleOutAnimationController.dispose();
    rotateAnimationController.dispose();
    propSoftAnimationController.dispose();
    welcomeAnimationController.dispose();
    descriptionAnimationController.dispose();
    emailBoxSizeAnimationController.dispose();
    emailBoxDisplayAnimationController.dispose();
    passwordBoxDisplayAnimationController.dispose();
    passwordBoxSizeAnimationController.dispose();
    showPasswordEyeAnimationController.dispose();
    rememberMeAnimationController.dispose();
    loginAnimationController.dispose();
    futureSoftAnimationController.dispose();
  }
}
