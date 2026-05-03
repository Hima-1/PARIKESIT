// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_dokumentasi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FileDokumentasi {

@FlexibleStringConverter() String get id;@FlexibleStringConverter() String get dokumentasiKegiatanId; String get namaFile; String get tipeFile; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of FileDokumentasi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileDokumentasiCopyWith<FileDokumentasi> get copyWith => _$FileDokumentasiCopyWithImpl<FileDokumentasi>(this as FileDokumentasi, _$identity);

  /// Serializes this FileDokumentasi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileDokumentasi&&(identical(other.id, id) || other.id == id)&&(identical(other.dokumentasiKegiatanId, dokumentasiKegiatanId) || other.dokumentasiKegiatanId == dokumentasiKegiatanId)&&(identical(other.namaFile, namaFile) || other.namaFile == namaFile)&&(identical(other.tipeFile, tipeFile) || other.tipeFile == tipeFile)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dokumentasiKegiatanId,namaFile,tipeFile,createdAt,updatedAt);

@override
String toString() {
  return 'FileDokumentasi(id: $id, dokumentasiKegiatanId: $dokumentasiKegiatanId, namaFile: $namaFile, tipeFile: $tipeFile, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FileDokumentasiCopyWith<$Res>  {
  factory $FileDokumentasiCopyWith(FileDokumentasi value, $Res Function(FileDokumentasi) _then) = _$FileDokumentasiCopyWithImpl;
@useResult
$Res call({
@FlexibleStringConverter() String id,@FlexibleStringConverter() String dokumentasiKegiatanId, String namaFile, String tipeFile, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$FileDokumentasiCopyWithImpl<$Res>
    implements $FileDokumentasiCopyWith<$Res> {
  _$FileDokumentasiCopyWithImpl(this._self, this._then);

  final FileDokumentasi _self;
  final $Res Function(FileDokumentasi) _then;

/// Create a copy of FileDokumentasi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dokumentasiKegiatanId = null,Object? namaFile = null,Object? tipeFile = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dokumentasiKegiatanId: null == dokumentasiKegiatanId ? _self.dokumentasiKegiatanId : dokumentasiKegiatanId // ignore: cast_nullable_to_non_nullable
as String,namaFile: null == namaFile ? _self.namaFile : namaFile // ignore: cast_nullable_to_non_nullable
as String,tipeFile: null == tipeFile ? _self.tipeFile : tipeFile // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FileDokumentasi].
extension FileDokumentasiPatterns on FileDokumentasi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileDokumentasi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileDokumentasi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileDokumentasi value)  $default,){
final _that = this;
switch (_that) {
case _FileDokumentasi():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileDokumentasi value)?  $default,){
final _that = this;
switch (_that) {
case _FileDokumentasi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@FlexibleStringConverter()  String id, @FlexibleStringConverter()  String dokumentasiKegiatanId,  String namaFile,  String tipeFile,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileDokumentasi() when $default != null:
return $default(_that.id,_that.dokumentasiKegiatanId,_that.namaFile,_that.tipeFile,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@FlexibleStringConverter()  String id, @FlexibleStringConverter()  String dokumentasiKegiatanId,  String namaFile,  String tipeFile,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FileDokumentasi():
return $default(_that.id,_that.dokumentasiKegiatanId,_that.namaFile,_that.tipeFile,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@FlexibleStringConverter()  String id, @FlexibleStringConverter()  String dokumentasiKegiatanId,  String namaFile,  String tipeFile,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FileDokumentasi() when $default != null:
return $default(_that.id,_that.dokumentasiKegiatanId,_that.namaFile,_that.tipeFile,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileDokumentasi implements FileDokumentasi {
  const _FileDokumentasi({@FlexibleStringConverter() required this.id, @FlexibleStringConverter() required this.dokumentasiKegiatanId, required this.namaFile, required this.tipeFile, required this.createdAt, required this.updatedAt});
  factory _FileDokumentasi.fromJson(Map<String, dynamic> json) => _$FileDokumentasiFromJson(json);

@override@FlexibleStringConverter() final  String id;
@override@FlexibleStringConverter() final  String dokumentasiKegiatanId;
@override final  String namaFile;
@override final  String tipeFile;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of FileDokumentasi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileDokumentasiCopyWith<_FileDokumentasi> get copyWith => __$FileDokumentasiCopyWithImpl<_FileDokumentasi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileDokumentasiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileDokumentasi&&(identical(other.id, id) || other.id == id)&&(identical(other.dokumentasiKegiatanId, dokumentasiKegiatanId) || other.dokumentasiKegiatanId == dokumentasiKegiatanId)&&(identical(other.namaFile, namaFile) || other.namaFile == namaFile)&&(identical(other.tipeFile, tipeFile) || other.tipeFile == tipeFile)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dokumentasiKegiatanId,namaFile,tipeFile,createdAt,updatedAt);

@override
String toString() {
  return 'FileDokumentasi(id: $id, dokumentasiKegiatanId: $dokumentasiKegiatanId, namaFile: $namaFile, tipeFile: $tipeFile, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FileDokumentasiCopyWith<$Res> implements $FileDokumentasiCopyWith<$Res> {
  factory _$FileDokumentasiCopyWith(_FileDokumentasi value, $Res Function(_FileDokumentasi) _then) = __$FileDokumentasiCopyWithImpl;
@override @useResult
$Res call({
@FlexibleStringConverter() String id,@FlexibleStringConverter() String dokumentasiKegiatanId, String namaFile, String tipeFile, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$FileDokumentasiCopyWithImpl<$Res>
    implements _$FileDokumentasiCopyWith<$Res> {
  __$FileDokumentasiCopyWithImpl(this._self, this._then);

  final _FileDokumentasi _self;
  final $Res Function(_FileDokumentasi) _then;

/// Create a copy of FileDokumentasi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dokumentasiKegiatanId = null,Object? namaFile = null,Object? tipeFile = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_FileDokumentasi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dokumentasiKegiatanId: null == dokumentasiKegiatanId ? _self.dokumentasiKegiatanId : dokumentasiKegiatanId // ignore: cast_nullable_to_non_nullable
as String,namaFile: null == namaFile ? _self.namaFile : namaFile // ignore: cast_nullable_to_non_nullable
as String,tipeFile: null == tipeFile ? _self.tipeFile : tipeFile // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
