// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment_domain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssessmentDomain {

 int get id;@JsonKey(name: 'nama_domain') String get namaDomain;@JsonKey(name: 'bobot_domain') double get bobotDomain;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;
/// Create a copy of AssessmentDomain
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssessmentDomainCopyWith<AssessmentDomain> get copyWith => _$AssessmentDomainCopyWithImpl<AssessmentDomain>(this as AssessmentDomain, _$identity);

  /// Serializes this AssessmentDomain to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssessmentDomain&&(identical(other.id, id) || other.id == id)&&(identical(other.namaDomain, namaDomain) || other.namaDomain == namaDomain)&&(identical(other.bobotDomain, bobotDomain) || other.bobotDomain == bobotDomain)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,namaDomain,bobotDomain,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'AssessmentDomain(id: $id, namaDomain: $namaDomain, bobotDomain: $bobotDomain, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $AssessmentDomainCopyWith<$Res>  {
  factory $AssessmentDomainCopyWith(AssessmentDomain value, $Res Function(AssessmentDomain) _then) = _$AssessmentDomainCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'nama_domain') String namaDomain,@JsonKey(name: 'bobot_domain') double bobotDomain,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class _$AssessmentDomainCopyWithImpl<$Res>
    implements $AssessmentDomainCopyWith<$Res> {
  _$AssessmentDomainCopyWithImpl(this._self, this._then);

  final AssessmentDomain _self;
  final $Res Function(AssessmentDomain) _then;

/// Create a copy of AssessmentDomain
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? namaDomain = null,Object? bobotDomain = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,namaDomain: null == namaDomain ? _self.namaDomain : namaDomain // ignore: cast_nullable_to_non_nullable
as String,bobotDomain: null == bobotDomain ? _self.bobotDomain : bobotDomain // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssessmentDomain].
extension AssessmentDomainPatterns on AssessmentDomain {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssessmentDomain value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssessmentDomain() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssessmentDomain value)  $default,){
final _that = this;
switch (_that) {
case _AssessmentDomain():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssessmentDomain value)?  $default,){
final _that = this;
switch (_that) {
case _AssessmentDomain() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama_domain')  String namaDomain, @JsonKey(name: 'bobot_domain')  double bobotDomain, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssessmentDomain() when $default != null:
return $default(_that.id,_that.namaDomain,_that.bobotDomain,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama_domain')  String namaDomain, @JsonKey(name: 'bobot_domain')  double bobotDomain, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _AssessmentDomain():
return $default(_that.id,_that.namaDomain,_that.bobotDomain,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'nama_domain')  String namaDomain, @JsonKey(name: 'bobot_domain')  double bobotDomain, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _AssessmentDomain() when $default != null:
return $default(_that.id,_that.namaDomain,_that.bobotDomain,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssessmentDomain implements AssessmentDomain {
  const _AssessmentDomain({required this.id, @JsonKey(name: 'nama_domain') required this.namaDomain, @JsonKey(name: 'bobot_domain') required this.bobotDomain, @JsonKey(name: 'created_at') this.createdAt = null, @JsonKey(name: 'updated_at') this.updatedAt = null, @JsonKey(name: 'deleted_at') this.deletedAt = null});
  factory _AssessmentDomain.fromJson(Map<String, dynamic> json) => _$AssessmentDomainFromJson(json);

@override final  int id;
@override@JsonKey(name: 'nama_domain') final  String namaDomain;
@override@JsonKey(name: 'bobot_domain') final  double bobotDomain;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;

/// Create a copy of AssessmentDomain
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssessmentDomainCopyWith<_AssessmentDomain> get copyWith => __$AssessmentDomainCopyWithImpl<_AssessmentDomain>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssessmentDomainToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssessmentDomain&&(identical(other.id, id) || other.id == id)&&(identical(other.namaDomain, namaDomain) || other.namaDomain == namaDomain)&&(identical(other.bobotDomain, bobotDomain) || other.bobotDomain == bobotDomain)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,namaDomain,bobotDomain,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'AssessmentDomain(id: $id, namaDomain: $namaDomain, bobotDomain: $bobotDomain, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$AssessmentDomainCopyWith<$Res> implements $AssessmentDomainCopyWith<$Res> {
  factory _$AssessmentDomainCopyWith(_AssessmentDomain value, $Res Function(_AssessmentDomain) _then) = __$AssessmentDomainCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'nama_domain') String namaDomain,@JsonKey(name: 'bobot_domain') double bobotDomain,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class __$AssessmentDomainCopyWithImpl<$Res>
    implements _$AssessmentDomainCopyWith<$Res> {
  __$AssessmentDomainCopyWithImpl(this._self, this._then);

  final _AssessmentDomain _self;
  final $Res Function(_AssessmentDomain) _then;

/// Create a copy of AssessmentDomain
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? namaDomain = null,Object? bobotDomain = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(_AssessmentDomain(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,namaDomain: null == namaDomain ? _self.namaDomain : namaDomain // ignore: cast_nullable_to_non_nullable
as String,bobotDomain: null == bobotDomain ? _self.bobotDomain : bobotDomain // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
