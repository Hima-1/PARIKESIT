// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment_disposisi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssessmentDisposisi {

 int get id;@JsonKey(name: 'formulir_id') int get formulirId;@JsonKey(name: 'indikator_id') int? get indikatorId;@JsonKey(name: 'from_profile_id') int? get fromUserId;@JsonKey(name: 'to_profile_id') int? get toUserId;@JsonKey(name: 'assigned_profile_id') int? get assignedUserId; DisposisiStatus get status; String? get catatan;@JsonKey(name: 'is_completed') bool get isCompleted;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of AssessmentDisposisi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssessmentDisposisiCopyWith<AssessmentDisposisi> get copyWith => _$AssessmentDisposisiCopyWithImpl<AssessmentDisposisi>(this as AssessmentDisposisi, _$identity);

  /// Serializes this AssessmentDisposisi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssessmentDisposisi&&(identical(other.id, id) || other.id == id)&&(identical(other.formulirId, formulirId) || other.formulirId == formulirId)&&(identical(other.indikatorId, indikatorId) || other.indikatorId == indikatorId)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.assignedUserId, assignedUserId) || other.assignedUserId == assignedUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,formulirId,indikatorId,fromUserId,toUserId,assignedUserId,status,catatan,isCompleted,createdAt);

@override
String toString() {
  return 'AssessmentDisposisi(id: $id, formulirId: $formulirId, indikatorId: $indikatorId, fromUserId: $fromUserId, toUserId: $toUserId, assignedUserId: $assignedUserId, status: $status, catatan: $catatan, isCompleted: $isCompleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AssessmentDisposisiCopyWith<$Res>  {
  factory $AssessmentDisposisiCopyWith(AssessmentDisposisi value, $Res Function(AssessmentDisposisi) _then) = _$AssessmentDisposisiCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'formulir_id') int formulirId,@JsonKey(name: 'indikator_id') int? indikatorId,@JsonKey(name: 'from_profile_id') int? fromUserId,@JsonKey(name: 'to_profile_id') int? toUserId,@JsonKey(name: 'assigned_profile_id') int? assignedUserId, DisposisiStatus status, String? catatan,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$AssessmentDisposisiCopyWithImpl<$Res>
    implements $AssessmentDisposisiCopyWith<$Res> {
  _$AssessmentDisposisiCopyWithImpl(this._self, this._then);

  final AssessmentDisposisi _self;
  final $Res Function(AssessmentDisposisi) _then;

/// Create a copy of AssessmentDisposisi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? formulirId = null,Object? indikatorId = freezed,Object? fromUserId = freezed,Object? toUserId = freezed,Object? assignedUserId = freezed,Object? status = null,Object? catatan = freezed,Object? isCompleted = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,formulirId: null == formulirId ? _self.formulirId : formulirId // ignore: cast_nullable_to_non_nullable
as int,indikatorId: freezed == indikatorId ? _self.indikatorId : indikatorId // ignore: cast_nullable_to_non_nullable
as int?,fromUserId: freezed == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as int?,toUserId: freezed == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as int?,assignedUserId: freezed == assignedUserId ? _self.assignedUserId : assignedUserId // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DisposisiStatus,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssessmentDisposisi].
extension AssessmentDisposisiPatterns on AssessmentDisposisi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssessmentDisposisi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssessmentDisposisi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssessmentDisposisi value)  $default,){
final _that = this;
switch (_that) {
case _AssessmentDisposisi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssessmentDisposisi value)?  $default,){
final _that = this;
switch (_that) {
case _AssessmentDisposisi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'formulir_id')  int formulirId, @JsonKey(name: 'indikator_id')  int? indikatorId, @JsonKey(name: 'from_profile_id')  int? fromUserId, @JsonKey(name: 'to_profile_id')  int? toUserId, @JsonKey(name: 'assigned_profile_id')  int? assignedUserId,  DisposisiStatus status,  String? catatan, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssessmentDisposisi() when $default != null:
return $default(_that.id,_that.formulirId,_that.indikatorId,_that.fromUserId,_that.toUserId,_that.assignedUserId,_that.status,_that.catatan,_that.isCompleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'formulir_id')  int formulirId, @JsonKey(name: 'indikator_id')  int? indikatorId, @JsonKey(name: 'from_profile_id')  int? fromUserId, @JsonKey(name: 'to_profile_id')  int? toUserId, @JsonKey(name: 'assigned_profile_id')  int? assignedUserId,  DisposisiStatus status,  String? catatan, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AssessmentDisposisi():
return $default(_that.id,_that.formulirId,_that.indikatorId,_that.fromUserId,_that.toUserId,_that.assignedUserId,_that.status,_that.catatan,_that.isCompleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'formulir_id')  int formulirId, @JsonKey(name: 'indikator_id')  int? indikatorId, @JsonKey(name: 'from_profile_id')  int? fromUserId, @JsonKey(name: 'to_profile_id')  int? toUserId, @JsonKey(name: 'assigned_profile_id')  int? assignedUserId,  DisposisiStatus status,  String? catatan, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AssessmentDisposisi() when $default != null:
return $default(_that.id,_that.formulirId,_that.indikatorId,_that.fromUserId,_that.toUserId,_that.assignedUserId,_that.status,_that.catatan,_that.isCompleted,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssessmentDisposisi implements AssessmentDisposisi {
  const _AssessmentDisposisi({required this.id, @JsonKey(name: 'formulir_id') required this.formulirId, @JsonKey(name: 'indikator_id') this.indikatorId, @JsonKey(name: 'from_profile_id') this.fromUserId, @JsonKey(name: 'to_profile_id') this.toUserId, @JsonKey(name: 'assigned_profile_id') this.assignedUserId, required this.status, this.catatan, @JsonKey(name: 'is_completed') this.isCompleted = false, @JsonKey(name: 'created_at') this.createdAt});
  factory _AssessmentDisposisi.fromJson(Map<String, dynamic> json) => _$AssessmentDisposisiFromJson(json);

@override final  int id;
@override@JsonKey(name: 'formulir_id') final  int formulirId;
@override@JsonKey(name: 'indikator_id') final  int? indikatorId;
@override@JsonKey(name: 'from_profile_id') final  int? fromUserId;
@override@JsonKey(name: 'to_profile_id') final  int? toUserId;
@override@JsonKey(name: 'assigned_profile_id') final  int? assignedUserId;
@override final  DisposisiStatus status;
@override final  String? catatan;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of AssessmentDisposisi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssessmentDisposisiCopyWith<_AssessmentDisposisi> get copyWith => __$AssessmentDisposisiCopyWithImpl<_AssessmentDisposisi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssessmentDisposisiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssessmentDisposisi&&(identical(other.id, id) || other.id == id)&&(identical(other.formulirId, formulirId) || other.formulirId == formulirId)&&(identical(other.indikatorId, indikatorId) || other.indikatorId == indikatorId)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.assignedUserId, assignedUserId) || other.assignedUserId == assignedUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,formulirId,indikatorId,fromUserId,toUserId,assignedUserId,status,catatan,isCompleted,createdAt);

@override
String toString() {
  return 'AssessmentDisposisi(id: $id, formulirId: $formulirId, indikatorId: $indikatorId, fromUserId: $fromUserId, toUserId: $toUserId, assignedUserId: $assignedUserId, status: $status, catatan: $catatan, isCompleted: $isCompleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AssessmentDisposisiCopyWith<$Res> implements $AssessmentDisposisiCopyWith<$Res> {
  factory _$AssessmentDisposisiCopyWith(_AssessmentDisposisi value, $Res Function(_AssessmentDisposisi) _then) = __$AssessmentDisposisiCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'formulir_id') int formulirId,@JsonKey(name: 'indikator_id') int? indikatorId,@JsonKey(name: 'from_profile_id') int? fromUserId,@JsonKey(name: 'to_profile_id') int? toUserId,@JsonKey(name: 'assigned_profile_id') int? assignedUserId, DisposisiStatus status, String? catatan,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$AssessmentDisposisiCopyWithImpl<$Res>
    implements _$AssessmentDisposisiCopyWith<$Res> {
  __$AssessmentDisposisiCopyWithImpl(this._self, this._then);

  final _AssessmentDisposisi _self;
  final $Res Function(_AssessmentDisposisi) _then;

/// Create a copy of AssessmentDisposisi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? formulirId = null,Object? indikatorId = freezed,Object? fromUserId = freezed,Object? toUserId = freezed,Object? assignedUserId = freezed,Object? status = null,Object? catatan = freezed,Object? isCompleted = null,Object? createdAt = freezed,}) {
  return _then(_AssessmentDisposisi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,formulirId: null == formulirId ? _self.formulirId : formulirId // ignore: cast_nullable_to_non_nullable
as int,indikatorId: freezed == indikatorId ? _self.indikatorId : indikatorId // ignore: cast_nullable_to_non_nullable
as int?,fromUserId: freezed == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as int?,toUserId: freezed == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as int?,assignedUserId: freezed == assignedUserId ? _self.assignedUserId : assignedUserId // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DisposisiStatus,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
