// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    _DashboardStats(
      totalOpd: (json['total_opd'] as num).toInt(),
      selesai: (json['selesai'] as num).toInt(),
      progres: (json['progres'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardStatsToJson(_DashboardStats instance) =>
    <String, dynamic>{
      'total_opd': instance.totalOpd,
      'selesai': instance.selesai,
      'progres': instance.progres,
    };
