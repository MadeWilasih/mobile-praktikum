import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Meminta izin notifikasi dan mengembalikan statusnya:
  /// authorized | provisional | denied | notDetermined
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus.name}');
    return settings.authorizationStatus;
  }

  // ===== PRAKTIK 9: FCM TOKEN =====

  Future<String?> getToken() async {
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
    return token;
  }

  /// Token dapat berubah, sehingga perubahan perlu didengarkan.
  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui');
      onRefresh(newToken);
    });
  }

  /// Opsional: simpan token ke tabel device_tokens di Supabase.
  Future<void> saveTokenToSupabase(String token) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      await Supabase.instance.client.from('device_tokens').upsert({
        'token': token,
        'user_id': user.id,
        'platform': defaultTargetPlatform.name,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      debugPrint('Token tersimpan ke Supabase');
    } catch (e) {
      debugPrint('Gagal menyimpan token: $e');
    }
  }
}
