import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/job_list_provider.dart';
import '../../../widgets/job_card.dart';
import '../../../widgets/filter_bottom_sheet.dart';
import '../../detail/job_detail_screen.dart';
import '../../../models/job.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
      // near bottom
      ref.read(jobListProvider.notifier).loadMore(keyword: _currentKeyword);
    }
  }

  void _onSearch() {
    setState(() {
      _currentKeyword = _searchController.text.trim().isEmpty ? '알바' : _searchController.text.trim();
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
              // Search bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '직무명·지역·회사명으로 검색',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    onPressed: _onSearch,
                    child: const Text('검색', style: TextStyle(color: Colors.black87)),
                  )
                ],
              ),
              const SizedBox(height: 12),
              // List area
              Expanded(
                child: jobListAsync.when(
                  data: (items) => RefreshIndicator(
                    onRefresh: () => ref.read(jobListProvider.notifier).refresh(keyword: _currentKeyword),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: items.length + 1,
                      itemBuilder: (context, idx) {
                        if (idx == items.length) {
                          // loader at bottom
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
                          onPressed: () => ref.read(jobListProvider.notifier).loadInitial(keyword: _currentKeyword),
                          child: const Text('다시 시도'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이페이지'),
        ],
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
