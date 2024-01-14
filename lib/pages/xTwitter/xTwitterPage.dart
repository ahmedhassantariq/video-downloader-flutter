import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components/customTextfield.dart';
class XTwitterPage extends StatefulWidget {
  const XTwitterPage({super.key});

  @override
  State<XTwitterPage> createState() => _XTwitterPageState();
}

class _XTwitterPageState extends State<XTwitterPage> {
  final TextEditingController _searchFieldEditor = TextEditingController();

  filterUrl() {
    RegExp regExp = RegExp(r'^.*twitter\.com\/.*\/status\/(\d+).*');
    RegExpMatch? match = regExp.firstMatch(_searchFieldEditor.text);
    print(match);
    if (match != null && match.groupCount > 0) {
      print(match.group(1));
      searchUrl(match.group(1));
    } else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Url")));
    }
  }

  searchUrl(String? videoID){
    if(_searchFieldEditor.text.isNotEmpty){
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> YoutubeController(videoID: videoID)));
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);},icon: const Icon(Icons.arrow_back, color: Colors.black,),),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(FontAwesomeIcons.xTwitter, color: Colors.black, size: 30),
            SizedBox(width: 8.0,),
            Text("Twitter",style: TextStyle(color: Colors.black),)
          ],
        ),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextField(controller: TextEditingController(), hintText: "Paste the link here"),
            const SizedBox(height: 8.0),
            CupertinoButton(onPressed: (){
              filterUrl();
            } ,color: Colors.grey.shade100,borderRadius: BorderRadius.circular(25),child: const Text("Start", style: TextStyle(color: Colors.black),),)
          ],
        ),
      ),
    );
  }
}
