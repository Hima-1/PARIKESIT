// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bukti_dukung.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BuktiDukung {

 int get id;@JsonKey(name: 'penilaian_id') int get penilaianId; String get path;@JsonKey(name: 'nama_file') String get namaFile;@JsonKey(name: 'ukuran_file') int get ukuranFile;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of BuktiDukung
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BuktiDukungCopyWith<BuktiDukung> get copyWith => _$BuktiDukungCopyWithImpl<BuktiDukung>(this as BuktiDukung, _$identity);

  /// Serializes this BuktiDukung to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BuktiDukung&&(identical(other.id, id) || other.id == id)&&(identical(other.penilaianId, penilaianId) || other.penilaianId == penilaianId)&&(identical(other.path, path) || other.path == path)&&(identical(other.namaFile, namaFile) || other.namaFile == namaFile)&&(identical(other.ukuranFile, ukuranFile) || other.ukuranFile == ukuranFile)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,penilaianId,path,namaFile,ukuranFile,createdAt,updatedAt);

@override
String toString() {
  return 'BuktiDukung(id: $id, penilaianId: $penilaianId, path: $path, namaFile: $namaFile, ukuranFile: $ukuranFile, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BuktiDukungCopyWith<$Res>  {
  factory $BuktiDukungCopyWith(BuktiDukung value, $Res Function(BuktiDukung) _then) = _$BuktiDukungCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'penilaian_id') int penilaianId, String path,@JsonKey(name: 'nama_file') String namaFile,@JsonKey(name: 'ukuran_file') int ukuranFile,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$BuktiDukungCopyWithImpl<$Res>
    implements $BuktiDukungCopyWith<$Res> {
  _$BuktiDukungCopyWithImpl(this._self, this._then);

  final BuktiDukung _self;
  final $Res Function(BuktiDukung) _then;

/// Create a copy of BuktiDukung
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? penilaianId = null,Object? path = null,Object? namaFile = null,Object? ukuranFile = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,penilaianId: null == penilaianId ? _self.penilaianId : penilaianId // ignore: cast_nullable_to_non_nullable
as int,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,namaFile: null == namaFile ? _self.namaFile : namaFile // ignore: cast_nullable_to_non_nullable
as String,ukuranFile: null == ukuranFile ? _self.ukuranFile : ukuranFile // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BuktiDukung].
extension BuktiDukungPatterns on BuktiDukung {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BuktiDukung value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BuktiDukung() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BuktiDukung value)  $default,){
final _that = this;
switch (_that) {
case _BuktiDukung():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BuktiDukung value)?  $default,){
final _that = this;
switch (_that) {
case _BuktiDukung() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'penilaian_id')  int penilaianId,  String path, @JsonKey(name: 'nama_file')  String namaFile, @JsonKey(name: 'ukuran_file')  int ukuranFile, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BuktiDukung() when $default != null:
return $default(_that.id,_that.penilaianId,_that.path,_that.namaFile,_that.ukuranFile,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'penilaian_id')  int penilaianId,  String path, @JsonKey(name: 'nama_file')  String namaFile, @JsonKey(name: 'ukuran_file')  int ukuranFile, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BuktiDukung():
return $default(_that.id,_that.penilaianId,_that.path,_that.namaFile,_that.ukuranFile,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'penilaian_id')  int penilaianId,  String path, @JsonKey(name: 'nama_file')  String namaFile, @JsonKey(name: 'ukuran_file')  int ukuranFile, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BuktiDukung() when $default != null:
return $default(_that.id,_that.penilaianId,_that.path,_that.namaFile,_that.ukuranFile,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BuktiDukung implements BuktiDukung {
  const _BuktiDukung({required this.id, @JsonKey(name: 'penilaian_id') required this.penilaianId, required this.path, @JsonKey(name: 'nama_file') required this.namaFile, @JsonKey(name: 'ukuran_file') required this.ukuranFile, @JsonKey(name: 'created_at') this.createdAt = null, @JsonKey(name: 'updated_at') this.updatedAt = null});
  factory _BuktiDukung.fromJson(Map<String, dynamic> json) => _$BuktiDukungFromJson(json);

@override final  int id;
@override@JsonKey(name: 'penilaian_id') final  int penilaianId;
@override final  String path;
@override@JsonKey(name: 'nama_file') final  String namaFile;
@override@JsonKey(name: 'ukuran_file') final  int ukuranFile;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of BuktiDukung
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BuktiDukungCopyWith<_BuktiDukung> get copyWith => __$BuktiDukungCopyWithImpl<_BuktiDukung>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BuktiDukungToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BuktiDukung&&(identical(other.id, id) || other.id == id)&&(identical(other.penilaianId, penilaianId) || other.penilaianId == penilaianId)&&(identical(other.path, path) || other.path == path)&&(identical(other.namaFile, namaFile) || other.namaFile == namaFile)&&(identical(other.ukuranFile, ukuranFile) || other.ukuranFile == ukuranFile)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,penilaianId,path,namaFile,ukuranFile,createdAt,updatedAt);

@override
String toString() {
  return 'BuktiDukung(id: $id, penilaianId: $penilaianId, path: $path, namaFile: $namaFile, ukuranFile: $ukuranFile, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BuktiDukungCopyWith<$Res> implements $BuktiDukungCopyWith<$Res> {
  factory _$BuktiDukungCopyWith(_BuktiDukung value, $Res Function(_BuktiDukung) _then) = __$BuktiDukungCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'penilaian_id') int penilaianId, String path,@JsonKey(name: 'nama_file') String namaFile,@JsonKey(name: 'ukuran_file') int ukuranFile,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$BuktiDukungCopyWithImpl<$Res>
    implements _$BuktiDukungCopyWith<$Res> {
  __$BuktiDukungCopyWithImpl(this._self, this._then);

  final _BuktiDukung _self;
  final $Res Function(_BuktiDukung) _then;

/// Create a copy of BuktiDukung
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? penilaianId = null,Object? path = null,Object? namaFile = null,Object? ukuranFile = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_BuktiDukung(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,penilaianId: null == penilaianId ? _self.penilaianId : penilaianId // ignore: cast_nullable_to_non_nullable
as int,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,namaFile: null == namaFile ? _self.namaFile : namaFile // ignore: cast_nullable_to_non_nullable
as String,ukuranFile: null == ukuranFile ? _self.ukuranFile : ukuranFile // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
