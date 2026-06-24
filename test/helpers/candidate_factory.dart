import 'package:candidate_dashboard/data/models/candidate.dart';

Candidate candidateFactory({
  String id = 'id',
  String name = 'Иван Иванов',
  Verdict verdict = Verdict.suitable,
  VerdictColor verdictColor = VerdictColor.green,
  String totalExperience = '~3.5 г.',
  CandidateStatus status = CandidateStatus.fresh,
  DateTime? dateAdded,
}) {
  return Candidate(
    id: id,
    name: name,
    position: 'flutter-middle',
    positionLabel: 'Flutter — ведущий программист',
    file: '$id.pdf',
    email: '$id@email.com',
    phone: '+996 555 000-000',
    city: 'Бишкек',
    tg: '@$id',
    exp: const [
      Experience(
        period: '2022 — н.в.',
        company: 'Tech',
        role: 'Flutter Developer',
        duration: '2 г.',
      ),
    ],
    totalExperience: totalExperience,
    stack: 'Flutter, Dart, BLoC',
    edu: 'КНУ, 2020',
    verdict: verdict,
    verdictColor: verdictColor,
    criteria: const [
      Criterion(status: CriterionStatus.ok, text: 'Flutter/Dart — есть'),
    ],
    summary: 'Summary',
    questions: const ['Question?'],
    status: status,
    dateAdded: dateAdded ?? DateTime(2026),
  );
}
