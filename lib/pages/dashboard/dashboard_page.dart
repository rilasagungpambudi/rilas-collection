import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bookcolection/global/local/database_helper.dart';
import 'package:bookcolection/global/widget/app_bar.dart';
import 'package:bookcolection/model/book_model.dart';
import 'package:bookcolection/pages/book/book_description.dart';
import 'package:bookcolection/pages/dashboard/widget/book_card.dart';
import 'package:bookcolection/state/book_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final dbHelper = DatabaseHelper();

  bool isSearchClicked = false;
  bool isShowSearchResult = false;
  bool isOffline = false; // Menyimpan status koneksi

  Timer? _debounce;
  List<DataBook>? books; // Data dari SQLite

  @override
  void initState() {
    super.initState();
    // Cek status koneksi saat pertama kali

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkConnectivity();
      debugPrint("chekk $isOffline");
      if (!isOffline) {
        Provider.of<ProviderBook>(context, listen: false)
          ..setTitle("")
          ..getInit();
      } else {
        await _loadBooksFromSQLite();
      }

      scrollController.addListener(() async {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          if (!isOffline) {
            await Provider.of<ProviderBook>(context, listen: false).getBook();
          }
        }
      });
    });
  }

  /// Cek status koneksi internet
  _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOffline = connectivityResult == ConnectivityResult.none;
    });

    // Pantau perubahan status koneksi
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isOffline = result == ConnectivityResult.none;
      });

      if (!isOffline) {
        // Jika online, ambil data dari API
        Provider.of<ProviderBook>(context, listen: false)
          ..setTitle("")
          ..getInit();
      } else {
        // Jika offline, ambil data dari SQLite
        _loadBooksFromSQLite();
      }
    });
  }

  /// Muat data dari SQLite
  Future<void> _loadBooksFromSQLite() async {
    books = await dbHelper.getBooks();
    setState(() {});
  }

  /// Filter data berdasarkan input pencarian
  void myFilterItems(String value) async {
    if (value.isEmpty) {
      setState(() {
        isShowSearchResult = false;
      });
      if (!isOffline) {
        Provider.of<ProviderBook>(context, listen: false)
          ..setTitle("")
          ..getBook(reset: true);
      } else {
        await _loadBooksFromSQLite();
      }
    } else {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 1000), () async {
        setState(() {
          isShowSearchResult = true;
        });

        if (!isOffline) {
          Provider.of<ProviderBook>(context, listen: false)
            ..setTitle(_searchController.text)
            ..getBook(reset: true);
        } else {
          books = books
              ?.where((book) =>
                  book.nameBook.toLowerCase().contains(value.toLowerCase()))
              .toList();
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars(
        title: "Book Store",
        backBtn: false,
        centerTitle: false,
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/logo.png",
            height: 30,
            width: 30,
            fit: BoxFit.contain,
          ),
        ),
        customTitle: isSearchClicked
            ? Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 16, 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  autofocus: true,
                  controller: _searchController,
                  onChanged: myFilterItems,
                  decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      hintText: 'Cari...'),
                ),
              )
            : const Text(
                "Book Store",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearchClicked = !isSearchClicked;
                if (!isSearchClicked) {
                  _searchController.clear();
                  myFilterItems("");
                }
              });
            },
            icon: Icon(
              isSearchClicked ? Icons.close : Icons.search,
              color: Colors.black,
              size: 24,
            ),
          )
        ],
      ),
      body: isOffline
          ? _buildOfflineData() // Tampilkan data dari SQLite jika offline
          : _buildOnlineData(context), // Tampilkan data dari API jika online
    );
  }

  Widget _buildOfflineData() {
    return books == null
        ? const Center(child: CircularProgressIndicator())
        : books!.isEmpty
            ? const Center(child: Text("No books available offline."))
            : GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.55,
                ),
                itemCount: books!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BookCard(
                    title: books?[index].nameBook ?? "",
                    imagePath: books?[index].coverBook ?? "",
                    author: books?[index].author ?? "",
                    isbn: books?[index].codeBook ?? "",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDescriptionPage(
                            nameBook: books?[index].nameBook ?? "",
                            codeBook: books?[index].codeBook ?? "",
                            publicationYear: books![index].publicationYear,
                            namePublication:
                                books?[index].namePublication ?? "",
                            author: books?[index].author ?? "",
                            coverBook: books?[index].coverBook ?? "",
                            synopsis: books?[index].synopsis ?? "",
                          ),
                        ),
                      );
                    },
                  );
                },
              );
  }

  Widget _buildOnlineData(BuildContext context) {
    return Consumer<ProviderBook>(
      builder: (context, provider, child) {
        return provider.resBook?.data == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: provider.resBook!.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final book = provider.resBook!.data[index];
                    return BookCard(
                      title: book.nameBook,
                      imagePath: book.coverBook,
                      author: book.author,
                      isbn: book.codeBook,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDescriptionPage(
                              nameBook: book.nameBook,
                              codeBook: book.codeBook,
                              publicationYear: book.publicationYear,
                              namePublication: book.namePublication,
                              author: book.author,
                              coverBook: book.coverBook,
                              synopsis: book.synopsis,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
      },
    );
  }
}
