// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pembinaan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Pembinaan {

@FlexibleStringConverter() String get id;@FlexibleStringConverter()@JsonKey(name: 'created_by_id') String get createdById; String get directoryPembinaan; String get judulPembinaan; String get buktiDukungUndanganPembinaan; String get daftarHadirPembinaan; String get materiPembinaan; String get notulaPembinaan;@JsonKey(name: 'creator_name') String get creatorName;@JsonKey(name: 'file_pembinaan') List<FilePembinaan> get files; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Pembinaan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PembinaanCopyWith<Pembinaan> get copyWith => _$PembinaanCopyWithImpl<Pembinaan>(this as Pembinaan, _$identity);

  /// Serializes this Pembinaan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pembinaan&&(identical(other.id, id) || other.id == id)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.directoryPembinaan, directoryPembinaan) || other.directoryPembinaan == directoryPembinaan)&&(identical(other.judulPembinaan, judulPembinaan) || other.judulPembinaan == judulPembinaan)&&(identical(other.buktiDukungUndanganPembinaan, buktiDukungUndanganPembinaan) || other.buktiDukungUndanganPembinaan == buktiDukungUndanganPembinaan)&&(identical(other.daftarHadirPembinaan, daftarHadirPembinaan) || other.daftarHadirPembinaan == daftarHadirPembinaan)&&(identical(other.materiPembinaan, materiPembinaan) || other.materiPembinaan == materiPembinaan)&&(identical(other.notulaPembinaan, notulaPembinaan) || other.notulaPembinaan == notulaPembinaan)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdById,directoryPembinaan,judulPembinaan,buktiDukungUndanganPembinaan,daftarHadirPembinaan,materiPembinaan,notulaPembinaan,creatorName,const DeepCollectionEquality().hash(files),createdAt,updatedAt);

@override
String toString() {
  return 'Pembinaan(id: $id, createdById: $createdById, directoryPembinaan: $directoryPembinaan, judulPembinaan: $judulPembinaan, buktiDukungUndanganPembinaan: $buktiDukungUndanganPembinaan, daftarHadirPembinaan: $daftarHadirPembinaan, materiPembinaan: $materiPembinaan, notulaPembinaan: $notulaPembinaan, creatorName: $creatorName, files: $files, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PembinaanCopyWith<$Res>  {
  factory $PembinaanCopyWith(Pembinaan value, $Res Function(Pembinaan) _then) = _$PembinaanCopyWithImpl;
@useResult
$Res call({
@FlexibleStringConverter() String id,@FlexibleStringConverter()@JsonKey(name: 'created_by_id') String createdById, String directoryPembinaan, String judulPembinaan, String buktiDukungUndanganPembinaan, String daftarHadirPembinaan, String materiPembinaan, String notulaPembinaan,@JsonKey(name: 'creator_name') String creatorName,@JsonKey(name: 'file_pembinaan') List<FilePembinaan> files, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$PembinaanCopyWithImpl<$Res>
    implements $PembinaanCopyWith<$Res> {
  _$PembinaanCopyWithImpl(this._self, this._then);

  final Pembinaan _self;
  final $Res Function(Pembinaan) _then;

/// Create a copy of Pembinaan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdById = null,Object? directoryPembinaan = null,Object? judulPembinaan = null,Object? buktiDukungUndanganPembinaan = null,Object? daftarHadirPembinaan = null,Object? materiPembinaan = null,Object? notulaPembinaan = null,Object? creatorName = null,Object? files = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdById: null == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String,directoryPembinaan: null == directoryPembinaan ? _self.directoryPembinaan : directoryPembinaan // ignore: cast_nullable_to_non_nullable
as String,judulPembinaan: null == judulPembinaan ? _self.judulPembinaan : judulPembinaan // ignore: cast_nullable_to_non_nullable
as String,buktiDukungUndanganPembinaan: null == buktiDukungUndanganPembinaan ? _self.buktiDukungUndanganPembinaan : buktiDukungUndanganPembinaan // ignore: cast_nullable_to_non_nullable
as String,daftarHadirPembinaan: null == daftarHadirPembinaan ? _self.daftarHadirPembinaan : daftarHadirPembinaan // ignore: cast_nullable_to_non_nullable
as String,materiPembinaan: null == materiPembinaan ? _self.materiPembinaan : materiPembinaan // ignore: cast_nullable_to_non_nullable
as String,notulaPembinaan: null == notulaPembinaan ? _self.notulaPembinaan : notulaPembinaan // ignore: cast_nullable_to_non_nullable
as String,creatorName: null == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<FilePembinaan>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Pembinaan].
extension PembinaanPatterns on Pembinaan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pembinaan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pembinaan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pembinaan value)  $default,){
final _that = this;
switch (_that) {
case _Pembinaan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pembinaan value)?  $default,){
final _that = this;
switch (_that) {
case _Pembinaan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@FlexibleStringConverter()  String id, @FlexibleStringConverter()@JsonKey(name: 'created_by_id')  String createdById,  String directoryPembinaan,  String judulPembinaan,  String buktiDukungUndanganPembinaan,  String daftarHadirPembinaan,  String materiPembinaan,  String notulaPembinaan, @JsonKey(name: 'creator_name')  String creatorName, @JsonKey(name: 'file_pembinaan')  List<FilePembinaan> files,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pembinaan() when $default != null:
return $default(_that.id,_that.createdById,_that.directoryPembinaan,_that.judulPembinaan,_that.buktiDukungUndanganPembinaan,_that.daftarHadirPembinaan,_that.materiPembinaan,_that.notulaPembinaan,_that.creatorName,_that.files,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@FlexibleStringConverter()  String id, @FlexibleStringConverter()@JsonKey(name: 'created_by_id')  String createdById,  String directoryPembinaan,  String judulPembinaan,  String buktiDukungUndanganPembinaan,  String daftarHadirPembinaan,  String materiPembinaan,  String notulaPembinaan, @JsonKey(name: 'creator_name')  String creatorName, @JsonKey(name: 'file_pembinaan')  List<FilePembinaan> files,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Pembinaan():
return $default(_that.id,_that.createdById,_that.directoryPembinaan,_that.judulPembinaan,_that.buktiDukungUndanganPembinaan,_that.daftarHadirPembinaan,_that.materiPembinaan,_that.notulaPembinaan,_that.creatorName,_that.files,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@FlexibleStringConverter()  String id, @FlexibleStringConverter()@JsonKey(name: 'created_by_id')  String createdById,  String directoryPembinaan,  String judulPembinaan,  String buktiDukungUndanganPembinaan,  String daftarHadirPembinaan,  String materiPembinaan,  String notulaPembinaan, @JsonKey(name: 'creator_name')  String creatorName, @JsonKey(name: 'file_pembinaan')  List<FilePembinaan> files,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Pembinaan() when $default != null:
return $default(_that.id,_that.createdById,_that.directoryPembinaan,_that.judulPembinaan,_that.buktiDukungUndanganPembinaan,_that.daftarHadirPembinaan,_that.materiPembinaan,_that.notulaPembinaan,_that.creatorName,_that.files,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pembinaan implements Pembinaan {
  const _Pembinaan({@FlexibleStringConverter() required this.id, @FlexibleStringConverter()@JsonKey(name: 'created_by_id') required this.createdById, required this.directoryPembinaan, required this.judulPembinaan, required this.buktiDukungUndanganPembinaan, required this.daftarHadirPembinaan, required this.materiPembinaan, required this.notulaPembinaan, @JsonKey(name: 'creator_name') this.creatorName = 'Pengguna', @JsonKey(name: 'file_pembinaan') final  List<FilePembinaan> files = const [], required this.createdAt, required this.updatedAt}): _files = files;
  factory _Pembinaan.fromJson(Map<String, dynamic> json) => _$PembinaanFromJson(json);

@override@FlexibleStringConverter() final  String id;
@override@FlexibleStringConverter()@JsonKey(name: 'created_by_id') final  String createdById;
@override final  String directoryPembinaan;
@override final  String judulPembinaan;
@override final  String buktiDukungUndanganPembinaan;
@override final  String daftarHadirPembinaan;
@override final  String materiPembinaan;
@override final  String notulaPembinaan;
@override@JsonKey(name: 'creator_name') final  String creatorName;
 final  List<FilePembinaan> _files;
@override@JsonKey(name: 'file_pembinaan') List<FilePembinaan> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Pembinaan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PembinaanCopyWith<_Pembinaan> get copyWith => __$PembinaanCopyWithImpl<_Pembinaan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PembinaanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pembinaan&&(identical(other.id, id) || other.id == id)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.directoryPembinaan, directoryPembinaan) || other.directoryPembinaan == directoryPembinaan)&&(identical(other.judulPembinaan, judulPembinaan) || other.judulPembinaan == judulPembinaan)&&(identical(other.buktiDukungUndanganPembinaan, buktiDukungUndanganPembinaan) || other.buktiDukungUndanganPembinaan == buktiDukungUndanganPembinaan)&&(identical(other.daftarHadirPembinaan, daftarHadirPembinaan) || other.daftarHadirPembinaan == daftarHadirPembinaan)&&(identical(other.materiPembinaan, materiPembinaan) || other.materiPembinaan == materiPembinaan)&&(identical(other.notulaPembinaan, notulaPembinaan) || other.notulaPembinaan == notulaPembinaan)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdById,directoryPembinaan,judulPembinaan,buktiDukungUndanganPembinaan,daftarHadirPembinaan,materiPembinaan,notulaPembinaan,creatorName,const DeepCollectionEquality().hash(_files),createdAt,updatedAt);

@override
String toString() {
  return 'Pembinaan(id: $id, createdById: $createdById, directoryPembinaan: $directoryPembinaan, judulPembinaan: $judulPembinaan, buktiDukungUndanganPembinaan: $buktiDukungUndanganPembinaan, daftarHadirPembinaan: $daftarHadirPembinaan, materiPembinaan: $materiPembinaan, notulaPembinaan: $notulaPembinaan, creatorName: $creatorName, files: $files, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PembinaanCopyWith<$Res> implements $PembinaanCopyWith<$Res> {
  factory _$PembinaanCopyWith(_Pembinaan value, $Res Function(_Pembinaan) _then) = __$PembinaanCopyWithImpl;
@override @useResult
$Res call({
@FlexibleStringConverter() String id,@FlexibleStringConverter()@JsonKey(name: 'created_by_id') String createdById, String directoryPembinaan, String judulPembinaan, String buktiDukungUndanganPembinaan, String daftarHadirPembinaan, String materiPembinaan, String notulaPembinaan,@JsonKey(name: 'creator_name') String creatorName,@JsonKey(name: 'file_pembinaan') List<FilePembinaan> files, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$PembinaanCopyWithImpl<$Res>
    implements _$PembinaanCopyWith<$Res> {
  __$PembinaanCopyWithImpl(this._self, this._then);

  final _Pembinaan _self;
  final $Res Function(_Pembinaan) _then;

/// Create a copy of Pembinaan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdById = null,Object? directoryPembinaan = null,Object? judulPembinaan = null,Object? buktiDukungUndanganPembinaan = null,Object? daftarHadirPembinaan = null,Object? materiPembinaan = null,Object? notulaPembinaan = null,Object? creatorName = null,Object? files = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Pembinaan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdById: null == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String,directoryPembinaan: null == directoryPembinaan ? _self.directoryPembinaan : directoryPembinaan // ignore: cast_nullable_to_non_nullable
as String,judulPembinaan: null == judulPembinaan ? _self.judulPembinaan : judulPembinaan // ignore: cast_nullable_to_non_nullable
as String,buktiDukungUndanganPembinaan: null == buktiDukungUndanganPembinaan ? _self.buktiDukungUndanganPembinaan : buktiDukungUndanganPembinaan // ignore: cast_nullable_to_non_nullable
as String,daftarHadirPembinaan: null == daftarHadirPembinaan ? _self.daftarHadirPembinaan : daftarHadirPembinaan // ignore: cast_nullable_to_non_nullable
as String,materiPembinaan: null == materiPembinaan ? _self.materiPembinaan : materiPembinaan // ignore: cast_nullable_to_non_nullable
as String,notulaPembinaan: null == notulaPembinaan ? _self.notulaPembinaan : notulaPembinaan // ignore: cast_nullable_to_non_nullable
as String,creatorName: null == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<FilePembinaan>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
