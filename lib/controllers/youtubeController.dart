import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanner/components/controlsModel.dart';
import 'package:scanner/controllers/playerScreen.dart';
import 'package:scanner/model/data.dart';
import 'package:http/http.dart' as http;




class YoutubeController extends StatefulWidget {
  final String? videoID;
  final ControlsModel controls;
  const YoutubeController({
    required this.controls,
    required this.videoID,
    super.key});

  @override
  State<YoutubeController> createState() => _YoutubeControllerState();
}

class _YoutubeControllerState extends State<YoutubeController> {
  bool isLoading = false;
  double progress = 0.0;

  late BannerAd bannerAd;
  bool isLoaded = false;

  initBannerAd(){
    bannerAd = BannerAd(
        size: AdSize.largeBanner,
        adUnitId: widget.controls.listPageAdUnitID,
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

  Future<DataModel>getYoutubeInfo() async {
    final res = await http.get(Uri.parse("https://downloader-six.vercel.app/api/getVideoInfo/?url=${widget.videoID}"));
    return DataModel.fromJson(jsonDecode(res.body));
  }
  late Future<DataModel> futureStream;
  @override
  void initState() {
    futureStream = getYoutubeInfo();
    if(defaultTargetPlatform == TargetPlatform.android) {
      if(widget.controls.showListPageAd) {
        initBannerAd();
      }
    }
    super.initState();

  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void download(String url, String title, String format) async {
    print(url);
    print(title);
    String path = await _getFilePath(title);
    print(path);
    var status = await Permission.storage.request().then((value) async {
      if (value.isGranted) {
        try{
          FileDownloader.downloadFile(
              url: url,
              name: title,
              downloadDestination: DownloadDestinations.publicDownloads,
              onProgress: (process, value){
                isLoading = true;
                setState(() {
                  progress = value;
                });
              },
              onDownloadCompleted: (completed){
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Download Completed")));
              },
              onDownloadError: (e){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Download Error")));

              }
          );
        }catch(e){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Download Error")));
        }

        isLoading = false;
      } else if (value.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Permission Denied")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error has Occurred")));
      }
    });
  }

  Future<String> _getFilePath(String filename) async {
    Directory? dir;

    try {
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); // for iOS
      } else {
        dir = Directory('/storage/emulated/0/Download/');  // for android
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      print("Cannot get download folder path $err");
    }
    return "${dir?.path}$filename";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isLoaded ? SizedBox(
    height: bannerAd.size.height.toDouble(),
    width: bannerAd.size.width.toDouble(),
    child: AdWidget(ad: bannerAd,),
    ): const SizedBox(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);},icon: const Icon(Icons.arrow_back, color: Colors.black,),),
        backgroundColor: Colors.white,
        title: const Icon(FontAwesomeIcons.youtube, color: Colors.red, size: 30)),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            isLoading ? const LinearProgressIndicator() : const SizedBox(),
            const SizedBox(height: 8.0,),
            isLoading ?  Text(progress.toString(), style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),) : const SizedBox(),
            const SizedBox(height: 8.0,),
            FutureBuilder(
              future: futureStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.formats.length,
                        itemBuilder: (context,index){
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(TextSpan(text: snapshot.data!.formats[index]['ext'].toString())),
                                  CupertinoButton(child: const Icon(CupertinoIcons.play_arrow_solid, color: Colors.red,), onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyScreen(url: snapshot.data!.formats[index]['url'])));
                                  }),
                                  CupertinoButton(
                                      padding: const EdgeInsets.all(8.0), onPressed: () {
                                        download(
                                            snapshot.data!.formats[index]['url'],
                                            snapshot.data!.title,
                                            snapshot.data!.formats[index]['ext'].toString());
                                            },
                                      child: const Text("Download",style: TextStyle(color: Colors.red),)),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],);
                } else if(snapshot.hasError) {
                  return const Center(child: Icon(Icons.error));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
