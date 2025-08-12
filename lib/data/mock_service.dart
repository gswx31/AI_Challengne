import 'package:parttime_search_app/models/job.dart';

class MockJobService {
  static List<Job> generateJobs({required int start, required int count, String keyword = '알바'}) {
    return List.generate(count, (i) {
      final idx = start + i;
      final daysLeft = (idx % 7) + 1; // D-1..D-7
      final locationList = [
        '서울 강남구 역삼동',
        '서울 강남구 삼성동',
        '서울 서초구 서초동',
        '서울 마포구 합정동',
        '부산 해운대구 우동',
        '대구 수성구 범어동',
        '인천 연수구 옥련동'
      ];
      return Job(
        id: 'job_$idx',
        title: '$keyword 모집 공고 #$idx',
        companyName: '회사명 $idx',
        payType: idx % 2 == 0 ? '시급' : '월급',
        payAmount: idx % 2 == 0 ? '${10000 + (idx % 5) * 500}원' : '${200 + (idx % 5) * 10}원',
        location: locationList[idx % locationList.length],
        deadline: 'D-$daysLeft',
        jobDescription: '이 포지션은 $idx 번 채용 공고의 상세 설명입니다. 업무 내용, 자격 요건 등.',
        isScraped: idx % 6 == 0,
      );
    });
  }
}
