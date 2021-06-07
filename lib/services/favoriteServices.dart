import 'package:book_manager/commonWidget/commons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//Favoriye alma işlemlerinin yapıldığı services

class Favorite {
  List favoriler = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CommonWidgets commonWidgets=CommonWidgets();

  Future<void> addFavorite(String id, String userID) async {
    favoriler.add(id);
    await _firestore.collection("books").doc(id).update(
      {
        'favoriteUsers': FieldValue.arrayUnion([userID]),
      },
    );
  }

  Future<void> removeFavorite(String id, String userID) async {
    favoriler.remove(id);
    await _firestore.collection("books").doc(id).update(
      {
        'favoriteUsers': FieldValue.arrayRemove([userID])
      },
    );

    commonWidgets.customToast("Favoriden Çıkarıldı", Colors.redAccent);

  }

  bool isFavorite(String id) {
    print("favoriye alınanlar" + favoriler.toString());

    return favoriler.contains(id);
  }
}