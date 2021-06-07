import 'package:book_manager/pages/homePage.dart';
import 'package:book_manager/services/firebase_auth_services.dart';
import 'package:book_manager/signinPage/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//Oturum açma durumuna göre sayfa yönlendirme
class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  AuthServices authServices = AuthServices();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Hata Oluştu ${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    User user = snapshot.data;

                    if (user == null) {
                      return EmailveSifreLoginPage();
                    } else {
                      return HomePage();
                    }
                  }
                  return CircularProgressIndicator();
                });
          }

          return CircularProgressIndicator();
        });
  }
}
