
import 'package:download/pages/redirectScreen.dart';
import 'package:download/pages/twitch/twitchPage.dart';
import 'package:download/pages/xTwitter/xTwitterPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


import '../components/controlsModel.dart';
import 'instagram/instagramPage.dart';


class HomePage extends StatefulWidget {
  final ControlsModel controls;
  const HomePage({
    required this.controls,
    super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late BannerAd bannerAd;
  bool isLoaded = false;
  var adUnit = "ca-app-pub-3940256099942544/6300978111";

  initBannerAd(){
    bannerAd = BannerAd(
        size: AdSize.largeBanner,
        adUnitId: adUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad){
            setState(() {
              isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error){
            ad.dispose();
            print(error);
          },
        ),
        request: const AdRequest());
    bannerAd.load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      checkRedirect();
    });
    if(defaultTargetPlatform == TargetPlatform.android) {
      if(widget.controls.showHomePageAd) {
        initBannerAd();
      }
    }
  }

  checkRedirect(){
    if(widget.controls.isRedirect){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RedirectScreen(controls: widget.controls,)));
    }
  }


  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text("Video Downloader", style: TextStyle(color: Colors.black),)),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.youtube, color: Colors.red),
                      SizedBox(width: 8.0),
                      Text("Youtube", style: TextStyle(color: Colors.red))],), onPressed: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>const YoutubePage()));
              }),
              CupertinoButton(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.xTwitter, color: Colors.black),
                      SizedBox(width: 8.0),
                      Text(" (Twitter)", style: TextStyle(color: Colors.black))],), onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const XTwitterPage()));
              }),
              CupertinoButton(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.instagram, color: Colors.red),
                      SizedBox(width: 8.0),
                      Text("Instagram", style: TextStyle(color: Colors.red))],), onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const InstagramPage()));
              }),
              CupertinoButton(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.twitch, color: Colors.black),
                      SizedBox(width: 8.0),
                      Text("Twitch", style: TextStyle(color: Colors.purple))],), onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const TwitchPage()));
              }),
            ],),
          bottomNavigationBar: isLoaded ? SizedBox(
            height: bannerAd.size.height.toDouble(),
            width: bannerAd.size.width.toDouble(),
            child: AdWidget(ad: bannerAd,),
          ): SizedBox(),
    );
  }
}
