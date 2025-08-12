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
