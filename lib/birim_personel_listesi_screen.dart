import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/person.dart';
import 'add_person_screen.dart';

class BirimPersonelListesiScreen extends StatelessWidget {
  final int birimNo;
  final String birimAdi;

  const BirimPersonelListesiScreen({
    super.key,
    required this.birimNo,
    required this.birimAdi,
  });

  Future<void> _callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Arama başlatılamadı: $number';
    }
  }

  String _getGorevAdi(int gorevNo) {
    const gorevAdlari = {
      1: 'Personel',
      2: 'Şef',
      3: 'Müdür',
      4: 'Başkan',
      5: 'Başkan Yardımcısı',
      6: 'Yönetici Sekreteri',
    };
    return gorevAdlari[gorevNo] ?? 'Bilinmiyor';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$birimAdi Personelleri',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF003366),
            fontSize: 15,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFDDEAFD),
      ),
      backgroundColor: const Color(0xFFF2F6FC),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('persons')
            .where('birimNo', isEqualTo: birimNo)
            .orderBy('name')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text('$birimAdi biriminde henüz personel yok.'),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final person = Person(
                id: docs[index].id,
                name: data['name'] ?? '',
                belediyeNo: data['belediyeNo'] ?? '',
                dahiliNo: data['dahiliNo'] ?? '',
                email: data['email'] ?? '',
                birimNo: data['birimNo'] ?? 0,
                gorevNo: data['gorevNo'] ?? 0,
              );

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    person.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Görev: ${_getGorevAdi(person.gorevNo)}\n'
                    'Dahili: ${person.dahiliNo}\n'
                    'Belediye No: ${person.belediyeNo}\n'
                    'Email: ${person.email}',
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.phone,
                      color: person.birimNo == 33 ? Colors.grey : Colors.green,
                    ),
                    onPressed: person.birimNo == 33
                        ? null
                        : () => _callNumber(person.belediyeNo),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddPersonScreen(
                    onPersonAdded: (_) {},
                    birimNo: birimNo,
                    birimAdi: birimAdi,
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
