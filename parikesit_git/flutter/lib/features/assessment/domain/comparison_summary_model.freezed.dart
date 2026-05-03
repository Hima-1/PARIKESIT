// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comparison_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ComparisonSummaryModel {

@JsonKey(name: 'opd_id') int get opdId;@JsonKey(name: 'nama_opd') String get opdName;@JsonKey(name: 'skor_mandiri') double get skorMandiri;@JsonKey(name: 'skor_walidata') double get skorWalidata;@JsonKey(name: 'skor_bps') double get skorBps;
/// Create a copy of ComparisonSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComparisonSummaryModelCopyWith<ComparisonSummaryModel> get copyWith => _$ComparisonSummaryModelCopyWithImpl<ComparisonSummaryModel>(this as ComparisonSummaryModel, _$identity);

  /// Serializes this ComparisonSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComparisonSummaryModel&&(identical(other.opdId, opdId) || other.opdId == opdId)&&(identical(other.opdName, opdName) || other.opdName == opdName)&&(identical(other.skorMandiri, skorMandiri) || other.skorMandiri == skorMandiri)&&(identical(other.skorWalidata, skorWalidata) || other.skorWalidata == skorWalidata)&&(identical(other.skorBps, skorBps) || other.skorBps == skorBps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opdId,opdName,skorMandiri,skorWalidata,skorBps);

@override
String toString() {
  return 'ComparisonSummaryModel(opdId: $opdId, opdName: $opdName, skorMandiri: $skorMandiri, skorWalidata: $skorWalidata, skorBps: $skorBps)';
}


}

/// @nodoc
abstract mixin class $ComparisonSummaryModelCopyWith<$Res>  {
  factory $ComparisonSummaryModelCopyWith(ComparisonSummaryModel value, $Res Function(ComparisonSummaryModel) _then) = _$ComparisonSummaryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'opd_id') int opdId,@JsonKey(name: 'nama_opd') String opdName,@JsonKey(name: 'skor_mandiri') double skorMandiri,@JsonKey(name: 'skor_walidata') double skorWalidata,@JsonKey(name: 'skor_bps') double skorBps
});




}
/// @nodoc
class _$ComparisonSummaryModelCopyWithImpl<$Res>
    implements $ComparisonSummaryModelCopyWith<$Res> {
  _$ComparisonSummaryModelCopyWithImpl(this._self, this._then);

  final ComparisonSummaryModel _self;
  final $Res Function(ComparisonSummaryModel) _then;

/// Create a copy of ComparisonSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? opdId = null,Object? opdName = null,Object? skorMandiri = null,Object? skorWalidata = null,Object? skorBps = null,}) {
  return _then(_self.copyWith(
opdId: null == opdId ? _self.opdId : opdId // ignore: cast_nullable_to_non_nullable
as int,opdName: null == opdName ? _self.opdName : opdName // ignore: cast_nullable_to_non_nullable
as String,skorMandiri: null == skorMandiri ? _self.skorMandiri : skorMandiri // ignore: cast_nullable_to_non_nullable
as double,skorWalidata: null == skorWalidata ? _self.skorWalidata : skorWalidata // ignore: cast_nullable_to_non_nullable
as double,skorBps: null == skorBps ? _self.skorBps : skorBps // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ComparisonSummaryModel].
extension ComparisonSummaryModelPatterns on ComparisonSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComparisonSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComparisonSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComparisonSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _ComparisonSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComparisonSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComparisonSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'opd_id')  int opdId, @JsonKey(name: 'nama_opd')  String opdName, @JsonKey(name: 'skor_mandiri')  double skorMandiri, @JsonKey(name: 'skor_walidata')  double skorWalidata, @JsonKey(name: 'skor_bps')  double skorBps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComparisonSummaryModel() when $default != null:
return $default(_that.opdId,_that.opdName,_that.skorMandiri,_that.skorWalidata,_that.skorBps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'opd_id')  int opdId, @JsonKey(name: 'nama_opd')  String opdName, @JsonKey(name: 'skor_mandiri')  double skorMandiri, @JsonKey(name: 'skor_walidata')  double skorWalidata, @JsonKey(name: 'skor_bps')  double skorBps)  $default,) {final _that = this;
switch (_that) {
case _ComparisonSummaryModel():
return $default(_that.opdId,_that.opdName,_that.skorMandiri,_that.skorWalidata,_that.skorBps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'opd_id')  int opdId, @JsonKey(name: 'nama_opd')  String opdName, @JsonKey(name: 'skor_mandiri')  double skorMandiri, @JsonKey(name: 'skor_walidata')  double skorWalidata, @JsonKey(name: 'skor_bps')  double skorBps)?  $default,) {final _that = this;
switch (_that) {
case _ComparisonSummaryModel() when $default != null:
return $default(_that.opdId,_that.opdName,_that.skorMandiri,_that.skorWalidata,_that.skorBps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComparisonSummaryModel implements ComparisonSummaryModel {
  const _ComparisonSummaryModel({@JsonKey(name: 'opd_id') required this.opdId, @JsonKey(name: 'nama_opd') required this.opdName, @JsonKey(name: 'skor_mandiri') required this.skorMandiri, @JsonKey(name: 'skor_walidata') required this.skorWalidata, @JsonKey(name: 'skor_bps') required this.skorBps});
  factory _ComparisonSummaryModel.fromJson(Map<String, dynamic> json) => _$ComparisonSummaryModelFromJson(json);

@override@JsonKey(name: 'opd_id') final  int opdId;
@override@JsonKey(name: 'nama_opd') final  String opdName;
@override@JsonKey(name: 'skor_mandiri') final  double skorMandiri;
@override@JsonKey(name: 'skor_walidata') final  double skorWalidata;
@override@JsonKey(name: 'skor_bps') final  double skorBps;

/// Create a copy of ComparisonSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComparisonSummaryModelCopyWith<_ComparisonSummaryModel> get copyWith => __$ComparisonSummaryModelCopyWithImpl<_ComparisonSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComparisonSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComparisonSummaryModel&&(identical(other.opdId, opdId) || other.opdId == opdId)&&(identical(other.opdName, opdName) || other.opdName == opdName)&&(identical(other.skorMandiri, skorMandiri) || other.skorMandiri == skorMandiri)&&(identical(other.skorWalidata, skorWalidata) || other.skorWalidata == skorWalidata)&&(identical(other.skorBps, skorBps) || other.skorBps == skorBps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opdId,opdName,skorMandiri,skorWalidata,skorBps);

@override
String toString() {
  return 'ComparisonSummaryModel(opdId: $opdId, opdName: $opdName, skorMandiri: $skorMandiri, skorWalidata: $skorWalidata, skorBps: $skorBps)';
}


}

/// @nodoc
abstract mixin class _$ComparisonSummaryModelCopyWith<$Res> implements $ComparisonSummaryModelCopyWith<$Res> {
  factory _$ComparisonSummaryModelCopyWith(_ComparisonSummaryModel value, $Res Function(_ComparisonSummaryModel) _then) = __$ComparisonSummaryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'opd_id') int opdId,@JsonKey(name: 'nama_opd') String opdName,@JsonKey(name: 'skor_mandiri') double skorMandiri,@JsonKey(name: 'skor_walidata') double skorWalidata,@JsonKey(name: 'skor_bps') double skorBps
});




}
/// @nodoc
class __$ComparisonSummaryModelCopyWithImpl<$Res>
    implements _$ComparisonSummaryModelCopyWith<$Res> {
  __$ComparisonSummaryModelCopyWithImpl(this._self, this._then);

  final _ComparisonSummaryModel _self;
  final $Res Function(_ComparisonSummaryModel) _then;

/// Create a copy of ComparisonSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? opdId = null,Object? opdName = null,Object? skorMandiri = null,Object? skorWalidata = null,Object? skorBps = null,}) {
  return _then(_ComparisonSummaryModel(
opdId: null == opdId ? _self.opdId : opdId // ignore: cast_nullable_to_non_nullable
as int,opdName: null == opdName ? _self.opdName : opdName // ignore: cast_nullable_to_non_nullable
as String,skorMandiri: null == skorMandiri ? _self.skorMandiri : skorMandiri // ignore: cast_nullable_to_non_nullable
as double,skorWalidata: null == skorWalidata ? _self.skorWalidata : skorWalidata // ignore: cast_nullable_to_non_nullable
as double,skorBps: null == skorBps ? _self.skorBps : skorBps // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
