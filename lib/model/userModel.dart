import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//User model
class Users {
  Users user;
  final String userID;
  String email;
  String userName;
  String profilURL;
  DateTime createdAt;

  Users({@required this.userID,
    @required this.email,
    this.profilURL,this.userName,this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID ?? "",
      'email': email ?? "unknown",
      'userName': uret( ),
      'profilURL': profilURL?? "",
      'createdAt': createdAt ?? FieldValue.serverTimestamp( ),
    };
  }

  Users.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilURL = map['profilURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate( );

  @override
  String toString() {
    return 'User{userID: $userID, email: $email, userName: $userName, profilURL: $profilURL, createdAt: $createdAt,}';
  }

  String uret() {
      return email.substring( 0, email.indexOf( "@" ) ) + randomSayiUret( );

  }


  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(99);
    return rastgeleSayi.toString();
  }
}