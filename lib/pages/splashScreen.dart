import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scanner/pages/homePage.dart';
import 'package:scanner/pages/youtube/youtubePage.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});



  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;
  Future<void> waitForSplash() async {

    await Future.delayed(const Duration(seconds: 1));
    if(!isLoading){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const YoutubePage() ));
    }
  }


  @override
  void initState() {
    super.initState();
    waitForSplash();
  }


  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.download, size: 100, color: Colors.red,),
          SizedBox(height: 16),
          CircularProgressIndicator(
            backgroundColor: Colors.white,
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
            color: Colors.red,
          )
        ],
      ),
    );
  }
}
