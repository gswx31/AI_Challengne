import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parttime_search_app/screens/landing_screen.dart';
import 'package:parttime_search_app/screens/search_screen.dart';
import 'package:parttime_search_app/screens/favorites_screen.dart';
import 'package:parttime_search_app/screens/profile_screen.dart';
import 'package:parttime_search_app/widgets/bottom_nav_bar.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 1; // 기본을 '검색' 화면으로

  late final List<Widget> _pages = [
    const LandingScreen(),
    const SearchScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '알바 검색 (Demo)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFFC000),
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
      ),
      home: Scaffold(
        body: SafeArea(child: _pages[_selectedIndex]),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
