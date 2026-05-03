import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/app_pagination_footer.dart';

void main() {
  testWidgets('renders mobile pagination controls in a single row', (
    tester,
  ) async {
    var previousTapCount = 0;
    var nextTapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              child: AppPaginationFooter(
                currentPage: 2,
                lastPage: 5,
                hasPreviousPage: true,
                hasNextPage: true,
                onPrevious: () => previousTapCount++,
                onNext: () => nextTapCount++,
              ),
            ),
          ),
        ),
      ),
    );

    final footer = find.byType(AppPaginationFooter);

    expect(find.text('Halaman 2 dari 5'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    expect(find.byTooltip('Halaman sebelumnya'), findsOneWidget);
    expect(find.byTooltip('Halaman berikutnya'), findsOneWidget);
    expect(find.text('Mundur'), findsNothing);
    expect(find.text('Lanjut'), findsNothing);
    expect(find.text('Sebelumnya'), findsNothing);
    expect(find.text('Berikutnya'), findsNothing);
    expect(
      find.descendant(of: footer, matching: find.byType(Row)),
      findsWidgets,
    );
    expect(
      find.descendant(of: footer, matching: find.byType(Column)),
      findsNothing,
    );

    final previousCenter = tester
        .getCenter(find.byIcon(Icons.chevron_left_rounded))
        .dy;
    final statusCenter = tester.getCenter(find.text('Halaman 2 dari 5')).dy;
    final nextCenter = tester
        .getCenter(find.byIcon(Icons.chevron_right_rounded))
        .dy;

    expect((previousCenter - statusCenter).abs(), lessThan(12));
    expect((nextCenter - statusCenter).abs(), lessThan(12));

    await tester.tap(find.byTooltip('Halaman sebelumnya'));
    await tester.tap(find.byTooltip('Halaman berikutnya'));

    expect(previousTapCount, 1);
    expect(nextTapCount, 1);
  });
}
