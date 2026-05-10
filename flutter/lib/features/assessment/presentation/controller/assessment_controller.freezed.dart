// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssessmentFormState {

 int get formulirId; AssessmentFormModel? get formulir; String? get selectedDomainId; String? get selectedAspekId; List<AssessmentIndikator> get indikators; Map<int, Penilaian> get draftsByIndikatorId; Map<int, List<BuktiDukung>> get buktiDukungByPenilaianId;
/// Create a copy of AssessmentFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssessmentFormStateCopyWith<AssessmentFormState> get copyWith => _$AssessmentFormStateCopyWithImpl<AssessmentFormState>(this as AssessmentFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssessmentFormState&&(identical(other.formulirId, formulirId) || other.formulirId == formulirId)&&(identical(other.formulir, formulir) || other.formulir == formulir)&&(identical(other.selectedDomainId, selectedDomainId) || other.selectedDomainId == selectedDomainId)&&(identical(other.selectedAspekId, selectedAspekId) || other.selectedAspekId == selectedAspekId)&&const DeepCollectionEquality().equals(other.indikators, indikators)&&const DeepCollectionEquality().equals(other.draftsByIndikatorId, draftsByIndikatorId)&&const DeepCollectionEquality().equals(other.buktiDukungByPenilaianId, buktiDukungByPenilaianId));
}


@override
int get hashCode => Object.hash(runtimeType,formulirId,formulir,selectedDomainId,selectedAspekId,const DeepCollectionEquality().hash(indikators),const DeepCollectionEquality().hash(draftsByIndikatorId),const DeepCollectionEquality().hash(buktiDukungByPenilaianId));

@override
String toString() {
  return 'AssessmentFormState(formulirId: $formulirId, formulir: $formulir, selectedDomainId: $selectedDomainId, selectedAspekId: $selectedAspekId, indikators: $indikators, draftsByIndikatorId: $draftsByIndikatorId, buktiDukungByPenilaianId: $buktiDukungByPenilaianId)';
}


}

/// @nodoc
abstract mixin class $AssessmentFormStateCopyWith<$Res>  {
  factory $AssessmentFormStateCopyWith(AssessmentFormState value, $Res Function(AssessmentFormState) _then) = _$AssessmentFormStateCopyWithImpl;
@useResult
$Res call({
 int formulirId, AssessmentFormModel? formulir, String? selectedDomainId, String? selectedAspekId, List<AssessmentIndikator> indikators, Map<int, Penilaian> draftsByIndikatorId, Map<int, List<BuktiDukung>> buktiDukungByPenilaianId
});


$AssessmentFormModelCopyWith<$Res>? get formulir;

}
/// @nodoc
class _$AssessmentFormStateCopyWithImpl<$Res>
    implements $AssessmentFormStateCopyWith<$Res> {
  _$AssessmentFormStateCopyWithImpl(this._self, this._then);

  final AssessmentFormState _self;
  final $Res Function(AssessmentFormState) _then;

/// Create a copy of AssessmentFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formulirId = null,Object? formulir = freezed,Object? selectedDomainId = freezed,Object? selectedAspekId = freezed,Object? indikators = null,Object? draftsByIndikatorId = null,Object? buktiDukungByPenilaianId = null,}) {
  return _then(_self.copyWith(
formulirId: null == formulirId ? _self.formulirId : formulirId // ignore: cast_nullable_to_non_nullable
as int,formulir: freezed == formulir ? _self.formulir : formulir // ignore: cast_nullable_to_non_nullable
as AssessmentFormModel?,selectedDomainId: freezed == selectedDomainId ? _self.selectedDomainId : selectedDomainId // ignore: cast_nullable_to_non_nullable
as String?,selectedAspekId: freezed == selectedAspekId ? _self.selectedAspekId : selectedAspekId // ignore: cast_nullable_to_non_nullable
as String?,indikators: null == indikators ? _self.indikators : indikators // ignore: cast_nullable_to_non_nullable
as List<AssessmentIndikator>,draftsByIndikatorId: null == draftsByIndikatorId ? _self.draftsByIndikatorId : draftsByIndikatorId // ignore: cast_nullable_to_non_nullable
as Map<int, Penilaian>,buktiDukungByPenilaianId: null == buktiDukungByPenilaianId ? _self.buktiDukungByPenilaianId : buktiDukungByPenilaianId // ignore: cast_nullable_to_non_nullable
as Map<int, List<BuktiDukung>>,
  ));
}
/// Create a copy of AssessmentFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssessmentFormModelCopyWith<$Res>? get formulir {
    if (_self.formulir == null) {
    return null;
  }

  return $AssessmentFormModelCopyWith<$Res>(_self.formulir!, (value) {
    return _then(_self.copyWith(formulir: value));
  });
}
}


/// Adds pattern-matching-related methods to [AssessmentFormState].
extension AssessmentFormStatePatterns on AssessmentFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssessmentFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssessmentFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssessmentFormState value)  $default,){
final _that = this;
switch (_that) {
case _AssessmentFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssessmentFormState value)?  $default,){
final _that = this;
switch (_that) {
case _AssessmentFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int formulirId,  AssessmentFormModel? formulir,  String? selectedDomainId,  String? selectedAspekId,  List<AssessmentIndikator> indikators,  Map<int, Penilaian> draftsByIndikatorId,  Map<int, List<BuktiDukung>> buktiDukungByPenilaianId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssessmentFormState() when $default != null:
return $default(_that.formulirId,_that.formulir,_that.selectedDomainId,_that.selectedAspekId,_that.indikators,_that.draftsByIndikatorId,_that.buktiDukungByPenilaianId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int formulirId,  AssessmentFormModel? formulir,  String? selectedDomainId,  String? selectedAspekId,  List<AssessmentIndikator> indikators,  Map<int, Penilaian> draftsByIndikatorId,  Map<int, List<BuktiDukung>> buktiDukungByPenilaianId)  $default,) {final _that = this;
switch (_that) {
case _AssessmentFormState():
return $default(_that.formulirId,_that.formulir,_that.selectedDomainId,_that.selectedAspekId,_that.indikators,_that.draftsByIndikatorId,_that.buktiDukungByPenilaianId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int formulirId,  AssessmentFormModel? formulir,  String? selectedDomainId,  String? selectedAspekId,  List<AssessmentIndikator> indikators,  Map<int, Penilaian> draftsByIndikatorId,  Map<int, List<BuktiDukung>> buktiDukungByPenilaianId)?  $default,) {final _that = this;
switch (_that) {
case _AssessmentFormState() when $default != null:
return $default(_that.formulirId,_that.formulir,_that.selectedDomainId,_that.selectedAspekId,_that.indikators,_that.draftsByIndikatorId,_that.buktiDukungByPenilaianId);case _:
  return null;

}
}

}

/// @nodoc


class _AssessmentFormState implements AssessmentFormState {
  const _AssessmentFormState({required this.formulirId, this.formulir, this.selectedDomainId, this.selectedAspekId, final  List<AssessmentIndikator> indikators = const <AssessmentIndikator>[], final  Map<int, Penilaian> draftsByIndikatorId = const <int, Penilaian>{}, final  Map<int, List<BuktiDukung>> buktiDukungByPenilaianId = const <int, List<BuktiDukung>>{}}): _indikators = indikators,_draftsByIndikatorId = draftsByIndikatorId,_buktiDukungByPenilaianId = buktiDukungByPenilaianId;
  

@override final  int formulirId;
@override final  AssessmentFormModel? formulir;
@override final  String? selectedDomainId;
@override final  String? selectedAspekId;
 final  List<AssessmentIndikator> _indikators;
@override@JsonKey() List<AssessmentIndikator> get indikators {
  if (_indikators is EqualUnmodifiableListView) return _indikators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_indikators);
}

 final  Map<int, Penilaian> _draftsByIndikatorId;
@override@JsonKey() Map<int, Penilaian> get draftsByIndikatorId {
  if (_draftsByIndikatorId is EqualUnmodifiableMapView) return _draftsByIndikatorId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_draftsByIndikatorId);
}

 final  Map<int, List<BuktiDukung>> _buktiDukungByPenilaianId;
@override@JsonKey() Map<int, List<BuktiDukung>> get buktiDukungByPenilaianId {
  if (_buktiDukungByPenilaianId is EqualUnmodifiableMapView) return _buktiDukungByPenilaianId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_buktiDukungByPenilaianId);
}


/// Create a copy of AssessmentFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssessmentFormStateCopyWith<_AssessmentFormState> get copyWith => __$AssessmentFormStateCopyWithImpl<_AssessmentFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssessmentFormState&&(identical(other.formulirId, formulirId) || other.formulirId == formulirId)&&(identical(other.formulir, formulir) || other.formulir == formulir)&&(identical(other.selectedDomainId, selectedDomainId) || other.selectedDomainId == selectedDomainId)&&(identical(other.selectedAspekId, selectedAspekId) || other.selectedAspekId == selectedAspekId)&&const DeepCollectionEquality().equals(other._indikators, _indikators)&&const DeepCollectionEquality().equals(other._draftsByIndikatorId, _draftsByIndikatorId)&&const DeepCollectionEquality().equals(other._buktiDukungByPenilaianId, _buktiDukungByPenilaianId));
}


@override
int get hashCode => Object.hash(runtimeType,formulirId,formulir,selectedDomainId,selectedAspekId,const DeepCollectionEquality().hash(_indikators),const DeepCollectionEquality().hash(_draftsByIndikatorId),const DeepCollectionEquality().hash(_buktiDukungByPenilaianId));

@override
String toString() {
  return 'AssessmentFormState(formulirId: $formulirId, formulir: $formulir, selectedDomainId: $selectedDomainId, selectedAspekId: $selectedAspekId, indikators: $indikators, draftsByIndikatorId: $draftsByIndikatorId, buktiDukungByPenilaianId: $buktiDukungByPenilaianId)';
}


}

/// @nodoc
abstract mixin class _$AssessmentFormStateCopyWith<$Res> implements $AssessmentFormStateCopyWith<$Res> {
  factory _$AssessmentFormStateCopyWith(_AssessmentFormState value, $Res Function(_AssessmentFormState) _then) = __$AssessmentFormStateCopyWithImpl;
@override @useResult
$Res call({
 int formulirId, AssessmentFormModel? formulir, String? selectedDomainId, String? selectedAspekId, List<AssessmentIndikator> indikators, Map<int, Penilaian> draftsByIndikatorId, Map<int, List<BuktiDukung>> buktiDukungByPenilaianId
});


@override $AssessmentFormModelCopyWith<$Res>? get formulir;

}
/// @nodoc
class __$AssessmentFormStateCopyWithImpl<$Res>
    implements _$AssessmentFormStateCopyWith<$Res> {
  __$AssessmentFormStateCopyWithImpl(this._self, this._then);

  final _AssessmentFormState _self;
  final $Res Function(_AssessmentFormState) _then;

/// Create a copy of AssessmentFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formulirId = null,Object? formulir = freezed,Object? selectedDomainId = freezed,Object? selectedAspekId = freezed,Object? indikators = null,Object? draftsByIndikatorId = null,Object? buktiDukungByPenilaianId = null,}) {
  return _then(_AssessmentFormState(
formulirId: null == formulirId ? _self.formulirId : formulirId // ignore: cast_nullable_to_non_nullable
as int,formulir: freezed == formulir ? _self.formulir : formulir // ignore: cast_nullable_to_non_nullable
as AssessmentFormModel?,selectedDomainId: freezed == selectedDomainId ? _self.selectedDomainId : selectedDomainId // ignore: cast_nullable_to_non_nullable
as String?,selectedAspekId: freezed == selectedAspekId ? _self.selectedAspekId : selectedAspekId // ignore: cast_nullable_to_non_nullable
as String?,indikators: null == indikators ? _self._indikators : indikators // ignore: cast_nullable_to_non_nullable
as List<AssessmentIndikator>,draftsByIndikatorId: null == draftsByIndikatorId ? _self._draftsByIndikatorId : draftsByIndikatorId // ignore: cast_nullable_to_non_nullable
as Map<int, Penilaian>,buktiDukungByPenilaianId: null == buktiDukungByPenilaianId ? _self._buktiDukungByPenilaianId : buktiDukungByPenilaianId // ignore: cast_nullable_to_non_nullable
as Map<int, List<BuktiDukung>>,
  ));
}

/// Create a copy of AssessmentFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssessmentFormModelCopyWith<$Res>? get formulir {
    if (_self.formulir == null) {
    return null;
  }

  return $AssessmentFormModelCopyWith<$Res>(_self.formulir!, (value) {
    return _then(_self.copyWith(formulir: value));
  });
}
}

// dart format on
