import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scanner/pages/splashScreen.dart';

void main() async {
  var devices = ["77D9C1BA6BDFF96411B2C82DA9D6EB13"];
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: devices);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Scanner',
      home: SplashScreen(),
    );
  }
}

