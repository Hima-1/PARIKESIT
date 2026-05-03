import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/widgets/ethno_radar_chart.dart';

void main() {
  testWidgets('EthnoRadarChart shows placeholder when data length < 3', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: EthnoRadarChart(
              currentScores: [1.0, 2.0],
              targetScores: [3.0, 3.0],
              labels: ['Label 1', 'Label 2'],
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining('Data belum mencukupi'), findsOneWidget);
    expect(find.byType(RadarChart), findsNothing);
  });

  testWidgets('EthnoRadarChart shows RadarChart when data length >= 3', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: EthnoRadarChart(
              currentScores: [1.0, 2.0, 3.0],
              targetScores: [4.0, 4.0, 4.0],
              labels: ['L1', 'L2', 'L3'],
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining('Data belum mencukupi'), findsNothing);
    expect(find.byType(RadarChart), findsOneWidget);
  });
}
