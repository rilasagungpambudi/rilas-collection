import 'package:bookcolection/api/book/api_book.dart';
import 'package:bookcolection/model/book_model.dart';
import 'package:flutter/material.dart';

class ProviderBook with ChangeNotifier {
  int page = 1;
  int limit = 10;
  bool init = true;
  bool isLoadingNextPage = false;
  bool isLoadingBook = false;
  bool isLoadingBookDetail = true;
  DataBook? resBookDetail;
  String textError = "";
  BookModel? resBook;
  String title = '';

  setPage(int page) {
    page = page;
    notifyListeners();
  }

  setTitle(data) {
    title = data;
    notifyListeners();
  }

  getInit() async {
    if (init) {
      page = 1;
      notifyListeners();
      getBookInit();
      init = false;
      notifyListeners();
    }
  }

  getBook({bool? reset}) async {
    if (reset == true) {
      page = 1;
      resBook = null;
      isLoadingBook = true;
      notifyListeners();
    }

    var res = await BookApi().getBook(page: page, limit: limit);
    if (page == 1) {
      resBook = res;
      isLoadingNextPage = true;
      if (resBook?.data != null && resBook?.data != null) {
        if (resBook!.data.length < limit) {
          isLoadingNextPage = false;
        }
      }
    }
    if (page > 1) {
      if (resBook?.data != null && res!.data.isNotEmpty) {
        resBook!.data.addAll(res.data);
        isLoadingNextPage = true;
      } else {
        isLoadingNextPage = false;
      }
    }

    isLoadingBook = false;
    isLoadingNextPage = false;
    notifyListeners();
  }

  getBookInit() async {
    isLoadingBook = true;
    notifyListeners();
    var res = await BookApi().getBook(page: page, limit: limit);
    resBook = res;
    debugPrint("haloo resnya ${res?.data}");
    isLoadingBook = false;
    notifyListeners();
  }

  getDetail(int idBook) async {
    isLoadingBookDetail = true;
    notifyListeners();
    var res = await BookApi().getDetail(idBook);
    resBookDetail = res;
    isLoadingBookDetail = false;
    notifyListeners();
  }

  deleteDetail(int idBook) async {
    isLoadingBookDetail = true;
    notifyListeners();
    var res = await BookApi().deleteBook(idBook);
    isLoadingBookDetail = false;
    notifyListeners();
  }

  // Metode untuk mengupdate state detail buku
  void updateBookDetail({
    required String idBook,
    required String nameBook,
    required String codeBook,
    required DateTime publicationYear,
    required String namePublication,
    required String author,
    required String coverBook,
    required String synopsis,
  }) async {
    var res = await BookApi().updateBook(
      idBook: idBook,
      nameBook: nameBook,
      codeBook: codeBook,
      publicationYear: publicationYear,
      namePublication: namePublication,
      author: author,
      coverBook: coverBook,
      synopsis: synopsis,
    );
    isLoadingBookDetail = false;
    // Notifikasi perubahan kepada listener
    notifyListeners();
  }

  // Metode untuk mengupdate state detail buku
  void addPost({required Map<String, dynamic>? data}) async {
    var res = await BookApi().addBook(data: data);
    isLoadingBookDetail = false;
    // Notifikasi perubahan kepada listener
    notifyListeners();
  }
}
