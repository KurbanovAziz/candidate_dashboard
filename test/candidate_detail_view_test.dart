import 'package:candidate_dashboard/features/candidate_detail/widgets/candidate_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/candidate_factory.dart';

void main() {
  testWidgets('detail page content fits narrow screen', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final candidate = candidateFactory(
      name: 'Очень длинное имя кандидата для проверки верстки',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: CandidateDetailContent(
              candidate: candidate,
              isStatusUpdating: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Карточка кандидата'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
