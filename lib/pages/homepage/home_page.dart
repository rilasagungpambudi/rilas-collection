import 'package:bookcolection/pages/book/book_add_and_update.dart';
import 'package:bookcolection/pages/dashboard/dashboard_page.dart';
import 'package:bookcolection/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = GetStorage();
  // List of pages to show when a BottomNavigationBar item is selected
  final List<Widget> _pages = [
    const DashboardPage(),
    const AddBookPage(),
    const ProfilePage(),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedFontSize: 12.0, // Ukuran teks saat item dipilih
        unselectedFontSize: 12.0, // Ukuran teks saat item tidak dipilih
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
