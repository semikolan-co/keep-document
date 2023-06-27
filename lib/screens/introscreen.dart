import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intro_slider/intro_slider.dart';
// import 'package:intro_slider/scrollbar_behavior_enum.dart';
// import 'package:intro_slider/slide_object.dart';
import 'package:passmanager/main.dart';
import 'package:passmanager/screens/homepage.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
          title: "Your Security, Our Obligation",
          styleTitle: const TextStyle(
              color: Color.fromRGBO(22, 68, 62, 1), fontSize: 25),
          styleDescription: const TextStyle(
              color: Color.fromRGBO(22, 68, 62, 1), fontSize: 18),
          description:
              "Your Each and Every information is totally secure and stored only in your own device.",
          pathImage: "assets/intro1.png",
          backgroundColor: Colors.white),
    );
    slides.add(
      Slide(
          title: "Documents at a Single Click",
          description:
              "Easily store, share and organise all your documents at one place.",
          pathImage: "assets/intro2.png",
          styleTitle: const TextStyle(
              color: Color.fromRGBO(22, 68, 62, 1), fontSize: 25),
          styleDescription: const TextStyle(
              color: Color.fromRGBO(22, 68, 62, 1), fontSize: 18),
          backgroundColor: Colors.white),
    );
    if (authorized == 'Authorized') FlutterNativeSplash.remove();
  }

  void onDonePress() {
    // Do what you want
    Navigator.pushNamed(context, MyHomePage.routeName);
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color.fromRGBO(22, 68, 62, 1),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color.fromRGBO(22, 68, 62, 1),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color.fromRGBO(22, 68, 62, 1),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(Color(0x33F3B4BA)),
      overlayColor: MaterialStateProperty.all<Color>(Color(0x33FFA8B0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      renderSkipBtn: this.renderSkipBtn(),
      skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: this.renderNextBtn(),
      nextButtonStyle: myButtonStyle(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      doneButtonStyle: myButtonStyle(),

      // Dot indicator
      // colorDot: Color.fromRGBO(22, 68, 62, 0.2),
      // colorActiveDot: Color.fromRGBO(22, 68, 62, 1),
      // sizeDot: 13.0,

      // Show or hide status bar
      // hideStatusBar: true,
      // hideStatusBar: false,
      // backgroundColorAllSlides: Colors.grey,

      // Scrollbar
      // verticalScrollbarBehavior: scrollbarBehavior.SHOW_ALWAYS,
    );
  }
}
