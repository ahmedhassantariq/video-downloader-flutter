import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/controlsModel.dart';

class RedirectScreen extends StatefulWidget {
  final ControlsModel controls;
  const RedirectScreen({
    required this.controls,
    super.key});

  @override
  State<RedirectScreen> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  late Uri _url;

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _url = Uri.parse(widget.controls.redirectURL);
    _launchUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Our Services have been moved.",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            CupertinoButton(onPressed: (){_launchUrl();}, child: const Text("Redirect"))

          ],
        ),
      ),
    );
  }
}
