class MaturityLevel {
  const MaturityLevel(this.level, this.label);

  final int level;
  final String label;

  static const MaturityLevel rintisan = MaturityLevel(1, 'Rintisan');
  static const MaturityLevel terkelola = MaturityLevel(2, 'Terkelola');
  static const MaturityLevel terdefinisi = MaturityLevel(3, 'Terdefinisi');
  static const MaturityLevel terpadu = MaturityLevel(4, 'Terpadu');
  static const MaturityLevel optimum = MaturityLevel(5, 'Optimum');

  static const List<MaturityLevel> values = [
    rintisan,
    terkelola,
    terdefinisi,
    terpadu,
    optimum,
  ];

  static String getLabel(int level) {
    return values
        .firstWhere(
          (v) => v.level == level,
          orElse: () => MaturityLevel(level, 'Level $level'),
        )
        .label;
  }

  static String getFullLabel(int level) {
    final label = getLabel(level);
    return 'Level $level. $label';
  }
}

extension MaturityLevelExtension on int {
  String get maturityLabel => MaturityLevel.getLabel(this);
  String get maturityFullLabel => MaturityLevel.getFullLabel(this);
}

extension MaturityLevelDoubleExtension on double {
  String get maturityLabel => MaturityLevel.getLabel(round());
  String get maturityFullLabel => MaturityLevel.getFullLabel(round());
}
