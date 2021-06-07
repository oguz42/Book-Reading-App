import 'package:book_manager/model/categoriModel.dart';
import 'package:book_manager/signinPage/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'bookPage.dart';
import 'favoriteBookPage.dart';
//Ana sayfa kategorilerin listelendiği bölüm
class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Categori categori = Categori();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        label: Text(
          "Wish List ❤",
          style: TextStyle(color: Colors.black87),
        ),
        onPressed: () {
          Navigator.of(context).push(PageTransition(
              child: MyFavoriteBook(),
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 180),
              reverseDuration: Duration(milliseconds: 200)));
        },
      ),
      appBar: AppBar(
        title: Text("Categories"),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                var cikisYapidliMi = await signOut();
                if (cikisYapidliMi) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => EmailveSifreLoginPage()));
                } else {}
              }),
          // IconButton(
          //     icon: Icon(Icons.add),
          //     onPressed: () async {
          //       List<Book> bookList = [];
          //
          //       QuerySnapshot query =
          //           await FirebaseFirestore.instance.collection("books").get();
          //       for (DocumentSnapshot document in query.docs) {
          //         Book perBook = Book.fromMap(document.data());
          //         bookList.add(perBook);
          //       }
          //
          //       for (Book book in bookList) {
          //         await FirebaseFirestore.instance
          //             .collection("books")
          //             .doc(book.bookID)
          //             .update({"favoriteUsers": []});
          //       }
          //     })
        ],
      ),
      body: ListView.builder(
          itemCount: categori.categoriList.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageTransition(
                        child: BookPage(
                          perCategori: categori.categoriList[index],
                        ),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 180),
                        reverseDuration: Duration(milliseconds: 200)));
                  },
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      colors: [
                        // Colors are easy thanks to Flutter's Colors class.
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.025),
                      ],
                    )),
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 3,
                      child: Column(
                        children: [
                          Image(
                            height: 140,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/" + categori.categoriListImage[index]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 15),
                    child: Text(
                      categori.categoriList[index],
                      style: TextStyle(
                          color: index == 0 ? Colors.black87 : Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  alignment: Alignment.topLeft,
                )
              ],
            );
          }),
    );
  }

  signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print("error cıktı $e");
      return false;
    }
  }
}
