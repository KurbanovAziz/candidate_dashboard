import 'dart:io';

import 'package:candidate_dashboard/data/datasources/candidate_local_data_source.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'helpers/candidate_factory.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp(
      'candidate_dashboard_hive_test_',
    );
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('cached candidates and changed statuses survive box reopen', () async {
    final candidate = candidateFactory(id: 'ivan');
    final firstStorage = await _openStorage('first');

    await firstStorage.saveCandidates([candidate]);
    await firstStorage.saveStatus(candidate.id, CandidateStatus.review);
    await Hive.close();

    Hive.init(tempDir.path);
    final reopenedStorage = await _openStorage('first');
    final restored = await reopenedStorage.readCandidates();

    expect(restored, hasLength(1));
    expect(restored.single.id, candidate.id);
    expect(restored.single.status, CandidateStatus.review);
  });
}

Future<CandidateLocalDataSource> _openStorage(String suffix) async {
  return CandidateLocalDataSource(
    cacheBox: await Hive.openBox<String>('candidate_cache_$suffix'),
    statusBox: await Hive.openBox<String>('candidate_statuses_$suffix'),
    syncQueueBox: await Hive.openBox<String>('candidate_sync_$suffix'),
  );
}
