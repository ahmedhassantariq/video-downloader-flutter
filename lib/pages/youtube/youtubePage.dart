import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scanner/components/controlsModel.dart';
import '../../components/customTextfield.dart';
import '../../controllers/youtubeController.dart';
import '../redirectScreen.dart';
class YoutubePage extends StatefulWidget {
 final ControlsModel controls;
  const YoutubePage({
    super.key,
    required this.controls,
  });

  @override
  State<YoutubePage> createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  final TextEditingController _searchFieldEditor = TextEditingController();


  searchUrl(){
    if(_searchFieldEditor.text.isNotEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> YoutubeController(videoID: _searchFieldEditor.text, controls: widget.controls,)));
    }
  }


  late BannerAd bannerAd;
  bool isLoaded = false;
  initBannerAd(){
    bannerAd = BannerAd(
        size: AdSize.largeBanner,
        adUnitId: widget.controls.homePageAdUnitID,
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
        title: const Row(
        children: [
          Icon(FontAwesomeIcons.youtube, color: Colors.red, size: 30),
          SizedBox(width: 8.0,),
          Text("Video Downloader",style: TextStyle(color: Colors.red),)
        ],
      ),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(controller: _searchFieldEditor, hintText: "Paste the link here"),
            const SizedBox(height: 8.0),
            CupertinoButton(onPressed: (){
              searchUrl();
            }, color: Colors.red,borderRadius: BorderRadius.circular(25),child: const Text("Start", style: TextStyle(color: Colors.white),),),
            ],
        ),
      ),
      bottomNavigationBar: isLoaded ? SizedBox(
        height: bannerAd.size.height.toDouble(),
        width: bannerAd.size.width.toDouble(),
        child: AdWidget(ad: bannerAd,),
      ): SizedBox(),
    );
  }
}
