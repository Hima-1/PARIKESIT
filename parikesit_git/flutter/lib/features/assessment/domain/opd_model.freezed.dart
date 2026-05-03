// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opd_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpdProgress {

 int get count; double get percentage;
/// Create a copy of OpdProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpdProgressCopyWith<OpdProgress> get copyWith => _$OpdProgressCopyWithImpl<OpdProgress>(this as OpdProgress, _$identity);

  /// Serializes this OpdProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpdProgress&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,percentage);

@override
String toString() {
  return 'OpdProgress(count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $OpdProgressCopyWith<$Res>  {
  factory $OpdProgressCopyWith(OpdProgress value, $Res Function(OpdProgress) _then) = _$OpdProgressCopyWithImpl;
@useResult
$Res call({
 int count, double percentage
});




}
/// @nodoc
class _$OpdProgressCopyWithImpl<$Res>
    implements $OpdProgressCopyWith<$Res> {
  _$OpdProgressCopyWithImpl(this._self, this._then);

  final OpdProgress _self;
  final $Res Function(OpdProgress) _then;

/// Create a copy of OpdProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OpdProgress].
extension OpdProgressPatterns on OpdProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpdProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpdProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpdProgress value)  $default,){
final _that = this;
switch (_that) {
case _OpdProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpdProgress value)?  $default,){
final _that = this;
switch (_that) {
case _OpdProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  double percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpdProgress() when $default != null:
return $default(_that.count,_that.percentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  double percentage)  $default,) {final _that = this;
switch (_that) {
case _OpdProgress():
return $default(_that.count,_that.percentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  double percentage)?  $default,) {final _that = this;
switch (_that) {
case _OpdProgress() when $default != null:
return $default(_that.count,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpdProgress implements OpdProgress {
  const _OpdProgress({this.count = 0, this.percentage = 0});
  factory _OpdProgress.fromJson(Map<String, dynamic> json) => _$OpdProgressFromJson(json);

@override@JsonKey() final  int count;
@override@JsonKey() final  double percentage;

/// Create a copy of OpdProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpdProgressCopyWith<_OpdProgress> get copyWith => __$OpdProgressCopyWithImpl<_OpdProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpdProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpdProgress&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,percentage);

@override
String toString() {
  return 'OpdProgress(count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$OpdProgressCopyWith<$Res> implements $OpdProgressCopyWith<$Res> {
  factory _$OpdProgressCopyWith(_OpdProgress value, $Res Function(_OpdProgress) _then) = __$OpdProgressCopyWithImpl;
@override @useResult
$Res call({
 int count, double percentage
});




}
/// @nodoc
class __$OpdProgressCopyWithImpl<$Res>
    implements _$OpdProgressCopyWith<$Res> {
  __$OpdProgressCopyWithImpl(this._self, this._then);

  final _OpdProgress _self;
  final $Res Function(_OpdProgress) _then;

/// Create a copy of OpdProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? percentage = null,}) {
  return _then(_OpdProgress(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$OpdModel {

 int get id; String get name; String? get role;@JsonKey(name: 'nomor_telepon') String? get nomorTelepon;@JsonKey(name: 'opd_score') double? get opdScore;@JsonKey(name: 'walidata_score') double? get walidataScore;@JsonKey(name: 'admin_score') double? get adminScore;@JsonKey(name: 'total_indikator') int get totalIndicators;@JsonKey(name: 'opd_progress') OpdProgress? get opdProgress;@JsonKey(name: 'walidata_progress') OpdProgress? get walidataProgress;@JsonKey(name: 'admin_progress') OpdProgress? get adminProgress;
/// Create a copy of OpdModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpdModelCopyWith<OpdModel> get copyWith => _$OpdModelCopyWithImpl<OpdModel>(this as OpdModel, _$identity);

  /// Serializes this OpdModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpdModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.nomorTelepon, nomorTelepon) || other.nomorTelepon == nomorTelepon)&&(identical(other.opdScore, opdScore) || other.opdScore == opdScore)&&(identical(other.walidataScore, walidataScore) || other.walidataScore == walidataScore)&&(identical(other.adminScore, adminScore) || other.adminScore == adminScore)&&(identical(other.totalIndicators, totalIndicators) || other.totalIndicators == totalIndicators)&&(identical(other.opdProgress, opdProgress) || other.opdProgress == opdProgress)&&(identical(other.walidataProgress, walidataProgress) || other.walidataProgress == walidataProgress)&&(identical(other.adminProgress, adminProgress) || other.adminProgress == adminProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,nomorTelepon,opdScore,walidataScore,adminScore,totalIndicators,opdProgress,walidataProgress,adminProgress);

@override
String toString() {
  return 'OpdModel(id: $id, name: $name, role: $role, nomorTelepon: $nomorTelepon, opdScore: $opdScore, walidataScore: $walidataScore, adminScore: $adminScore, totalIndicators: $totalIndicators, opdProgress: $opdProgress, walidataProgress: $walidataProgress, adminProgress: $adminProgress)';
}


}

/// @nodoc
abstract mixin class $OpdModelCopyWith<$Res>  {
  factory $OpdModelCopyWith(OpdModel value, $Res Function(OpdModel) _then) = _$OpdModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? role,@JsonKey(name: 'nomor_telepon') String? nomorTelepon,@JsonKey(name: 'opd_score') double? opdScore,@JsonKey(name: 'walidata_score') double? walidataScore,@JsonKey(name: 'admin_score') double? adminScore,@JsonKey(name: 'total_indikator') int totalIndicators,@JsonKey(name: 'opd_progress') OpdProgress? opdProgress,@JsonKey(name: 'walidata_progress') OpdProgress? walidataProgress,@JsonKey(name: 'admin_progress') OpdProgress? adminProgress
});


$OpdProgressCopyWith<$Res>? get opdProgress;$OpdProgressCopyWith<$Res>? get walidataProgress;$OpdProgressCopyWith<$Res>? get adminProgress;

}
/// @nodoc
class _$OpdModelCopyWithImpl<$Res>
    implements $OpdModelCopyWith<$Res> {
  _$OpdModelCopyWithImpl(this._self, this._then);

  final OpdModel _self;
  final $Res Function(OpdModel) _then;

/// Create a copy of OpdModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = freezed,Object? nomorTelepon = freezed,Object? opdScore = freezed,Object? walidataScore = freezed,Object? adminScore = freezed,Object? totalIndicators = null,Object? opdProgress = freezed,Object? walidataProgress = freezed,Object? adminProgress = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,nomorTelepon: freezed == nomorTelepon ? _self.nomorTelepon : nomorTelepon // ignore: cast_nullable_to_non_nullable
as String?,opdScore: freezed == opdScore ? _self.opdScore : opdScore // ignore: cast_nullable_to_non_nullable
as double?,walidataScore: freezed == walidataScore ? _self.walidataScore : walidataScore // ignore: cast_nullable_to_non_nullable
as double?,adminScore: freezed == adminScore ? _self.adminScore : adminScore // ignore: cast_nullable_to_non_nullable
as double?,totalIndicators: null == totalIndicators ? _self.totalIndicators : totalIndicators // ignore: cast_nullable_to_non_nullable
as int,opdProgress: freezed == opdProgress ? _self.opdProgress : opdProgress // ignore: cast_nullable_to_non_nullable
as OpdProgress?,walidataProgress: freezed == walidataProgress ? _self.walidataProgress : walidataProgress // ignore: cast_nullable_to_non_nullable
as OpdProgress?,adminProgress: freezed == adminProgress ? _self.adminProgress : adminProgress // ignore: cast_nullable_to_non_nullable
as OpdProgress?,
  ));
}
/// Create a copy of OpdModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressCopyWith<$Res>? get opdProgress {
    if (_self.opdProgress == null) {
    return null;
  }

  return $OpdProgressCopyWith<$Res>(_self.opdProgress!, (value) {
    return _then(_self.copyWith(opdProgress: value));
  });
}/// Create a copy of OpdModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressCopyWith<$Res>? get walidataProgress {
    if (_self.walidataProgress == null) {
    return null;
  }

  return $OpdProgressCopyWith<$Res>(_self.walidataProgress!, (value) {
    return _then(_self.copyWith(walidataProgress: value));
  });
}/// Create a copy of OpdModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressCopyWith<$Res>? get adminProgress {
    if (_self.adminProgress == null) {
    return null;
  }

  return $OpdProgressCopyWith<$Res>(_self.adminProgress!, (value) {
    return _then(_self.copyWith(adminProgress: value));
  });
}
}


/// Adds pattern-matching-related methods to [OpdModel].
extension OpdModelPatterns on OpdModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpdModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpdModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpdModel value)  $default,){
final _that = this;
switch (_that) {
case _OpdModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpdModel value)?  $default,){
final _that = this;
switch (_that) {
case _OpdModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? role, @JsonKey(name: 'nomor_telepon')  String? nomorTelepon, @JsonKey(name: 'opd_score')  double? opdScore, @JsonKey(name: 'walidata_score')  double? walidataScore, @JsonKey(name: 'admin_score')  double? adminScore, @JsonKey(name: 'total_indikator')  int totalIndicators, @JsonKey(name: 'opd_progress')  OpdProgress? opdProgress, @JsonKey(name: 'walidata_progress')  OpdProgress? walidataProgress, @JsonKey(name: 'admin_progress')  OpdProgress? adminProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpdModel() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.nomorTelepon,_that.opdScore,_that.walidataScore,_that.adminScore,_that.totalIndicators,_that.opdProgress,_that.walidataProgress,_that.adminProgress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? role, @JsonKey(name: 'nomor_telepon')  String? nomorTelepon, @JsonKey(name: 'opd_score')  double? opdScore, @JsonKey(name: 'walidata_score')  double? walidataScore, @JsonKey(name: 'admin_score')  double? adminScore, @JsonKey(name: 'total_indikator')  int totalIndicators, @JsonKey(name: 'opd_progress')  OpdProgress? opdProgress, @JsonKey(name: 'walidata_progress')  OpdProgress? walidataProgress, @JsonKey(name: 'admin_progress')  OpdProgress? adminProgress)  $default,) {final _that = this;
switch (_that) {
case _OpdModel():
return $default(_that.id,_that.name,_that.role,_that.nomorTelepon,_that.opdScore,_that.walidataScore,_that.adminScore,_that.totalIndicators,_that.opdProgress,_that.walidataProgress,_that.adminProgress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? role, @JsonKey(name: 'nomor_telepon')  String? nomorTelepon, @JsonKey(name: 'opd_score')  double? opdScore, @JsonKey(name: 'walidata_score')  double? walidataScore, @JsonKey(name: 'admin_score')  double? adminScore, @JsonKey(name: 'total_indikator')  int totalIndicators, @JsonKey(name: 'opd_progress')  OpdProgress? opdProgress, @JsonKey(name: 'walidata_progress')  OpdProgress? walidataProgress, @JsonKey(name: 'admin_progress')  OpdProgress? adminProgress)?  $default,) {final _that = this;
switch (_that) {
case _OpdModel() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.nomorTelepon,_that.opdScore,_that.walidataScore,_that.adminScore,_that.totalIndicators,_that.opdProgress,_that.walidataProgress,_that.adminProgress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpdModel implements OpdModel {
  const _OpdModel({required this.id, required this.name, this.role, @JsonKey(name: 'nomor_telepon') this.nomorTelepon, @JsonKey(name: 'opd_score') this.opdScore, @JsonKey(name: 'walidata_score') this.walidataScore, @JsonKey(name: 'admin_score') this.adminScore, @JsonKey(name: 'total_indikator') this.totalIndicators = 0, @JsonKey(name: 'opd_progress') this.opdProgress, @JsonKey(name: 'walidata_progress') this.walidataProgress, @JsonKey(name: 'admin_progress') this.adminProgress});
  factory _OpdModel.fromJson(Map<String, dynamic> json) => _$OpdModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? role;
@override@JsonKey(name: 'nomor_telepon') final  String? nomorTelepon;
@override@JsonKey(name: 'opd_score') final  double? opdScore;
@override@JsonKey(name: 'walidata_score') final  double? walidataScore;
@override@JsonKey(name: 'admin_score') final  double? adminScore;
@override@JsonKey(name: 'total_indikator') final  int totalIndicators;
@override@JsonKey(name: 'opd_progress') final  OpdProgress? opdProgress;
@override@JsonKey(name: 'walidata_progress') final  OpdProgress? walidataProgress;
@override@JsonKey(name: 'admin_progress') final  OpdProgress? adminProgress;

/// Create a copy of OpdModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpdModelCopyWith<_OpdModel> get copyWith => __$OpdModelCopyWithImpl<_OpdModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpdModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpdModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.nomorTelepon, nomorTelepon) || other.nomorTelepon == nomorTelepon)&&(identical(other.opdScore, opdScore) || other.opdScore == opdScore)&&(identical(other.walidataScore, walidataScore) || other.walidataScore == walidataScore)&&(identical(other.adminScore, adminScore) || other.adminScore == adminScore)&&(identical(other.totalIndicators, totalIndicators) || other.totalIndicators == totalIndicators)&&(identical(other.opdProgress, opdProgress) || other.opdProgress == opdProgress)&&(identical(other.walidataProgress, walidataProgress) || other.walidataProgress == walidataProgress)&&(identical(other.adminProgress, adminProgress) || other.adminProgress == adminProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,nomorTelepon,opdScore,walidataScore,adminScore,totalIndicators,opdProgress,walidataProgress,adminProgress);

@override
String toString() {
  return 'OpdModel(id: $id, name: $name, role: $role, nomorTelepon: $nomorTelepon, opdScore: $opdScore, walidataScore: $walidataScore, adminScore: $adminScore, totalIndicators: $totalIndicators, opdProgress: $opdProgress, walidataProgress: $walidataProgress, adminProgress: $adminProgress)';
}


}

/// @nodoc
abstract mixin class _$OpdModelCopyWith<$Res> implements $OpdModelCopyWith<$Res> {
  factory _$OpdModelCopyWith(_OpdModel value, $Res Function(_OpdModel) _then) = __$OpdModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? role,@JsonKey(name: 'nomor_telepon') String? nomorTelepon,@JsonKey(name: 'opd_score') double? opdScore,@JsonKey(name: 'walidata_score') double? walidataScore,@JsonKey(name: 'admin_score') double? adminScore,@JsonKey(name: 'total_indikator') int totalIndicators,@JsonKey(name: 'opd_progress') OpdProgress? opdProgress,@JsonKey(name: 'walidata_progress') OpdProgress? walidataProgress,@JsonKey(name: 'admin_progress') OpdProgress? adminProgress
});


@override $OpdProgressCopyWith<$Res>? get opdProgress;@override $OpdProgressCopyWith<$Res>? get walidataProgress;@override $OpdProgressCopyWith<$Res>? get adminProgress;

}
/// @nodoc
class __$OpdModelCopyWithImpl<$Res>
    implements _$OpdModelCopyWith<$Res> {
  __$OpdModelCopyWithImpl(this._self, this._then);

  final _OpdModel _self;
  final $Res Function(_OpdModel) _then;

/// Create a copy of OpdModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = freezed,Object? nomorTelepon = freezed,Object? opdScore = freezed,Object? walidataScore = freezed,Object? adminScore = freezed,Object? totalIndicators = null,Object? opdProgress = freezed,Object? walidataProgress = freezed,Object? adminProgress = freezed,}) {
  return _then(_OpdModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,nomorTelepon: freezed == nomorTelepon ? _self.nomorTelepon : nomorTelepon // ignore: cast_nullable_to_non_nullable
as String?,opdScore: freezed == opdScore ? _self.opdScore : opdScore // ignore: cast_nullable_to_non_nullable
as double?,walidataScore: freezed == walidataScore ? _self.walidataScore : walidataScore // ignore: cast_nullable_to_non_nullable
as double?,adminScore: freezed == adminScore ? _self.adminScore : adminScore // ignore: cast_nullable_to_non_nullable
as double?,totalIndicators: null == totalIndicators ? _self.totalIndicators : totalIndicators // ignore: cast_nullable_to_non_nullable
as int,opdProgress: freezed == opdProgress ? _self.opdProgress : opdProgress // ignore: cast_nullable_to_non_nullable
as OpdProgress?,walidataProgress: freezed == walidataProgress ? _self.walidataProgress : walidataProgress // ignore: cast_nullable_to_non_nullable
as OpdProgress?,adminProgress: freezed == adminProgress ? _self.adminProgress : adminProgress // ignore: cast_nullable_to_non_nullable
as OpdProgress?,
  ));
}

/// Create a copy of OpdModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressCopyWith<$Res>? get opdProgress {
    if (_self.opdProgress == null) {
    return null;
  }

  return $OpdProgressCopyWith<$Res>(_self.opdProgress!, (value) {
    return _then(_self.copyWith(opdProgress: value));
  });
}/// Create a copy of OpdModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressCopyWith<$Res>? get walidataProgress {
    if (_self.walidataProgress == null) {
    return null;
  }

  return $OpdProgressCopyWith<$Res>(_self.walidataProgress!, (value) {
    return _then(_self.copyWith(walidataProgress: value));
  });
}/// Create a copy of OpdModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpdProgressCopyWith<$Res>? get adminProgress {
    if (_self.adminProgress == null) {
    return null;
  }

  return $OpdProgressCopyWith<$Res>(_self.adminProgress!, (value) {
    return _then(_self.copyWith(adminProgress: value));
  });
}
}

// dart format on
