import 'package:flutter/material.dart';
import 'package:parttime_search_app/models/job.dart';

class JobCard extends StatefulWidget {
  final Job job;
  final VoidCallback onTap;
  final void Function(String jobId)? onScrapToggle;

  const JobCard({
    Key? key,
    required this.job,
    required this.onTap,
    this.onScrapToggle,
  }) : super(key: key);

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> with SingleTickerProviderStateMixin {
  late bool _isScraped;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _isScraped = widget.job.isScraped;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      lowerBound: 0.8,
      upperBound: 1.0,
    );
    _animController.value = _isScraped ? 1.0 : 0.8;
  }

  @override
  void didUpdateWidget(covariant JobCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.job.isScraped != widget.job.isScraped) {
      _isScraped = widget.job.isScraped;
      _animController.animateTo(_isScraped ? 1.0 : 0.8);
    }
  }

  void _toggleScrap() {
    setState(() {
      _isScraped = !_isScraped;
      if (_isScraped) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
    widget.onScrapToggle?.call(widget.job.id);
  }

  Color _deadlineColor(String deadline) {
    if (deadline.startsWith('D-')) {
      final days = int.tryParse(deadline.replaceFirst('D-', '')) ?? 99;
      if (days <= 3) return Colors.red;
    }
    return Colors.black87;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.04), blurRadius: 8, offset: const Offset(0,3))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // left: text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.job.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(widget.job.companyName, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('${widget.job.payType} ', style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(widget.job.payAmount, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Flexible(child: Text(widget.job.location, style: TextStyle(color: Colors.grey.shade700), overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 12),
                      Text(widget.job.deadline, style: TextStyle(color: _deadlineColor(widget.job.deadline), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            // scrap button
            const SizedBox(width: 8),
            ScaleTransition(
              scale: _animController,
              child: IconButton(
                onPressed: _toggleScrap,
                icon: Icon(_isScraped ? Icons.bookmark : Icons.bookmark_border),
                color: _isScraped ? const Color(0xFFFFC000) : Colors.grey.shade600,
                tooltip: _isScraped ? '스크랩 취소' : '스크랩',
                splashRadius: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
