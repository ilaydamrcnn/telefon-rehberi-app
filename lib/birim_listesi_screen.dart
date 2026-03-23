import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'person_list_screen.dart';

class BirimListesiScreen extends StatelessWidget {
  const BirimListesiScreen({super.key});

  IconData getBirimIcon(String birimAdi) {
    switch (birimAdi.toLowerCase()) {
      case 'afet işleri müdürlüğü':
        return Icons.warning;
      case 'arge müdürlüğü':
        return Icons.lightbulb;
      case 'bilgi işlem müdürlüğü':
        return Icons.computer;
      case 'destek hizmetleri müdürlüğü':
        return Icons.support_agent;
      case 'emlak istimlak müdürlüğü':
        return Icons.house;
      case 'evlendirme memurluğu':
        return Icons.favorite;
      case 'fen işleri müdürlüğü':
        return Icons.construction;
      case 'gençlik ve spor hizmetleri müdürlüğü':
        return Icons.sports_soccer;
      case 'hukuk işleri müdürlüğü':
        return Icons.gavel;
      case 'iklim değişikliği ve sıfır atık müdürlüğü':
        return Icons.eco;
      case 'imar ve şehircilik müdürlüğü':
        return Icons.location_city;
      case 'insan kaynakları ve eğitim müdürlüğü':
        return Icons.group;
      case 'işletme ve iştirakler müdürlüğü':
        return Icons.business;
      case 'kadın ve aile hizmetleri müdürlüğü':
        return Icons.family_restroom;
      case 'kentsel dönüşüm müdürlüğü':
        return Icons.apartment;
      case 'kırsal hizmetler müdürlüğü':
        return Icons.agriculture;
      case 'kültür işleri müdürlüğü':
        return Icons.theater_comedy;
      case 'kütüphane müdürlüğü':
        return Icons.menu_book;
      case 'mali hizmetler müdürlüğü':
        return Icons.account_balance_wallet;
      case 'muhtarlık işleri müdürlüğü':
        return Icons.account_balance;
      case 'özel kalem müdürlüğü':
        return Icons.person;
      case 'park ve bahçeler müdürlüğü':
        return Icons.park;
      case 'plan ve proje müdürlüğü':
        return Icons.map;
      case 'ruhsat ve denetim müdürlüğü':
        return Icons.fact_check;
      case 'sağlık işleri müdürlüğü':
        return Icons.local_hospital;
      case 'sosyal destek hizmetleri müdürlüğü':
        return Icons.volunteer_activism;
      case 'strateji geliştirme müdürlüğü':
        return Icons.assessment;
      case 'teftiş kurulu müdürlüğü':
        return Icons.search;
      case 'temizlik işleri müdürlüğü':
        return Icons.cleaning_services;
      case 'veteriner işleri müdürlüğü':
        return Icons.pets;
      case 'yazı işleri müdürlüğü':
        return Icons.edit_document;
      case 'zabıta müdürlüğü':
        return Icons.security;
      default:
        return Icons.apartment;
    }
  }

  Future<void> _addBirim(BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Yeni Birim Ekle"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Birim Adı"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () async {
                final yeniAd = controller.text.trim();
                if (yeniAd.isNotEmpty) {
                  final query = await FirebaseFirestore.instance
                      .collection('birimler')
                      .orderBy('no', descending: true)
                      .limit(1)
                      .get();

                  int yeniNo = 1;
                  if (query.docs.isNotEmpty) {
                    final mevcutNo = query.docs.first['no'] ?? 0;
                    yeniNo = (mevcutNo as int) + 1;
                  }

                  await FirebaseFirestore.instance.collection('birimler').add({
                    'adı': yeniAd,
                    'no': yeniNo,
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Ekle"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editBirim(
      BuildContext context, String docId, String mevcutAd) async {
    final TextEditingController controller =
        TextEditingController(text: mevcutAd);

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Birim Adını Düzenle"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Yeni birim adı"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () async {
                final yeniAd = controller.text.trim();
                if (yeniAd.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('birimler')
                      .doc(docId)
                      .update({
                    'adı': yeniAd,
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Kaydet"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBirim(BuildContext context, String docId) async {
    final bool? onay = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Silme Onayı"),
          content: const Text("Bu birimi silmek istediğinize emin misiniz?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Sil"),
            ),
          ],
        );
      },
    );

    if (onay == true) {
      await FirebaseFirestore.instance
          .collection('birimler')
          .doc(docId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FC),
      appBar: AppBar(
        title: const Text(
          "Birim Listesi",
          style: TextStyle(
            fontSize: 25,
            color: Color(0xFF003366),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFDDEAFD),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87),
            onPressed: () => _addBirim(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('birimler')
            .orderBy('adı')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final birimDocs = snapshot.data?.docs ?? [];

          if (birimDocs.isEmpty) {
            return const Center(child: Text("Henüz birim eklenmemiş."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: birimDocs.length,
            itemBuilder: (context, index) {
              final doc = birimDocs[index];
              final data = doc.data() as Map<String, dynamic>;
              final birimAdi = (data['adı'] ?? 'Birim Adı').toString();
              final birimNo = data['no'];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.blue.shade100, width: 1),
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      getBirimIcon(birimAdi),
                      color: const Color(0xFF003366),
                    ),
                  ),
                  title: Text(
                    birimAdi,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PersonListScreen(
                          filtreliBirimNo: birimNo,
                          filtreliBirimAdi: birimAdi,
                        ),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF003366)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _editBirim(context, doc.id, birimAdi),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon:
                            const Icon(Icons.delete, color: Color(0xFF003366)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _deleteBirim(context, doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
