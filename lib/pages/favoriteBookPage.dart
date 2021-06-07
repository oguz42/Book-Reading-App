import 'package:book_manager/model/bookModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'bookDetailPage.dart';

class MyFavoriteBook extends StatefulWidget {
  @override
  _MyFavoriteBookState createState() => _MyFavoriteBookState();
}


//Favori kitapların gösteridiği widget

class _MyFavoriteBookState extends State<MyFavoriteBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
          body: FutureBuilder<List<Book>>(
            future: forFavoriteBook(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Book> listbook = [];
                listbook = snapshot.data;
                if (listbook.length == 0) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Text(
                        "There are no favorite books...",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: listbook.length,
                      shrinkWrap: false,
                      itemBuilder: (BuildContext context, int index) {
                        Book perBook;
                        perBook = listbook[index];
                        return Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    child: BookDetailPage(book: perBook),
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 180),
                                    reverseDuration:
                                        Duration(milliseconds: 200)));
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(

                                      height: 450,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          // Where the linear gradient begins and ends
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          // Add one stop for each color. Stops should increase from 0 to 1
                                          colors: [
                                            // Colors are easy thanks to Flutter's Colors class.
                                            Colors.redAccent.withOpacity(0.8),
                                            Colors.redAccent.withOpacity(0.7),
                                            Colors.redAccent.withOpacity(0.6),
                                            Colors.redAccent.withOpacity(0.6),
                                            Colors.redAccent.withOpacity(0.4),
                                            Colors.redAccent.withOpacity(0.1),
                                            Colors.redAccent.withOpacity(0.05),
                                            Colors.redAccent.withOpacity(0.025),
                                          ],
                                        )
                                      ),
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Align(
                                              child: Text(
                                                "  " + perBook.bookName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 19),
                                                textAlign: TextAlign.left,
                                              ),
                                              alignment: Alignment.topLeft,
                                            ),
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20)),
                                              child: Image(
                                                  image: NetworkImage(
                                                      perBook.bookImage),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                  height: 405),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 380, right: 25),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent[700],
                                  size: 35,
                                ),
                              ),
                              alignment: Alignment.bottomRight,
                            )
                          ],
                        );
                      });
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          physics: AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                title: Text(
                  "Wish List",
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
                floating: true,
                //  pinned: true,
                primary: true,
                expandedHeight: MediaQuery.of(context).size.height / 3.4,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    child: Image(
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1591120626624-29f57a2645be?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1952&q=80"),
                    ),
                  ),
                ),
              )
            ];
          },
        ),
      ),
    );
  }

  currentUser() {
    User user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<List<Book>> forFavoriteBook() async {
    List<Book> bookList = [];
    User gelenUser = currentUser();
    print(gelenUser.uid);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("books")
        .where("favoriteUsers", arrayContains: gelenUser.uid)
        .get();
    for (DocumentSnapshot document in querySnapshot.docs) {
      Book perBook = Book.fromMap(document.data());
      bookList.add(perBook);
    }

    return bookList;
  }
}
