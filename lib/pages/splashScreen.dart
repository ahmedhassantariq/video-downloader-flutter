import 'package:flutter/material.dart';
import 'package:scanner/pages/youtube/youtubePage.dart';

import '../components/controlsModel.dart';
import '../controllers/firebase_services.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});



  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  late Future<ControlsModel> controls;



  @override
  void initState() {
    super.initState();
    controls = FirebaseServices().getControls();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: controls,
            builder: (builder, snapshot){
              if(snapshot.hasError){
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Video Downloader", style: TextStyle(color: Colors.red, fontSize: 36, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8.0),
                    Text("An Error has Occurred!", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                );
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Video Downloader", style: TextStyle(color: Colors.red, fontSize: 36, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8.0),
                    CircularProgressIndicator(color: Colors.red, strokeWidth: 7.0, strokeCap: StrokeCap.round,)
                  ],
                );
              }
              return !snapshot.data!.isReview ? YoutubePage(controls: snapshot.requireData,) : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Video Downloader", style: TextStyle(color: Colors.red, fontSize: 36, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8.0),
                  CircularProgressIndicator(color: Colors.red, strokeWidth: 7.0, strokeCap: StrokeCap.round,)
                ],
              );
            }),
      ),
    );
  }
}
