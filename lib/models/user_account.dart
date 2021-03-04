import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';

class UserAccount extends ChangeNotifier {
  String displayName;
  String email;
  String profilePicUrl;
  ImageProvider profilePic;
  bool loading;

  Future<String> getDisplayName() async {
    var isLogged = await FacebookAuth.instance.isLogged;
    if (isLogged == null) {
      return FirebaseAuth.instance?.currentUser?.displayName ??
          'Ajolote anónimo';
    } else {
      var userData = await FacebookAuth.instance.getUserData();
      return userData['name'] ?? '<error al obtener tu nombre>';
    }
  }

  Future<String> getEmail() async {
    var isLogged = await FacebookAuth.instance.isLogged;
    if (isLogged == null) {
      return FirebaseAuth.instance.currentUser?.email ?? 'Correo no aplicable';
    } else {
      var userData = await FacebookAuth.instance.getUserData();
      return userData['email'];
    }
  }

  Future<String> getProfilePicUrl() async {
    var isLogged = await FacebookAuth.instance.isLogged;
    if (isLogged == null) {
      return FirebaseAuth.instance.currentUser?.photoURL;
    } else {
      var userData = await FacebookAuth.instance.getUserData();
      return userData['picture']['data']['url'];
    }
  }

  Future<void> cacheUserAccount() async {
    displayName = await getDisplayName();
    email = await getEmail();
    profilePicUrl = await getProfilePicUrl();
    if (profilePicUrl == null) {
      profilePic = AssetImage('img/icon-full-new.png');
    } else {
      profilePic = CachedNetworkImageProvider(profilePicUrl);
    }
  }

  Future<void> init() async {
    loading = true;
    notifyListeners();
    await cacheUserAccount();
    notifyListeners();
  }
}
