#!/bin/bash
# 아래 스크립트는 Flutter 프로젝트 내 lib/widgets, lib/screens 등의 여러 Dart 파일을 생성하는 명령어 예시입니다.
# 원하시면 바로 터미널에 복사해서 붙여넣고 실행하면 각 파일이 생성됩니다.

mkdir -p lib/widgets
mkdir -p lib/screens
mkdir -p lib/features/home/state
mkdir -p lib/features/detail

# filter_bottom_sheet.dart
cat <<'EOF' > lib/widgets/filter_bottom_sheet.dart
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
EOF

# location_selector.dart
cat <<'EOF' > lib/widgets/location_selector.dart
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
EOF

# bottom_nav_bar.dart
cat <<'EOF' > lib/widgets/bottom_nav_bar.dart
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
EOF

# landing_screen.dart
cat <<'EOF' > lib/screens/landing_screen.dart
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
EOF

# search_screen.dart
cat <<'EOF' > lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parttime_search_app/features/home/state/job_list_provider.dart';
import 'package:parttime_search_app/widgets/job_card.dart';
import 'package:parttime_search_app/widgets/filter_bottom_sheet.dart';
import 'package:parttime_search_app/features/detail/job_detail_screen.dart';
import 'package:parttime_search_app/models/job.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _currentKeyword = '알바';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(jobListProvider.notifier).loadMore(keyword: _currentKeyword);
    }
  }

  void _onSearch() {
    setState(() {
      _currentKeyword =
          _searchController.text.trim().isEmpty ? '알바' : _searchController.text.trim();
    });
    ref.read(jobListProvider.notifier).loadInitial(keyword: _currentKeyword);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobListAsync = ref.watch(jobListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('검색'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const FilterBottomSheet(),
            ),
            icon: const Icon(Icons.filter_list),
            tooltip: '필터',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '직무명·지역·회사명으로 검색',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onSubmitted: (_) => _onSearch(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC000),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    onPressed: _onSearch,
                    child: const Text('검색', style: TextStyle(color: Colors.black87)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: jobListAsync.when(
                  data: (items) => RefreshIndicator(
                    onRefresh: () => ref
                        .read(jobListProvider.notifier)
                        .refresh(keyword: _currentKeyword),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: items.length + 1,
                      itemBuilder: (context, idx) {
                        if (idx == items.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final job = items[idx];
                        return JobCard(
                          job: job,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => JobDetailScreen(job: job),
                              ),
                            );
                          },
                          onScrapToggle: (id) {
                            ref.read(jobListProvider.notifier).toggleScrap(id);
                          },
                        );
                      },
                    ),
                  ),
                  loading: () => ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, i) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: _SkeletonCard(),
                    ),
                  ),
                  error: (e, st) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('데이터를 불러오지 못했습니다.'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () =>
                              ref.read(jobListProvider.notifier).loadInitial(keyword: _currentKeyword),
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 180, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                Container(height: 12, width: 120, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                Container(height: 12, width: 220, color: Colors.grey.shade300),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 36, height: 36, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}
EOF

# job_detail_screen.dart
cat <<'EOF' > lib/features/detail/job_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:parttime_search_app/models/job.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final isUrgent = job.deadline.startsWith('D-') &&
        (int.tryParse(job.deadline.replaceFirst('D-', '')) ?? 99) <= 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('공고 상세'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${job.companyName}·${job.location}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('${job.payType}${job.payAmount}', style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(width: 12),
                if (isUrgent)
                  Row(
                    children: [
                      const Icon(Icons.priority_high, color: Colors.red),
                      const SizedBox(width: 6),
                      Text(job.deadline, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  )
                else
                  Text(job.deadline, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 18),
            const Text('상세내용', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(job.jobDescription),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('지원하기(샘플)')));
              },
              child: const Text('지원하기'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFC000)),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# favorites_screen.dart
cat <<'EOF' > lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parttime_search_app/features/home/state/job_list_provider.dart';
import 'package:parttime_search_app/widgets/job_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobListAsync = ref.watch(jobListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('찜한 공고')),
      body: jobListAsync.when(
        data: (items) {
          final saved = items.where((j) => j.isScraped).toList();
          if (saved.isEmpty) {
            return const Center(child: Text('찜한 공고가 없습니다.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: saved.length,
            itemBuilder: (context, idx) {
              final job = saved[idx];
              return JobCard(
                job: job,
                onTap: () {},
                onScrapToggle: (id) => ref.read(jobListProvider.notifier).toggleScrap(id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('에러: $e')),
      ),
    );
  }
}
EOF

# profile_screen.dart
cat <<'EOF' > lib/screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('내 정보')),
      body: Center(child: Text('프로필 화면(추후 구현)')),
    );
  }
}
EOF

echo "모든 파일이 lib 폴더에 생성되었습니다."
