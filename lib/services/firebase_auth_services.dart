import 'package:book_manager/commonWidget/commons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_manager/model/userModel.dart';
import 'package:flutter/material.dart';
//Auth işlemlerinin yapıldığı services

class AuthServices {
  CommonWidgets commonWidgets=CommonWidgets();

  Future signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print("oturum acmada  sorun cıktı");
      return false;
    }
  }

  Future register(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = FirebaseAuth.instance.currentUser;
      var deger=await userCreateFireStore(user);
if(deger){
  print("data firestore a kaydedildi");
}else{
  print("firestore a yazılırken hata cıktı");
}
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);

      if (e.code == 'weak-password') {
        commonWidgets.customToast("weak pasword ",Colors.redAccent[700]);

        print("bu şifre  güçsüz");
      } else if (e.code == 'email-already-in-use') {

        commonWidgets.customToast("email already in use",Colors.redAccent[700]);

      }



      return false;
    } catch (e) {
      print("error cıktı $e");
      return false;
    }
  }

  currentUser() {
    User gelenUser;

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        gelenUser = user;
      } else {
        print('User is  in!');
        gelenUser = user;
        print("gelen user elseten $gelenUser");
      }
    });
    print("returnden once gleen user $gelenUser");
    return gelenUser;
  }

  userCreateFireStore(User user) async {
    print("user create firestore");
    DocumentSnapshot _okunanUser = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    if (_okunanUser.data() == null) {
      Users users=Users(email: user.email,userID: user.uid);

      await    FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(users.toMap());

      return true;
    } else {
      print("oyle bir kullanıcı var o yüzden oluşturulamadı");
      return false;
    }
  }
}
