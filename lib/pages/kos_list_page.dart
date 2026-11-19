import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/kos_service.dart';

class KosListPage extends StatefulWidget {
  final bool openAddOnStart;
  const KosListPage({super.key, this.openAddOnStart = false});

  @override
  State<KosListPage> createState() => _KosListPageState();
}

class _KosListPageState extends State<KosListPage> {
  final _service = KosService();
  final String _myId = Supabase.instance.client.auth.currentUser!.id;
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchAll();
    if (widget.openAddOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openForm());
    }
  }

  void _reload() => setState(() => _future = _service.fetchAll());

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _openForm({Map<String, dynamic>? kos}) async {
    final nameC = TextEditingController(text: kos?['name'] ?? '');
    final addrC = TextEditingController(text: kos?['address'] ?? '');
    final priceC = TextEditingController(text: '${kos?['price'] ?? ''}');

    final save = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(kos == null ? 'Tambah Kos' : 'Edit Kos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: addrC,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: priceC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (save != true) return;

    final name = nameC.text.trim();
    final address = addrC.text.trim();
    final price = int.tryParse(priceC.text.trim()) ?? 0;

    try {
      if (kos == null) {
        await _service.add(name: name, address: address, price: price);
        _snack('Kos ditambahkan');
      } else {
        final ok = await _service.update(kos['id'], {
          'name': name,
          'address': address,
          'price': price,
        });
        _snack(ok ? 'Kos diperbarui' : 'Ditolak: bukan kos milikmu');
      }
    } on PostgrestException catch (e) {
      _snack('Ditolak: ${e.message}');
    }
    _reload();
  }

  Future<void> _delete(String id) async {
    try {
      final ok = await _service.delete(id);
      _snack(ok ? 'Kos dihapus' : 'Ditolak: bukan kos milikmu');
    } on PostgrestException catch (e) {
      _snack('Ditolak: ${e.message}');
    }
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Kos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada data kos'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final kos = items[i];
              final isMine = kos['owner_id'] == _myId;
              return ListTile(
                title: Text(kos['name'] ?? '-'),
                subtitle: Text(
                  '${kos['address'] ?? '-'} • Rp ${kos['price'] ?? 0}',
                ),
                trailing: isMine
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openForm(kos: kos),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _delete(kos['id']),
                          ),
                        ],
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
