import 'package:cloud_firestore/cloud_firestore.dart';

class ControlsModel {
  final bool isReview;
  final bool showHomePageAd;
  final bool showListPageAd;
  final String homePageAdUnitID;
  final String listPageAdUnitID;
  final bool isRedirect;
  final String redirectURL;

  const ControlsModel({
    required this.isReview,
    required this.showHomePageAd,
    required this.showListPageAd,
    required this.homePageAdUnitID,
    required this.listPageAdUnitID,
    required this.isRedirect,
    required this.redirectURL,

  });

  factory ControlsModel.fromMap(DocumentSnapshot<Map<String, dynamic>> documentSnapshot){
    return(
        ControlsModel(
          isReview: documentSnapshot.get('isReview'),
          homePageAdUnitID: documentSnapshot.get('homePageAdUnit-ID'),
          listPageAdUnitID: documentSnapshot.get('listPageAdUnit-ID'),
          showListPageAd: documentSnapshot.get('showListPageAd'),
          showHomePageAd: documentSnapshot.get('showHomePageAd'),
          isRedirect: documentSnapshot.get('isRedirect'),
          redirectURL: documentSnapshot.get('redirectURL'),

        ));
  }
}