// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoleScore {

 double? get opd; double? get walidata; double? get admin;
/// Create a copy of RoleScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleScoreCopyWith<RoleScore> get copyWith => _$RoleScoreCopyWithImpl<RoleScore>(this as RoleScore, _$identity);

  /// Serializes this RoleScore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleScore&&(identical(other.opd, opd) || other.opd == opd)&&(identical(other.walidata, walidata) || other.walidata == walidata)&&(identical(other.admin, admin) || other.admin == admin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opd,walidata,admin);

@override
String toString() {
  return 'RoleScore(opd: $opd, walidata: $walidata, admin: $admin)';
}


}

/// @nodoc
abstract mixin class $RoleScoreCopyWith<$Res>  {
  factory $RoleScoreCopyWith(RoleScore value, $Res Function(RoleScore) _then) = _$RoleScoreCopyWithImpl;
@useResult
$Res call({
 double? opd, double? walidata, double? admin
});




}
/// @nodoc
class _$RoleScoreCopyWithImpl<$Res>
    implements $RoleScoreCopyWith<$Res> {
  _$RoleScoreCopyWithImpl(this._self, this._then);

  final RoleScore _self;
  final $Res Function(RoleScore) _then;

/// Create a copy of RoleScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? opd = freezed,Object? walidata = freezed,Object? admin = freezed,}) {
  return _then(_self.copyWith(
opd: freezed == opd ? _self.opd : opd // ignore: cast_nullable_to_non_nullable
as double?,walidata: freezed == walidata ? _self.walidata : walidata // ignore: cast_nullable_to_non_nullable
as double?,admin: freezed == admin ? _self.admin : admin // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoleScore].
extension RoleScorePatterns on RoleScore {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleScore() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleScore value)  $default,){
final _that = this;
switch (_that) {
case _RoleScore():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleScore value)?  $default,){
final _that = this;
switch (_that) {
case _RoleScore() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? opd,  double? walidata,  double? admin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoleScore() when $default != null:
return $default(_that.opd,_that.walidata,_that.admin);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? opd,  double? walidata,  double? admin)  $default,) {final _that = this;
switch (_that) {
case _RoleScore():
return $default(_that.opd,_that.walidata,_that.admin);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? opd,  double? walidata,  double? admin)?  $default,) {final _that = this;
switch (_that) {
case _RoleScore() when $default != null:
return $default(_that.opd,_that.walidata,_that.admin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoleScore implements RoleScore {
  const _RoleScore({this.opd, this.walidata, this.admin});
  factory _RoleScore.fromJson(Map<String, dynamic> json) => _$RoleScoreFromJson(json);

@override final  double? opd;
@override final  double? walidata;
@override final  double? admin;

/// Create a copy of RoleScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleScoreCopyWith<_RoleScore> get copyWith => __$RoleScoreCopyWithImpl<_RoleScore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoleScoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleScore&&(identical(other.opd, opd) || other.opd == opd)&&(identical(other.walidata, walidata) || other.walidata == walidata)&&(identical(other.admin, admin) || other.admin == admin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opd,walidata,admin);

@override
String toString() {
  return 'RoleScore(opd: $opd, walidata: $walidata, admin: $admin)';
}


}

/// @nodoc
abstract mixin class _$RoleScoreCopyWith<$Res> implements $RoleScoreCopyWith<$Res> {
  factory _$RoleScoreCopyWith(_RoleScore value, $Res Function(_RoleScore) _then) = __$RoleScoreCopyWithImpl;
@override @useResult
$Res call({
 double? opd, double? walidata, double? admin
});




}
/// @nodoc
class __$RoleScoreCopyWithImpl<$Res>
    implements _$RoleScoreCopyWith<$Res> {
  __$RoleScoreCopyWithImpl(this._self, this._then);

  final _RoleScore _self;
  final $Res Function(_RoleScore) _then;

/// Create a copy of RoleScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? opd = freezed,Object? walidata = freezed,Object? admin = freezed,}) {
  return _then(_RoleScore(
opd: freezed == opd ? _self.opd : opd // ignore: cast_nullable_to_non_nullable
as double?,walidata: freezed == walidata ? _self.walidata : walidata // ignore: cast_nullable_to_non_nullable
as double?,admin: freezed == admin ? _self.admin : admin // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$PendingIndicatorPreview {

 int get id;@JsonKey(name: 'nama') String get name; String get domain;@JsonKey(name: 'aspek') String get aspect;@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'user_name') String get userName;
/// Create a copy of PendingIndicatorPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingIndicatorPreviewCopyWith<PendingIndicatorPreview> get copyWith => _$PendingIndicatorPreviewCopyWithImpl<PendingIndicatorPreview>(this as PendingIndicatorPreview, _$identity);

  /// Serializes this PendingIndicatorPreview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingIndicatorPreview&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.aspect, aspect) || other.aspect == aspect)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,domain,aspect,userId,userName);

@override
String toString() {
  return 'PendingIndicatorPreview(id: $id, name: $name, domain: $domain, aspect: $aspect, userId: $userId, userName: $userName)';
}


}

/// @nodoc
abstract mixin class $PendingIndicatorPreviewCopyWith<$Res>  {
  factory $PendingIndicatorPreviewCopyWith(PendingIndicatorPreview value, $Res Function(PendingIndicatorPreview) _then) = _$PendingIndicatorPreviewCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'nama') String name, String domain,@JsonKey(name: 'aspek') String aspect,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'user_name') String userName
});




}
/// @nodoc
class _$PendingIndicatorPreviewCopyWithImpl<$Res>
    implements $PendingIndicatorPreviewCopyWith<$Res> {
  _$PendingIndicatorPreviewCopyWithImpl(this._self, this._then);

  final PendingIndicatorPreview _self;
  final $Res Function(PendingIndicatorPreview) _then;

/// Create a copy of PendingIndicatorPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? domain = null,Object? aspect = null,Object? userId = null,Object? userName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,aspect: null == aspect ? _self.aspect : aspect // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingIndicatorPreview].
extension PendingIndicatorPreviewPatterns on PendingIndicatorPreview {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingIndicatorPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingIndicatorPreview() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingIndicatorPreview value)  $default,){
final _that = this;
switch (_that) {
case _PendingIndicatorPreview():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingIndicatorPreview value)?  $default,){
final _that = this;
switch (_that) {
case _PendingIndicatorPreview() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama')  String name,  String domain, @JsonKey(name: 'aspek')  String aspect, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'user_name')  String userName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingIndicatorPreview() when $default != null:
return $default(_that.id,_that.name,_that.domain,_that.aspect,_that.userId,_that.userName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama')  String name,  String domain, @JsonKey(name: 'aspek')  String aspect, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'user_name')  String userName)  $default,) {final _that = this;
switch (_that) {
case _PendingIndicatorPreview():
return $default(_that.id,_that.name,_that.domain,_that.aspect,_that.userId,_that.userName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'nama')  String name,  String domain, @JsonKey(name: 'aspek')  String aspect, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'user_name')  String userName)?  $default,) {final _that = this;
switch (_that) {
case _PendingIndicatorPreview() when $default != null:
return $default(_that.id,_that.name,_that.domain,_that.aspect,_that.userId,_that.userName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingIndicatorPreview implements PendingIndicatorPreview {
  const _PendingIndicatorPreview({required this.id, @JsonKey(name: 'nama') required this.name, required this.domain, @JsonKey(name: 'aspek') required this.aspect, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'user_name') required this.userName});
  factory _PendingIndicatorPreview.fromJson(Map<String, dynamic> json) => _$PendingIndicatorPreviewFromJson(json);

@override final  int id;
@override@JsonKey(name: 'nama') final  String name;
@override final  String domain;
@override@JsonKey(name: 'aspek') final  String aspect;
@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'user_name') final  String userName;

/// Create a copy of PendingIndicatorPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingIndicatorPreviewCopyWith<_PendingIndicatorPreview> get copyWith => __$PendingIndicatorPreviewCopyWithImpl<_PendingIndicatorPreview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingIndicatorPreviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingIndicatorPreview&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.aspect, aspect) || other.aspect == aspect)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,domain,aspect,userId,userName);

@override
String toString() {
  return 'PendingIndicatorPreview(id: $id, name: $name, domain: $domain, aspect: $aspect, userId: $userId, userName: $userName)';
}


}

/// @nodoc
abstract mixin class _$PendingIndicatorPreviewCopyWith<$Res> implements $PendingIndicatorPreviewCopyWith<$Res> {
  factory _$PendingIndicatorPreviewCopyWith(_PendingIndicatorPreview value, $Res Function(_PendingIndicatorPreview) _then) = __$PendingIndicatorPreviewCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'nama') String name, String domain,@JsonKey(name: 'aspek') String aspect,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'user_name') String userName
});




}
/// @nodoc
class __$PendingIndicatorPreviewCopyWithImpl<$Res>
    implements _$PendingIndicatorPreviewCopyWith<$Res> {
  __$PendingIndicatorPreviewCopyWithImpl(this._self, this._then);

  final _PendingIndicatorPreview _self;
  final $Res Function(_PendingIndicatorPreview) _then;

/// Create a copy of PendingIndicatorPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? domain = null,Object? aspect = null,Object? userId = null,Object? userName = null,}) {
  return _then(_PendingIndicatorPreview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,aspect: null == aspect ? _self.aspect : aspect // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReviewProgressSummary {

@JsonKey(name: 'total_indicators') int get totalIndicators;@JsonKey(name: 'corrected_count') int get correctedCount;@FlexibleDoubleConverter() double get percentage;@JsonKey(name: 'final_correction_score') double? get finalCorrectionScore;@JsonKey(name: 'pending_indicator_preview') List<PendingIndicatorPreview> get pendingIndicatorPreview;
/// Create a copy of ReviewProgressSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewProgressSummaryCopyWith<ReviewProgressSummary> get copyWith => _$ReviewProgressSummaryCopyWithImpl<ReviewProgressSummary>(this as ReviewProgressSummary, _$identity);

  /// Serializes this ReviewProgressSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewProgressSummary&&(identical(other.totalIndicators, totalIndicators) || other.totalIndicators == totalIndicators)&&(identical(other.correctedCount, correctedCount) || other.correctedCount == correctedCount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.finalCorrectionScore, finalCorrectionScore) || other.finalCorrectionScore == finalCorrectionScore)&&const DeepCollectionEquality().equals(other.pendingIndicatorPreview, pendingIndicatorPreview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIndicators,correctedCount,percentage,finalCorrectionScore,const DeepCollectionEquality().hash(pendingIndicatorPreview));

@override
String toString() {
  return 'ReviewProgressSummary(totalIndicators: $totalIndicators, correctedCount: $correctedCount, percentage: $percentage, finalCorrectionScore: $finalCorrectionScore, pendingIndicatorPreview: $pendingIndicatorPreview)';
}


}

/// @nodoc
abstract mixin class $ReviewProgressSummaryCopyWith<$Res>  {
  factory $ReviewProgressSummaryCopyWith(ReviewProgressSummary value, $Res Function(ReviewProgressSummary) _then) = _$ReviewProgressSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_indicators') int totalIndicators,@JsonKey(name: 'corrected_count') int correctedCount,@FlexibleDoubleConverter() double percentage,@JsonKey(name: 'final_correction_score') double? finalCorrectionScore,@JsonKey(name: 'pending_indicator_preview') List<PendingIndicatorPreview> pendingIndicatorPreview
});




}
/// @nodoc
class _$ReviewProgressSummaryCopyWithImpl<$Res>
    implements $ReviewProgressSummaryCopyWith<$Res> {
  _$ReviewProgressSummaryCopyWithImpl(this._self, this._then);

  final ReviewProgressSummary _self;
  final $Res Function(ReviewProgressSummary) _then;

/// Create a copy of ReviewProgressSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIndicators = null,Object? correctedCount = null,Object? percentage = null,Object? finalCorrectionScore = freezed,Object? pendingIndicatorPreview = null,}) {
  return _then(_self.copyWith(
totalIndicators: null == totalIndicators ? _self.totalIndicators : totalIndicators // ignore: cast_nullable_to_non_nullable
as int,correctedCount: null == correctedCount ? _self.correctedCount : correctedCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,finalCorrectionScore: freezed == finalCorrectionScore ? _self.finalCorrectionScore : finalCorrectionScore // ignore: cast_nullable_to_non_nullable
as double?,pendingIndicatorPreview: null == pendingIndicatorPreview ? _self.pendingIndicatorPreview : pendingIndicatorPreview // ignore: cast_nullable_to_non_nullable
as List<PendingIndicatorPreview>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewProgressSummary].
extension ReviewProgressSummaryPatterns on ReviewProgressSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewProgressSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewProgressSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewProgressSummary value)  $default,){
final _that = this;
switch (_that) {
case _ReviewProgressSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewProgressSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewProgressSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_indicators')  int totalIndicators, @JsonKey(name: 'corrected_count')  int correctedCount, @FlexibleDoubleConverter()  double percentage, @JsonKey(name: 'final_correction_score')  double? finalCorrectionScore, @JsonKey(name: 'pending_indicator_preview')  List<PendingIndicatorPreview> pendingIndicatorPreview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewProgressSummary() when $default != null:
return $default(_that.totalIndicators,_that.correctedCount,_that.percentage,_that.finalCorrectionScore,_that.pendingIndicatorPreview);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_indicators')  int totalIndicators, @JsonKey(name: 'corrected_count')  int correctedCount, @FlexibleDoubleConverter()  double percentage, @JsonKey(name: 'final_correction_score')  double? finalCorrectionScore, @JsonKey(name: 'pending_indicator_preview')  List<PendingIndicatorPreview> pendingIndicatorPreview)  $default,) {final _that = this;
switch (_that) {
case _ReviewProgressSummary():
return $default(_that.totalIndicators,_that.correctedCount,_that.percentage,_that.finalCorrectionScore,_that.pendingIndicatorPreview);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_indicators')  int totalIndicators, @JsonKey(name: 'corrected_count')  int correctedCount, @FlexibleDoubleConverter()  double percentage, @JsonKey(name: 'final_correction_score')  double? finalCorrectionScore, @JsonKey(name: 'pending_indicator_preview')  List<PendingIndicatorPreview> pendingIndicatorPreview)?  $default,) {final _that = this;
switch (_that) {
case _ReviewProgressSummary() when $default != null:
return $default(_that.totalIndicators,_that.correctedCount,_that.percentage,_that.finalCorrectionScore,_that.pendingIndicatorPreview);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewProgressSummary implements ReviewProgressSummary {
  const _ReviewProgressSummary({@JsonKey(name: 'total_indicators') required this.totalIndicators, @JsonKey(name: 'corrected_count') required this.correctedCount, @FlexibleDoubleConverter() this.percentage = 0, @JsonKey(name: 'final_correction_score') this.finalCorrectionScore, @JsonKey(name: 'pending_indicator_preview') final  List<PendingIndicatorPreview> pendingIndicatorPreview = const <PendingIndicatorPreview>[]}): _pendingIndicatorPreview = pendingIndicatorPreview;
  factory _ReviewProgressSummary.fromJson(Map<String, dynamic> json) => _$ReviewProgressSummaryFromJson(json);

@override@JsonKey(name: 'total_indicators') final  int totalIndicators;
@override@JsonKey(name: 'corrected_count') final  int correctedCount;
@override@JsonKey()@FlexibleDoubleConverter() final  double percentage;
@override@JsonKey(name: 'final_correction_score') final  double? finalCorrectionScore;
 final  List<PendingIndicatorPreview> _pendingIndicatorPreview;
@override@JsonKey(name: 'pending_indicator_preview') List<PendingIndicatorPreview> get pendingIndicatorPreview {
  if (_pendingIndicatorPreview is EqualUnmodifiableListView) return _pendingIndicatorPreview;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingIndicatorPreview);
}


/// Create a copy of ReviewProgressSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewProgressSummaryCopyWith<_ReviewProgressSummary> get copyWith => __$ReviewProgressSummaryCopyWithImpl<_ReviewProgressSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewProgressSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewProgressSummary&&(identical(other.totalIndicators, totalIndicators) || other.totalIndicators == totalIndicators)&&(identical(other.correctedCount, correctedCount) || other.correctedCount == correctedCount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.finalCorrectionScore, finalCorrectionScore) || other.finalCorrectionScore == finalCorrectionScore)&&const DeepCollectionEquality().equals(other._pendingIndicatorPreview, _pendingIndicatorPreview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIndicators,correctedCount,percentage,finalCorrectionScore,const DeepCollectionEquality().hash(_pendingIndicatorPreview));

@override
String toString() {
  return 'ReviewProgressSummary(totalIndicators: $totalIndicators, correctedCount: $correctedCount, percentage: $percentage, finalCorrectionScore: $finalCorrectionScore, pendingIndicatorPreview: $pendingIndicatorPreview)';
}


}

/// @nodoc
abstract mixin class _$ReviewProgressSummaryCopyWith<$Res> implements $ReviewProgressSummaryCopyWith<$Res> {
  factory _$ReviewProgressSummaryCopyWith(_ReviewProgressSummary value, $Res Function(_ReviewProgressSummary) _then) = __$ReviewProgressSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_indicators') int totalIndicators,@JsonKey(name: 'corrected_count') int correctedCount,@FlexibleDoubleConverter() double percentage,@JsonKey(name: 'final_correction_score') double? finalCorrectionScore,@JsonKey(name: 'pending_indicator_preview') List<PendingIndicatorPreview> pendingIndicatorPreview
});




}
/// @nodoc
class __$ReviewProgressSummaryCopyWithImpl<$Res>
    implements _$ReviewProgressSummaryCopyWith<$Res> {
  __$ReviewProgressSummaryCopyWithImpl(this._self, this._then);

  final _ReviewProgressSummary _self;
  final $Res Function(_ReviewProgressSummary) _then;

/// Create a copy of ReviewProgressSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIndicators = null,Object? correctedCount = null,Object? percentage = null,Object? finalCorrectionScore = freezed,Object? pendingIndicatorPreview = null,}) {
  return _then(_ReviewProgressSummary(
totalIndicators: null == totalIndicators ? _self.totalIndicators : totalIndicators // ignore: cast_nullable_to_non_nullable
as int,correctedCount: null == correctedCount ? _self.correctedCount : correctedCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,finalCorrectionScore: freezed == finalCorrectionScore ? _self.finalCorrectionScore : finalCorrectionScore // ignore: cast_nullable_to_non_nullable
as double?,pendingIndicatorPreview: null == pendingIndicatorPreview ? _self._pendingIndicatorPreview : pendingIndicatorPreview // ignore: cast_nullable_to_non_nullable
as List<PendingIndicatorPreview>,
  ));
}


}


/// @nodoc
mixin _$AspectModel {

 String get id;@JsonKey(name: 'nama_aspek') String get name;@JsonKey(name: 'indikator') List<IndicatorModel> get indicators; RoleScore? get scores;
/// Create a copy of AspectModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AspectModelCopyWith<AspectModel> get copyWith => _$AspectModelCopyWithImpl<AspectModel>(this as AspectModel, _$identity);

  /// Serializes this AspectModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AspectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.indicators, indicators)&&(identical(other.scores, scores) || other.scores == scores));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(indicators),scores);

@override
String toString() {
  return 'AspectModel(id: $id, name: $name, indicators: $indicators, scores: $scores)';
}


}

/// @nodoc
abstract mixin class $AspectModelCopyWith<$Res>  {
  factory $AspectModelCopyWith(AspectModel value, $Res Function(AspectModel) _then) = _$AspectModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'nama_aspek') String name,@JsonKey(name: 'indikator') List<IndicatorModel> indicators, RoleScore? scores
});


$RoleScoreCopyWith<$Res>? get scores;

}
/// @nodoc
class _$AspectModelCopyWithImpl<$Res>
    implements $AspectModelCopyWith<$Res> {
  _$AspectModelCopyWithImpl(this._self, this._then);

  final AspectModel _self;
  final $Res Function(AspectModel) _then;

/// Create a copy of AspectModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? indicators = null,Object? scores = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,indicators: null == indicators ? _self.indicators : indicators // ignore: cast_nullable_to_non_nullable
as List<IndicatorModel>,scores: freezed == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as RoleScore?,
  ));
}
/// Create a copy of AspectModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleScoreCopyWith<$Res>? get scores {
    if (_self.scores == null) {
    return null;
  }

  return $RoleScoreCopyWith<$Res>(_self.scores!, (value) {
    return _then(_self.copyWith(scores: value));
  });
}
}


/// Adds pattern-matching-related methods to [AspectModel].
extension AspectModelPatterns on AspectModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AspectModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AspectModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AspectModel value)  $default,){
final _that = this;
switch (_that) {
case _AspectModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AspectModel value)?  $default,){
final _that = this;
switch (_that) {
case _AspectModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'nama_aspek')  String name, @JsonKey(name: 'indikator')  List<IndicatorModel> indicators,  RoleScore? scores)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AspectModel() when $default != null:
return $default(_that.id,_that.name,_that.indicators,_that.scores);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'nama_aspek')  String name, @JsonKey(name: 'indikator')  List<IndicatorModel> indicators,  RoleScore? scores)  $default,) {final _that = this;
switch (_that) {
case _AspectModel():
return $default(_that.id,_that.name,_that.indicators,_that.scores);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'nama_aspek')  String name, @JsonKey(name: 'indikator')  List<IndicatorModel> indicators,  RoleScore? scores)?  $default,) {final _that = this;
switch (_that) {
case _AspectModel() when $default != null:
return $default(_that.id,_that.name,_that.indicators,_that.scores);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AspectModel implements AspectModel {
  const _AspectModel({required this.id, @JsonKey(name: 'nama_aspek') required this.name, @JsonKey(name: 'indikator') final  List<IndicatorModel> indicators = const <IndicatorModel>[], this.scores}): _indicators = indicators;
  factory _AspectModel.fromJson(Map<String, dynamic> json) => _$AspectModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'nama_aspek') final  String name;
 final  List<IndicatorModel> _indicators;
@override@JsonKey(name: 'indikator') List<IndicatorModel> get indicators {
  if (_indicators is EqualUnmodifiableListView) return _indicators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_indicators);
}

@override final  RoleScore? scores;

/// Create a copy of AspectModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AspectModelCopyWith<_AspectModel> get copyWith => __$AspectModelCopyWithImpl<_AspectModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AspectModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AspectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._indicators, _indicators)&&(identical(other.scores, scores) || other.scores == scores));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_indicators),scores);

@override
String toString() {
  return 'AspectModel(id: $id, name: $name, indicators: $indicators, scores: $scores)';
}


}

/// @nodoc
abstract mixin class _$AspectModelCopyWith<$Res> implements $AspectModelCopyWith<$Res> {
  factory _$AspectModelCopyWith(_AspectModel value, $Res Function(_AspectModel) _then) = __$AspectModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'nama_aspek') String name,@JsonKey(name: 'indikator') List<IndicatorModel> indicators, RoleScore? scores
});


@override $RoleScoreCopyWith<$Res>? get scores;

}
/// @nodoc
class __$AspectModelCopyWithImpl<$Res>
    implements _$AspectModelCopyWith<$Res> {
  __$AspectModelCopyWithImpl(this._self, this._then);

  final _AspectModel _self;
  final $Res Function(_AspectModel) _then;

/// Create a copy of AspectModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? indicators = null,Object? scores = freezed,}) {
  return _then(_AspectModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,indicators: null == indicators ? _self._indicators : indicators // ignore: cast_nullable_to_non_nullable
as List<IndicatorModel>,scores: freezed == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as RoleScore?,
  ));
}

/// Create a copy of AspectModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleScoreCopyWith<$Res>? get scores {
    if (_self.scores == null) {
    return null;
  }

  return $RoleScoreCopyWith<$Res>(_self.scores!, (value) {
    return _then(_self.copyWith(scores: value));
  });
}
}


/// @nodoc
mixin _$DomainModel {

 String get id;@JsonKey(name: 'nama_domain') String get name;@JsonKey(name: 'updated_at') DateTime get date;@JsonKey(name: 'aspek') List<AspectModel> get aspects; int get indicatorCount; RoleScore? get scores;
/// Create a copy of DomainModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DomainModelCopyWith<DomainModel> get copyWith => _$DomainModelCopyWithImpl<DomainModel>(this as DomainModel, _$identity);

  /// Serializes this DomainModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DomainModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.aspects, aspects)&&(identical(other.indicatorCount, indicatorCount) || other.indicatorCount == indicatorCount)&&(identical(other.scores, scores) || other.scores == scores));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,date,const DeepCollectionEquality().hash(aspects),indicatorCount,scores);

@override
String toString() {
  return 'DomainModel(id: $id, name: $name, date: $date, aspects: $aspects, indicatorCount: $indicatorCount, scores: $scores)';
}


}

/// @nodoc
abstract mixin class $DomainModelCopyWith<$Res>  {
  factory $DomainModelCopyWith(DomainModel value, $Res Function(DomainModel) _then) = _$DomainModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'nama_domain') String name,@JsonKey(name: 'updated_at') DateTime date,@JsonKey(name: 'aspek') List<AspectModel> aspects, int indicatorCount, RoleScore? scores
});


$RoleScoreCopyWith<$Res>? get scores;

}
/// @nodoc
class _$DomainModelCopyWithImpl<$Res>
    implements $DomainModelCopyWith<$Res> {
  _$DomainModelCopyWithImpl(this._self, this._then);

  final DomainModel _self;
  final $Res Function(DomainModel) _then;

/// Create a copy of DomainModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? date = null,Object? aspects = null,Object? indicatorCount = null,Object? scores = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,aspects: null == aspects ? _self.aspects : aspects // ignore: cast_nullable_to_non_nullable
as List<AspectModel>,indicatorCount: null == indicatorCount ? _self.indicatorCount : indicatorCount // ignore: cast_nullable_to_non_nullable
as int,scores: freezed == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as RoleScore?,
  ));
}
/// Create a copy of DomainModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleScoreCopyWith<$Res>? get scores {
    if (_self.scores == null) {
    return null;
  }

  return $RoleScoreCopyWith<$Res>(_self.scores!, (value) {
    return _then(_self.copyWith(scores: value));
  });
}
}


/// Adds pattern-matching-related methods to [DomainModel].
extension DomainModelPatterns on DomainModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DomainModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DomainModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DomainModel value)  $default,){
final _that = this;
switch (_that) {
case _DomainModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DomainModel value)?  $default,){
final _that = this;
switch (_that) {
case _DomainModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'nama_domain')  String name, @JsonKey(name: 'updated_at')  DateTime date, @JsonKey(name: 'aspek')  List<AspectModel> aspects,  int indicatorCount,  RoleScore? scores)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DomainModel() when $default != null:
return $default(_that.id,_that.name,_that.date,_that.aspects,_that.indicatorCount,_that.scores);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'nama_domain')  String name, @JsonKey(name: 'updated_at')  DateTime date, @JsonKey(name: 'aspek')  List<AspectModel> aspects,  int indicatorCount,  RoleScore? scores)  $default,) {final _that = this;
switch (_that) {
case _DomainModel():
return $default(_that.id,_that.name,_that.date,_that.aspects,_that.indicatorCount,_that.scores);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'nama_domain')  String name, @JsonKey(name: 'updated_at')  DateTime date, @JsonKey(name: 'aspek')  List<AspectModel> aspects,  int indicatorCount,  RoleScore? scores)?  $default,) {final _that = this;
switch (_that) {
case _DomainModel() when $default != null:
return $default(_that.id,_that.name,_that.date,_that.aspects,_that.indicatorCount,_that.scores);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DomainModel extends DomainModel {
  const _DomainModel({required this.id, @JsonKey(name: 'nama_domain') required this.name, @JsonKey(name: 'updated_at') required this.date, @JsonKey(name: 'aspek') required final  List<AspectModel> aspects, required this.indicatorCount, this.scores}): _aspects = aspects,super._();
  factory _DomainModel.fromJson(Map<String, dynamic> json) => _$DomainModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'nama_domain') final  String name;
@override@JsonKey(name: 'updated_at') final  DateTime date;
 final  List<AspectModel> _aspects;
@override@JsonKey(name: 'aspek') List<AspectModel> get aspects {
  if (_aspects is EqualUnmodifiableListView) return _aspects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aspects);
}

@override final  int indicatorCount;
@override final  RoleScore? scores;

/// Create a copy of DomainModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DomainModelCopyWith<_DomainModel> get copyWith => __$DomainModelCopyWithImpl<_DomainModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DomainModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DomainModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._aspects, _aspects)&&(identical(other.indicatorCount, indicatorCount) || other.indicatorCount == indicatorCount)&&(identical(other.scores, scores) || other.scores == scores));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,date,const DeepCollectionEquality().hash(_aspects),indicatorCount,scores);

@override
String toString() {
  return 'DomainModel(id: $id, name: $name, date: $date, aspects: $aspects, indicatorCount: $indicatorCount, scores: $scores)';
}


}

/// @nodoc
abstract mixin class _$DomainModelCopyWith<$Res> implements $DomainModelCopyWith<$Res> {
  factory _$DomainModelCopyWith(_DomainModel value, $Res Function(_DomainModel) _then) = __$DomainModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'nama_domain') String name,@JsonKey(name: 'updated_at') DateTime date,@JsonKey(name: 'aspek') List<AspectModel> aspects, int indicatorCount, RoleScore? scores
});


@override $RoleScoreCopyWith<$Res>? get scores;

}
/// @nodoc
class __$DomainModelCopyWithImpl<$Res>
    implements _$DomainModelCopyWith<$Res> {
  __$DomainModelCopyWithImpl(this._self, this._then);

  final _DomainModel _self;
  final $Res Function(_DomainModel) _then;

/// Create a copy of DomainModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? date = null,Object? aspects = null,Object? indicatorCount = null,Object? scores = freezed,}) {
  return _then(_DomainModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,aspects: null == aspects ? _self._aspects : aspects // ignore: cast_nullable_to_non_nullable
as List<AspectModel>,indicatorCount: null == indicatorCount ? _self.indicatorCount : indicatorCount // ignore: cast_nullable_to_non_nullable
as int,scores: freezed == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as RoleScore?,
  ));
}

/// Create a copy of DomainModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleScoreCopyWith<$Res>? get scores {
    if (_self.scores == null) {
    return null;
  }

  return $RoleScoreCopyWith<$Res>(_self.scores!, (value) {
    return _then(_self.copyWith(scores: value));
  });
}
}


/// @nodoc
mixin _$AssessmentFormModel {

 String get id;@JsonKey(name: 'nama_formulir') String get title;@JsonKey(name: 'created_at') DateTime get date; List<DomainModel> get domains;@JsonKey(name: 'participating_opd_count') int get opdCount; RoleScore? get scores;@JsonKey(name: 'review_progress') ReviewProgressSummary? get reviewProgress;
/// Create a copy of AssessmentFormModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssessmentFormModelCopyWith<AssessmentFormModel> get copyWith => _$AssessmentFormModelCopyWithImpl<AssessmentFormModel>(this as AssessmentFormModel, _$identity);

  /// Serializes this AssessmentFormModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssessmentFormModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.domains, domains)&&(identical(other.opdCount, opdCount) || other.opdCount == opdCount)&&(identical(other.scores, scores) || other.scores == scores)&&(identical(other.reviewProgress, reviewProgress) || other.reviewProgress == reviewProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,date,const DeepCollectionEquality().hash(domains),opdCount,scores,reviewProgress);

@override
String toString() {
  return 'AssessmentFormModel(id: $id, title: $title, date: $date, domains: $domains, opdCount: $opdCount, scores: $scores, reviewProgress: $reviewProgress)';
}


}

/// @nodoc
abstract mixin class $AssessmentFormModelCopyWith<$Res>  {
  factory $AssessmentFormModelCopyWith(AssessmentFormModel value, $Res Function(AssessmentFormModel) _then) = _$AssessmentFormModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'nama_formulir') String title,@JsonKey(name: 'created_at') DateTime date, List<DomainModel> domains,@JsonKey(name: 'participating_opd_count') int opdCount, RoleScore? scores,@JsonKey(name: 'review_progress') ReviewProgressSummary? reviewProgress
});


$RoleScoreCopyWith<$Res>? get scores;$ReviewProgressSummaryCopyWith<$Res>? get reviewProgress;

}
/// @nodoc
class _$AssessmentFormModelCopyWithImpl<$Res>
    implements $AssessmentFormModelCopyWith<$Res> {
  _$AssessmentFormModelCopyWithImpl(this._self, this._then);

  final AssessmentFormModel _self;
  final $Res Function(AssessmentFormModel) _then;

/// Create a copy of AssessmentFormModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? date = null,Object? domains = null,Object? opdCount = null,Object? scores = freezed,Object? reviewProgress = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,domains: null == domains ? _self.domains : domains // ignore: cast_nullable_to_non_nullable
as List<DomainModel>,opdCount: null == opdCount ? _self.opdCount : opdCount // ignore: cast_nullable_to_non_nullable
as int,scores: freezed == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as RoleScore?,reviewProgress: freezed == reviewProgress ? _self.reviewProgress : reviewProgress // ignore: cast_nullable_to_non_nullable
as ReviewProgressSummary?,
  ));
}
/// Create a copy of AssessmentFormModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleScoreCopyWith<$Res>? get scores {
    if (_self.scores == null) {
    return null;
  }

  return $RoleScoreCopyWith<$Res>(_self.scores!, (value) {
    return _then(_self.copyWith(scores: value));
  });
}/// Create a copy of AssessmentFormModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewProgressSummaryCopyWith<$Res>? get reviewProgress {
    if (_self.reviewProgress == null) {
    return null;
  }

  return $ReviewProgressSummaryCopyWith<$Res>(_self.reviewProgress!, (value) {
    return _then(_self.copyWith(reviewProgress: value));
  });
}
}


/// Adds pattern-matching-related methods to [AssessmentFormModel].
extension AssessmentFormModelPatterns on AssessmentFormModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssessmentFormModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssessmentFormModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssessmentFormModel value)  $default,){
final _that = this;
switch (_that) {
case _AssessmentFormModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssessmentFormModel value)?  $default,){
final _that = this;
switch (_that) {
case _AssessmentFormModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'nama_formulir')  String title, @JsonKey(name: 'created_at')  DateTime date,  List<DomainModel> domains, @JsonKey(name: 'participating_opd_count')  int opdCount,  RoleScore? scores, @JsonKey(name: 'review_progress')  ReviewProgressSummary? reviewProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssessmentFormModel() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.domains,_that.opdCount,_that.scores,_that.reviewProgress);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'nama_formulir')  String title, @JsonKey(name: 'created_at')  DateTime date,  List<DomainModel> domains, @JsonKey(name: 'participating_opd_count')  int opdCount,  RoleScore? scores, @JsonKey(name: 'review_progress')  ReviewProgressSummary? reviewProgress)  $default,) {final _that = this;
switch (_that) {
case _AssessmentFormModel():
return $default(_that.id,_that.title,_that.date,_that.domains,_that.opdCount,_that.scores,_that.reviewProgress);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'nama_formulir')  String title, @JsonKey(name: 'created_at')  DateTime date,  List<DomainModel> domains, @JsonKey(name: 'participating_opd_count')  int opdCount,  RoleScore? scores, @JsonKey(name: 'review_progress')  ReviewProgressSummary? reviewProgress)?  $default,) {final _that = this;
switch (_that) {
case _AssessmentFormModel() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.domains,_that.opdCount,_that.scores,_that.reviewProgress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssessmentFormModel extends AssessmentFormModel {
  const _AssessmentFormModel({required this.id, @JsonKey(name: 'nama_formulir') required this.title, @JsonKey(name: 'created_at') required this.date, required final  List<DomainModel> domains, @JsonKey(name: 'participating_opd_count') this.opdCount = 0, this.scores, @JsonKey(name: 'review_progress') this.reviewProgress}): _domains = domains,super._();
  factory _AssessmentFormModel.fromJson(Map<String, dynamic> json) => _$AssessmentFormModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'nama_formulir') final  String title;
@override@JsonKey(name: 'created_at') final  DateTime date;
 final  List<DomainModel> _domains;
@override List<DomainModel> get domains {
  if (_domains is EqualUnmodifiableListView) return _domains;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_domains);
}

@override@JsonKey(name: 'participating_opd_count') final  int opdCount;
@override final  RoleScore? scores;
@override@JsonKey(name: 'review_progress') final  ReviewProgressSummary? reviewProgress;

/// Create a copy of AssessmentFormModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssessmentFormModelCopyWith<_AssessmentFormModel> get copyWith => __$AssessmentFormModelCopyWithImpl<_AssessmentFormModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssessmentFormModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssessmentFormModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._domains, _domains)&&(identical(other.opdCount, opdCount) || other.opdCount == opdCount)&&(identical(other.scores, scores) || other.scores == scores)&&(identical(other.reviewProgress, reviewProgress) || other.reviewProgress == reviewProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,date,const DeepCollectionEquality().hash(_domains),opdCount,scores,reviewProgress);

@override
String toString() {
  return 'AssessmentFormModel(id: $id, title: $title, date: $date, domains: $domains, opdCount: $opdCount, scores: $scores, reviewProgress: $reviewProgress)';
}


}

/// @nodoc
abstract mixin class _$AssessmentFormModelCopyWith<$Res> implements $AssessmentFormModelCopyWith<$Res> {
  factory _$AssessmentFormModelCopyWith(_AssessmentFormModel value, $Res Function(_AssessmentFormModel) _then) = __$AssessmentFormModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'nama_formulir') String title,@JsonKey(name: 'created_at') DateTime date, List<DomainModel> domains,@JsonKey(name: 'participating_opd_count') int opdCount, RoleScore? scores,@JsonKey(name: 'review_progress') ReviewProgressSummary? reviewProgress
});


@override $RoleScoreCopyWith<$Res>? get scores;@override $ReviewProgressSummaryCopyWith<$Res>? get reviewProgress;

}
/// @nodoc
class __$AssessmentFormModelCopyWithImpl<$Res>
    implements _$AssessmentFormModelCopyWith<$Res> {
  __$AssessmentFormModelCopyWithImpl(this._self, this._then);

  final _AssessmentFormModel _self;
  final $Res Function(_AssessmentFormModel) _then;

/// Create a copy of AssessmentFormModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? date = null,Object? domains = null,Object? opdCount = null,Object? scores = freezed,Object? reviewProgress = freezed,}) {
  return _then(_AssessmentFormModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,domains: null == domains ? _self._domains : domains // ignore: cast_nullable_to_non_nullable
as List<DomainModel>,opdCount: null == opdCount ? _self.opdCount : opdCount // ignore: cast_nullable_to_non_nullable
as int,scores: freezed == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as RoleScore?,reviewProgress: freezed == reviewProgress ? _self.reviewProgress : reviewProgress // ignore: cast_nullable_to_non_nullable
as ReviewProgressSummary?,
  ));
}

/// Create a copy of AssessmentFormModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleScoreCopyWith<$Res>? get scores {
    if (_self.scores == null) {
    return null;
  }

  return $RoleScoreCopyWith<$Res>(_self.scores!, (value) {
    return _then(_self.copyWith(scores: value));
  });
}/// Create a copy of AssessmentFormModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewProgressSummaryCopyWith<$Res>? get reviewProgress {
    if (_self.reviewProgress == null) {
    return null;
  }

  return $ReviewProgressSummaryCopyWith<$Res>(_self.reviewProgress!, (value) {
    return _then(_self.copyWith(reviewProgress: value));
  });
}
}


/// @nodoc
mixin _$IndicatorModel {

 String get id; String get name;@JsonKey(name: 'kode_indikator') String? get kodeIndikator;@JsonKey(name: 'bobot_indikator')@FlexibleDoubleConverter() double get bobotIndikator;@JsonKey(name: 'level_1_kriteria') String? get level1Kriteria;@JsonKey(name: 'level_2_kriteria') String? get level2Kriteria;@JsonKey(name: 'level_3_kriteria') String? get level3Kriteria;@JsonKey(name: 'level_4_kriteria') String? get level4Kriteria;@JsonKey(name: 'level_5_kriteria') String? get level5Kriteria;@JsonKey(name: 'level_1_kriteria_10101') String? get level1Kriteria10101;@JsonKey(name: 'level_2_kriteria_10101') String? get level2Kriteria10101;@JsonKey(name: 'level_3_kriteria_10101') String? get level3Kriteria10101;@JsonKey(name: 'level_4_kriteria_10101') String? get level4Kriteria10101;@JsonKey(name: 'level_5_kriteria_10101') String? get level5Kriteria10101;@JsonKey(name: 'level_1_kriteria_10201') String? get level1Kriteria10201;@JsonKey(name: 'level_2_kriteria_10201') String? get level2Kriteria10201;@JsonKey(name: 'level_3_kriteria_10201') String? get level3Kriteria10201;@JsonKey(name: 'level_4_kriteria_10201') String? get level4Kriteria10201;@JsonKey(name: 'level_5_kriteria_10201') String? get level5Kriteria10201; RoleScore? get scores;
/// Create a copy of IndicatorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IndicatorModelCopyWith<IndicatorModel> get copyWith => _$IndicatorModelCopyWithImpl<IndicatorModel>(this as IndicatorModel, _$identity);

  /// Serializes this IndicatorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IndicatorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kodeIndikator, kodeIndikator) || other.kodeIndikator == kodeIndikator)&&(identical(other.bobotIndikator, bobotIndikator) || other.bobotIndikator == bobotIndikator)&&(identical(other.level1Kriteria, level1Kriteria) || other.level1Kriteria == level1Kriteria)&&(identical(other.level2Kriteria, level2Kriteria) || other.level2Kriteria == level2Kriteria)&&(identical(other.level3Kriteria, level3Kriteria) || other.level3Kriteria == level3Kriteria)&&(identical(other.level4Kriteria, level4Kriteria) || other.level4Kriteria == level4Kriteria)&&(identical(other.level5Kriteria, level5Kriteria) || other.level5Kriteria == level5Kriteria)&&(identical(other.level1Kriteria10101, level1Kriteria10101) || other.level1Kriteria10101 == level1Kriteria10101)&&(identical(other.level2Kriteria10101, level2Kriteria10101) || other.level2Kriteria10101 == level2Kriteria10101)&&(identical(other.level3Kriteria10101, level3Kriteria10101) || other.level3Kriteria10101 == level3Kriteria10101)&&(identical(other.level4Kriteria10101, level4Kriteria10101) || other.level4Kriteria10101 == level4Kriteria10101)&&(identical(other.level5Kriteria10101, level5Kriteria10101) || other.level5Kriteria10101 == level5Kriteria10101)&&(identical(other.level1Kriteria10201, level1Kriteria10201) || other.level1Kriteria10201 == level1Kriteria10201)&&(identical(other.level2Kriteria10201, level2Kriteria10201) || other.level2Kriteria10201 == level2Kriteria10201)&&(identical(other.level3Kriteria10201, level3Kriteria10201) || other.level3Kriteria10201 == level3Kriteria10201)&&(identical(other.level4Kriteria10201, level4Kriteria10201) || other.level4Kriteria10201 == level4Kriteria10201)&&(identical(other.level5Kriteria10201, level5Kriteria10201) || other.level5Kriteria10201 == level5Kriteria10201)&&(identical(other.scores, scores) || other.scores == scores));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,kodeIndikator,bobotIndikator,level1Kriteria,level2Kriteria,level3Kriteria,level4Kriteria,level5Kriteria,level1Kriteria10101,level2Kriteria10101,level3Kriteria10101,level4Kriteria10101,level5Kriteria10101,level1Kriteria10201,level2Kriteria10201,level3Kriteria10201,level4Kriteria10201,level5Kriteria10201,scores]);

@override
String toString() {
  return 'IndicatorModel(id: $id, name: $name, kodeIndikator: $kodeIndikator, bobotIndikator: $bobotIndikator, level1Kriteria: $level1Kriteria, level2Kriteria: $level2Kriteria, level3Kriteria: $level3Kriteria, level4Kriteria: $level4Kriteria, level5Kriteria: $level5Kriteria, level1Kriteria10101: $level1Kriteria10101, level2Kriteria10101: $level2Kriteria10101, level3Kriteria10101: $level3Kriteria10101, level4Kriteria10101: $level4Kriteria10101, level5Kriteria10101: $level5Kriteria10101, level1Kriteria10201: $level1Kriteria10201, level2Kriteria10201: $level2Kriteria10201, level3Kriteria10201: $level3Kriteria10201, level4Kriteria10201: $level4Kriteria10201, level5Kriteria10201: $level5Kriteria10201, scores: $scores)';
}


}

/// @nodoc
abstract mixin class $IndicatorModelCopyWith<$Res>  {
  factory $IndicatorModelCopyWith(IndicatorModel value, $Res Function(IndicatorModel) _then) = _$IndicatorModelCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'kode_indikator') String? kodeIndikator,@JsonKey(name: 'bobot_indikator')@FlexibleDoubleConverter() double bobotIndikator,@JsonKey(name: 'level_1_kriteria') String? level1Kriteria,@JsonKey(name: 'level_2_kriteria') String? level2Kriteria,@JsonKey(name: 'level_3_kriteria') String? level3Kriteria,@JsonKey(name: 'level_4_kriteria') String? level4Kriteria,@JsonKey(name: 'level_5_kriteria') String? level5Kriteria,@JsonKey(name: 'level_1_kriteria_10101') String? level1Kriteria10101,@JsonKey(name: 'level_2_kriteria_10101') String? level2Kriteria10101,@JsonKey(name: 'level_3_kriteria_10101') String? level3Kriteria10101,@JsonKey(name: 'level_4_kriteria_10101') String? level4Kriteria10101,@JsonKey(name: 'level_5_kriteria_10101') String? level5Kriteria10101,@JsonKey(name: 'level_1_kriteria_10201') String? level1Kriteria10201,@JsonKey(name: 'level_2_kriteria_10201') String? level2Kriteria10201,@JsonKey(name: 'level_3_kriteria_10201') String? level3Kriteria10201,@JsonKey(name: 'level_4_kriteria_10201') String? level4Kriteria10201,@JsonKey(name: 'level_5_kriteria_10201') String? level5Kriteria10201, RoleScore? scores
});


$RoleScoreCopyWith<$Res>? get scores;

}
/// @nodoc
class _$IndicatorModelCopyWithImpl<$Res>
    implements $IndicatorModelCopyWith<$Res> {
  _$IndicatorModelCopyWithImpl(this._self, this._then);

  final IndicatorModel _self;
  final $Res Function(IndicatorModel) _then;

/// Create a copy of IndicatorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? kodeIndikator = freezed,Object? bobotIndikator = null,Object? level1Kriteria = freezed,Object? level2Kriteria = freezed,Object? level3Kriteria = freezed,Object? level4Kriteria = freezed,Object? level5Kriteria = freezed,Object? level1Kriteria10101 = freezed,Object? level2Kriteria10101 = freezed,Object? level3Kriteria10101 = freezed,Object? level4Kriteria10101 = freezed,Object? level5Kriteria10101 = freezed,Object? level1Kriteria10201 = freezed,Object? level2Kriteria10201 = freezed,Object? level3Kriteria10201 = freezed,Object? level4Kriteria10201 = freezed,Object? level5Kriteria10201 = freezed,Object? scores = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kodeIndikator: freezed == kodeIndikator ? _self.kodeIndikator : kodeIndikator // ignore: cast_nullable_to_non_nullable
as String?,bobotIndikator: null == bobotIndikator ? _self.bobotIndikator : bobotIndikator // ignore: cast_nullable_to_non_nullable
as double,level1Kriteria: freezed == level1Kriteria ? _self.level1Kriteria : level1Kriteria // ignore: cast_nullable_to_non_nullable
as String?,level2Kriteria: freezed == level2Kriteria ? _self.level2Kriteria : level2Kriteria // ignore: cast_nullable_to_non_nullable
as String?,level3Kriteria: freezed == level3Kriteria ? _self.level3Kriteria : level3Kriteria // ignore: cast_nullable_to_non_nullable
as String?,level4Kriteria: freezed == level4Kriteria ? _self.level4Kriteria : level4Kriteria // ignore: cast_nullable_to_non_nullable
as String?,level5Kriteria: freezed == level5Kriteria ? _self.level5Kriteria : level5Kriteria // ignore: cast_nullable_to_non_nullable
as String?,level1Kriteria10101: freezed == level1Kriteria10101 ? _self.level1Kriteria10101 : level1Kriteria10101 // ignore: cast_nullable_to_non_nullable
as String?,level2Kriteria10101: freezed == level2Kriteria10101 ? _self.level2Kriteria10101 : level2Kriteria10101 // ignore: cast_nullable_to_non_nullable
as String?,level3Kriteria10101: freezed == level3Kriteria10101 ? _self.level3Kriteria10101 : level3Kriteria10101 // ignore: cast_nullable_to_non_nullable
as String?,level4Kriteria10101: freezed == level4Kriteria10101 ? _self.level4Kriteria10101 : level4Kriteria10101 // ignore: cast_nullable_to_non_nullable
as String?,level5Kriteria10101: freezed == level5Kriteria10101 ? _self.level5Kriteria10101 : level5Kriteria10101 // ignore: cast_nullable_to_non_nullable
as String?,level1Kriteria10201: freezed == level1Kriteria10201 ? _self.level1Kriteria10201 : level1Kriteria10201 // ignore: cast_nullable_to_non_nullable
as String?,level2Kriteria10201: freezed == level2Kriteria10201 ? _self.level2Kriteria10201 : level2Kriteria10201 // ignore: cast_nullable_to_non_nullable
as String?,level3Kriteria10201: freezed == level3Kriteria10201 ? _self.level3Kriteria10201 : level3Kriteria10201 // ignore: cast_nullable_to_non_nullable
as String?,level4Kriteria10201: freezed == level4Kriteria10201 ? _self.level4Kriteria10201 : level4Kriteria10201 // ignore: cast_nullable_to_non_nullable
as String?,level5Kriteria10201: freezed == level5Kriteria10201 ? _self.level5Kriteria10201 : level5Kriteria10201 // ignore: cast_nullable_to_non_nullable
as String?,scores: freezed == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as RoleScore?,
  ));
}
/// Create a copy of IndicatorModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleScoreCopyWith<$Res>? get scores {
    if (_self.scores == null) {
    return null;
  }

  return $RoleScoreCopyWith<$Res>(_self.scores!, (value) {
    return _then(_self.copyWith(scores: value));
  });
}
}


/// Adds pattern-matching-related methods to [IndicatorModel].
extension IndicatorModelPatterns on IndicatorModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IndicatorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IndicatorModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IndicatorModel value)  $default,){
final _that = this;
switch (_that) {
case _IndicatorModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IndicatorModel value)?  $default,){
final _that = this;
switch (_that) {
case _IndicatorModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'kode_indikator')  String? kodeIndikator, @JsonKey(name: 'bobot_indikator')@FlexibleDoubleConverter()  double bobotIndikator, @JsonKey(name: 'level_1_kriteria')  String? level1Kriteria, @JsonKey(name: 'level_2_kriteria')  String? level2Kriteria, @JsonKey(name: 'level_3_kriteria')  String? level3Kriteria, @JsonKey(name: 'level_4_kriteria')  String? level4Kriteria, @JsonKey(name: 'level_5_kriteria')  String? level5Kriteria, @JsonKey(name: 'level_1_kriteria_10101')  String? level1Kriteria10101, @JsonKey(name: 'level_2_kriteria_10101')  String? level2Kriteria10101, @JsonKey(name: 'level_3_kriteria_10101')  String? level3Kriteria10101, @JsonKey(name: 'level_4_kriteria_10101')  String? level4Kriteria10101, @JsonKey(name: 'level_5_kriteria_10101')  String? level5Kriteria10101, @JsonKey(name: 'level_1_kriteria_10201')  String? level1Kriteria10201, @JsonKey(name: 'level_2_kriteria_10201')  String? level2Kriteria10201, @JsonKey(name: 'level_3_kriteria_10201')  String? level3Kriteria10201, @JsonKey(name: 'level_4_kriteria_10201')  String? level4Kriteria10201, @JsonKey(name: 'level_5_kriteria_10201')  String? level5Kriteria10201,  RoleScore? scores)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IndicatorModel() when $default != null:
return $default(_that.id,_that.name,_that.kodeIndikator,_that.bobotIndikator,_that.level1Kriteria,_that.level2Kriteria,_that.level3Kriteria,_that.level4Kriteria,_that.level5Kriteria,_that.level1Kriteria10101,_that.level2Kriteria10101,_that.level3Kriteria10101,_that.level4Kriteria10101,_that.level5Kriteria10101,_that.level1Kriteria10201,_that.level2Kriteria10201,_that.level3Kriteria10201,_that.level4Kriteria10201,_that.level5Kriteria10201,_that.scores);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'kode_indikator')  String? kodeIndikator, @JsonKey(name: 'bobot_indikator')@FlexibleDoubleConverter()  double bobotIndikator, @JsonKey(name: 'level_1_kriteria')  String? level1Kriteria, @JsonKey(name: 'level_2_kriteria')  String? level2Kriteria, @JsonKey(name: 'level_3_kriteria')  String? level3Kriteria, @JsonKey(name: 'level_4_kriteria')  String? level4Kriteria, @JsonKey(name: 'level_5_kriteria')  String? level5Kriteria, @JsonKey(name: 'level_1_kriteria_10101')  String? level1Kriteria10101, @JsonKey(name: 'level_2_kriteria_10101')  String? level2Kriteria10101, @JsonKey(name: 'level_3_kriteria_10101')  String? level3Kriteria10101, @JsonKey(name: 'level_4_kriteria_10101')  String? level4Kriteria10101, @JsonKey(name: 'level_5_kriteria_10101')  String? level5Kriteria10101, @JsonKey(name: 'level_1_kriteria_10201')  String? level1Kriteria10201, @JsonKey(name: 'level_2_kriteria_10201')  String? level2Kriteria10201, @JsonKey(name: 'level_3_kriteria_10201')  String? level3Kriteria10201, @JsonKey(name: 'level_4_kriteria_10201')  String? level4Kriteria10201, @JsonKey(name: 'level_5_kriteria_10201')  String? level5Kriteria10201,  RoleScore? scores)  $default,) {final _that = this;
switch (_that) {
case _IndicatorModel():
return $default(_that.id,_that.name,_that.kodeIndikator,_that.bobotIndikator,_that.level1Kriteria,_that.level2Kriteria,_that.level3Kriteria,_that.level4Kriteria,_that.level5Kriteria,_that.level1Kriteria10101,_that.level2Kriteria10101,_that.level3Kriteria10101,_that.level4Kriteria10101,_that.level5Kriteria10101,_that.level1Kriteria10201,_that.level2Kriteria10201,_that.level3Kriteria10201,_that.level4Kriteria10201,_that.level5Kriteria10201,_that.scores);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'kode_indikator')  String? kodeIndikator, @JsonKey(name: 'bobot_indikator')@FlexibleDoubleConverter()  double bobotIndikator, @JsonKey(name: 'level_1_kriteria')  String? level1Kriteria, @JsonKey(name: 'level_2_kriteria')  String? level2Kriteria, @JsonKey(name: 'level_3_kriteria')  String? level3Kriteria, @JsonKey(name: 'level_4_kriteria')  String? level4Kriteria, @JsonKey(name: 'level_5_kriteria')  String? level5Kriteria, @JsonKey(name: 'level_1_kriteria_10101')  String? level1Kriteria10101, @JsonKey(name: 'level_2_kriteria_10101')  String? level2Kriteria10101, @JsonKey(name: 'level_3_kriteria_10101')  String? level3Kriteria10101, @JsonKey(name: 'level_4_kriteria_10101')  String? level4Kriteria10101, @JsonKey(name: 'level_5_kriteria_10101')  String? level5Kriteria10101, @JsonKey(name: 'level_1_kriteria_10201')  String? level1Kriteria10201, @JsonKey(name: 'level_2_kriteria_10201')  String? level2Kriteria10201, @JsonKey(name: 'level_3_kriteria_10201')  String? level3Kriteria10201, @JsonKey(name: 'level_4_kriteria_10201')  String? level4Kriteria10201, @JsonKey(name: 'level_5_kriteria_10201')  String? level5Kriteria10201,  RoleScore? scores)?  $default,) {final _that = this;
switch (_that) {
case _IndicatorModel() when $default != null:
return $default(_that.id,_that.name,_that.kodeIndikator,_that.bobotIndikator,_that.level1Kriteria,_that.level2Kriteria,_that.level3Kriteria,_that.level4Kriteria,_that.level5Kriteria,_that.level1Kriteria10101,_that.level2Kriteria10101,_that.level3Kriteria10101,_that.level4Kriteria10101,_that.level5Kriteria10101,_that.level1Kriteria10201,_that.level2Kriteria10201,_that.level3Kriteria10201,_that.level4Kriteria10201,_that.level5Kriteria10201,_that.scores);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IndicatorModel implements IndicatorModel {
  const _IndicatorModel({required this.id, required this.name, @JsonKey(name: 'kode_indikator') this.kodeIndikator, @JsonKey(name: 'bobot_indikator')@FlexibleDoubleConverter() this.bobotIndikator = 0, @JsonKey(name: 'level_1_kriteria') this.level1Kriteria, @JsonKey(name: 'level_2_kriteria') this.level2Kriteria, @JsonKey(name: 'level_3_kriteria') this.level3Kriteria, @JsonKey(name: 'level_4_kriteria') this.level4Kriteria, @JsonKey(name: 'level_5_kriteria') this.level5Kriteria, @JsonKey(name: 'level_1_kriteria_10101') this.level1Kriteria10101, @JsonKey(name: 'level_2_kriteria_10101') this.level2Kriteria10101, @JsonKey(name: 'level_3_kriteria_10101') this.level3Kriteria10101, @JsonKey(name: 'level_4_kriteria_10101') this.level4Kriteria10101, @JsonKey(name: 'level_5_kriteria_10101') this.level5Kriteria10101, @JsonKey(name: 'level_1_kriteria_10201') this.level1Kriteria10201, @JsonKey(name: 'level_2_kriteria_10201') this.level2Kriteria10201, @JsonKey(name: 'level_3_kriteria_10201') this.level3Kriteria10201, @JsonKey(name: 'level_4_kriteria_10201') this.level4Kriteria10201, @JsonKey(name: 'level_5_kriteria_10201') this.level5Kriteria10201, this.scores});
  factory _IndicatorModel.fromJson(Map<String, dynamic> json) => _$IndicatorModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'kode_indikator') final  String? kodeIndikator;
@override@JsonKey(name: 'bobot_indikator')@FlexibleDoubleConverter() final  double bobotIndikator;
@override@JsonKey(name: 'level_1_kriteria') final  String? level1Kriteria;
@override@JsonKey(name: 'level_2_kriteria') final  String? level2Kriteria;
@override@JsonKey(name: 'level_3_kriteria') final  String? level3Kriteria;
@override@JsonKey(name: 'level_4_kriteria') final  String? level4Kriteria;
@override@JsonKey(name: 'level_5_kriteria') final  String? level5Kriteria;
@override@JsonKey(name: 'level_1_kriteria_10101') final  String? level1Kriteria10101;
@override@JsonKey(name: 'level_2_kriteria_10101') final  String? level2Kriteria10101;
@override@JsonKey(name: 'level_3_kriteria_10101') final  String? level3Kriteria10101;
@override@JsonKey(name: 'level_4_kriteria_10101') final  String? level4Kriteria10101;
@override@JsonKey(name: 'level_5_kriteria_10101') final  String? level5Kriteria10101;
@override@JsonKey(name: 'level_1_kriteria_10201') final  String? level1Kriteria10201;
@override@JsonKey(name: 'level_2_kriteria_10201') final  String? level2Kriteria10201;
@override@JsonKey(name: 'level_3_kriteria_10201') final  String? level3Kriteria10201;
@override@JsonKey(name: 'level_4_kriteria_10201') final  String? level4Kriteria10201;
@override@JsonKey(name: 'level_5_kriteria_10201') final  String? level5Kriteria10201;
@override final  RoleScore? scores;

/// Create a copy of IndicatorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IndicatorModelCopyWith<_IndicatorModel> get copyWith => __$IndicatorModelCopyWithImpl<_IndicatorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IndicatorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IndicatorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kodeIndikator, kodeIndikator) || other.kodeIndikator == kodeIndikator)&&(identical(other.bobotIndikator, bobotIndikator) || other.bobotIndikator == bobotIndikator)&&(identical(other.level1Kriteria, level1Kriteria) || other.level1Kriteria == level1Kriteria)&&(identical(other.level2Kriteria, level2Kriteria) || other.level2Kriteria == level2Kriteria)&&(identical(other.level3Kriteria, level3Kriteria) || other.level3Kriteria == level3Kriteria)&&(identical(other.level4Kriteria, level4Kriteria) || other.level4Kriteria == level4Kriteria)&&(identical(other.level5Kriteria, level5Kriteria) || other.level5Kriteria == level5Kriteria)&&(identical(other.level1Kriteria10101, level1Kriteria10101) || other.level1Kriteria10101 == level1Kriteria10101)&&(identical(other.level2Kriteria10101, level2Kriteria10101) || other.level2Kriteria10101 == level2Kriteria10101)&&(identical(other.level3Kriteria10101, level3Kriteria10101) || other.level3Kriteria10101 == level3Kriteria10101)&&(identical(other.level4Kriteria10101, level4Kriteria10101) || other.level4Kriteria10101 == level4Kriteria10101)&&(identical(other.level5Kriteria10101, level5Kriteria10101) || other.level5Kriteria10101 == level5Kriteria10101)&&(identical(other.level1Kriteria10201, level1Kriteria10201) || other.level1Kriteria10201 == level1Kriteria10201)&&(identical(other.level2Kriteria10201, level2Kriteria10201) || other.level2Kriteria10201 == level2Kriteria10201)&&(identical(other.level3Kriteria10201, level3Kriteria10201) || other.level3Kriteria10201 == level3Kriteria10201)&&(identical(other.level4Kriteria10201, level4Kriteria10201) || other.level4Kriteria10201 == level4Kriteria10201)&&(identical(other.level5Kriteria10201, level5Kriteria10201) || other.level5Kriteria10201 == level5Kriteria10201)&&(identical(other.scores, scores) || other.scores == scores));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,kodeIndikator,bobotIndikator,level1Kriteria,level2Kriteria,level3Kriteria,level4Kriteria,level5Kriteria,level1Kriteria10101,level2Kriteria10101,level3Kriteria10101,level4Kriteria10101,level5Kriteria10101,level1Kriteria10201,level2Kriteria10201,level3Kriteria10201,level4Kriteria10201,level5Kriteria10201,scores]);

@override
String toString() {
  return 'IndicatorModel(id: $id, name: $name, kodeIndikator: $kodeIndikator, bobotIndikator: $bobotIndikator, level1Kriteria: $level1Kriteria, level2Kriteria: $level2Kriteria, level3Kriteria: $level3Kriteria, level4Kriteria: $level4Kriteria, level5Kriteria: $level5Kriteria, level1Kriteria10101: $level1Kriteria10101, level2Kriteria10101: $level2Kriteria10101, level3Kriteria10101: $level3Kriteria10101, level4Kriteria10101: $level4Kriteria10101, level5Kriteria10101: $level5Kriteria10101, level1Kriteria10201: $level1Kriteria10201, level2Kriteria10201: $level2Kriteria10201, level3Kriteria10201: $level3Kriteria10201, level4Kriteria10201: $level4Kriteria10201, level5Kriteria10201: $level5Kriteria10201, scores: $scores)';
}


}

/// @nodoc
abstract mixin class _$IndicatorModelCopyWith<$Res> implements $IndicatorModelCopyWith<$Res> {
  factory _$IndicatorModelCopyWith(_IndicatorModel value, $Res Function(_IndicatorModel) _then) = __$IndicatorModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'kode_indikator') String? kodeIndikator,@JsonKey(name: 'bobot_indikator')@FlexibleDoubleConverter() double bobotIndikator,@JsonKey(name: 'level_1_kriteria') String? level1Kriteria,@JsonKey(name: 'level_2_kriteria') String? level2Kriteria,@JsonKey(name: 'level_3_kriteria') String? level3Kriteria,@JsonKey(name: 'level_4_kriteria') String? level4Kriteria,@JsonKey(name: 'level_5_kriteria') String? level5Kriteria,@JsonKey(name: 'level_1_kriteria_10101') String? level1Kriteria10101,@JsonKey(name: 'level_2_kriteria_10101') String? level2Kriteria10101,@JsonKey(name: 'level_3_kriteria_10101') String? level3Kriteria10101,@JsonKey(name: 'level_4_kriteria_10101') String? level4Kriteria10101,@JsonKey(name: 'level_5_kriteria_10101') String? level5Kriteria10101,@JsonKey(name: 'level_1_kriteria_10201') String? level1Kriteria10201,@JsonKey(name: 'level_2_kriteria_10201') String? level2Kriteria10201,@JsonKey(name: 'level_3_kriteria_10201') String? level3Kriteria10201,@JsonKey(name: 'level_4_kriteria_10201') String? level4Kriteria10201,@JsonKey(name: 'level_5_kriteria_10201') String? level5Kriteria10201, RoleScore? scores
});


@override $RoleScoreCopyWith<$Res>? get scores;

}
/// @nodoc
class __$IndicatorModelCopyWithImpl<$Res>
    implements _$IndicatorModelCopyWith<$Res> {
  __$IndicatorModelCopyWithImpl(this._self, this._then);

  final _IndicatorModel _self;
  final $Res Function(_IndicatorModel) _then;

/// Create a copy of IndicatorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? kodeIndikator = freezed,Object? bobotIndikator = null,Object? level1Kriteria = freezed,Object? level2Kriteria = freezed,Object? level3Kriteria = freezed,Object? level4Kriteria = freezed,Object? level5Kriteria = freezed,Object? level1Kriteria10101 = freezed,Object? level2Kriteria10101 = freezed,Object? level3Kriteria10101 = freezed,Object? level4Kriteria10101 = freezed,Object? level5Kriteria10101 = freezed,Object? level1Kriteria10201 = freezed,Object? level2Kriteria10201 = freezed,Object? level3Kriteria10201 = freezed,Object? level4Kriteria10201 = freezed,Object? level5Kriteria10201 = freezed,Object? scores = freezed,}) {
  return _then(_IndicatorModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kodeIndikator: freezed == kodeIndikator ? _self.kodeIndikator : kodeIndikator // ignore: cast_nullable_to_non_nullable
as String?,bobotIndikator: null == bobotIndikator ? _self.bobotIndikator : bobotIndikator // ignore: cast_nullable_to_non_nullable
as double,level1Kriteria: freezed == level1Kriteria ? _self.level1Kriteria : level1Kriteria // ignore: cast_nullable_to_non_nullable
as String?,level2Kriteria: freezed == level2Kriteria ? _self.level2Kriteria : level2Kriteria // ignore: cast_nullable_to_non_nullable
as String?,level3Kriteria: freezed == level3Kriteria ? _self.level3Kriteria : level3Kriteria // ignore: cast_nullable_to_non_nullable
as String?,level4Kriteria: freezed == level4Kriteria ? _self.level4Kriteria : level4Kriteria // ignore: cast_nullable_to_non_nullable
as String?,level5Kriteria: freezed == level5Kriteria ? _self.level5Kriteria : level5Kriteria // ignore: cast_nullable_to_non_nullable
as String?,level1Kriteria10101: freezed == level1Kriteria10101 ? _self.level1Kriteria10101 : level1Kriteria10101 // ignore: cast_nullable_to_non_nullable
as String?,level2Kriteria10101: freezed == level2Kriteria10101 ? _self.level2Kriteria10101 : level2Kriteria10101 // ignore: cast_nullable_to_non_nullable
as String?,level3Kriteria10101: freezed == level3Kriteria10101 ? _self.level3Kriteria10101 : level3Kriteria10101 // ignore: cast_nullable_to_non_nullable
as String?,level4Kriteria10101: freezed == level4Kriteria10101 ? _self.level4Kriteria10101 : level4Kriteria10101 // ignore: cast_nullable_to_non_nullable
as String?,level5Kriteria10101: freezed == level5Kriteria10101 ? _self.level5Kriteria10101 : level5Kriteria10101 // ignore: cast_nullable_to_non_nullable
as String?,level1Kriteria10201: freezed == level1Kriteria10201 ? _self.level1Kriteria10201 : level1Kriteria10201 // ignore: cast_nullable_to_non_nullable
as String?,level2Kriteria10201: freezed == level2Kriteria10201 ? _self.level2Kriteria10201 : level2Kriteria10201 // ignore: cast_nullable_to_non_nullable
as String?,level3Kriteria10201: freezed == level3Kriteria10201 ? _self.level3Kriteria10201 : level3Kriteria10201 // ignore: cast_nullable_to_non_nullable
as String?,level4Kriteria10201: freezed == level4Kriteria10201 ? _self.level4Kriteria10201 : level4Kriteria10201 // ignore: cast_nullable_to_non_nullable
as String?,level5Kriteria10201: freezed == level5Kriteria10201 ? _self.level5Kriteria10201 : level5Kriteria10201 // ignore: cast_nullable_to_non_nullable
as String?,scores: freezed == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as RoleScore?,
  ));
}

/// Create a copy of IndicatorModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleScoreCopyWith<$Res>? get scores {
    if (_self.scores == null) {
    return null;
  }

  return $RoleScoreCopyWith<$Res>(_self.scores!, (value) {
    return _then(_self.copyWith(scores: value));
  });
}
}

// dart format on
