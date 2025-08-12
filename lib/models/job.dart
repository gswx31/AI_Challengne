class Job {
  final String id;
  final String title;
  final String companyName;
  final String payType; // '시급', '월급' 등
  final String payAmount; // '9,860원' 등
  final String location;
  final String deadline; // 'D-3' 등
  final String jobDescription;
  final DateTime postedAt;
  final bool isScraped;

  Job({
    required this.id,
    required this.title,
    required this.companyName,
    required this.payType,
    required this.payAmount,
    required this.location,
    required this.deadline,
    this.jobDescription = '상세 내용은 여기에 표시됩니다.',
    DateTime? postedAt,
    this.isScraped = false,
  }) : postedAt = postedAt ?? DateTime.now();

  Job copyWith({bool? isScraped}) {
    return Job(
      id: id,
      title: title,
      companyName: companyName,
      payType: payType,
      payAmount: payAmount,
      location: location,
      deadline: deadline,
      jobDescription: jobDescription,
      postedAt: postedAt,
      isScraped: isScraped ?? this.isScraped,
    );
  }
}
