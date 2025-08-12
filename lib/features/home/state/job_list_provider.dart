import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parttime_search_app/models/job.dart';
import 'package:parttime_search_app/data/mock_service.dart';

final jobListProvider = StateNotifierProvider<JobListNotifier, AsyncValue<List<Job>>>(
  (ref) => JobListNotifier(),
);

class JobListNotifier extends StateNotifier<AsyncValue<List<Job>>> {
  JobListNotifier() : super(const AsyncValue.loading()) {
    loadInitial();
  }

  int _loaded = 0;
  final int _pageSize = 15;
  bool _isLoadingMore = false;

  Future<void> loadInitial({String keyword = '알바'}) async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(milliseconds: 500));
      final data = MockJobService.generateJobs(start: 0, count: _pageSize, keyword: keyword);
      _loaded = data.length;
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore({String keyword = '알바'}) async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final more = MockJobService.generateJobs(start: _loaded, count: _pageSize, keyword: keyword);
      _loaded += more.length;
      final current = state.value ?? [];
      state = AsyncValue.data([...current, ...more]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  void toggleScrap(String jobId) {
    final list = state.value;
    if (list == null) return;
    final changed = list.map((j) {
      if (j.id == jobId) return j.copyWith(isScraped: !j.isScraped);
      return j;
    }).toList();
    state = AsyncValue.data(changed);
  }

  Future<void> refresh({String keyword = '알바'}) async {
    _loaded = 0;
    await loadInitial(keyword: keyword);
  }
}
