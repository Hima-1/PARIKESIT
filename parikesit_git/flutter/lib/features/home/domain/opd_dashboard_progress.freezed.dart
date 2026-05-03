// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opd_dashboard_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpdDashboardProgress {

 int get id;@JsonKey(name: 'nama') String get name;@JsonKey(name: 'tanggal') DateTime get date;@JsonKey(name: 'progress_per_indikator') OpdProgressDetail get progressPerIndikator;@JsonKey(name: 'hasil_penilaian_akhir') double? get hasilPenilaianAkhir;@JsonKey(name: 'progress_koreksi_walidata') OpdProgressDetail get progressKoreksiWalidata;@JsonKey(name: 'progress_evaluasi_admin') OpdProgressDetail get progressEvaluasiAdmin;
/// Create a copy of OpdDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpdDashboardProgressCopyWith<OpdDashboardProgress> get copyWith => _$OpdDashboardProgressCopyWithImpl<OpdDashboardProgress>(this as OpdDashboardProgress, _$identity);

  /// Serializes this OpdDashboardProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpdDashboardProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.progressPerIndikator, progressPerIndikator) || other.progressPerIndikator == progressPerIndikator)&&(identical(other.hasilPenilaianAkhir, hasilPenilaianAkhir) || other.hasilPenilaianAkhir == hasilPenilaianAkhir)&&(identical(other.progressKoreksiWalidata, progressKoreksiWalidata) || other.progressKoreksiWalidata == progressKoreksiWalidata)&&(identical(other.progressEvaluasiAdmin, progressEvaluasiAdmin) || other.progressEvaluasiAdmin == progressEvaluasiAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,date,progressPerIndikator,hasilPenilaianAkhir,progressKoreksiWalidata,progressEvaluasiAdmin);

@override
String toString() {
  return 'OpdDashboardProgress(id: $id, name: $name, date: $date, progressPerIndikator: $progressPerIndikator, hasilPenilaianAkhir: $hasilPenilaianAkhir, progressKoreksiWalidata: $progressKoreksiWalidata, progressEvaluasiAdmin: $progressEvaluasiAdmin)';
}


}

/// @nodoc
abstract mixin class $OpdDashboardProgressCopyWith<$Res>  {
  factory $OpdDashboardProgressCopyWith(OpdDashboardProgress value, $Res Function(OpdDashboardProgress) _then) = _$OpdDashboardProgressCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'nama') String name,@JsonKey(name: 'tanggal') DateTime date,@JsonKey(name: 'progress_per_indikator') OpdProgressDetail progressPerIndikator,@JsonKey(name: 'hasil_penilaian_akhir') double? hasilPenilaianAkhir,@JsonKey(name: 'progress_koreksi_walidata') OpdProgressDetail progressKoreksiWalidata,@JsonKey(name: 'progress_evaluasi_admin') OpdProgressDetail progressEvaluasiAdmin
});


$OpdProgressDetailCopyWith<$Res> get progressPerIndikator;$OpdProgressDetailCopyWith<$Res> get progressKoreksiWalidata;$OpdProgressDetailCopyWith<$Res> get progressEvaluasiAdmin;

}
/// @nodoc
class _$OpdDashboardProgressCopyWithImpl<$Res>
    implements $OpdDashboardProgressCopyWith<$Res> {
  _$OpdDashboardProgressCopyWithImpl(this._self, this._then);

  final OpdDashboardProgress _self;
  final $Res Function(OpdDashboardProgress) _then;

/// Create a copy of OpdDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? date = null,Object? progressPerIndikator = null,Object? hasilPenilaianAkhir = freezed,Object? progressKoreksiWalidata = null,Object? progressEvaluasiAdmin = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,progressPerIndikator: null == progressPerIndikator ? _self.progressPerIndikator : progressPerIndikator // ignore: cast_nullable_to_non_nullable
as OpdProgressDetail,hasilPenilaianAkhir: freezed == hasilPenilaianAkhir ? _self.hasilPenilaianAkhir : hasilPenilaianAkhir // ignore: cast_nullable_to_non_nullable
as double?,progressKoreksiWalidata: null == progressKoreksiWalidata ? _self.progressKoreksiWalidata : progressKoreksiWalidata // ignore: cast_nullable_to_non_nullable
as OpdProgressDetail,progressEvaluasiAdmin: null == progressEvaluasiAdmin ? _self.progressEvaluasiAdmin : progressEvaluasiAdmin // ignore: cast_nullable_to_non_nullable
as OpdProgressDetail,
  ));
}
/// Create a copy of OpdDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressDetailCopyWith<$Res> get progressPerIndikator {
  
  return $OpdProgressDetailCopyWith<$Res>(_self.progressPerIndikator, (value) {
    return _then(_self.copyWith(progressPerIndikator: value));
  });
}/// Create a copy of OpdDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressDetailCopyWith<$Res> get progressKoreksiWalidata {
  
  return $OpdProgressDetailCopyWith<$Res>(_self.progressKoreksiWalidata, (value) {
    return _then(_self.copyWith(progressKoreksiWalidata: value));
  });
}/// Create a copy of OpdDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressDetailCopyWith<$Res> get progressEvaluasiAdmin {
  
  return $OpdProgressDetailCopyWith<$Res>(_self.progressEvaluasiAdmin, (value) {
    return _then(_self.copyWith(progressEvaluasiAdmin: value));
  });
}
}


/// Adds pattern-matching-related methods to [OpdDashboardProgress].
extension OpdDashboardProgressPatterns on OpdDashboardProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpdDashboardProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpdDashboardProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpdDashboardProgress value)  $default,){
final _that = this;
switch (_that) {
case _OpdDashboardProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpdDashboardProgress value)?  $default,){
final _that = this;
switch (_that) {
case _OpdDashboardProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'tanggal')  DateTime date, @JsonKey(name: 'progress_per_indikator')  OpdProgressDetail progressPerIndikator, @JsonKey(name: 'hasil_penilaian_akhir')  double? hasilPenilaianAkhir, @JsonKey(name: 'progress_koreksi_walidata')  OpdProgressDetail progressKoreksiWalidata, @JsonKey(name: 'progress_evaluasi_admin')  OpdProgressDetail progressEvaluasiAdmin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpdDashboardProgress() when $default != null:
return $default(_that.id,_that.name,_that.date,_that.progressPerIndikator,_that.hasilPenilaianAkhir,_that.progressKoreksiWalidata,_that.progressEvaluasiAdmin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'tanggal')  DateTime date, @JsonKey(name: 'progress_per_indikator')  OpdProgressDetail progressPerIndikator, @JsonKey(name: 'hasil_penilaian_akhir')  double? hasilPenilaianAkhir, @JsonKey(name: 'progress_koreksi_walidata')  OpdProgressDetail progressKoreksiWalidata, @JsonKey(name: 'progress_evaluasi_admin')  OpdProgressDetail progressEvaluasiAdmin)  $default,) {final _that = this;
switch (_that) {
case _OpdDashboardProgress():
return $default(_that.id,_that.name,_that.date,_that.progressPerIndikator,_that.hasilPenilaianAkhir,_that.progressKoreksiWalidata,_that.progressEvaluasiAdmin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'tanggal')  DateTime date, @JsonKey(name: 'progress_per_indikator')  OpdProgressDetail progressPerIndikator, @JsonKey(name: 'hasil_penilaian_akhir')  double? hasilPenilaianAkhir, @JsonKey(name: 'progress_koreksi_walidata')  OpdProgressDetail progressKoreksiWalidata, @JsonKey(name: 'progress_evaluasi_admin')  OpdProgressDetail progressEvaluasiAdmin)?  $default,) {final _that = this;
switch (_that) {
case _OpdDashboardProgress() when $default != null:
return $default(_that.id,_that.name,_that.date,_that.progressPerIndikator,_that.hasilPenilaianAkhir,_that.progressKoreksiWalidata,_that.progressEvaluasiAdmin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpdDashboardProgress implements OpdDashboardProgress {
  const _OpdDashboardProgress({required this.id, @JsonKey(name: 'nama') required this.name, @JsonKey(name: 'tanggal') required this.date, @JsonKey(name: 'progress_per_indikator') required this.progressPerIndikator, @JsonKey(name: 'hasil_penilaian_akhir') this.hasilPenilaianAkhir, @JsonKey(name: 'progress_koreksi_walidata') required this.progressKoreksiWalidata, @JsonKey(name: 'progress_evaluasi_admin') required this.progressEvaluasiAdmin});
  factory _OpdDashboardProgress.fromJson(Map<String, dynamic> json) => _$OpdDashboardProgressFromJson(json);

@override final  int id;
@override@JsonKey(name: 'nama') final  String name;
@override@JsonKey(name: 'tanggal') final  DateTime date;
@override@JsonKey(name: 'progress_per_indikator') final  OpdProgressDetail progressPerIndikator;
@override@JsonKey(name: 'hasil_penilaian_akhir') final  double? hasilPenilaianAkhir;
@override@JsonKey(name: 'progress_koreksi_walidata') final  OpdProgressDetail progressKoreksiWalidata;
@override@JsonKey(name: 'progress_evaluasi_admin') final  OpdProgressDetail progressEvaluasiAdmin;

/// Create a copy of OpdDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpdDashboardProgressCopyWith<_OpdDashboardProgress> get copyWith => __$OpdDashboardProgressCopyWithImpl<_OpdDashboardProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpdDashboardProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpdDashboardProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.progressPerIndikator, progressPerIndikator) || other.progressPerIndikator == progressPerIndikator)&&(identical(other.hasilPenilaianAkhir, hasilPenilaianAkhir) || other.hasilPenilaianAkhir == hasilPenilaianAkhir)&&(identical(other.progressKoreksiWalidata, progressKoreksiWalidata) || other.progressKoreksiWalidata == progressKoreksiWalidata)&&(identical(other.progressEvaluasiAdmin, progressEvaluasiAdmin) || other.progressEvaluasiAdmin == progressEvaluasiAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,date,progressPerIndikator,hasilPenilaianAkhir,progressKoreksiWalidata,progressEvaluasiAdmin);

@override
String toString() {
  return 'OpdDashboardProgress(id: $id, name: $name, date: $date, progressPerIndikator: $progressPerIndikator, hasilPenilaianAkhir: $hasilPenilaianAkhir, progressKoreksiWalidata: $progressKoreksiWalidata, progressEvaluasiAdmin: $progressEvaluasiAdmin)';
}


}

/// @nodoc
abstract mixin class _$OpdDashboardProgressCopyWith<$Res> implements $OpdDashboardProgressCopyWith<$Res> {
  factory _$OpdDashboardProgressCopyWith(_OpdDashboardProgress value, $Res Function(_OpdDashboardProgress) _then) = __$OpdDashboardProgressCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'nama') String name,@JsonKey(name: 'tanggal') DateTime date,@JsonKey(name: 'progress_per_indikator') OpdProgressDetail progressPerIndikator,@JsonKey(name: 'hasil_penilaian_akhir') double? hasilPenilaianAkhir,@JsonKey(name: 'progress_koreksi_walidata') OpdProgressDetail progressKoreksiWalidata,@JsonKey(name: 'progress_evaluasi_admin') OpdProgressDetail progressEvaluasiAdmin
});


@override $OpdProgressDetailCopyWith<$Res> get progressPerIndikator;@override $OpdProgressDetailCopyWith<$Res> get progressKoreksiWalidata;@override $OpdProgressDetailCopyWith<$Res> get progressEvaluasiAdmin;

}
/// @nodoc
class __$OpdDashboardProgressCopyWithImpl<$Res>
    implements _$OpdDashboardProgressCopyWith<$Res> {
  __$OpdDashboardProgressCopyWithImpl(this._self, this._then);

  final _OpdDashboardProgress _self;
  final $Res Function(_OpdDashboardProgress) _then;

/// Create a copy of OpdDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? date = null,Object? progressPerIndikator = null,Object? hasilPenilaianAkhir = freezed,Object? progressKoreksiWalidata = null,Object? progressEvaluasiAdmin = null,}) {
  return _then(_OpdDashboardProgress(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,progressPerIndikator: null == progressPerIndikator ? _self.progressPerIndikator : progressPerIndikator // ignore: cast_nullable_to_non_nullable
as OpdProgressDetail,hasilPenilaianAkhir: freezed == hasilPenilaianAkhir ? _self.hasilPenilaianAkhir : hasilPenilaianAkhir // ignore: cast_nullable_to_non_nullable
as double?,progressKoreksiWalidata: null == progressKoreksiWalidata ? _self.progressKoreksiWalidata : progressKoreksiWalidata // ignore: cast_nullable_to_non_nullable
as OpdProgressDetail,progressEvaluasiAdmin: null == progressEvaluasiAdmin ? _self.progressEvaluasiAdmin : progressEvaluasiAdmin // ignore: cast_nullable_to_non_nullable
as OpdProgressDetail,
  ));
}

/// Create a copy of OpdDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressDetailCopyWith<$Res> get progressPerIndikator {
  
  return $OpdProgressDetailCopyWith<$Res>(_self.progressPerIndikator, (value) {
    return _then(_self.copyWith(progressPerIndikator: value));
  });
}/// Create a copy of OpdDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressDetailCopyWith<$Res> get progressKoreksiWalidata {
  
  return $OpdProgressDetailCopyWith<$Res>(_self.progressKoreksiWalidata, (value) {
    return _then(_self.copyWith(progressKoreksiWalidata: value));
  });
}/// Create a copy of OpdDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressDetailCopyWith<$Res> get progressEvaluasiAdmin {
  
  return $OpdProgressDetailCopyWith<$Res>(_self.progressEvaluasiAdmin, (value) {
    return _then(_self.copyWith(progressEvaluasiAdmin: value));
  });
}
}


/// @nodoc
mixin _$OpdProgressDetail {

 int get total;@JsonKey(name: 'terisi') int? get terisi;@JsonKey(name: 'sudah_dikoreksi') int? get sudahDikoreksi;@JsonKey(name: 'sudah_dievaluasi') int? get sudahDievaluasi; double get persentase;
/// Create a copy of OpdProgressDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpdProgressDetailCopyWith<OpdProgressDetail> get copyWith => _$OpdProgressDetailCopyWithImpl<OpdProgressDetail>(this as OpdProgressDetail, _$identity);

  /// Serializes this OpdProgressDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpdProgressDetail&&(identical(other.total, total) || other.total == total)&&(identical(other.terisi, terisi) || other.terisi == terisi)&&(identical(other.sudahDikoreksi, sudahDikoreksi) || other.sudahDikoreksi == sudahDikoreksi)&&(identical(other.sudahDievaluasi, sudahDievaluasi) || other.sudahDievaluasi == sudahDievaluasi)&&(identical(other.persentase, persentase) || other.persentase == persentase));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,terisi,sudahDikoreksi,sudahDievaluasi,persentase);

@override
String toString() {
  return 'OpdProgressDetail(total: $total, terisi: $terisi, sudahDikoreksi: $sudahDikoreksi, sudahDievaluasi: $sudahDievaluasi, persentase: $persentase)';
}


}

/// @nodoc
abstract mixin class $OpdProgressDetailCopyWith<$Res>  {
  factory $OpdProgressDetailCopyWith(OpdProgressDetail value, $Res Function(OpdProgressDetail) _then) = _$OpdProgressDetailCopyWithImpl;
@useResult
$Res call({
 int total,@JsonKey(name: 'terisi') int? terisi,@JsonKey(name: 'sudah_dikoreksi') int? sudahDikoreksi,@JsonKey(name: 'sudah_dievaluasi') int? sudahDievaluasi, double persentase
});




}
/// @nodoc
class _$OpdProgressDetailCopyWithImpl<$Res>
    implements $OpdProgressDetailCopyWith<$Res> {
  _$OpdProgressDetailCopyWithImpl(this._self, this._then);

  final OpdProgressDetail _self;
  final $Res Function(OpdProgressDetail) _then;

/// Create a copy of OpdProgressDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? terisi = freezed,Object? sudahDikoreksi = freezed,Object? sudahDievaluasi = freezed,Object? persentase = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,terisi: freezed == terisi ? _self.terisi : terisi // ignore: cast_nullable_to_non_nullable
as int?,sudahDikoreksi: freezed == sudahDikoreksi ? _self.sudahDikoreksi : sudahDikoreksi // ignore: cast_nullable_to_non_nullable
as int?,sudahDievaluasi: freezed == sudahDievaluasi ? _self.sudahDievaluasi : sudahDievaluasi // ignore: cast_nullable_to_non_nullable
as int?,persentase: null == persentase ? _self.persentase : persentase // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OpdProgressDetail].
extension OpdProgressDetailPatterns on OpdProgressDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpdProgressDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpdProgressDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpdProgressDetail value)  $default,){
final _that = this;
switch (_that) {
case _OpdProgressDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpdProgressDetail value)?  $default,){
final _that = this;
switch (_that) {
case _OpdProgressDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total, @JsonKey(name: 'terisi')  int? terisi, @JsonKey(name: 'sudah_dikoreksi')  int? sudahDikoreksi, @JsonKey(name: 'sudah_dievaluasi')  int? sudahDievaluasi,  double persentase)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpdProgressDetail() when $default != null:
return $default(_that.total,_that.terisi,_that.sudahDikoreksi,_that.sudahDievaluasi,_that.persentase);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total, @JsonKey(name: 'terisi')  int? terisi, @JsonKey(name: 'sudah_dikoreksi')  int? sudahDikoreksi, @JsonKey(name: 'sudah_dievaluasi')  int? sudahDievaluasi,  double persentase)  $default,) {final _that = this;
switch (_that) {
case _OpdProgressDetail():
return $default(_that.total,_that.terisi,_that.sudahDikoreksi,_that.sudahDievaluasi,_that.persentase);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total, @JsonKey(name: 'terisi')  int? terisi, @JsonKey(name: 'sudah_dikoreksi')  int? sudahDikoreksi, @JsonKey(name: 'sudah_dievaluasi')  int? sudahDievaluasi,  double persentase)?  $default,) {final _that = this;
switch (_that) {
case _OpdProgressDetail() when $default != null:
return $default(_that.total,_that.terisi,_that.sudahDikoreksi,_that.sudahDievaluasi,_that.persentase);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpdProgressDetail implements OpdProgressDetail {
  const _OpdProgressDetail({required this.total, @JsonKey(name: 'terisi') this.terisi, @JsonKey(name: 'sudah_dikoreksi') this.sudahDikoreksi, @JsonKey(name: 'sudah_dievaluasi') this.sudahDievaluasi, required this.persentase});
  factory _OpdProgressDetail.fromJson(Map<String, dynamic> json) => _$OpdProgressDetailFromJson(json);

@override final  int total;
@override@JsonKey(name: 'terisi') final  int? terisi;
@override@JsonKey(name: 'sudah_dikoreksi') final  int? sudahDikoreksi;
@override@JsonKey(name: 'sudah_dievaluasi') final  int? sudahDievaluasi;
@override final  double persentase;

/// Create a copy of OpdProgressDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpdProgressDetailCopyWith<_OpdProgressDetail> get copyWith => __$OpdProgressDetailCopyWithImpl<_OpdProgressDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpdProgressDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpdProgressDetail&&(identical(other.total, total) || other.total == total)&&(identical(other.terisi, terisi) || other.terisi == terisi)&&(identical(other.sudahDikoreksi, sudahDikoreksi) || other.sudahDikoreksi == sudahDikoreksi)&&(identical(other.sudahDievaluasi, sudahDievaluasi) || other.sudahDievaluasi == sudahDievaluasi)&&(identical(other.persentase, persentase) || other.persentase == persentase));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,terisi,sudahDikoreksi,sudahDievaluasi,persentase);

@override
String toString() {
  return 'OpdProgressDetail(total: $total, terisi: $terisi, sudahDikoreksi: $sudahDikoreksi, sudahDievaluasi: $sudahDievaluasi, persentase: $persentase)';
}


}

/// @nodoc
abstract mixin class _$OpdProgressDetailCopyWith<$Res> implements $OpdProgressDetailCopyWith<$Res> {
  factory _$OpdProgressDetailCopyWith(_OpdProgressDetail value, $Res Function(_OpdProgressDetail) _then) = __$OpdProgressDetailCopyWithImpl;
@override @useResult
$Res call({
 int total,@JsonKey(name: 'terisi') int? terisi,@JsonKey(name: 'sudah_dikoreksi') int? sudahDikoreksi,@JsonKey(name: 'sudah_dievaluasi') int? sudahDievaluasi, double persentase
});




}
/// @nodoc
class __$OpdProgressDetailCopyWithImpl<$Res>
    implements _$OpdProgressDetailCopyWith<$Res> {
  __$OpdProgressDetailCopyWithImpl(this._self, this._then);

  final _OpdProgressDetail _self;
  final $Res Function(_OpdProgressDetail) _then;

/// Create a copy of OpdProgressDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? terisi = freezed,Object? sudahDikoreksi = freezed,Object? sudahDievaluasi = freezed,Object? persentase = null,}) {
  return _then(_OpdProgressDetail(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,terisi: freezed == terisi ? _self.terisi : terisi // ignore: cast_nullable_to_non_nullable
as int?,sudahDikoreksi: freezed == sudahDikoreksi ? _self.sudahDikoreksi : sudahDikoreksi // ignore: cast_nullable_to_non_nullable
as int?,sudahDievaluasi: freezed == sudahDievaluasi ? _self.sudahDievaluasi : sudahDievaluasi // ignore: cast_nullable_to_non_nullable
as int?,persentase: null == persentase ? _self.persentase : persentase // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
