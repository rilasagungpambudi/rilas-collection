import 'dart:convert';

BookModel bookModelFromJson(String str) => BookModel.fromJson(json.decode(str));

String bookModelToJson(BookModel data) => json.encode(data.toJson());

class BookModel {
  List<DataBook> data;

  BookModel({required this.data});

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
        data:
            List<DataBook>.from(json["data"].map((x) => DataBook.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataBook {
  int? idBook;
  String nameBook;
  String codeBook;
  DateTime publicationYear;
  String namePublication;
  String author;
  String coverBook;
  String synopsis;

  DataBook({
    this.idBook,
    required this.nameBook,
    required this.codeBook,
    required this.publicationYear,
    required this.namePublication,
    required this.author,
    required this.coverBook,
    required this.synopsis,
  });

  factory DataBook.fromJson(Map<String, dynamic> json) => DataBook(
        idBook: json['id_book'],
        nameBook: json['name_book'],
        codeBook: json['code_book'],
        publicationYear: DateTime.parse(json['publication_year']),
        namePublication: json['name_pubclication'],
        author: json['author'],
        coverBook: json['cover_book'],
        synopsis: json['synopsis'],
      );

  Map<String, dynamic> toJson() => {
        'id_book': idBook,
        'name_book': nameBook,
        'code_book': codeBook,
        'publication_year': publicationYear.toIso8601String(),
        'name_pubclication': namePublication,
        'author': author,
        'cover_book': coverBook,
        'synopsis': synopsis,
      };
}
