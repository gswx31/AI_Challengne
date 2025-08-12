import 'package:flutter/material.dart';
import 'package:parttime_search_app/widgets/location_selector.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "근처 알바를 빠르게 찾아보세요",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text("자주 찾는 지역을 빠르게 선택할 수 있어요"),
            const SizedBox(height: 16),
            LocationSelector(),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                // 예시: 검색 탭으로 이동을 유도하려면 Navigator 사용 또는 bottom nav callback 필요
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('검색 탭으로 이동해주세요.')),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('바로 공고 검색'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC000),
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
