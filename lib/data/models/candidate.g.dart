// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CandidateImpl _$$CandidateImplFromJson(Map<String, dynamic> json) =>
    _$CandidateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      position: json['position'] as String,
      positionLabel: json['pos_label'] as String,
      file: json['file'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      city: json['city'] as String,
      tg: json['tg'] as String,
      exp: const ExperienceConverter().fromJson(json['exp'] as List),
      totalExperience: json['total_exp'] as String,
      stack: json['stack'] as String,
      edu: json['edu'] as String,
      verdict: $enumDecode(_$VerdictEnumMap, json['verdict']),
      verdictColor: $enumDecode(_$VerdictColorEnumMap, json['vc']),
      criteria: const CriterionConverter().fromJson(json['criteria'] as List),
      summary: json['summary'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status:
          $enumDecodeNullable(_$CandidateStatusEnumMap, json['status']) ??
          CandidateStatus.fresh,
      dateAdded: json['date_added'] == null
          ? null
          : DateTime.parse(json['date_added'] as String),
    );

Map<String, dynamic> _$$CandidateImplToJson(_$CandidateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'pos_label': instance.positionLabel,
      'file': instance.file,
      'email': instance.email,
      'phone': instance.phone,
      'city': instance.city,
      'tg': instance.tg,
      'exp': const ExperienceConverter().toJson(instance.exp),
      'total_exp': instance.totalExperience,
      'stack': instance.stack,
      'edu': instance.edu,
      'verdict': _$VerdictEnumMap[instance.verdict]!,
      'vc': _$VerdictColorEnumMap[instance.verdictColor]!,
      'criteria': const CriterionConverter().toJson(instance.criteria),
      'summary': instance.summary,
      'questions': instance.questions,
      'status': _$CandidateStatusEnumMap[instance.status]!,
      'date_added': instance.dateAdded?.toIso8601String(),
    };

const _$VerdictEnumMap = {
  Verdict.suitable: 'ПОДХОДИТ',
  Verdict.partial: 'ЧАСТИЧНО',
  Verdict.unsuitable: 'НЕ ПОДХОДИТ',
};

const _$VerdictColorEnumMap = {
  VerdictColor.green: 'verdict-green',
  VerdictColor.orange: 'verdict-orange',
  VerdictColor.red: 'verdict-red',
};

const _$CandidateStatusEnumMap = {
  CandidateStatus.fresh: 'new',
  CandidateStatus.review: 'review',
  CandidateStatus.invited: 'invited',
  CandidateStatus.rejected: 'rejected',
};
