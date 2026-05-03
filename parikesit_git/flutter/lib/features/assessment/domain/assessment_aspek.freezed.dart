// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment_aspek.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssessmentAspek {

 int get id;@JsonKey(name: 'domain_id') int get domainId;@JsonKey(name: 'nama_aspek') String get namaAspek;@JsonKey(name: 'bobot_aspek') double get bobotAspek;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;
/// Create a copy of AssessmentAspek
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssessmentAspekCopyWith<AssessmentAspek> get copyWith => _$AssessmentAspekCopyWithImpl<AssessmentAspek>(this as AssessmentAspek, _$identity);

  /// Serializes this AssessmentAspek to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssessmentAspek&&(identical(other.id, id) || other.id == id)&&(identical(other.domainId, domainId) || other.domainId == domainId)&&(identical(other.namaAspek, namaAspek) || other.namaAspek == namaAspek)&&(identical(other.bobotAspek, bobotAspek) || other.bobotAspek == bobotAspek)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,domainId,namaAspek,bobotAspek,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'AssessmentAspek(id: $id, domainId: $domainId, namaAspek: $namaAspek, bobotAspek: $bobotAspek, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $AssessmentAspekCopyWith<$Res>  {
  factory $AssessmentAspekCopyWith(AssessmentAspek value, $Res Function(AssessmentAspek) _then) = _$AssessmentAspekCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'domain_id') int domainId,@JsonKey(name: 'nama_aspek') String namaAspek,@JsonKey(name: 'bobot_aspek') double bobotAspek,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class _$AssessmentAspekCopyWithImpl<$Res>
    implements $AssessmentAspekCopyWith<$Res> {
  _$AssessmentAspekCopyWithImpl(this._self, this._then);

  final AssessmentAspek _self;
  final $Res Function(AssessmentAspek) _then;

/// Create a copy of AssessmentAspek
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? domainId = null,Object? namaAspek = null,Object? bobotAspek = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,domainId: null == domainId ? _self.domainId : domainId // ignore: cast_nullable_to_non_nullable
as int,namaAspek: null == namaAspek ? _self.namaAspek : namaAspek // ignore: cast_nullable_to_non_nullable
as String,bobotAspek: null == bobotAspek ? _self.bobotAspek : bobotAspek // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssessmentAspek].
extension AssessmentAspekPatterns on AssessmentAspek {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssessmentAspek value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssessmentAspek() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssessmentAspek value)  $default,){
final _that = this;
switch (_that) {
case _AssessmentAspek():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssessmentAspek value)?  $default,){
final _that = this;
switch (_that) {
case _AssessmentAspek() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'domain_id')  int domainId, @JsonKey(name: 'nama_aspek')  String namaAspek, @JsonKey(name: 'bobot_aspek')  double bobotAspek, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssessmentAspek() when $default != null:
return $default(_that.id,_that.domainId,_that.namaAspek,_that.bobotAspek,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'domain_id')  int domainId, @JsonKey(name: 'nama_aspek')  String namaAspek, @JsonKey(name: 'bobot_aspek')  double bobotAspek, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _AssessmentAspek():
return $default(_that.id,_that.domainId,_that.namaAspek,_that.bobotAspek,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'domain_id')  int domainId, @JsonKey(name: 'nama_aspek')  String namaAspek, @JsonKey(name: 'bobot_aspek')  double bobotAspek, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _AssessmentAspek() when $default != null:
return $default(_that.id,_that.domainId,_that.namaAspek,_that.bobotAspek,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssessmentAspek implements AssessmentAspek {
  const _AssessmentAspek({required this.id, @JsonKey(name: 'domain_id') required this.domainId, @JsonKey(name: 'nama_aspek') required this.namaAspek, @JsonKey(name: 'bobot_aspek') required this.bobotAspek, @JsonKey(name: 'created_at') this.createdAt = null, @JsonKey(name: 'updated_at') this.updatedAt = null, @JsonKey(name: 'deleted_at') this.deletedAt = null});
  factory _AssessmentAspek.fromJson(Map<String, dynamic> json) => _$AssessmentAspekFromJson(json);

@override final  int id;
@override@JsonKey(name: 'domain_id') final  int domainId;
@override@JsonKey(name: 'nama_aspek') final  String namaAspek;
@override@JsonKey(name: 'bobot_aspek') final  double bobotAspek;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;

/// Create a copy of AssessmentAspek
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssessmentAspekCopyWith<_AssessmentAspek> get copyWith => __$AssessmentAspekCopyWithImpl<_AssessmentAspek>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssessmentAspekToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssessmentAspek&&(identical(other.id, id) || other.id == id)&&(identical(other.domainId, domainId) || other.domainId == domainId)&&(identical(other.namaAspek, namaAspek) || other.namaAspek == namaAspek)&&(identical(other.bobotAspek, bobotAspek) || other.bobotAspek == bobotAspek)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,domainId,namaAspek,bobotAspek,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'AssessmentAspek(id: $id, domainId: $domainId, namaAspek: $namaAspek, bobotAspek: $bobotAspek, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$AssessmentAspekCopyWith<$Res> implements $AssessmentAspekCopyWith<$Res> {
  factory _$AssessmentAspekCopyWith(_AssessmentAspek value, $Res Function(_AssessmentAspek) _then) = __$AssessmentAspekCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'domain_id') int domainId,@JsonKey(name: 'nama_aspek') String namaAspek,@JsonKey(name: 'bobot_aspek') double bobotAspek,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class __$AssessmentAspekCopyWithImpl<$Res>
    implements _$AssessmentAspekCopyWith<$Res> {
  __$AssessmentAspekCopyWithImpl(this._self, this._then);

  final _AssessmentAspek _self;
  final $Res Function(_AssessmentAspek) _then;

/// Create a copy of AssessmentAspek
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? domainId = null,Object? namaAspek = null,Object? bobotAspek = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(_AssessmentAspek(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,domainId: null == domainId ? _self.domainId : domainId // ignore: cast_nullable_to_non_nullable
as int,namaAspek: null == namaAspek ? _self.namaAspek : namaAspek // ignore: cast_nullable_to_non_nullable
as String,bobotAspek: null == bobotAspek ? _self.bobotAspek : bobotAspek // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
