import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _payRange = const RangeValues(9000, 15000);

  final List<String> _workTypes = ['파트타임', '풀타임', '단기'];
  final Set<String> _selectedWorkTypes = {};

  final Map<String, Map<String, List<String>>> _regionHierarchy = {
    '서울': {
      '강남구': ['역삼동', '삼성동', '신사동'],
      '서초구': ['서초동', '방배동', '양재동'],
      '마포구': ['상암동', '공덕동', '합정동'],
    },
    '부산': {
      '해운대구': ['우동', '중동', '좌동'],
      '동래구': ['명륜동', '온천동', '사직동'],
    },
    '대구': {
      '수성구': ['범어동', '만촌동'],
    },
  };

  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedNeighborhood;

  void _resetRegion() {
    setState(() {
      _selectedCity = null;
      _selectedDistrict = null;
      _selectedNeighborhood = null;
    });
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.deepPurpleAccent, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<T>(
            isExpanded: true,
            underline: const SizedBox.shrink(),
            value: value,
            hint: Text(
              '선택해주세요',
              style: TextStyle(color: Colors.deepPurple.shade300),
            ),
            items: items
                .map(
                  (e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(
                      e.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            iconEnabledColor: Colors.deepPurpleAccent,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cityList = _regionHierarchy.keys.toList();
    final districtList =
        _selectedCity != null ? _regionHierarchy[_selectedCity!]!.keys.toList() : <String>[];
    final neighborhoodList = (_selectedCity != null && _selectedDistrict != null)
        ? _regionHierarchy[_selectedCity!]![_selectedDistrict!]!
        : <String>[];

    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.35,
          maxChildSize: 0.95,
          builder: (_, controller) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ListView(
              controller: controller,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '필터설정',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.deepPurple),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _payRange = const RangeValues(9000, 15000);
                              _selectedWorkTypes.clear();
                              _resetRegion();
                            });
                          },
                          icon: const Icon(Icons.restart_alt, color: Colors.deepPurpleAccent),
                          tooltip: '초기화',
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // TODO: 필터 적용 로직 연결
                          },
                          icon: const Icon(Icons.done, color: Colors.deepPurpleAccent),
                          tooltip: '적용',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('근무형태', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: _workTypes.map((type) {
                    final selected = _selectedWorkTypes.contains(type);
                    return ChoiceChip(
                      label: Text(type),
                      selected: selected,
                      onSelected: (v) {
                        setState(() {
                          if (v) {
                            _selectedWorkTypes.add(type);
                          } else {
                            _selectedWorkTypes.remove(type);
                          }
                        });
                      },
                      selectedColor: Colors.deepPurple.shade200,
                      backgroundColor: Colors.deepPurple.shade50,
                      labelStyle: TextStyle(
                        color: selected ? Colors.deepPurple.shade900 : Colors.deepPurple.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                _buildDropdown<String>(
                  label: '시(도)',
                  value: _selectedCity,
                  items: cityList,
                  onChanged: (val) {
                    setState(() {
                      _selectedCity = val;
                      _selectedDistrict = null;
                      _selectedNeighborhood = null;
                    });
                  },
                  icon: Icons.location_city_outlined,
                ),
                const SizedBox(height: 16),
                if (_selectedCity != null)
                  _buildDropdown<String>(
                    label: '구(군)',
                    value: _selectedDistrict,
                    items: districtList,
                    onChanged: (val) {
                      setState(() {
                        _selectedDistrict = val;
                        _selectedNeighborhood = null;
                      });
                    },
                    icon: Icons.map_outlined,
                  ),
                if (_selectedCity != null) const SizedBox(height: 16),
                if (_selectedDistrict != null)
                  _buildDropdown<String>(
                    label: '동',
                    value: _selectedNeighborhood,
                    items: neighborhoodList,
                    onChanged: (val) {
                      setState(() {
                        _selectedNeighborhood = val;
                      });
                    },
                    icon: Icons.home_work_outlined,
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.attach_money_rounded, color: Colors.deepPurpleAccent, size: 20),
                    const SizedBox(width: 8),
                    Text('시급범위', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 8),
                RangeSlider(
                  values: _payRange,
                  min: 8000,
                  max: 30000,
                  divisions: 22,
                  activeColor: Colors.deepPurpleAccent,
                  inactiveColor: Colors.deepPurple.shade100,
                  labels: RangeLabels('${_payRange.start.toInt()}원', '${_payRange.end.toInt()}원'),
                  onChanged: (v) {
                    setState(() {
                      _payRange = v;
                    });
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
