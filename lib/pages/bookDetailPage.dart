import 'dart:async';
import 'dart:io';

import 'package:book_manager/commonWidget/commons.dart';
import 'file:///D:/projeler/all_flutter_project/book_manager/lib/services/favoriteServices.dart';
import 'package:book_manager/model/bookModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
//Kitap Pdf dosyasının gösterildiği widget

class BookDetailPage extends StatefulWidget {
  Book book;

  BookDetailPage({this.book});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  String remotePDFpath = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      final url = widget.book.bookFile;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return remotePDFpath.length > 0 && remotePDFpath != null
        ? PDFScreen(
            path: remotePDFpath,
            book: widget.book,
          )
        : Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  "assets/book_background.jpeg",
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        "Book Loading Please Wait...",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      )),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Container(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

class PDFScreen extends StatefulWidget {
  Book book;
  final String path;

  PDFScreen({Key key, this.path, this.book}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  User user;
  CommonWidgets commonWidgets = CommonWidgets();
  Favorite favorite = Favorite();
  bool isFavorite = false;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int page, int total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                if (isFavorite == false) {
                  upDateFavorite(widget.book.bookID, widget.book);
                  widget.book.favoriteUsers.length += 1;
                  isFavorite = !isFavorite;
                  setState(() {});
                } else {
                  favorite.removeFavorite(widget.book.bookID, user.uid);
                  widget.book.favoriteUsers.length += 1;
                  isFavorite = !isFavorite;
                  setState(() {});
                }
              },
              child: isFavorite
                  ? Padding(
                      padding: const EdgeInsets.only(top: 3.0, right: 22),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.pinkAccent[400],
                        size: 38,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 25.0, top: 4),
                      child: Icon(
                        Icons.favorite_border,
                        size: 32,
                        color: Colors.pinkAccent[400],
                      ),
                    ),
            ),
          )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages ~/ 2}"),
              onPressed: () async {
                await snapshot.data.setPage(pages ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }

  upDateFavorite(String id, Book book) async {
    await favorite.addFavorite(id, user.uid);

    commonWidgets.customToast("Favoriye Alındı", Colors.greenAccent[700]);
  }

  currentUser() {
    user = FirebaseAuth.instance.currentUser;
  }
}
