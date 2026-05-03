// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_assessment_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminAssessmentProgress {

 int get id;@JsonKey(name: 'nama') String get name;@JsonKey(name: 'tanggal') DateTime get date; int get opdFilledCount; int get opdTotalCount; int get walidataCorrectedCount; int get walidataTotalCount;
/// Create a copy of AdminAssessmentProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminAssessmentProgressCopyWith<AdminAssessmentProgress> get copyWith => _$AdminAssessmentProgressCopyWithImpl<AdminAssessmentProgress>(this as AdminAssessmentProgress, _$identity);

  /// Serializes this AdminAssessmentProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminAssessmentProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.opdFilledCount, opdFilledCount) || other.opdFilledCount == opdFilledCount)&&(identical(other.opdTotalCount, opdTotalCount) || other.opdTotalCount == opdTotalCount)&&(identical(other.walidataCorrectedCount, walidataCorrectedCount) || other.walidataCorrectedCount == walidataCorrectedCount)&&(identical(other.walidataTotalCount, walidataTotalCount) || other.walidataTotalCount == walidataTotalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,date,opdFilledCount,opdTotalCount,walidataCorrectedCount,walidataTotalCount);

@override
String toString() {
  return 'AdminAssessmentProgress(id: $id, name: $name, date: $date, opdFilledCount: $opdFilledCount, opdTotalCount: $opdTotalCount, walidataCorrectedCount: $walidataCorrectedCount, walidataTotalCount: $walidataTotalCount)';
}


}

/// @nodoc
abstract mixin class $AdminAssessmentProgressCopyWith<$Res>  {
  factory $AdminAssessmentProgressCopyWith(AdminAssessmentProgress value, $Res Function(AdminAssessmentProgress) _then) = _$AdminAssessmentProgressCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'nama') String name,@JsonKey(name: 'tanggal') DateTime date, int opdFilledCount, int opdTotalCount, int walidataCorrectedCount, int walidataTotalCount
});




}
/// @nodoc
class _$AdminAssessmentProgressCopyWithImpl<$Res>
    implements $AdminAssessmentProgressCopyWith<$Res> {
  _$AdminAssessmentProgressCopyWithImpl(this._self, this._then);

  final AdminAssessmentProgress _self;
  final $Res Function(AdminAssessmentProgress) _then;

/// Create a copy of AdminAssessmentProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? date = null,Object? opdFilledCount = null,Object? opdTotalCount = null,Object? walidataCorrectedCount = null,Object? walidataTotalCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,opdFilledCount: null == opdFilledCount ? _self.opdFilledCount : opdFilledCount // ignore: cast_nullable_to_non_nullable
as int,opdTotalCount: null == opdTotalCount ? _self.opdTotalCount : opdTotalCount // ignore: cast_nullable_to_non_nullable
as int,walidataCorrectedCount: null == walidataCorrectedCount ? _self.walidataCorrectedCount : walidataCorrectedCount // ignore: cast_nullable_to_non_nullable
as int,walidataTotalCount: null == walidataTotalCount ? _self.walidataTotalCount : walidataTotalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminAssessmentProgress].
extension AdminAssessmentProgressPatterns on AdminAssessmentProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminAssessmentProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminAssessmentProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminAssessmentProgress value)  $default,){
final _that = this;
switch (_that) {
case _AdminAssessmentProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminAssessmentProgress value)?  $default,){
final _that = this;
switch (_that) {
case _AdminAssessmentProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'tanggal')  DateTime date,  int opdFilledCount,  int opdTotalCount,  int walidataCorrectedCount,  int walidataTotalCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminAssessmentProgress() when $default != null:
return $default(_that.id,_that.name,_that.date,_that.opdFilledCount,_that.opdTotalCount,_that.walidataCorrectedCount,_that.walidataTotalCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'tanggal')  DateTime date,  int opdFilledCount,  int opdTotalCount,  int walidataCorrectedCount,  int walidataTotalCount)  $default,) {final _that = this;
switch (_that) {
case _AdminAssessmentProgress():
return $default(_that.id,_that.name,_that.date,_that.opdFilledCount,_that.opdTotalCount,_that.walidataCorrectedCount,_that.walidataTotalCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'tanggal')  DateTime date,  int opdFilledCount,  int opdTotalCount,  int walidataCorrectedCount,  int walidataTotalCount)?  $default,) {final _that = this;
switch (_that) {
case _AdminAssessmentProgress() when $default != null:
return $default(_that.id,_that.name,_that.date,_that.opdFilledCount,_that.opdTotalCount,_that.walidataCorrectedCount,_that.walidataTotalCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminAssessmentProgress implements AdminAssessmentProgress {
  const _AdminAssessmentProgress({required this.id, @JsonKey(name: 'nama') required this.name, @JsonKey(name: 'tanggal') required this.date, required this.opdFilledCount, required this.opdTotalCount, required this.walidataCorrectedCount, required this.walidataTotalCount});
  factory _AdminAssessmentProgress.fromJson(Map<String, dynamic> json) => _$AdminAssessmentProgressFromJson(json);

@override final  int id;
@override@JsonKey(name: 'nama') final  String name;
@override@JsonKey(name: 'tanggal') final  DateTime date;
@override final  int opdFilledCount;
@override final  int opdTotalCount;
@override final  int walidataCorrectedCount;
@override final  int walidataTotalCount;

/// Create a copy of AdminAssessmentProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminAssessmentProgressCopyWith<_AdminAssessmentProgress> get copyWith => __$AdminAssessmentProgressCopyWithImpl<_AdminAssessmentProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminAssessmentProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminAssessmentProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.opdFilledCount, opdFilledCount) || other.opdFilledCount == opdFilledCount)&&(identical(other.opdTotalCount, opdTotalCount) || other.opdTotalCount == opdTotalCount)&&(identical(other.walidataCorrectedCount, walidataCorrectedCount) || other.walidataCorrectedCount == walidataCorrectedCount)&&(identical(other.walidataTotalCount, walidataTotalCount) || other.walidataTotalCount == walidataTotalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,date,opdFilledCount,opdTotalCount,walidataCorrectedCount,walidataTotalCount);

@override
String toString() {
  return 'AdminAssessmentProgress(id: $id, name: $name, date: $date, opdFilledCount: $opdFilledCount, opdTotalCount: $opdTotalCount, walidataCorrectedCount: $walidataCorrectedCount, walidataTotalCount: $walidataTotalCount)';
}


}

/// @nodoc
abstract mixin class _$AdminAssessmentProgressCopyWith<$Res> implements $AdminAssessmentProgressCopyWith<$Res> {
  factory _$AdminAssessmentProgressCopyWith(_AdminAssessmentProgress value, $Res Function(_AdminAssessmentProgress) _then) = __$AdminAssessmentProgressCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'nama') String name,@JsonKey(name: 'tanggal') DateTime date, int opdFilledCount, int opdTotalCount, int walidataCorrectedCount, int walidataTotalCount
});




}
/// @nodoc
class __$AdminAssessmentProgressCopyWithImpl<$Res>
    implements _$AdminAssessmentProgressCopyWith<$Res> {
  __$AdminAssessmentProgressCopyWithImpl(this._self, this._then);

  final _AdminAssessmentProgress _self;
  final $Res Function(_AdminAssessmentProgress) _then;

/// Create a copy of AdminAssessmentProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? date = null,Object? opdFilledCount = null,Object? opdTotalCount = null,Object? walidataCorrectedCount = null,Object? walidataTotalCount = null,}) {
  return _then(_AdminAssessmentProgress(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,opdFilledCount: null == opdFilledCount ? _self.opdFilledCount : opdFilledCount // ignore: cast_nullable_to_non_nullable
as int,opdTotalCount: null == opdTotalCount ? _self.opdTotalCount : opdTotalCount // ignore: cast_nullable_to_non_nullable
as int,walidataCorrectedCount: null == walidataCorrectedCount ? _self.walidataCorrectedCount : walidataCorrectedCount // ignore: cast_nullable_to_non_nullable
as int,walidataTotalCount: null == walidataTotalCount ? _self.walidataTotalCount : walidataTotalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
