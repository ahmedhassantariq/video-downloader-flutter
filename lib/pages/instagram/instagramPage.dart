import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components/customTextfield.dart';

class InstagramPage extends StatefulWidget {
  const InstagramPage({super.key});

  @override
  State<InstagramPage> createState() => _InstagramPageState();
}

class _InstagramPageState extends State<InstagramPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);},icon: const Icon(Icons.arrow_back, color: Colors.black,),),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(FontAwesomeIcons.instagram, color: Colors.red, size: 30),
            SizedBox(width: 8.0,),
            Text("Instagram",style: TextStyle(color: Colors.red),)
          ],
        ),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextField(controller: TextEditingController(), hintText: "Paste the link here"),
            const SizedBox(height: 8.0),
            CupertinoButton(onPressed: (){

            } ,color: Colors.red,borderRadius: BorderRadius.circular(25),child: const Text("Start", style: TextStyle(color: Colors.white),),)
          ],
        ),
      ),
    );
  }
}
