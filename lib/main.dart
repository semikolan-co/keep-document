//list order by most recently added
//edit option of added document
//UI of adding as per figma
//after some time chages
//dark mode
//sort by option to user
//delete the image inside the add section

import 'dart:io';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/screens/datascreen.dart';
import 'package:passmanager/screens/edit_data.dart';
import 'package:passmanager/screens/introscreen.dart';
import 'package:passmanager/models/sharedpref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/adddata.dart';
import 'screens/homepage.dart';
import 'package:flutter/services.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await FacebookAudienceNetwork.init();
  // Map? sdkConfiguration = await AppLovinMAX.initialize(
  //     'uicNLf8N8Z6CupLurBDKWofB95QiOgHRT8348DDPwnbdVrV7_Mkarhqlvl59N0mpghTD6pI6zHsrMvGCEWqdGX');
  // AppLovinMAX.showMediationDebugger();
  final String? data = await SharedPref.read('data') ?? '';
  runApp(MyApp(data: data));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.data});
  final String? data;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool authenticated = false;
  final LocalAuthentication auth = LocalAuthentication();
  // bool _isAuthenticating = false;
  bool _canCheckBiometrics = true;
  String authorized = 'Not Authorized';

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (_) {
      canCheckBiometrics = false;
      // print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
    if (!_canCheckBiometrics) {
      FlutterNativeSplash.remove();
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        // _isAuthenticating = true;
        authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'You need to authenticate to use this app!',
          options: const AuthenticationOptions(
              // cancelButton: 'Cancel',
              // goToSettingsButton: 'Settings',
              // goToSettingsDescription: 'Open settings to set up fingerprints',
              // biometricHint: 'Place your finger or use password',
              // biometricNotRecognized: 'Fingerprint not recognized',
              // biometricSuccess: 'Fingerprint recognized',
              // signInTitle: 'Authenticate',
              stickyAuth: true,
              useErrorDialogs: true));
      setState(() {
        // _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      // print(e);
      setState(() {
        // _isAuthenticating = false;
        authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => authorized = authenticated ? 'Authorized' : 'Not Authorized');
    if (authorized == 'Authorized') {
      FlutterNativeSplash.remove();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    if (_canCheckBiometrics) _authenticate();
  }

  @override
  Widget build(BuildContext context) {
    List<DataItem> dataList = [];
    if (widget.data != null && widget.data != '') {
      dataList = DataItem.decode(widget.data.toString());
    }
    return MaterialApp(
      title: 'Keep Document',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (authorized == 'Not Authorized')
          ? exit(0)
          : dataList.isEmpty
              ? const IntroScreen()
              : const MyHomePage(title: 'Keep Document'),
      routes: {
        DataScreen.routeName: (ctx) => const DataScreen(),
        AddData.routeName: (ctx) => const AddData(),
        // EditData.routeName: (ctx) =>  EditData(),
        MyHomePage.routeName: (ctx) => const MyHomePage(title: 'Keep Document'),
        EditData.routeName: (ctx) => EditData(
              item: DataItem(
                  date: '',
                  title: '',
                  imgUrl: [],
                  id: '',
                  pdfPath: [],
                  description: ''),
            ),
      },
    );
  }
}
