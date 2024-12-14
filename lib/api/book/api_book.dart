import 'dart:convert';

import 'package:bookcolection/global/const/base_url.dart';
import 'package:bookcolection/global/local/database_helper.dart';
import 'package:bookcolection/helper/api_handler.dart';
import 'package:bookcolection/model/book_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

class BookApi {
  String url(String path) => baseUrl + path;

  Future<BookModel?> getBook({required int page, required int limit}) async {
    final dbHelper = DatabaseHelper();
    List<DataBook>? books;

    /// Muat data dari SQLite
    Future<void> _loadBooksFromSQLite() async {
      books = await dbHelper.getBooks();
    }

    _loadBooksFromSQLite();

    var res =
        await ApiHandler().get(url("/api/read.php?page=$page&limit=$limit"));
    debugPrint("haloo aaa panjangnya ${books!.length}");

    final jsonResponse = json.decode(res.data);
    var data = BookModel.fromJson(jsonResponse);
    if (books!.isEmpty) {
      debugPrint("haloo looping terus");
      for (var i = 0; i < data.data.length; i++) {
        dbHelper.addBook(DataBook(
          nameBook: data.data[i].nameBook,
          codeBook: data.data[i].codeBook,
          publicationYear: data.data[i].publicationYear,
          namePublication: data.data[i].nameBook,
          author: data.data[i].author,
          coverBook: data.data[i].coverBook,
          synopsis: data.data[i].synopsis,
        ));
      }
    }
    debugPrint("haloo aaa panjangnya ${books!.length}");
    return data;
  }

  Future<DataBook?> getDetail(int idBook) async {
    var res = await ApiHandler().get(url("blog/detail/$idBook"));
    return DataBook.fromJson(res.data);
  }

  Future<void> deleteBook(int idBook) async {
    var res = await ApiHandler().get(url("blog/detail/$idBook"));
    debugPrint(res.toString());
  }

  Future<void> updateBook(
      {required String idBook,
      required String nameBook,
      required String codeBook,
      required DateTime publicationYear,
      required String namePublication,
      required String author,
      required String coverBook,
      required String synopsis}) async {
    var res = await ApiHandler().post(url("/api/read.php"));
    debugPrint(res.toString());
  }

  Future<void> addBook({required Map<String, dynamic>? data}) async {
    var res = await ApiHandler().post(url("/api/read.php"), data: data);
    debugPrint(res.toString());
    Get.snackbar('Berhasil', "Data Berhasil di Tambah",
        colorText: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green);
  }
}
