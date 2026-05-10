import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/utils/app_dialogs.dart';
import 'package:parikesit/core/utils/app_error_mapper.dart';
import 'package:parikesit/core/widgets/app_add_icon_button.dart';
import 'package:parikesit/core/widgets/app_empty_state.dart';
import 'package:parikesit/core/widgets/app_pagination_footer.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';

import '../../../core/router/route_constants.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/ethno_progress_bar.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../domain/assessment_indikator.dart';
import 'controller/assessment_controller.dart';
import 'controller/assessment_list_controller.dart';

part 'widgets/penilaian_mandiri_widgets.dart';

enum _PenilaianSegment { buatFormulir, isiFormulir }

enum _FormulirCardAction { edit, delete }

class PenilaianMandiriScreen extends ConsumerStatefulWidget {
  const PenilaianMandiriScreen({super.key});

  @override
  ConsumerState<PenilaianMandiriScreen> createState() =>
      _PenilaianMandiriScreenState();
}

class _PenilaianMandiriScreenState
    extends ConsumerState<PenilaianMandiriScreen> {
  _PenilaianSegment _segment = _PenilaianSegment.buatFormulir;
  AssessmentFormModel? _selectedFormulir;

  void _selectFormulir(AssessmentFormModel formulir) {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedFormulir = formulir;
      _segment = _PenilaianSegment.isiFormulir;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton:
          _segment == _PenilaianSegment.isiFormulir && _selectedFormulir != null
          ? FloatingActionButton.small(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedFormulir = null;
                  _segment = _PenilaianSegment.isiFormulir;
                });
              },
              backgroundColor: AppTheme.gold,
              foregroundColor: AppTheme.sogan,
              child: const Icon(LucideIcons.arrowLeft),
            )
          : null,
      body: Column(
        children: [
          _buildToggle(),
          Expanded(
            child: _segment == _PenilaianSegment.buatFormulir
                ? const _BuatFormulirView()
                : _IsiFormulirView(
                    formulir: _selectedFormulir,
                    onSelectFormulir: _selectFormulir,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.shellSurfaceSoft,
        border: Border(
          bottom: BorderSide(color: AppTheme.sogan.withValues(alpha: 0.08)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SegmentedButton<_PenilaianSegment>(
        segments: const [
          ButtonSegment(
            value: _PenilaianSegment.buatFormulir,
            label: Text('Buat Formulir'),
            icon: Icon(LucideIcons.filePlus),
          ),
          ButtonSegment(
            value: _PenilaianSegment.isiFormulir,
            label: Text('Isi Formulir'),
            icon: Icon(LucideIcons.fileEdit),
          ),
        ],
        selected: {_segment},
        onSelectionChanged: (Set<_PenilaianSegment> selected) {
          HapticFeedback.selectionClick();
          setState(() => _segment = selected.first);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppTheme.sogan;
            return null;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).colorScheme.onPrimary;
            }
            return AppTheme.sogan;
          }),
        ),
      ),
    );
  }
}
