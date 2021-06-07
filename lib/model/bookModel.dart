//Book Model
class Book{
  String bookID;
  String bookImage;
  String bookFile;
  String bookName;
  String bookWriter;
  String bookSummary;
  String publishYear;
  String bookCategory;
  List favoriteUsers;


  Book.fromMap(Map<String, dynamic> map)
      : bookID = map['bookID'],
        bookImage = map['bookImage'],
        bookFile = map['bookFile'],
        bookName = map['bookName'],
        bookWriter = map['bookWriter'],
        bookSummary = map['bookSummary'],
        publishYear = map['publishYear'],
        favoriteUsers = map['favoriteUsers'],
        bookCategory = map['bookCategory'];


}