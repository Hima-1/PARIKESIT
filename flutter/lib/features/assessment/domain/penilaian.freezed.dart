// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'penilaian.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Penilaian {

 int get id;@JsonKey(name: 'formulir_id') int get formulirId;@JsonKey(name: 'indikator_id') int get indikatorId;@FlexibleDoubleConverter() double get nilai; String? get catatan; String? get evaluasi;@JsonKey(name: 'bukti_dukung', fromJson: _buktiDukungFromJson, toJson: _buktiDukungToJson) List<String>? get buktiDukung;@JsonKey(name: 'catatan_koreksi') String? get catatanKoreksi;@JsonKey(name: 'dikerjakan_by') int? get dikerjakanBy;@JsonKey(name: 'diupdate_by') int? get diupdateBy;@JsonKey(name: 'dikoreksi_by') int? get dikoreksiBy;@JsonKey(name: 'nilai_diupdate')@NullableFlexibleDoubleConverter() double? get nilaiDiupdate;@JsonKey(name: 'nilai_koreksi')@NullableFlexibleDoubleConverter() double? get nilaiKoreksi; PenilaianStatus? get status;@JsonKey(name: 'tanggal_diperbarui')@NullableLaravelDateConverter() DateTime? get tanggalDiperbarui;@JsonKey(name: 'tanggal_dikoreksi')@NullableLaravelDateConverter() DateTime? get tanggalDikoreksi;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;
/// Create a copy of Penilaian
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PenilaianCopyWith<Penilaian> get copyWith => _$PenilaianCopyWithImpl<Penilaian>(this as Penilaian, _$identity);

  /// Serializes this Penilaian to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Penilaian&&(identical(other.id, id) || other.id == id)&&(identical(other.formulirId, formulirId) || other.formulirId == formulirId)&&(identical(other.indikatorId, indikatorId) || other.indikatorId == indikatorId)&&(identical(other.nilai, nilai) || other.nilai == nilai)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.evaluasi, evaluasi) || other.evaluasi == evaluasi)&&const DeepCollectionEquality().equals(other.buktiDukung, buktiDukung)&&(identical(other.catatanKoreksi, catatanKoreksi) || other.catatanKoreksi == catatanKoreksi)&&(identical(other.dikerjakanBy, dikerjakanBy) || other.dikerjakanBy == dikerjakanBy)&&(identical(other.diupdateBy, diupdateBy) || other.diupdateBy == diupdateBy)&&(identical(other.dikoreksiBy, dikoreksiBy) || other.dikoreksiBy == dikoreksiBy)&&(identical(other.nilaiDiupdate, nilaiDiupdate) || other.nilaiDiupdate == nilaiDiupdate)&&(identical(other.nilaiKoreksi, nilaiKoreksi) || other.nilaiKoreksi == nilaiKoreksi)&&(identical(other.status, status) || other.status == status)&&(identical(other.tanggalDiperbarui, tanggalDiperbarui) || other.tanggalDiperbarui == tanggalDiperbarui)&&(identical(other.tanggalDikoreksi, tanggalDikoreksi) || other.tanggalDikoreksi == tanggalDikoreksi)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,formulirId,indikatorId,nilai,catatan,evaluasi,const DeepCollectionEquality().hash(buktiDukung),catatanKoreksi,dikerjakanBy,diupdateBy,dikoreksiBy,nilaiDiupdate,nilaiKoreksi,status,tanggalDiperbarui,tanggalDikoreksi,createdAt,updatedAt,deletedAt]);

@override
String toString() {
  return 'Penilaian(id: $id, formulirId: $formulirId, indikatorId: $indikatorId, nilai: $nilai, catatan: $catatan, evaluasi: $evaluasi, buktiDukung: $buktiDukung, catatanKoreksi: $catatanKoreksi, dikerjakanBy: $dikerjakanBy, diupdateBy: $diupdateBy, dikoreksiBy: $dikoreksiBy, nilaiDiupdate: $nilaiDiupdate, nilaiKoreksi: $nilaiKoreksi, status: $status, tanggalDiperbarui: $tanggalDiperbarui, tanggalDikoreksi: $tanggalDikoreksi, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $PenilaianCopyWith<$Res>  {
  factory $PenilaianCopyWith(Penilaian value, $Res Function(Penilaian) _then) = _$PenilaianCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'formulir_id') int formulirId,@JsonKey(name: 'indikator_id') int indikatorId,@FlexibleDoubleConverter() double nilai, String? catatan, String? evaluasi,@JsonKey(name: 'bukti_dukung', fromJson: _buktiDukungFromJson, toJson: _buktiDukungToJson) List<String>? buktiDukung,@JsonKey(name: 'catatan_koreksi') String? catatanKoreksi,@JsonKey(name: 'dikerjakan_by') int? dikerjakanBy,@JsonKey(name: 'diupdate_by') int? diupdateBy,@JsonKey(name: 'dikoreksi_by') int? dikoreksiBy,@JsonKey(name: 'nilai_diupdate')@NullableFlexibleDoubleConverter() double? nilaiDiupdate,@JsonKey(name: 'nilai_koreksi')@NullableFlexibleDoubleConverter() double? nilaiKoreksi, PenilaianStatus? status,@JsonKey(name: 'tanggal_diperbarui')@NullableLaravelDateConverter() DateTime? tanggalDiperbarui,@JsonKey(name: 'tanggal_dikoreksi')@NullableLaravelDateConverter() DateTime? tanggalDikoreksi,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class _$PenilaianCopyWithImpl<$Res>
    implements $PenilaianCopyWith<$Res> {
  _$PenilaianCopyWithImpl(this._self, this._then);

  final Penilaian _self;
  final $Res Function(Penilaian) _then;

/// Create a copy of Penilaian
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? formulirId = null,Object? indikatorId = null,Object? nilai = null,Object? catatan = freezed,Object? evaluasi = freezed,Object? buktiDukung = freezed,Object? catatanKoreksi = freezed,Object? dikerjakanBy = freezed,Object? diupdateBy = freezed,Object? dikoreksiBy = freezed,Object? nilaiDiupdate = freezed,Object? nilaiKoreksi = freezed,Object? status = freezed,Object? tanggalDiperbarui = freezed,Object? tanggalDikoreksi = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,formulirId: null == formulirId ? _self.formulirId : formulirId // ignore: cast_nullable_to_non_nullable
as int,indikatorId: null == indikatorId ? _self.indikatorId : indikatorId // ignore: cast_nullable_to_non_nullable
as int,nilai: null == nilai ? _self.nilai : nilai // ignore: cast_nullable_to_non_nullable
as double,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,evaluasi: freezed == evaluasi ? _self.evaluasi : evaluasi // ignore: cast_nullable_to_non_nullable
as String?,buktiDukung: freezed == buktiDukung ? _self.buktiDukung : buktiDukung // ignore: cast_nullable_to_non_nullable
as List<String>?,catatanKoreksi: freezed == catatanKoreksi ? _self.catatanKoreksi : catatanKoreksi // ignore: cast_nullable_to_non_nullable
as String?,dikerjakanBy: freezed == dikerjakanBy ? _self.dikerjakanBy : dikerjakanBy // ignore: cast_nullable_to_non_nullable
as int?,diupdateBy: freezed == diupdateBy ? _self.diupdateBy : diupdateBy // ignore: cast_nullable_to_non_nullable
as int?,dikoreksiBy: freezed == dikoreksiBy ? _self.dikoreksiBy : dikoreksiBy // ignore: cast_nullable_to_non_nullable
as int?,nilaiDiupdate: freezed == nilaiDiupdate ? _self.nilaiDiupdate : nilaiDiupdate // ignore: cast_nullable_to_non_nullable
as double?,nilaiKoreksi: freezed == nilaiKoreksi ? _self.nilaiKoreksi : nilaiKoreksi // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PenilaianStatus?,tanggalDiperbarui: freezed == tanggalDiperbarui ? _self.tanggalDiperbarui : tanggalDiperbarui // ignore: cast_nullable_to_non_nullable
as DateTime?,tanggalDikoreksi: freezed == tanggalDikoreksi ? _self.tanggalDikoreksi : tanggalDikoreksi // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Penilaian].
extension PenilaianPatterns on Penilaian {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Penilaian value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Penilaian() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Penilaian value)  $default,){
final _that = this;
switch (_that) {
case _Penilaian():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Penilaian value)?  $default,){
final _that = this;
switch (_that) {
case _Penilaian() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'formulir_id')  int formulirId, @JsonKey(name: 'indikator_id')  int indikatorId, @FlexibleDoubleConverter()  double nilai,  String? catatan,  String? evaluasi, @JsonKey(name: 'bukti_dukung', fromJson: _buktiDukungFromJson, toJson: _buktiDukungToJson)  List<String>? buktiDukung, @JsonKey(name: 'catatan_koreksi')  String? catatanKoreksi, @JsonKey(name: 'dikerjakan_by')  int? dikerjakanBy, @JsonKey(name: 'diupdate_by')  int? diupdateBy, @JsonKey(name: 'dikoreksi_by')  int? dikoreksiBy, @JsonKey(name: 'nilai_diupdate')@NullableFlexibleDoubleConverter()  double? nilaiDiupdate, @JsonKey(name: 'nilai_koreksi')@NullableFlexibleDoubleConverter()  double? nilaiKoreksi,  PenilaianStatus? status, @JsonKey(name: 'tanggal_diperbarui')@NullableLaravelDateConverter()  DateTime? tanggalDiperbarui, @JsonKey(name: 'tanggal_dikoreksi')@NullableLaravelDateConverter()  DateTime? tanggalDikoreksi, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Penilaian() when $default != null:
return $default(_that.id,_that.formulirId,_that.indikatorId,_that.nilai,_that.catatan,_that.evaluasi,_that.buktiDukung,_that.catatanKoreksi,_that.dikerjakanBy,_that.diupdateBy,_that.dikoreksiBy,_that.nilaiDiupdate,_that.nilaiKoreksi,_that.status,_that.tanggalDiperbarui,_that.tanggalDikoreksi,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'formulir_id')  int formulirId, @JsonKey(name: 'indikator_id')  int indikatorId, @FlexibleDoubleConverter()  double nilai,  String? catatan,  String? evaluasi, @JsonKey(name: 'bukti_dukung', fromJson: _buktiDukungFromJson, toJson: _buktiDukungToJson)  List<String>? buktiDukung, @JsonKey(name: 'catatan_koreksi')  String? catatanKoreksi, @JsonKey(name: 'dikerjakan_by')  int? dikerjakanBy, @JsonKey(name: 'diupdate_by')  int? diupdateBy, @JsonKey(name: 'dikoreksi_by')  int? dikoreksiBy, @JsonKey(name: 'nilai_diupdate')@NullableFlexibleDoubleConverter()  double? nilaiDiupdate, @JsonKey(name: 'nilai_koreksi')@NullableFlexibleDoubleConverter()  double? nilaiKoreksi,  PenilaianStatus? status, @JsonKey(name: 'tanggal_diperbarui')@NullableLaravelDateConverter()  DateTime? tanggalDiperbarui, @JsonKey(name: 'tanggal_dikoreksi')@NullableLaravelDateConverter()  DateTime? tanggalDikoreksi, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _Penilaian():
return $default(_that.id,_that.formulirId,_that.indikatorId,_that.nilai,_that.catatan,_that.evaluasi,_that.buktiDukung,_that.catatanKoreksi,_that.dikerjakanBy,_that.diupdateBy,_that.dikoreksiBy,_that.nilaiDiupdate,_that.nilaiKoreksi,_that.status,_that.tanggalDiperbarui,_that.tanggalDikoreksi,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'formulir_id')  int formulirId, @JsonKey(name: 'indikator_id')  int indikatorId, @FlexibleDoubleConverter()  double nilai,  String? catatan,  String? evaluasi, @JsonKey(name: 'bukti_dukung', fromJson: _buktiDukungFromJson, toJson: _buktiDukungToJson)  List<String>? buktiDukung, @JsonKey(name: 'catatan_koreksi')  String? catatanKoreksi, @JsonKey(name: 'dikerjakan_by')  int? dikerjakanBy, @JsonKey(name: 'diupdate_by')  int? diupdateBy, @JsonKey(name: 'dikoreksi_by')  int? dikoreksiBy, @JsonKey(name: 'nilai_diupdate')@NullableFlexibleDoubleConverter()  double? nilaiDiupdate, @JsonKey(name: 'nilai_koreksi')@NullableFlexibleDoubleConverter()  double? nilaiKoreksi,  PenilaianStatus? status, @JsonKey(name: 'tanggal_diperbarui')@NullableLaravelDateConverter()  DateTime? tanggalDiperbarui, @JsonKey(name: 'tanggal_dikoreksi')@NullableLaravelDateConverter()  DateTime? tanggalDikoreksi, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Penilaian() when $default != null:
return $default(_that.id,_that.formulirId,_that.indikatorId,_that.nilai,_that.catatan,_that.evaluasi,_that.buktiDukung,_that.catatanKoreksi,_that.dikerjakanBy,_that.diupdateBy,_that.dikoreksiBy,_that.nilaiDiupdate,_that.nilaiKoreksi,_that.status,_that.tanggalDiperbarui,_that.tanggalDikoreksi,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Penilaian implements Penilaian {
  const _Penilaian({required this.id, @JsonKey(name: 'formulir_id') required this.formulirId, @JsonKey(name: 'indikator_id') required this.indikatorId, @FlexibleDoubleConverter() required this.nilai, this.catatan = null, this.evaluasi = null, @JsonKey(name: 'bukti_dukung', fromJson: _buktiDukungFromJson, toJson: _buktiDukungToJson) final  List<String>? buktiDukung = null, @JsonKey(name: 'catatan_koreksi') this.catatanKoreksi = null, @JsonKey(name: 'dikerjakan_by') this.dikerjakanBy = null, @JsonKey(name: 'diupdate_by') this.diupdateBy = null, @JsonKey(name: 'dikoreksi_by') this.dikoreksiBy = null, @JsonKey(name: 'nilai_diupdate')@NullableFlexibleDoubleConverter() this.nilaiDiupdate = null, @JsonKey(name: 'nilai_koreksi')@NullableFlexibleDoubleConverter() this.nilaiKoreksi = null, this.status = null, @JsonKey(name: 'tanggal_diperbarui')@NullableLaravelDateConverter() this.tanggalDiperbarui = null, @JsonKey(name: 'tanggal_dikoreksi')@NullableLaravelDateConverter() this.tanggalDikoreksi = null, @JsonKey(name: 'created_at') this.createdAt = null, @JsonKey(name: 'updated_at') this.updatedAt = null, @JsonKey(name: 'deleted_at') this.deletedAt = null}): _buktiDukung = buktiDukung;
  factory _Penilaian.fromJson(Map<String, dynamic> json) => _$PenilaianFromJson(json);

@override final  int id;
@override@JsonKey(name: 'formulir_id') final  int formulirId;
@override@JsonKey(name: 'indikator_id') final  int indikatorId;
@override@FlexibleDoubleConverter() final  double nilai;
@override@JsonKey() final  String? catatan;
@override@JsonKey() final  String? evaluasi;
 final  List<String>? _buktiDukung;
@override@JsonKey(name: 'bukti_dukung', fromJson: _buktiDukungFromJson, toJson: _buktiDukungToJson) List<String>? get buktiDukung {
  final value = _buktiDukung;
  if (value == null) return null;
  if (_buktiDukung is EqualUnmodifiableListView) return _buktiDukung;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'catatan_koreksi') final  String? catatanKoreksi;
@override@JsonKey(name: 'dikerjakan_by') final  int? dikerjakanBy;
@override@JsonKey(name: 'diupdate_by') final  int? diupdateBy;
@override@JsonKey(name: 'dikoreksi_by') final  int? dikoreksiBy;
@override@JsonKey(name: 'nilai_diupdate')@NullableFlexibleDoubleConverter() final  double? nilaiDiupdate;
@override@JsonKey(name: 'nilai_koreksi')@NullableFlexibleDoubleConverter() final  double? nilaiKoreksi;
@override@JsonKey() final  PenilaianStatus? status;
@override@JsonKey(name: 'tanggal_diperbarui')@NullableLaravelDateConverter() final  DateTime? tanggalDiperbarui;
@override@JsonKey(name: 'tanggal_dikoreksi')@NullableLaravelDateConverter() final  DateTime? tanggalDikoreksi;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;

/// Create a copy of Penilaian
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PenilaianCopyWith<_Penilaian> get copyWith => __$PenilaianCopyWithImpl<_Penilaian>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PenilaianToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Penilaian&&(identical(other.id, id) || other.id == id)&&(identical(other.formulirId, formulirId) || other.formulirId == formulirId)&&(identical(other.indikatorId, indikatorId) || other.indikatorId == indikatorId)&&(identical(other.nilai, nilai) || other.nilai == nilai)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.evaluasi, evaluasi) || other.evaluasi == evaluasi)&&const DeepCollectionEquality().equals(other._buktiDukung, _buktiDukung)&&(identical(other.catatanKoreksi, catatanKoreksi) || other.catatanKoreksi == catatanKoreksi)&&(identical(other.dikerjakanBy, dikerjakanBy) || other.dikerjakanBy == dikerjakanBy)&&(identical(other.diupdateBy, diupdateBy) || other.diupdateBy == diupdateBy)&&(identical(other.dikoreksiBy, dikoreksiBy) || other.dikoreksiBy == dikoreksiBy)&&(identical(other.nilaiDiupdate, nilaiDiupdate) || other.nilaiDiupdate == nilaiDiupdate)&&(identical(other.nilaiKoreksi, nilaiKoreksi) || other.nilaiKoreksi == nilaiKoreksi)&&(identical(other.status, status) || other.status == status)&&(identical(other.tanggalDiperbarui, tanggalDiperbarui) || other.tanggalDiperbarui == tanggalDiperbarui)&&(identical(other.tanggalDikoreksi, tanggalDikoreksi) || other.tanggalDikoreksi == tanggalDikoreksi)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,formulirId,indikatorId,nilai,catatan,evaluasi,const DeepCollectionEquality().hash(_buktiDukung),catatanKoreksi,dikerjakanBy,diupdateBy,dikoreksiBy,nilaiDiupdate,nilaiKoreksi,status,tanggalDiperbarui,tanggalDikoreksi,createdAt,updatedAt,deletedAt]);

@override
String toString() {
  return 'Penilaian(id: $id, formulirId: $formulirId, indikatorId: $indikatorId, nilai: $nilai, catatan: $catatan, evaluasi: $evaluasi, buktiDukung: $buktiDukung, catatanKoreksi: $catatanKoreksi, dikerjakanBy: $dikerjakanBy, diupdateBy: $diupdateBy, dikoreksiBy: $dikoreksiBy, nilaiDiupdate: $nilaiDiupdate, nilaiKoreksi: $nilaiKoreksi, status: $status, tanggalDiperbarui: $tanggalDiperbarui, tanggalDikoreksi: $tanggalDikoreksi, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$PenilaianCopyWith<$Res> implements $PenilaianCopyWith<$Res> {
  factory _$PenilaianCopyWith(_Penilaian value, $Res Function(_Penilaian) _then) = __$PenilaianCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'formulir_id') int formulirId,@JsonKey(name: 'indikator_id') int indikatorId,@FlexibleDoubleConverter() double nilai, String? catatan, String? evaluasi,@JsonKey(name: 'bukti_dukung', fromJson: _buktiDukungFromJson, toJson: _buktiDukungToJson) List<String>? buktiDukung,@JsonKey(name: 'catatan_koreksi') String? catatanKoreksi,@JsonKey(name: 'dikerjakan_by') int? dikerjakanBy,@JsonKey(name: 'diupdate_by') int? diupdateBy,@JsonKey(name: 'dikoreksi_by') int? dikoreksiBy,@JsonKey(name: 'nilai_diupdate')@NullableFlexibleDoubleConverter() double? nilaiDiupdate,@JsonKey(name: 'nilai_koreksi')@NullableFlexibleDoubleConverter() double? nilaiKoreksi, PenilaianStatus? status,@JsonKey(name: 'tanggal_diperbarui')@NullableLaravelDateConverter() DateTime? tanggalDiperbarui,@JsonKey(name: 'tanggal_dikoreksi')@NullableLaravelDateConverter() DateTime? tanggalDikoreksi,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class __$PenilaianCopyWithImpl<$Res>
    implements _$PenilaianCopyWith<$Res> {
  __$PenilaianCopyWithImpl(this._self, this._then);

  final _Penilaian _self;
  final $Res Function(_Penilaian) _then;

/// Create a copy of Penilaian
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? formulirId = null,Object? indikatorId = null,Object? nilai = null,Object? catatan = freezed,Object? evaluasi = freezed,Object? buktiDukung = freezed,Object? catatanKoreksi = freezed,Object? dikerjakanBy = freezed,Object? diupdateBy = freezed,Object? dikoreksiBy = freezed,Object? nilaiDiupdate = freezed,Object? nilaiKoreksi = freezed,Object? status = freezed,Object? tanggalDiperbarui = freezed,Object? tanggalDikoreksi = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(_Penilaian(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,formulirId: null == formulirId ? _self.formulirId : formulirId // ignore: cast_nullable_to_non_nullable
as int,indikatorId: null == indikatorId ? _self.indikatorId : indikatorId // ignore: cast_nullable_to_non_nullable
as int,nilai: null == nilai ? _self.nilai : nilai // ignore: cast_nullable_to_non_nullable
as double,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,evaluasi: freezed == evaluasi ? _self.evaluasi : evaluasi // ignore: cast_nullable_to_non_nullable
as String?,buktiDukung: freezed == buktiDukung ? _self._buktiDukung : buktiDukung // ignore: cast_nullable_to_non_nullable
as List<String>?,catatanKoreksi: freezed == catatanKoreksi ? _self.catatanKoreksi : catatanKoreksi // ignore: cast_nullable_to_non_nullable
as String?,dikerjakanBy: freezed == dikerjakanBy ? _self.dikerjakanBy : dikerjakanBy // ignore: cast_nullable_to_non_nullable
as int?,diupdateBy: freezed == diupdateBy ? _self.diupdateBy : diupdateBy // ignore: cast_nullable_to_non_nullable
as int?,dikoreksiBy: freezed == dikoreksiBy ? _self.dikoreksiBy : dikoreksiBy // ignore: cast_nullable_to_non_nullable
as int?,nilaiDiupdate: freezed == nilaiDiupdate ? _self.nilaiDiupdate : nilaiDiupdate // ignore: cast_nullable_to_non_nullable
as double?,nilaiKoreksi: freezed == nilaiKoreksi ? _self.nilaiKoreksi : nilaiKoreksi // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PenilaianStatus?,tanggalDiperbarui: freezed == tanggalDiperbarui ? _self.tanggalDiperbarui : tanggalDiperbarui // ignore: cast_nullable_to_non_nullable
as DateTime?,tanggalDikoreksi: freezed == tanggalDikoreksi ? _self.tanggalDikoreksi : tanggalDikoreksi // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
