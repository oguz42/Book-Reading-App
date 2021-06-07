import 'package:book_manager/commonWidget/commons.dart';
import 'file:///D:/projeler/all_flutter_project/book_manager/lib/services/favoriteServices.dart';
import 'package:book_manager/model/bookModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'bookDetailPage.dart';
//kategorilerine göre kitapların gösterildiği widget
class BookPage extends StatefulWidget {
  String perCategori;

  BookPage({this.perCategori});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  User user;
  CommonWidgets commonWidgets = CommonWidgets();
  Favorite favorite = Favorite();
  bool isFavorite = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.perCategori),
//await FirebaseFirestore.instance.collection("books").doc(perID).set({
//
//   });
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder<List<Book>>(
          future: forCategoryBook(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<Book> listbook = [];
              listbook = snapshot.data;

              return ListView.builder(
                  itemCount: listbook.length,
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
                                reverseDuration: Duration(milliseconds: 200)));
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 550,
                                decoration: BoxDecoration(
                                    // gradient: LinearGradient(
                                    //   // Where the linear gradient begins and ends
                                    //   begin: Alignment.bottomCenter,
                                    //   end: Alignment.topCenter,
                                    //   // Add one stop for each color. Stops should increase from 0 to 1
                                    //   colors: [
                                    //     // Colors are easy thanks to Flutter's Colors class.
                                    //     Colors.brown.withOpacity(0.8),
                                    //     Colors.brown.withOpacity(0.7),
                                    //     Colors.brown.withOpacity(0.6),
                                    //     Colors.brown.withOpacity(0.6),
                                    //     Colors.brown.withOpacity(0.4),
                                    //     Colors.brown.withOpacity(0.1),
                                    //     Colors.brown.withOpacity(0.05),
                                    //     Colors.brown.withOpacity(0.025),
                                    //   ],
                                    // )
                                    ),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
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
                                       SizedBox(height: 5,),
                                       ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20)),
                                              child: Image(
                                                  image: NetworkImage(
                                                      perBook.bookImage),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                  height: 505),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),

                      ],
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<List<Book>> forCategoryBook() async {
    List<Book> bookList = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("books")
        .where("bookCategory", isEqualTo: widget.perCategori)
        .get();
    for (DocumentSnapshot document in querySnapshot.docs) {
      Book perBook = Book.fromMap(document.data());
      bookList.add(perBook);
    }

    return bookList;
  }


}
