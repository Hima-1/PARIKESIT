// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walidata_dashboard_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalidataDashboardProgress {

 int get id;@JsonKey(name: 'nama') String get name;@JsonKey(name: 'tanggal') DateTime get date;@JsonKey(name: 'nilai_koreksi_akhir') double? get finalCorrectionScore;@JsonKey(name: 'indikator_belum_dikoreksi') List<UncorrectedIndicator> get uncorrectedIndicators;@JsonKey(name: 'statistik_walidata') WalidataStats get stats;
/// Create a copy of WalidataDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalidataDashboardProgressCopyWith<WalidataDashboardProgress> get copyWith => _$WalidataDashboardProgressCopyWithImpl<WalidataDashboardProgress>(this as WalidataDashboardProgress, _$identity);

  /// Serializes this WalidataDashboardProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalidataDashboardProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.finalCorrectionScore, finalCorrectionScore) || other.finalCorrectionScore == finalCorrectionScore)&&const DeepCollectionEquality().equals(other.uncorrectedIndicators, uncorrectedIndicators)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,date,finalCorrectionScore,const DeepCollectionEquality().hash(uncorrectedIndicators),stats);

@override
String toString() {
  return 'WalidataDashboardProgress(id: $id, name: $name, date: $date, finalCorrectionScore: $finalCorrectionScore, uncorrectedIndicators: $uncorrectedIndicators, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $WalidataDashboardProgressCopyWith<$Res>  {
  factory $WalidataDashboardProgressCopyWith(WalidataDashboardProgress value, $Res Function(WalidataDashboardProgress) _then) = _$WalidataDashboardProgressCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'nama') String name,@JsonKey(name: 'tanggal') DateTime date,@JsonKey(name: 'nilai_koreksi_akhir') double? finalCorrectionScore,@JsonKey(name: 'indikator_belum_dikoreksi') List<UncorrectedIndicator> uncorrectedIndicators,@JsonKey(name: 'statistik_walidata') WalidataStats stats
});


$WalidataStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$WalidataDashboardProgressCopyWithImpl<$Res>
    implements $WalidataDashboardProgressCopyWith<$Res> {
  _$WalidataDashboardProgressCopyWithImpl(this._self, this._then);

  final WalidataDashboardProgress _self;
  final $Res Function(WalidataDashboardProgress) _then;

/// Create a copy of WalidataDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? date = null,Object? finalCorrectionScore = freezed,Object? uncorrectedIndicators = null,Object? stats = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,finalCorrectionScore: freezed == finalCorrectionScore ? _self.finalCorrectionScore : finalCorrectionScore // ignore: cast_nullable_to_non_nullable
as double?,uncorrectedIndicators: null == uncorrectedIndicators ? _self.uncorrectedIndicators : uncorrectedIndicators // ignore: cast_nullable_to_non_nullable
as List<UncorrectedIndicator>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as WalidataStats,
  ));
}
/// Create a copy of WalidataDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalidataStatsCopyWith<$Res> get stats {

  return $WalidataStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalidataDashboardProgress].
extension WalidataDashboardProgressPatterns on WalidataDashboardProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalidataDashboardProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalidataDashboardProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalidataDashboardProgress value)  $default,){
final _that = this;
switch (_that) {
case _WalidataDashboardProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalidataDashboardProgress value)?  $default,){
final _that = this;
switch (_that) {
case _WalidataDashboardProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'tanggal')  DateTime date, @JsonKey(name: 'nilai_koreksi_akhir')  double? finalCorrectionScore, @JsonKey(name: 'indikator_belum_dikoreksi')  List<UncorrectedIndicator> uncorrectedIndicators, @JsonKey(name: 'statistik_walidata')  WalidataStats stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalidataDashboardProgress() when $default != null:
return $default(_that.id,_that.name,_that.date,_that.finalCorrectionScore,_that.uncorrectedIndicators,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'tanggal')  DateTime date, @JsonKey(name: 'nilai_koreksi_akhir')  double? finalCorrectionScore, @JsonKey(name: 'indikator_belum_dikoreksi')  List<UncorrectedIndicator> uncorrectedIndicators, @JsonKey(name: 'statistik_walidata')  WalidataStats stats)  $default,) {final _that = this;
switch (_that) {
case _WalidataDashboardProgress():
return $default(_that.id,_that.name,_that.date,_that.finalCorrectionScore,_that.uncorrectedIndicators,_that.stats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'tanggal')  DateTime date, @JsonKey(name: 'nilai_koreksi_akhir')  double? finalCorrectionScore, @JsonKey(name: 'indikator_belum_dikoreksi')  List<UncorrectedIndicator> uncorrectedIndicators, @JsonKey(name: 'statistik_walidata')  WalidataStats stats)?  $default,) {final _that = this;
switch (_that) {
case _WalidataDashboardProgress() when $default != null:
return $default(_that.id,_that.name,_that.date,_that.finalCorrectionScore,_that.uncorrectedIndicators,_that.stats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalidataDashboardProgress implements WalidataDashboardProgress {
  const _WalidataDashboardProgress({required this.id, @JsonKey(name: 'nama') required this.name, @JsonKey(name: 'tanggal') required this.date, @JsonKey(name: 'nilai_koreksi_akhir') this.finalCorrectionScore, @JsonKey(name: 'indikator_belum_dikoreksi') required final  List<UncorrectedIndicator> uncorrectedIndicators, @JsonKey(name: 'statistik_walidata') required this.stats}): _uncorrectedIndicators = uncorrectedIndicators;
  factory _WalidataDashboardProgress.fromJson(Map<String, dynamic> json) => _$WalidataDashboardProgressFromJson(json);

@override final  int id;
@override@JsonKey(name: 'nama') final  String name;
@override@JsonKey(name: 'tanggal') final  DateTime date;
@override@JsonKey(name: 'nilai_koreksi_akhir') final  double? finalCorrectionScore;
 final  List<UncorrectedIndicator> _uncorrectedIndicators;
@override@JsonKey(name: 'indikator_belum_dikoreksi') List<UncorrectedIndicator> get uncorrectedIndicators {
  if (_uncorrectedIndicators is EqualUnmodifiableListView) return _uncorrectedIndicators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uncorrectedIndicators);
}

@override@JsonKey(name: 'statistik_walidata') final  WalidataStats stats;

/// Create a copy of WalidataDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalidataDashboardProgressCopyWith<_WalidataDashboardProgress> get copyWith => __$WalidataDashboardProgressCopyWithImpl<_WalidataDashboardProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalidataDashboardProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalidataDashboardProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.finalCorrectionScore, finalCorrectionScore) || other.finalCorrectionScore == finalCorrectionScore)&&const DeepCollectionEquality().equals(other._uncorrectedIndicators, _uncorrectedIndicators)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,date,finalCorrectionScore,const DeepCollectionEquality().hash(_uncorrectedIndicators),stats);

@override
String toString() {
  return 'WalidataDashboardProgress(id: $id, name: $name, date: $date, finalCorrectionScore: $finalCorrectionScore, uncorrectedIndicators: $uncorrectedIndicators, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$WalidataDashboardProgressCopyWith<$Res> implements $WalidataDashboardProgressCopyWith<$Res> {
  factory _$WalidataDashboardProgressCopyWith(_WalidataDashboardProgress value, $Res Function(_WalidataDashboardProgress) _then) = __$WalidataDashboardProgressCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'nama') String name,@JsonKey(name: 'tanggal') DateTime date,@JsonKey(name: 'nilai_koreksi_akhir') double? finalCorrectionScore,@JsonKey(name: 'indikator_belum_dikoreksi') List<UncorrectedIndicator> uncorrectedIndicators,@JsonKey(name: 'statistik_walidata') WalidataStats stats
});


@override $WalidataStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$WalidataDashboardProgressCopyWithImpl<$Res>
    implements _$WalidataDashboardProgressCopyWith<$Res> {
  __$WalidataDashboardProgressCopyWithImpl(this._self, this._then);

  final _WalidataDashboardProgress _self;
  final $Res Function(_WalidataDashboardProgress) _then;

/// Create a copy of WalidataDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? date = null,Object? finalCorrectionScore = freezed,Object? uncorrectedIndicators = null,Object? stats = null,}) {
  return _then(_WalidataDashboardProgress(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,finalCorrectionScore: freezed == finalCorrectionScore ? _self.finalCorrectionScore : finalCorrectionScore // ignore: cast_nullable_to_non_nullable
as double?,uncorrectedIndicators: null == uncorrectedIndicators ? _self._uncorrectedIndicators : uncorrectedIndicators // ignore: cast_nullable_to_non_nullable
as List<UncorrectedIndicator>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as WalidataStats,
  ));
}

/// Create a copy of WalidataDashboardProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalidataStatsCopyWith<$Res> get stats {

  return $WalidataStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// @nodoc
mixin _$UncorrectedIndicator {

 int get id;@JsonKey(name: 'nama') String get name;@JsonKey(name: 'domain') String get domain;@JsonKey(name: 'aspek') String get aspect;@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'user_name') String get userName;
/// Create a copy of UncorrectedIndicator
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UncorrectedIndicatorCopyWith<UncorrectedIndicator> get copyWith => _$UncorrectedIndicatorCopyWithImpl<UncorrectedIndicator>(this as UncorrectedIndicator, _$identity);

  /// Serializes this UncorrectedIndicator to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UncorrectedIndicator&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.aspect, aspect) || other.aspect == aspect)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,domain,aspect,userId,userName);

@override
String toString() {
  return 'UncorrectedIndicator(id: $id, name: $name, domain: $domain, aspect: $aspect, userId: $userId, userName: $userName)';
}


}

/// @nodoc
abstract mixin class $UncorrectedIndicatorCopyWith<$Res>  {
  factory $UncorrectedIndicatorCopyWith(UncorrectedIndicator value, $Res Function(UncorrectedIndicator) _then) = _$UncorrectedIndicatorCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'nama') String name,@JsonKey(name: 'domain') String domain,@JsonKey(name: 'aspek') String aspect,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'user_name') String userName
});




}
/// @nodoc
class _$UncorrectedIndicatorCopyWithImpl<$Res>
    implements $UncorrectedIndicatorCopyWith<$Res> {
  _$UncorrectedIndicatorCopyWithImpl(this._self, this._then);

  final UncorrectedIndicator _self;
  final $Res Function(UncorrectedIndicator) _then;

/// Create a copy of UncorrectedIndicator
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? domain = null,Object? aspect = null,Object? userId = null,Object? userName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,aspect: null == aspect ? _self.aspect : aspect // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UncorrectedIndicator].
extension UncorrectedIndicatorPatterns on UncorrectedIndicator {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UncorrectedIndicator value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UncorrectedIndicator() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UncorrectedIndicator value)  $default,){
final _that = this;
switch (_that) {
case _UncorrectedIndicator():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UncorrectedIndicator value)?  $default,){
final _that = this;
switch (_that) {
case _UncorrectedIndicator() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'domain')  String domain, @JsonKey(name: 'aspek')  String aspect, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'user_name')  String userName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UncorrectedIndicator() when $default != null:
return $default(_that.id,_that.name,_that.domain,_that.aspect,_that.userId,_that.userName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'domain')  String domain, @JsonKey(name: 'aspek')  String aspect, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'user_name')  String userName)  $default,) {final _that = this;
switch (_that) {
case _UncorrectedIndicator():
return $default(_that.id,_that.name,_that.domain,_that.aspect,_that.userId,_that.userName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'nama')  String name, @JsonKey(name: 'domain')  String domain, @JsonKey(name: 'aspek')  String aspect, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'user_name')  String userName)?  $default,) {final _that = this;
switch (_that) {
case _UncorrectedIndicator() when $default != null:
return $default(_that.id,_that.name,_that.domain,_that.aspect,_that.userId,_that.userName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UncorrectedIndicator implements UncorrectedIndicator {
  const _UncorrectedIndicator({required this.id, @JsonKey(name: 'nama') required this.name, @JsonKey(name: 'domain') required this.domain, @JsonKey(name: 'aspek') required this.aspect, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'user_name') required this.userName});
  factory _UncorrectedIndicator.fromJson(Map<String, dynamic> json) => _$UncorrectedIndicatorFromJson(json);

@override final  int id;
@override@JsonKey(name: 'nama') final  String name;
@override@JsonKey(name: 'domain') final  String domain;
@override@JsonKey(name: 'aspek') final  String aspect;
@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'user_name') final  String userName;

/// Create a copy of UncorrectedIndicator
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UncorrectedIndicatorCopyWith<_UncorrectedIndicator> get copyWith => __$UncorrectedIndicatorCopyWithImpl<_UncorrectedIndicator>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UncorrectedIndicatorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UncorrectedIndicator&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.aspect, aspect) || other.aspect == aspect)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,domain,aspect,userId,userName);

@override
String toString() {
  return 'UncorrectedIndicator(id: $id, name: $name, domain: $domain, aspect: $aspect, userId: $userId, userName: $userName)';
}


}

/// @nodoc
abstract mixin class _$UncorrectedIndicatorCopyWith<$Res> implements $UncorrectedIndicatorCopyWith<$Res> {
  factory _$UncorrectedIndicatorCopyWith(_UncorrectedIndicator value, $Res Function(_UncorrectedIndicator) _then) = __$UncorrectedIndicatorCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'nama') String name,@JsonKey(name: 'domain') String domain,@JsonKey(name: 'aspek') String aspect,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'user_name') String userName
});




}
/// @nodoc
class __$UncorrectedIndicatorCopyWithImpl<$Res>
    implements _$UncorrectedIndicatorCopyWith<$Res> {
  __$UncorrectedIndicatorCopyWithImpl(this._self, this._then);

  final _UncorrectedIndicator _self;
  final $Res Function(_UncorrectedIndicator) _then;

/// Create a copy of UncorrectedIndicator
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? domain = null,Object? aspect = null,Object? userId = null,Object? userName = null,}) {
  return _then(_UncorrectedIndicator(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,aspect: null == aspect ? _self.aspect : aspect // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WalidataStats {

@JsonKey(name: 'total_indikator') int get totalIndicators;@JsonKey(name: 'terkoreksi') int get correctedCount;@JsonKey(name: 'persentase') double get percentage;
/// Create a copy of WalidataStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalidataStatsCopyWith<WalidataStats> get copyWith => _$WalidataStatsCopyWithImpl<WalidataStats>(this as WalidataStats, _$identity);

  /// Serializes this WalidataStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalidataStats&&(identical(other.totalIndicators, totalIndicators) || other.totalIndicators == totalIndicators)&&(identical(other.correctedCount, correctedCount) || other.correctedCount == correctedCount)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIndicators,correctedCount,percentage);

@override
String toString() {
  return 'WalidataStats(totalIndicators: $totalIndicators, correctedCount: $correctedCount, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $WalidataStatsCopyWith<$Res>  {
  factory $WalidataStatsCopyWith(WalidataStats value, $Res Function(WalidataStats) _then) = _$WalidataStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_indikator') int totalIndicators,@JsonKey(name: 'terkoreksi') int correctedCount,@JsonKey(name: 'persentase') double percentage
});




}
/// @nodoc
class _$WalidataStatsCopyWithImpl<$Res>
    implements $WalidataStatsCopyWith<$Res> {
  _$WalidataStatsCopyWithImpl(this._self, this._then);

  final WalidataStats _self;
  final $Res Function(WalidataStats) _then;

/// Create a copy of WalidataStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIndicators = null,Object? correctedCount = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
totalIndicators: null == totalIndicators ? _self.totalIndicators : totalIndicators // ignore: cast_nullable_to_non_nullable
as int,correctedCount: null == correctedCount ? _self.correctedCount : correctedCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WalidataStats].
extension WalidataStatsPatterns on WalidataStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalidataStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalidataStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalidataStats value)  $default,){
final _that = this;
switch (_that) {
case _WalidataStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalidataStats value)?  $default,){
final _that = this;
switch (_that) {
case _WalidataStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_indikator')  int totalIndicators, @JsonKey(name: 'terkoreksi')  int correctedCount, @JsonKey(name: 'persentase')  double percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalidataStats() when $default != null:
return $default(_that.totalIndicators,_that.correctedCount,_that.percentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_indikator')  int totalIndicators, @JsonKey(name: 'terkoreksi')  int correctedCount, @JsonKey(name: 'persentase')  double percentage)  $default,) {final _that = this;
switch (_that) {
case _WalidataStats():
return $default(_that.totalIndicators,_that.correctedCount,_that.percentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_indikator')  int totalIndicators, @JsonKey(name: 'terkoreksi')  int correctedCount, @JsonKey(name: 'persentase')  double percentage)?  $default,) {final _that = this;
switch (_that) {
case _WalidataStats() when $default != null:
return $default(_that.totalIndicators,_that.correctedCount,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalidataStats implements WalidataStats {
  const _WalidataStats({@JsonKey(name: 'total_indikator') required this.totalIndicators, @JsonKey(name: 'terkoreksi') required this.correctedCount, @JsonKey(name: 'persentase') required this.percentage});
  factory _WalidataStats.fromJson(Map<String, dynamic> json) => _$WalidataStatsFromJson(json);

@override@JsonKey(name: 'total_indikator') final  int totalIndicators;
@override@JsonKey(name: 'terkoreksi') final  int correctedCount;
@override@JsonKey(name: 'persentase') final  double percentage;

/// Create a copy of WalidataStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalidataStatsCopyWith<_WalidataStats> get copyWith => __$WalidataStatsCopyWithImpl<_WalidataStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalidataStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalidataStats&&(identical(other.totalIndicators, totalIndicators) || other.totalIndicators == totalIndicators)&&(identical(other.correctedCount, correctedCount) || other.correctedCount == correctedCount)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIndicators,correctedCount,percentage);

@override
String toString() {
  return 'WalidataStats(totalIndicators: $totalIndicators, correctedCount: $correctedCount, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$WalidataStatsCopyWith<$Res> implements $WalidataStatsCopyWith<$Res> {
  factory _$WalidataStatsCopyWith(_WalidataStats value, $Res Function(_WalidataStats) _then) = __$WalidataStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_indikator') int totalIndicators,@JsonKey(name: 'terkoreksi') int correctedCount,@JsonKey(name: 'persentase') double percentage
});




}
/// @nodoc
class __$WalidataStatsCopyWithImpl<$Res>
    implements _$WalidataStatsCopyWith<$Res> {
  __$WalidataStatsCopyWithImpl(this._self, this._then);

  final _WalidataStats _self;
  final $Res Function(_WalidataStats) _then;

/// Create a copy of WalidataStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIndicators = null,Object? correctedCount = null,Object? percentage = null,}) {
  return _then(_WalidataStats(
totalIndicators: null == totalIndicators ? _self.totalIndicators : totalIndicators // ignore: cast_nullable_to_non_nullable
as int,correctedCount: null == correctedCount ? _self.correctedCount : correctedCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
