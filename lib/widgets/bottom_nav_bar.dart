import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemTapped,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_filled), label: '홈'),
        NavigationDestination(icon: Icon(Icons.search), label: '검색'),
        NavigationDestination(icon: Icon(Icons.favorite_border), label: '찜'),
        NavigationDestination(icon: Icon(Icons.person_outline), label: '프로필'),
      ],
    );
  }
}
