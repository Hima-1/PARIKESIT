import '../../../core/router/route_constants.dart';

const String incompleteFormReminderType = 'incomplete_form_reminder';
const String incompleteFormSummaryType = 'incomplete_form_summary';

String? resolveNotificationTargetRoute(Map<String, dynamic> data) {
  final String? type = _nonEmptyString(data['type']);
  if (type == null) {
    return null;
  }

  return switch (type) {
    incompleteFormSummaryType => RouteConstants.assessmentMandiri,
    incompleteFormReminderType => _resolveReminderRoute(data),
    _ => null,
  };
}

String _resolveReminderRoute(Map<String, dynamic> data) {
  final Uri? targetUri = _parseInternalRoute(data['target_route']);
  final String? routeFormulirId = targetUri == null
      ? null
      : _validId(targetUri.queryParameters['formulirId']);
  if (targetUri?.path == RouteConstants.assessmentKegiatan &&
      routeFormulirId != null) {
    return _buildKegiatanRoute(routeFormulirId);
  }

  final String? payloadFormulirId =
      _validId(data['formulir_id']) ?? _validId(data['activity_id']);
  if (payloadFormulirId != null) {
    return _buildKegiatanRoute(payloadFormulirId);
  }

  return RouteConstants.assessmentMandiri;
}

Uri? _parseInternalRoute(Object? value) {
  final String? route = _nonEmptyString(value);
  if (route == null) {
    return null;
  }

  final Uri? uri = Uri.tryParse(route);
  if (uri == null || uri.hasScheme || uri.hasAuthority) {
    return null;
  }

  return uri;
}

String _buildKegiatanRoute(String formulirId) {
  return Uri(
    path: RouteConstants.assessmentKegiatan,
    queryParameters: {'formulirId': formulirId},
  ).toString();
}

String? _validId(Object? value) {
  final String? text = _nonEmptyString(value);
  if (text == null) {
    return null;
  }

  final int? id = int.tryParse(text);
  if (id == null || id <= 0) {
    return null;
  }

  return id.toString();
}

String? _nonEmptyString(Object? value) {
  final String text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}
