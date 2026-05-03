// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opd_performance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpdPerformance {

@JsonKey(name: 'opd_name') String get opdName; double get score;
/// Create a copy of OpdPerformance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpdPerformanceCopyWith<OpdPerformance> get copyWith => _$OpdPerformanceCopyWithImpl<OpdPerformance>(this as OpdPerformance, _$identity);

  /// Serializes this OpdPerformance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpdPerformance&&(identical(other.opdName, opdName) || other.opdName == opdName)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opdName,score);

@override
String toString() {
  return 'OpdPerformance(opdName: $opdName, score: $score)';
}


}

/// @nodoc
abstract mixin class $OpdPerformanceCopyWith<$Res>  {
  factory $OpdPerformanceCopyWith(OpdPerformance value, $Res Function(OpdPerformance) _then) = _$OpdPerformanceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'opd_name') String opdName, double score
});




}
/// @nodoc
class _$OpdPerformanceCopyWithImpl<$Res>
    implements $OpdPerformanceCopyWith<$Res> {
  _$OpdPerformanceCopyWithImpl(this._self, this._then);

  final OpdPerformance _self;
  final $Res Function(OpdPerformance) _then;

/// Create a copy of OpdPerformance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? opdName = null,Object? score = null,}) {
  return _then(_self.copyWith(
opdName: null == opdName ? _self.opdName : opdName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OpdPerformance].
extension OpdPerformancePatterns on OpdPerformance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpdPerformance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpdPerformance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpdPerformance value)  $default,){
final _that = this;
switch (_that) {
case _OpdPerformance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpdPerformance value)?  $default,){
final _that = this;
switch (_that) {
case _OpdPerformance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'opd_name')  String opdName,  double score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpdPerformance() when $default != null:
return $default(_that.opdName,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'opd_name')  String opdName,  double score)  $default,) {final _that = this;
switch (_that) {
case _OpdPerformance():
return $default(_that.opdName,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'opd_name')  String opdName,  double score)?  $default,) {final _that = this;
switch (_that) {
case _OpdPerformance() when $default != null:
return $default(_that.opdName,_that.score);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpdPerformance implements OpdPerformance {
  const _OpdPerformance({@JsonKey(name: 'opd_name') required this.opdName, required this.score});
  factory _OpdPerformance.fromJson(Map<String, dynamic> json) => _$OpdPerformanceFromJson(json);

@override@JsonKey(name: 'opd_name') final  String opdName;
@override final  double score;

/// Create a copy of OpdPerformance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpdPerformanceCopyWith<_OpdPerformance> get copyWith => __$OpdPerformanceCopyWithImpl<_OpdPerformance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpdPerformanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpdPerformance&&(identical(other.opdName, opdName) || other.opdName == opdName)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opdName,score);

@override
String toString() {
  return 'OpdPerformance(opdName: $opdName, score: $score)';
}


}

/// @nodoc
abstract mixin class _$OpdPerformanceCopyWith<$Res> implements $OpdPerformanceCopyWith<$Res> {
  factory _$OpdPerformanceCopyWith(_OpdPerformance value, $Res Function(_OpdPerformance) _then) = __$OpdPerformanceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'opd_name') String opdName, double score
});




}
/// @nodoc
class __$OpdPerformanceCopyWithImpl<$Res>
    implements _$OpdPerformanceCopyWith<$Res> {
  __$OpdPerformanceCopyWithImpl(this._self, this._then);

  final _OpdPerformance _self;
  final $Res Function(_OpdPerformance) _then;

/// Create a copy of OpdPerformance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? opdName = null,Object? score = null,}) {
  return _then(_OpdPerformance(
opdName: null == opdName ? _self.opdName : opdName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
