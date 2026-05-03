// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dokumentasi_kegiatan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DokumentasiKegiatan {

@FlexibleStringConverter() String get id;@FlexibleStringConverter()@JsonKey(name: 'created_by_id') String get createdById;@JsonKey(name: 'directory_dokumentasi') String get directoryDokumentasi;@JsonKey(name: 'judul_dokumentasi') String get judulDokumentasi;@JsonKey(name: 'bukti_dukung_undangan_dokumentasi') String get buktiDukungUndanganDokumentasi;@JsonKey(name: 'daftar_hadir_dokumentasi') String get daftarHadirDokumentasi;@JsonKey(name: 'materi_dokumentasi') String get materiDokumentasi;@JsonKey(name: 'notula_dokumentasi') String get notulaDokumentasi;@JsonKey(name: 'creator_name') String get creatorName;@JsonKey(name: 'file_dokumentasi') List<FileDokumentasi> get files;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of DokumentasiKegiatan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DokumentasiKegiatanCopyWith<DokumentasiKegiatan> get copyWith => _$DokumentasiKegiatanCopyWithImpl<DokumentasiKegiatan>(this as DokumentasiKegiatan, _$identity);

  /// Serializes this DokumentasiKegiatan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DokumentasiKegiatan&&(identical(other.id, id) || other.id == id)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.directoryDokumentasi, directoryDokumentasi) || other.directoryDokumentasi == directoryDokumentasi)&&(identical(other.judulDokumentasi, judulDokumentasi) || other.judulDokumentasi == judulDokumentasi)&&(identical(other.buktiDukungUndanganDokumentasi, buktiDukungUndanganDokumentasi) || other.buktiDukungUndanganDokumentasi == buktiDukungUndanganDokumentasi)&&(identical(other.daftarHadirDokumentasi, daftarHadirDokumentasi) || other.daftarHadirDokumentasi == daftarHadirDokumentasi)&&(identical(other.materiDokumentasi, materiDokumentasi) || other.materiDokumentasi == materiDokumentasi)&&(identical(other.notulaDokumentasi, notulaDokumentasi) || other.notulaDokumentasi == notulaDokumentasi)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdById,directoryDokumentasi,judulDokumentasi,buktiDukungUndanganDokumentasi,daftarHadirDokumentasi,materiDokumentasi,notulaDokumentasi,creatorName,const DeepCollectionEquality().hash(files),createdAt,updatedAt);

@override
String toString() {
  return 'DokumentasiKegiatan(id: $id, createdById: $createdById, directoryDokumentasi: $directoryDokumentasi, judulDokumentasi: $judulDokumentasi, buktiDukungUndanganDokumentasi: $buktiDukungUndanganDokumentasi, daftarHadirDokumentasi: $daftarHadirDokumentasi, materiDokumentasi: $materiDokumentasi, notulaDokumentasi: $notulaDokumentasi, creatorName: $creatorName, files: $files, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DokumentasiKegiatanCopyWith<$Res>  {
  factory $DokumentasiKegiatanCopyWith(DokumentasiKegiatan value, $Res Function(DokumentasiKegiatan) _then) = _$DokumentasiKegiatanCopyWithImpl;
@useResult
$Res call({
@FlexibleStringConverter() String id,@FlexibleStringConverter()@JsonKey(name: 'created_by_id') String createdById,@JsonKey(name: 'directory_dokumentasi') String directoryDokumentasi,@JsonKey(name: 'judul_dokumentasi') String judulDokumentasi,@JsonKey(name: 'bukti_dukung_undangan_dokumentasi') String buktiDukungUndanganDokumentasi,@JsonKey(name: 'daftar_hadir_dokumentasi') String daftarHadirDokumentasi,@JsonKey(name: 'materi_dokumentasi') String materiDokumentasi,@JsonKey(name: 'notula_dokumentasi') String notulaDokumentasi,@JsonKey(name: 'creator_name') String creatorName,@JsonKey(name: 'file_dokumentasi') List<FileDokumentasi> files,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$DokumentasiKegiatanCopyWithImpl<$Res>
    implements $DokumentasiKegiatanCopyWith<$Res> {
  _$DokumentasiKegiatanCopyWithImpl(this._self, this._then);

  final DokumentasiKegiatan _self;
  final $Res Function(DokumentasiKegiatan) _then;

/// Create a copy of DokumentasiKegiatan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdById = null,Object? directoryDokumentasi = null,Object? judulDokumentasi = null,Object? buktiDukungUndanganDokumentasi = null,Object? daftarHadirDokumentasi = null,Object? materiDokumentasi = null,Object? notulaDokumentasi = null,Object? creatorName = null,Object? files = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdById: null == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String,directoryDokumentasi: null == directoryDokumentasi ? _self.directoryDokumentasi : directoryDokumentasi // ignore: cast_nullable_to_non_nullable
as String,judulDokumentasi: null == judulDokumentasi ? _self.judulDokumentasi : judulDokumentasi // ignore: cast_nullable_to_non_nullable
as String,buktiDukungUndanganDokumentasi: null == buktiDukungUndanganDokumentasi ? _self.buktiDukungUndanganDokumentasi : buktiDukungUndanganDokumentasi // ignore: cast_nullable_to_non_nullable
as String,daftarHadirDokumentasi: null == daftarHadirDokumentasi ? _self.daftarHadirDokumentasi : daftarHadirDokumentasi // ignore: cast_nullable_to_non_nullable
as String,materiDokumentasi: null == materiDokumentasi ? _self.materiDokumentasi : materiDokumentasi // ignore: cast_nullable_to_non_nullable
as String,notulaDokumentasi: null == notulaDokumentasi ? _self.notulaDokumentasi : notulaDokumentasi // ignore: cast_nullable_to_non_nullable
as String,creatorName: null == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<FileDokumentasi>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DokumentasiKegiatan].
extension DokumentasiKegiatanPatterns on DokumentasiKegiatan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DokumentasiKegiatan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DokumentasiKegiatan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DokumentasiKegiatan value)  $default,){
final _that = this;
switch (_that) {
case _DokumentasiKegiatan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DokumentasiKegiatan value)?  $default,){
final _that = this;
switch (_that) {
case _DokumentasiKegiatan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@FlexibleStringConverter()  String id, @FlexibleStringConverter()@JsonKey(name: 'created_by_id')  String createdById, @JsonKey(name: 'directory_dokumentasi')  String directoryDokumentasi, @JsonKey(name: 'judul_dokumentasi')  String judulDokumentasi, @JsonKey(name: 'bukti_dukung_undangan_dokumentasi')  String buktiDukungUndanganDokumentasi, @JsonKey(name: 'daftar_hadir_dokumentasi')  String daftarHadirDokumentasi, @JsonKey(name: 'materi_dokumentasi')  String materiDokumentasi, @JsonKey(name: 'notula_dokumentasi')  String notulaDokumentasi, @JsonKey(name: 'creator_name')  String creatorName, @JsonKey(name: 'file_dokumentasi')  List<FileDokumentasi> files, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DokumentasiKegiatan() when $default != null:
return $default(_that.id,_that.createdById,_that.directoryDokumentasi,_that.judulDokumentasi,_that.buktiDukungUndanganDokumentasi,_that.daftarHadirDokumentasi,_that.materiDokumentasi,_that.notulaDokumentasi,_that.creatorName,_that.files,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@FlexibleStringConverter()  String id, @FlexibleStringConverter()@JsonKey(name: 'created_by_id')  String createdById, @JsonKey(name: 'directory_dokumentasi')  String directoryDokumentasi, @JsonKey(name: 'judul_dokumentasi')  String judulDokumentasi, @JsonKey(name: 'bukti_dukung_undangan_dokumentasi')  String buktiDukungUndanganDokumentasi, @JsonKey(name: 'daftar_hadir_dokumentasi')  String daftarHadirDokumentasi, @JsonKey(name: 'materi_dokumentasi')  String materiDokumentasi, @JsonKey(name: 'notula_dokumentasi')  String notulaDokumentasi, @JsonKey(name: 'creator_name')  String creatorName, @JsonKey(name: 'file_dokumentasi')  List<FileDokumentasi> files, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DokumentasiKegiatan():
return $default(_that.id,_that.createdById,_that.directoryDokumentasi,_that.judulDokumentasi,_that.buktiDukungUndanganDokumentasi,_that.daftarHadirDokumentasi,_that.materiDokumentasi,_that.notulaDokumentasi,_that.creatorName,_that.files,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@FlexibleStringConverter()  String id, @FlexibleStringConverter()@JsonKey(name: 'created_by_id')  String createdById, @JsonKey(name: 'directory_dokumentasi')  String directoryDokumentasi, @JsonKey(name: 'judul_dokumentasi')  String judulDokumentasi, @JsonKey(name: 'bukti_dukung_undangan_dokumentasi')  String buktiDukungUndanganDokumentasi, @JsonKey(name: 'daftar_hadir_dokumentasi')  String daftarHadirDokumentasi, @JsonKey(name: 'materi_dokumentasi')  String materiDokumentasi, @JsonKey(name: 'notula_dokumentasi')  String notulaDokumentasi, @JsonKey(name: 'creator_name')  String creatorName, @JsonKey(name: 'file_dokumentasi')  List<FileDokumentasi> files, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DokumentasiKegiatan() when $default != null:
return $default(_that.id,_that.createdById,_that.directoryDokumentasi,_that.judulDokumentasi,_that.buktiDukungUndanganDokumentasi,_that.daftarHadirDokumentasi,_that.materiDokumentasi,_that.notulaDokumentasi,_that.creatorName,_that.files,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DokumentasiKegiatan implements DokumentasiKegiatan {
  const _DokumentasiKegiatan({@FlexibleStringConverter() required this.id, @FlexibleStringConverter()@JsonKey(name: 'created_by_id') required this.createdById, @JsonKey(name: 'directory_dokumentasi') required this.directoryDokumentasi, @JsonKey(name: 'judul_dokumentasi') required this.judulDokumentasi, @JsonKey(name: 'bukti_dukung_undangan_dokumentasi') required this.buktiDukungUndanganDokumentasi, @JsonKey(name: 'daftar_hadir_dokumentasi') required this.daftarHadirDokumentasi, @JsonKey(name: 'materi_dokumentasi') required this.materiDokumentasi, @JsonKey(name: 'notula_dokumentasi') required this.notulaDokumentasi, @JsonKey(name: 'creator_name') this.creatorName = 'Pengguna', @JsonKey(name: 'file_dokumentasi') final  List<FileDokumentasi> files = const [], @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): _files = files;
  factory _DokumentasiKegiatan.fromJson(Map<String, dynamic> json) => _$DokumentasiKegiatanFromJson(json);

@override@FlexibleStringConverter() final  String id;
@override@FlexibleStringConverter()@JsonKey(name: 'created_by_id') final  String createdById;
@override@JsonKey(name: 'directory_dokumentasi') final  String directoryDokumentasi;
@override@JsonKey(name: 'judul_dokumentasi') final  String judulDokumentasi;
@override@JsonKey(name: 'bukti_dukung_undangan_dokumentasi') final  String buktiDukungUndanganDokumentasi;
@override@JsonKey(name: 'daftar_hadir_dokumentasi') final  String daftarHadirDokumentasi;
@override@JsonKey(name: 'materi_dokumentasi') final  String materiDokumentasi;
@override@JsonKey(name: 'notula_dokumentasi') final  String notulaDokumentasi;
@override@JsonKey(name: 'creator_name') final  String creatorName;
 final  List<FileDokumentasi> _files;
@override@JsonKey(name: 'file_dokumentasi') List<FileDokumentasi> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of DokumentasiKegiatan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DokumentasiKegiatanCopyWith<_DokumentasiKegiatan> get copyWith => __$DokumentasiKegiatanCopyWithImpl<_DokumentasiKegiatan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DokumentasiKegiatanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DokumentasiKegiatan&&(identical(other.id, id) || other.id == id)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.directoryDokumentasi, directoryDokumentasi) || other.directoryDokumentasi == directoryDokumentasi)&&(identical(other.judulDokumentasi, judulDokumentasi) || other.judulDokumentasi == judulDokumentasi)&&(identical(other.buktiDukungUndanganDokumentasi, buktiDukungUndanganDokumentasi) || other.buktiDukungUndanganDokumentasi == buktiDukungUndanganDokumentasi)&&(identical(other.daftarHadirDokumentasi, daftarHadirDokumentasi) || other.daftarHadirDokumentasi == daftarHadirDokumentasi)&&(identical(other.materiDokumentasi, materiDokumentasi) || other.materiDokumentasi == materiDokumentasi)&&(identical(other.notulaDokumentasi, notulaDokumentasi) || other.notulaDokumentasi == notulaDokumentasi)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdById,directoryDokumentasi,judulDokumentasi,buktiDukungUndanganDokumentasi,daftarHadirDokumentasi,materiDokumentasi,notulaDokumentasi,creatorName,const DeepCollectionEquality().hash(_files),createdAt,updatedAt);

@override
String toString() {
  return 'DokumentasiKegiatan(id: $id, createdById: $createdById, directoryDokumentasi: $directoryDokumentasi, judulDokumentasi: $judulDokumentasi, buktiDukungUndanganDokumentasi: $buktiDukungUndanganDokumentasi, daftarHadirDokumentasi: $daftarHadirDokumentasi, materiDokumentasi: $materiDokumentasi, notulaDokumentasi: $notulaDokumentasi, creatorName: $creatorName, files: $files, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DokumentasiKegiatanCopyWith<$Res> implements $DokumentasiKegiatanCopyWith<$Res> {
  factory _$DokumentasiKegiatanCopyWith(_DokumentasiKegiatan value, $Res Function(_DokumentasiKegiatan) _then) = __$DokumentasiKegiatanCopyWithImpl;
@override @useResult
$Res call({
@FlexibleStringConverter() String id,@FlexibleStringConverter()@JsonKey(name: 'created_by_id') String createdById,@JsonKey(name: 'directory_dokumentasi') String directoryDokumentasi,@JsonKey(name: 'judul_dokumentasi') String judulDokumentasi,@JsonKey(name: 'bukti_dukung_undangan_dokumentasi') String buktiDukungUndanganDokumentasi,@JsonKey(name: 'daftar_hadir_dokumentasi') String daftarHadirDokumentasi,@JsonKey(name: 'materi_dokumentasi') String materiDokumentasi,@JsonKey(name: 'notula_dokumentasi') String notulaDokumentasi,@JsonKey(name: 'creator_name') String creatorName,@JsonKey(name: 'file_dokumentasi') List<FileDokumentasi> files,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$DokumentasiKegiatanCopyWithImpl<$Res>
    implements _$DokumentasiKegiatanCopyWith<$Res> {
  __$DokumentasiKegiatanCopyWithImpl(this._self, this._then);

  final _DokumentasiKegiatan _self;
  final $Res Function(_DokumentasiKegiatan) _then;

/// Create a copy of DokumentasiKegiatan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdById = null,Object? directoryDokumentasi = null,Object? judulDokumentasi = null,Object? buktiDukungUndanganDokumentasi = null,Object? daftarHadirDokumentasi = null,Object? materiDokumentasi = null,Object? notulaDokumentasi = null,Object? creatorName = null,Object? files = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DokumentasiKegiatan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdById: null == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String,directoryDokumentasi: null == directoryDokumentasi ? _self.directoryDokumentasi : directoryDokumentasi // ignore: cast_nullable_to_non_nullable
as String,judulDokumentasi: null == judulDokumentasi ? _self.judulDokumentasi : judulDokumentasi // ignore: cast_nullable_to_non_nullable
as String,buktiDukungUndanganDokumentasi: null == buktiDukungUndanganDokumentasi ? _self.buktiDukungUndanganDokumentasi : buktiDukungUndanganDokumentasi // ignore: cast_nullable_to_non_nullable
as String,daftarHadirDokumentasi: null == daftarHadirDokumentasi ? _self.daftarHadirDokumentasi : daftarHadirDokumentasi // ignore: cast_nullable_to_non_nullable
as String,materiDokumentasi: null == materiDokumentasi ? _self.materiDokumentasi : materiDokumentasi // ignore: cast_nullable_to_non_nullable
as String,notulaDokumentasi: null == notulaDokumentasi ? _self.notulaDokumentasi : notulaDokumentasi // ignore: cast_nullable_to_non_nullable
as String,creatorName: null == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<FileDokumentasi>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
