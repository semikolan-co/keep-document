import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:passmanager/screens/homepage.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<ContentConfig> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      const ContentConfig(
          title: "Your Security, Our Obligation",
          styleTitle: TextStyle(
              color: Color.fromRGBO(22, 68, 62, 1), fontSize: 25),
          styleDescription: TextStyle(
              color: Color.fromRGBO(22, 68, 62, 1), fontSize: 18),
          description:
              "Your Each and Every information is totally secure and stored only in your own device.",
          pathImage: "assets/intro1.png",
          backgroundColor: Colors.white),
    );
    slides.add(
      const ContentConfig(
          title: "Documents at a Single Click",
          description:
              "Easily store, share and organise all your documents at one place.",
          pathImage: "assets/intro2.png",
          styleTitle: TextStyle(
              color: Color.fromRGBO(22, 68, 62, 1), fontSize: 25),
          styleDescription: TextStyle(
              color: Color.fromRGBO(22, 68, 62, 1), fontSize: 18),
          backgroundColor: Colors.white),
    );
    // if(authorized=='Authorized') FlutterNativeSplash.remove();
  }

  void onDonePress() {
    // Do what you want
    Navigator.pushNamed(context, MyHomePage.routeName);
  }

  Widget renderNextBtn() {
    return const Icon(
      Icons.navigate_next,
      color: Color.fromRGBO(22, 68, 62, 1),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return const Icon(
      Icons.done,
      color: Color.fromRGBO(22, 68, 62, 1),
    );
  }

  Widget renderSkipBtn() {
    return const Icon(
      Icons.skip_next,
      color: Color.fromRGBO(22, 68, 62, 1),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0x33F3B4BA)),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0x33FFA8B0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      listContentConfig: slides,
      onDonePress: onDonePress,
      renderSkipBtn: renderSkipBtn(),
      skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: renderNextBtn(),
      nextButtonStyle: myButtonStyle(),

      // Done button
      renderDoneBtn: renderDoneBtn(),
      doneButtonStyle: myButtonStyle(),

      // Dot indicator
      // colorDot: const Color.fromRGBO(22, 68, 62, 0.2),
      // colorActiveDot: const Color.fromRGBO(22, 68, 62, 1),
      // sizeDot: 13.0,

      // // Show or hide status bar
      // // hideStatusBar: true,
      // hideStatusBar: false,
      // backgroundColorAllSlides: Colors.grey,

      // // Scrollbar
      // verticalScrollbarBehavior: scrollbarBehavior.SHOW_ALWAYS,
    );
  }
}
