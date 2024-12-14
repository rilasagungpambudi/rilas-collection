import 'package:bookcolection/model/book_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  // Nama tabel dan kolom
  static const String tableBooks = 'books';
  static const String columnId = 'id_book';
  static const String columnName = 'name_book';
  static const String columnCode = 'code_book';
  static const String columnYear = 'publication_year';
  static const String columnPublication = 'name_pubclication';
  static const String columnAuthor = 'author';
  static const String columnCover = 'cover_book';
  static const String columnSynopsis = 'synopsis';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'bookcollection.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableBooks(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT,
        $columnCode TEXT,
        $columnYear TEXT,
        $columnPublication TEXT,
        $columnAuthor TEXT,
        $columnCover TEXT,
        $columnSynopsis TEXT
      )
    ''');
    debugPrint('Database created with table: $tableBooks');
  }

  // Tambah Data Buku
  Future<int> addBook(DataBook book) async {
    try {
      final db = await database;
      return await db.insert(tableBooks, book.toJson());
    } catch (e) {
      debugPrint('Error adding book: $e');
      return -1; // Mengindikasikan error
    }
  }

  // Ambil Semua Buku
  Future<List<DataBook>> getBooks() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(tableBooks);
      return List<DataBook>.from(maps.map((map) => DataBook.fromJson(map)));
    } catch (e) {
      debugPrint('Error fetching books: $e');
      return [];
    }
  }

  // Update Buku
  Future<int> updateBook(DataBook book) async {
    try {
      final db = await database;
      return await db.update(
        tableBooks,
        book.toJson(),
        where: '$columnId = ?',
        whereArgs: [book.idBook],
      );
    } catch (e) {
      debugPrint('Error updating book: $e');
      return -1;
    }
  }

  // Hapus Buku
  Future<int> deleteBook(int id) async {
    try {
      final db = await database;
      return await db.delete(
        tableBooks,
        where: '$columnId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Error deleting book: $e');
      return -1;
    }
  }

  // Menutup koneksi database
  Future<void> closeDatabase() async {
    try {
      final db = await _database;
      if (db != null) {
        await db.close();
        _database = null;
        debugPrint('Database connection closed');
      }
    } catch (e) {
      debugPrint('Error closing database: $e');
    }
  }
}
