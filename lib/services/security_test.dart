import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'kos_service.dart';

Future<List<String>> securityTest(
  String kosIdMilikUserA,
  String userAId,
) async {
  final kos = KosService();
  final hasil = <String>[];

  void log(String msg) {
    debugPrint(msg);
    hasil.add(msg);
  }

  // 0. User B boleh MELIHAT data -> harus ALLOWED
  final rows = await Supabase.instance.client
      .from('kos')
      .select()
      .eq('id', kosIdMilikUserA);
  log(
    rows.isNotEmpty
        ? '[PASS] SELECT diizinkan: User B dapat melihat data'
        : '[FAIL] User B tidak dapat melihat data',
  );

  // 1. User B mencoba mengubah data User A -> harus DENIED
  final updated = await kos.update(kosIdMilikUserA, {'name': 'DIUBAH USER B'});
  log(
    updated
        ? '[FAIL] User B berhasil mengubah data User A'
        : '[PASS] UPDATE ditolak oleh RLS',
  );

  // 2. User B mencoba menghapus data User A -> harus DENIED
  final deleted = await kos.delete(kosIdMilikUserA);
  log(
    deleted
        ? '[FAIL] User B berhasil menghapus data User A'
        : '[PASS] DELETE ditolak oleh RLS',
  );

  // 3. User B mencoba INSERT atas nama User A -> harus ERROR 42501
  try {
    await Supabase.instance.client.from('kos').insert({
      'owner_id': userAId,
      'name': 'Kos palsu',
    });
    log('[FAIL] INSERT atas nama user lain berhasil');
  } on PostgrestException catch (e) {
    log('[PASS] INSERT ditolak: ${e.code} - ${e.message}');
  }

  return hasil;
}
