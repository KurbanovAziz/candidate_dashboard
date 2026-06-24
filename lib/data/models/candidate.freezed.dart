// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Candidate _$CandidateFromJson(Map<String, dynamic> json) {
  return _Candidate.fromJson(json);
}

/// @nodoc
mixin _$Candidate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  @JsonKey(name: 'pos_label')
  String get positionLabel => throw _privateConstructorUsedError;
  String get file => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get tg => throw _privateConstructorUsedError;
  @ExperienceConverter()
  List<Experience> get exp => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_exp')
  String get totalExperience => throw _privateConstructorUsedError;
  String get stack => throw _privateConstructorUsedError;
  String get edu => throw _privateConstructorUsedError;
  Verdict get verdict => throw _privateConstructorUsedError;
  @JsonKey(name: 'vc')
  VerdictColor get verdictColor => throw _privateConstructorUsedError;
  @CriterionConverter()
  List<Criterion> get criteria => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  List<String> get questions => throw _privateConstructorUsedError;
  CandidateStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_added')
  DateTime? get dateAdded => throw _privateConstructorUsedError;

  /// Serializes this Candidate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Candidate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CandidateCopyWith<Candidate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandidateCopyWith<$Res> {
  factory $CandidateCopyWith(Candidate value, $Res Function(Candidate) then) =
      _$CandidateCopyWithImpl<$Res, Candidate>;
  @useResult
  $Res call({
    String id,
    String name,
    String position,
    @JsonKey(name: 'pos_label') String positionLabel,
    String file,
    String email,
    String phone,
    String city,
    String tg,
    @ExperienceConverter() List<Experience> exp,
    @JsonKey(name: 'total_exp') String totalExperience,
    String stack,
    String edu,
    Verdict verdict,
    @JsonKey(name: 'vc') VerdictColor verdictColor,
    @CriterionConverter() List<Criterion> criteria,
    String summary,
    List<String> questions,
    CandidateStatus status,
    @JsonKey(name: 'date_added') DateTime? dateAdded,
  });
}

/// @nodoc
class _$CandidateCopyWithImpl<$Res, $Val extends Candidate>
    implements $CandidateCopyWith<$Res> {
  _$CandidateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Candidate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? position = null,
    Object? positionLabel = null,
    Object? file = null,
    Object? email = null,
    Object? phone = null,
    Object? city = null,
    Object? tg = null,
    Object? exp = null,
    Object? totalExperience = null,
    Object? stack = null,
    Object? edu = null,
    Object? verdict = null,
    Object? verdictColor = null,
    Object? criteria = null,
    Object? summary = null,
    Object? questions = null,
    Object? status = null,
    Object? dateAdded = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as String,
            positionLabel: null == positionLabel
                ? _value.positionLabel
                : positionLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            file: null == file
                ? _value.file
                : file // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            tg: null == tg
                ? _value.tg
                : tg // ignore: cast_nullable_to_non_nullable
                      as String,
            exp: null == exp
                ? _value.exp
                : exp // ignore: cast_nullable_to_non_nullable
                      as List<Experience>,
            totalExperience: null == totalExperience
                ? _value.totalExperience
                : totalExperience // ignore: cast_nullable_to_non_nullable
                      as String,
            stack: null == stack
                ? _value.stack
                : stack // ignore: cast_nullable_to_non_nullable
                      as String,
            edu: null == edu
                ? _value.edu
                : edu // ignore: cast_nullable_to_non_nullable
                      as String,
            verdict: null == verdict
                ? _value.verdict
                : verdict // ignore: cast_nullable_to_non_nullable
                      as Verdict,
            verdictColor: null == verdictColor
                ? _value.verdictColor
                : verdictColor // ignore: cast_nullable_to_non_nullable
                      as VerdictColor,
            criteria: null == criteria
                ? _value.criteria
                : criteria // ignore: cast_nullable_to_non_nullable
                      as List<Criterion>,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as CandidateStatus,
            dateAdded: freezed == dateAdded
                ? _value.dateAdded
                : dateAdded // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CandidateImplCopyWith<$Res>
    implements $CandidateCopyWith<$Res> {
  factory _$$CandidateImplCopyWith(
    _$CandidateImpl value,
    $Res Function(_$CandidateImpl) then,
  ) = __$$CandidateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String position,
    @JsonKey(name: 'pos_label') String positionLabel,
    String file,
    String email,
    String phone,
    String city,
    String tg,
    @ExperienceConverter() List<Experience> exp,
    @JsonKey(name: 'total_exp') String totalExperience,
    String stack,
    String edu,
    Verdict verdict,
    @JsonKey(name: 'vc') VerdictColor verdictColor,
    @CriterionConverter() List<Criterion> criteria,
    String summary,
    List<String> questions,
    CandidateStatus status,
    @JsonKey(name: 'date_added') DateTime? dateAdded,
  });
}

/// @nodoc
class __$$CandidateImplCopyWithImpl<$Res>
    extends _$CandidateCopyWithImpl<$Res, _$CandidateImpl>
    implements _$$CandidateImplCopyWith<$Res> {
  __$$CandidateImplCopyWithImpl(
    _$CandidateImpl _value,
    $Res Function(_$CandidateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Candidate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? position = null,
    Object? positionLabel = null,
    Object? file = null,
    Object? email = null,
    Object? phone = null,
    Object? city = null,
    Object? tg = null,
    Object? exp = null,
    Object? totalExperience = null,
    Object? stack = null,
    Object? edu = null,
    Object? verdict = null,
    Object? verdictColor = null,
    Object? criteria = null,
    Object? summary = null,
    Object? questions = null,
    Object? status = null,
    Object? dateAdded = freezed,
  }) {
    return _then(
      _$CandidateImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as String,
        positionLabel: null == positionLabel
            ? _value.positionLabel
            : positionLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        file: null == file
            ? _value.file
            : file // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        tg: null == tg
            ? _value.tg
            : tg // ignore: cast_nullable_to_non_nullable
                  as String,
        exp: null == exp
            ? _value._exp
            : exp // ignore: cast_nullable_to_non_nullable
                  as List<Experience>,
        totalExperience: null == totalExperience
            ? _value.totalExperience
            : totalExperience // ignore: cast_nullable_to_non_nullable
                  as String,
        stack: null == stack
            ? _value.stack
            : stack // ignore: cast_nullable_to_non_nullable
                  as String,
        edu: null == edu
            ? _value.edu
            : edu // ignore: cast_nullable_to_non_nullable
                  as String,
        verdict: null == verdict
            ? _value.verdict
            : verdict // ignore: cast_nullable_to_non_nullable
                  as Verdict,
        verdictColor: null == verdictColor
            ? _value.verdictColor
            : verdictColor // ignore: cast_nullable_to_non_nullable
                  as VerdictColor,
        criteria: null == criteria
            ? _value._criteria
            : criteria // ignore: cast_nullable_to_non_nullable
                  as List<Criterion>,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as CandidateStatus,
        dateAdded: freezed == dateAdded
            ? _value.dateAdded
            : dateAdded // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CandidateImpl implements _Candidate {
  const _$CandidateImpl({
    required this.id,
    required this.name,
    required this.position,
    @JsonKey(name: 'pos_label') required this.positionLabel,
    required this.file,
    required this.email,
    required this.phone,
    required this.city,
    required this.tg,
    @ExperienceConverter() required final List<Experience> exp,
    @JsonKey(name: 'total_exp') required this.totalExperience,
    required this.stack,
    required this.edu,
    required this.verdict,
    @JsonKey(name: 'vc') required this.verdictColor,
    @CriterionConverter() required final List<Criterion> criteria,
    required this.summary,
    required final List<String> questions,
    this.status = CandidateStatus.fresh,
    @JsonKey(name: 'date_added') this.dateAdded,
  }) : _exp = exp,
       _criteria = criteria,
       _questions = questions;

  factory _$CandidateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CandidateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String position;
  @override
  @JsonKey(name: 'pos_label')
  final String positionLabel;
  @override
  final String file;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String city;
  @override
  final String tg;
  final List<Experience> _exp;
  @override
  @ExperienceConverter()
  List<Experience> get exp {
    if (_exp is EqualUnmodifiableListView) return _exp;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exp);
  }

  @override
  @JsonKey(name: 'total_exp')
  final String totalExperience;
  @override
  final String stack;
  @override
  final String edu;
  @override
  final Verdict verdict;
  @override
  @JsonKey(name: 'vc')
  final VerdictColor verdictColor;
  final List<Criterion> _criteria;
  @override
  @CriterionConverter()
  List<Criterion> get criteria {
    if (_criteria is EqualUnmodifiableListView) return _criteria;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_criteria);
  }

  @override
  final String summary;
  final List<String> _questions;
  @override
  List<String> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  @JsonKey()
  final CandidateStatus status;
  @override
  @JsonKey(name: 'date_added')
  final DateTime? dateAdded;

  @override
  String toString() {
    return 'Candidate(id: $id, name: $name, position: $position, positionLabel: $positionLabel, file: $file, email: $email, phone: $phone, city: $city, tg: $tg, exp: $exp, totalExperience: $totalExperience, stack: $stack, edu: $edu, verdict: $verdict, verdictColor: $verdictColor, criteria: $criteria, summary: $summary, questions: $questions, status: $status, dateAdded: $dateAdded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CandidateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.positionLabel, positionLabel) ||
                other.positionLabel == positionLabel) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.tg, tg) || other.tg == tg) &&
            const DeepCollectionEquality().equals(other._exp, _exp) &&
            (identical(other.totalExperience, totalExperience) ||
                other.totalExperience == totalExperience) &&
            (identical(other.stack, stack) || other.stack == stack) &&
            (identical(other.edu, edu) || other.edu == edu) &&
            (identical(other.verdict, verdict) || other.verdict == verdict) &&
            (identical(other.verdictColor, verdictColor) ||
                other.verdictColor == verdictColor) &&
            const DeepCollectionEquality().equals(other._criteria, _criteria) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dateAdded, dateAdded) ||
                other.dateAdded == dateAdded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    position,
    positionLabel,
    file,
    email,
    phone,
    city,
    tg,
    const DeepCollectionEquality().hash(_exp),
    totalExperience,
    stack,
    edu,
    verdict,
    verdictColor,
    const DeepCollectionEquality().hash(_criteria),
    summary,
    const DeepCollectionEquality().hash(_questions),
    status,
    dateAdded,
  ]);

  /// Create a copy of Candidate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CandidateImplCopyWith<_$CandidateImpl> get copyWith =>
      __$$CandidateImplCopyWithImpl<_$CandidateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CandidateImplToJson(this);
  }
}

abstract class _Candidate implements Candidate {
  const factory _Candidate({
    required final String id,
    required final String name,
    required final String position,
    @JsonKey(name: 'pos_label') required final String positionLabel,
    required final String file,
    required final String email,
    required final String phone,
    required final String city,
    required final String tg,
    @ExperienceConverter() required final List<Experience> exp,
    @JsonKey(name: 'total_exp') required final String totalExperience,
    required final String stack,
    required final String edu,
    required final Verdict verdict,
    @JsonKey(name: 'vc') required final VerdictColor verdictColor,
    @CriterionConverter() required final List<Criterion> criteria,
    required final String summary,
    required final List<String> questions,
    final CandidateStatus status,
    @JsonKey(name: 'date_added') final DateTime? dateAdded,
  }) = _$CandidateImpl;

  factory _Candidate.fromJson(Map<String, dynamic> json) =
      _$CandidateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get position;
  @override
  @JsonKey(name: 'pos_label')
  String get positionLabel;
  @override
  String get file;
  @override
  String get email;
  @override
  String get phone;
  @override
  String get city;
  @override
  String get tg;
  @override
  @ExperienceConverter()
  List<Experience> get exp;
  @override
  @JsonKey(name: 'total_exp')
  String get totalExperience;
  @override
  String get stack;
  @override
  String get edu;
  @override
  Verdict get verdict;
  @override
  @JsonKey(name: 'vc')
  VerdictColor get verdictColor;
  @override
  @CriterionConverter()
  List<Criterion> get criteria;
  @override
  String get summary;
  @override
  List<String> get questions;
  @override
  CandidateStatus get status;
  @override
  @JsonKey(name: 'date_added')
  DateTime? get dateAdded;

  /// Create a copy of Candidate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CandidateImplCopyWith<_$CandidateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Experience {
  String get period => throw _privateConstructorUsedError;
  String get company => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get duration => throw _privateConstructorUsedError;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExperienceCopyWith<Experience> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExperienceCopyWith<$Res> {
  factory $ExperienceCopyWith(
    Experience value,
    $Res Function(Experience) then,
  ) = _$ExperienceCopyWithImpl<$Res, Experience>;
  @useResult
  $Res call({String period, String company, String role, String duration});
}

/// @nodoc
class _$ExperienceCopyWithImpl<$Res, $Val extends Experience>
    implements $ExperienceCopyWith<$Res> {
  _$ExperienceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? company = null,
    Object? role = null,
    Object? duration = null,
  }) {
    return _then(
      _value.copyWith(
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
            company: null == company
                ? _value.company
                : company // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExperienceImplCopyWith<$Res>
    implements $ExperienceCopyWith<$Res> {
  factory _$$ExperienceImplCopyWith(
    _$ExperienceImpl value,
    $Res Function(_$ExperienceImpl) then,
  ) = __$$ExperienceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String period, String company, String role, String duration});
}

/// @nodoc
class __$$ExperienceImplCopyWithImpl<$Res>
    extends _$ExperienceCopyWithImpl<$Res, _$ExperienceImpl>
    implements _$$ExperienceImplCopyWith<$Res> {
  __$$ExperienceImplCopyWithImpl(
    _$ExperienceImpl _value,
    $Res Function(_$ExperienceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? company = null,
    Object? role = null,
    Object? duration = null,
  }) {
    return _then(
      _$ExperienceImpl(
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
        company: null == company
            ? _value.company
            : company // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ExperienceImpl implements _Experience {
  const _$ExperienceImpl({
    required this.period,
    required this.company,
    required this.role,
    required this.duration,
  });

  @override
  final String period;
  @override
  final String company;
  @override
  final String role;
  @override
  final String duration;

  @override
  String toString() {
    return 'Experience(period: $period, company: $company, role: $role, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExperienceImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, period, company, role, duration);

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExperienceImplCopyWith<_$ExperienceImpl> get copyWith =>
      __$$ExperienceImplCopyWithImpl<_$ExperienceImpl>(this, _$identity);
}

abstract class _Experience implements Experience {
  const factory _Experience({
    required final String period,
    required final String company,
    required final String role,
    required final String duration,
  }) = _$ExperienceImpl;

  @override
  String get period;
  @override
  String get company;
  @override
  String get role;
  @override
  String get duration;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExperienceImplCopyWith<_$ExperienceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Criterion {
  CriterionStatus get status => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  /// Create a copy of Criterion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CriterionCopyWith<Criterion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CriterionCopyWith<$Res> {
  factory $CriterionCopyWith(Criterion value, $Res Function(Criterion) then) =
      _$CriterionCopyWithImpl<$Res, Criterion>;
  @useResult
  $Res call({CriterionStatus status, String text});
}

/// @nodoc
class _$CriterionCopyWithImpl<$Res, $Val extends Criterion>
    implements $CriterionCopyWith<$Res> {
  _$CriterionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Criterion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? text = null}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as CriterionStatus,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CriterionImplCopyWith<$Res>
    implements $CriterionCopyWith<$Res> {
  factory _$$CriterionImplCopyWith(
    _$CriterionImpl value,
    $Res Function(_$CriterionImpl) then,
  ) = __$$CriterionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CriterionStatus status, String text});
}

/// @nodoc
class __$$CriterionImplCopyWithImpl<$Res>
    extends _$CriterionCopyWithImpl<$Res, _$CriterionImpl>
    implements _$$CriterionImplCopyWith<$Res> {
  __$$CriterionImplCopyWithImpl(
    _$CriterionImpl _value,
    $Res Function(_$CriterionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Criterion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? text = null}) {
    return _then(
      _$CriterionImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as CriterionStatus,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CriterionImpl implements _Criterion {
  const _$CriterionImpl({required this.status, required this.text});

  @override
  final CriterionStatus status;
  @override
  final String text;

  @override
  String toString() {
    return 'Criterion(status: $status, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CriterionImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, text);

  /// Create a copy of Criterion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CriterionImplCopyWith<_$CriterionImpl> get copyWith =>
      __$$CriterionImplCopyWithImpl<_$CriterionImpl>(this, _$identity);
}

abstract class _Criterion implements Criterion {
  const factory _Criterion({
    required final CriterionStatus status,
    required final String text,
  }) = _$CriterionImpl;

  @override
  CriterionStatus get status;
  @override
  String get text;

  /// Create a copy of Criterion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CriterionImplCopyWith<_$CriterionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
