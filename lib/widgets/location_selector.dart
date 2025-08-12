import 'package:flutter/material.dart';

class LocationSelector extends StatelessWidget {
  final List<Map<String, dynamic>> locations = [
    {"name": "서울강남구", "icon": Icons.apartment},
    {"name": "서울서초구", "icon": Icons.business},
    {"name": "서울마포구", "icon": Icons.local_cafe},
    {"name": "부산해운대구", "icon": Icons.beach_access},
    {"name": "대구수성구", "icon": Icons.park},
    {"name": "인천연수구", "icon": Icons.school},
    {"name": "광주북구", "icon": Icons.museum},
    {"name": "제주제주시", "icon": Icons.landscape},
  ];

  LocationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: locations
          .map(
            (loc) => ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 1,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${loc["name"]} 선택됨')),
                );
              },
              icon: Icon(loc["icon"], size: 18, color: Colors.deepPurpleAccent),
              label: Text(loc["name"], style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          )
          .toList(),
    );
  }
}
