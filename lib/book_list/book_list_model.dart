import 'package:book_list_sample/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookListModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('books').snapshots();

  List<Book>? books;

  void fetchBookList() {
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final String id = document.id;
        final String title = data['title'];
        final String author = data['author'];
        final String? imgUrl = data['imgUrl'];
        return Book(id, title, author, imgUrl);
      }).toList();

      this.books = books;
      notifyListeners();
    });
  }

  Future delete(Book book) async {
    return await FirebaseFirestore.instance
        .collection('books')
        .doc(book.id)
        .delete();
  }
}
