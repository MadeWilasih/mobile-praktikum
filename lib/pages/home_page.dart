import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/role_guard.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/kos_service.dart';
import '../services/security_test.dart';
import 'kos_list_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _openKosList({bool openAdd = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KosListPage(openAddOnStart: openAdd)),
    );
  }

  // Tombol sementara Praktik 6 (hapus setelah laporan selesai)
  Future<void> _runSecurityTest() async {
    final myId = Supabase.instance.client.auth.currentUser!.id;
    final all = await KosService().fetchAll();
    final target = all.where((k) => k['owner_id'] != myId).toList();
    if (target.isEmpty) {
      _snack('Tidak ada kos milik user lain');
      return;
    }
    final hasil = await securityTest(
      target.first['id'],
      target.first['owner_id'],
    );
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hasil Security Test'),
        content: Text(hasil.join('\n\n')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'owner':
        return 'Pemilik Kos';
      case 'admin':
        return 'Admin';
      default:
        return 'Pencari Kos';
    }
  }

  Widget _menuCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final width = (MediaQuery.of(context).size.width - 40 - 12) / 2;
    return SizedBox(
      width: width,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: cs.primary),
                ),
                const SizedBox(height: 14),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: cs.outline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final p = snap.data;
        if (snap.hasError || p == null) {
          return const Scaffold(
            body: Center(child: Text('Gagal memuat profil')),
          );
        }

        final cs = Theme.of(context).colorScheme;
        final displayName = p.name.isEmpty ? p.email : p.name;

        return Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              // ===== HEADER =====
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).padding.top + 16,
                  20,
                  28,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cs.primary, cs.tertiary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.home_work_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'KosFinder',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Halo, $displayName 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Temukan dan kelola kos dengan mudah',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_roleLabel(p.role)} • ${p.email}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== MENU =====
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _menuCard(
                          icon: Icons.list_alt_rounded,
                          label: 'Daftar Kos',
                          subtitle: 'Lihat semua kos',
                          onTap: () => _openKosList(),
                        ),
                        if (p.isOwner || p.isAdmin)
                          _menuCard(
                            icon: Icons.home_work_rounded,
                            label: 'My Kos',
                            subtitle: 'Kos milikmu',
                            onTap: () => _snack('Fitur My Kos belum tersedia'),
                          ),
                        if (p.isAdmin)
                          _menuCard(
                            icon: Icons.admin_panel_settings_rounded,
                            label: 'Kelola Data',
                            subtitle: 'Khusus admin',
                            onTap: () =>
                                _snack('Fitur Kelola Data belum tersedia'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // ===== BLOK SEMENTARA PRAKTIK 6 =====
                    OutlinedButton.icon(
                      onPressed: _runSecurityTest,
                      icon: const Icon(Icons.bug_report),
                      label: const Text('Security Test (sementara)'),
                    ),
                    // ===== AKHIR BLOK SEMENTARA =====
                  ],
                ),
              ),
            ],
          ),

          // Tambah Kos: langsung buka Daftar Kos + form tambah
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton.extended(
              onPressed: () => _openKosList(openAdd: true),
              icon: const Icon(Icons.add_home),
              label: const Text('Tambah Kos'),
            ),
          ),

          // ===== NAVIGASI BAWAH =====
          bottomNavigationBar: NavigationBar(
            selectedIndex: 0,
            onDestinationSelected: (i) {
              if (i == 1) _openKosList();
              if (i == 2) _logout();
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: Icon(Icons.list_alt_outlined),
                selectedIcon: Icon(Icons.list_alt),
                label: 'Daftar Kos',
              ),
              NavigationDestination(icon: Icon(Icons.logout), label: 'Keluar'),
            ],
          ),
        );
      },
    );
  }
}
