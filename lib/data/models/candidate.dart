import 'package:freezed_annotation/freezed_annotation.dart';

part 'candidate.freezed.dart';

part 'candidate.g.dart';

enum Verdict {
  @JsonValue('ПОДХОДИТ')
  suitable,
  @JsonValue('ЧАСТИЧНО')
  partial,
  @JsonValue('НЕ ПОДХОДИТ')
  unsuitable;

  String get label => switch (this) {
    Verdict.suitable => 'ПОДХОДИТ',
    Verdict.partial => 'ЧАСТИЧНО',
    Verdict.unsuitable => 'НЕ ПОДХОДИТ',
  };
}

enum VerdictColor {
  @JsonValue('verdict-green')
  green,
  @JsonValue('verdict-orange')
  orange,
  @JsonValue('verdict-red')
  red,
}

enum CriterionStatus {
  @JsonValue('ok')
  ok,
  @JsonValue('warn')
  warn,
  @JsonValue('no')
  no,
}

enum CandidateStatus {
  @JsonValue('new')
  fresh,
  @JsonValue('review')
  review,
  @JsonValue('invited')
  invited,
  @JsonValue('rejected')
  rejected;

  String get label => switch (this) {
    CandidateStatus.fresh => 'Новый',
    CandidateStatus.review => 'На рассмотрении',
    CandidateStatus.invited => 'Приглашён',
    CandidateStatus.rejected => 'Отклонён',
  };

  String get wireValue => switch (this) {
    CandidateStatus.fresh => 'new',
    CandidateStatus.review => 'review',
    CandidateStatus.invited => 'invited',
    CandidateStatus.rejected => 'rejected',
  };

  CandidateStatus get next => switch (this) {
    CandidateStatus.fresh => CandidateStatus.review,
    CandidateStatus.review => CandidateStatus.invited,
    CandidateStatus.invited => CandidateStatus.rejected,
    CandidateStatus.rejected => CandidateStatus.fresh,
  };
}

enum CandidateSort {
  name('По имени'),
  experience('По опыту'),
  dateAdded('По дате');

  const CandidateSort(this.label);

  final String label;
}

@freezed
class Candidate with _$Candidate {
  const factory Candidate({
    required String id,
    required String name,
    required String position,
    @JsonKey(name: 'pos_label') required String positionLabel,
    required String file,
    required String email,
    required String phone,
    required String city,
    required String tg,
    @ExperienceConverter() required List<Experience> exp,
    @JsonKey(name: 'total_exp') required String totalExperience,
    required String stack,
    required String edu,
    required Verdict verdict,
    @JsonKey(name: 'vc') required VerdictColor verdictColor,
    @CriterionConverter() required List<Criterion> criteria,
    required String summary,
    required List<String> questions,
    @Default(CandidateStatus.fresh) CandidateStatus status,
    @JsonKey(name: 'date_added') DateTime? dateAdded,
  }) = _Candidate;

  factory Candidate.fromJson(Map<String, dynamic> json) =>
      _$CandidateFromJson(json);
}

@freezed
class Experience with _$Experience {
  const factory Experience({
    required String period,
    required String company,
    required String role,
    required String duration,
  }) = _Experience;
}

@freezed
class Criterion with _$Criterion {
  const factory Criterion({
    required CriterionStatus status,
    required String text,
  }) = _Criterion;
}

class ExperienceConverter
    implements JsonConverter<List<Experience>, List<dynamic>> {
  const ExperienceConverter();

  @override
  List<Experience> fromJson(List<dynamic> json) => json
      .map((item) {
        final values = (item as List<dynamic>).cast<String>();
        return Experience(
          period: values.elementAtOrNull(0) ?? '',
          company: values.elementAtOrNull(1) ?? '',
          role: values.elementAtOrNull(2) ?? '',
          duration: values.elementAtOrNull(3) ?? '',
        );
      })
      .toList(growable: false);

  @override
  List<dynamic> toJson(List<Experience> object) => object
      .map((item) => [item.period, item.company, item.role, item.duration])
      .toList(growable: false);
}

class CriterionConverter
    implements JsonConverter<List<Criterion>, List<dynamic>> {
  const CriterionConverter();

  @override
  List<Criterion> fromJson(List<dynamic> json) => json
      .map((item) {
        final values = (item as List<dynamic>).cast<String>();
        return Criterion(
          status: CriterionStatusWire.fromValue(values.first),
          text: values.elementAtOrNull(1) ?? '',
        );
      })
      .toList(growable: false);

  @override
  List<dynamic> toJson(List<Criterion> object) => object
      .map((item) => [item.status.wireValue, item.text])
      .toList(growable: false);
}

extension CriterionStatusWire on CriterionStatus {
  String get wireValue => switch (this) {
    CriterionStatus.ok => 'ok',
    CriterionStatus.warn => 'warn',
    CriterionStatus.no => 'no',
  };

  static CriterionStatus fromValue(String value) => switch (value) {
    'ok' => CriterionStatus.ok,
    'warn' => CriterionStatus.warn,
    'no' => CriterionStatus.no,
    _ => CriterionStatus.warn,
  };
}
