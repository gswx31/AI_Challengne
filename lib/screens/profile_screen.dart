import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      body: const Center(child: Text('프로필 화면(추후 구현)')),
    );
  }
}
