import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/widgets/app_sort_dropdown_field.dart';

void main() {
  testWidgets('admin sort dropdown expands to the available width', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 280,
              child: AppSortDropdownField<String>(
                fieldKey: Key('admin-sort-field'),
                label: 'Urutkan',
                value: 'judul',
                items: [
                  DropdownMenuItem<String>(
                    value: 'judul',
                    child: Text('Judul'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'tanggal',
                    child: Text('Tanggal'),
                  ),
                ],
                onChanged: _noop,
              ),
            ),
          ),
        ),
      ),
    );

    final fieldSize = tester.getSize(find.byKey(const Key('admin-sort-field')));

    expect(fieldSize.width, moreOrLessEquals(280, epsilon: 0.1));
  });
}

void _noop(String? value) {}
