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
