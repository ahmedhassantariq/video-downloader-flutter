import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../components/customTextfield.dart';
import '../../controllers/youtubeController.dart';
class YoutubePage extends StatefulWidget {
  const YoutubePage({super.key});

  @override
  State<YoutubePage> createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  final TextEditingController _searchFieldEditor = TextEditingController();


  searchUrl(){
    if(_searchFieldEditor.text.isNotEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> YoutubeController(videoID: _searchFieldEditor.text)));
    }
  }


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
    initBannerAd();
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
