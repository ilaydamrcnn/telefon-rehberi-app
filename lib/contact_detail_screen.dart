import 'package:flutter/material.dart';
import '../models/person.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore eklendi
import 'edit_person_screen.dart';

class ContactDetailScreen extends StatefulWidget {
  final Person contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  _ContactDetailScreenState createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late Person currentContact;

  // Birim listesi eklendi
  final Map<int, String> birimListesi = {
    1: 'Afet İşleri Müdürlüğü',
    2: 'Arge Müdürlüğü',
    3: 'Bilgi İşlem Müdürlüğü',
    4: 'Destek Hizmetleri Müdürlüğü',
    5: 'Emlak İstimlak Müdürlüğü',
    6: 'Evlendirme Memurluğu',
    7: 'Fen İşleri Müdürlüğü',
    8: 'Gençlik ve Spor Hizmetleri Müdürlüğü',
    9: 'Hukuk İşleri Müdürlüğü',
    10: 'İklim Değişikliği ve Sıfır Atık Müdürlüğü',
    11: 'İmar ve Şehircilik Müdürlüğü',
    12: 'İnsan Kaynakları ve Eğitim Müdürlüğü',
    13: 'İşletme ve İştirakler Müdürlüğü',
    14: 'Kadın ve Aile Hizmetleri Müdürlüğü',
    15: 'Kentsel Dönüşüm Müdürlüğü',
    16: 'Kırsal Hizmetler Müdürlüğü',
    17: 'Kültür İşleri Müdürlüğü',
    18: 'Kütüphane Müdürlüğü',
    19: 'Mali Hizmetler Müdürlüğü',
    20: 'Muhtarlık İşleri Müdürlüğü',
    21: 'Özel Kalem Müdürlüğü',
    22: 'Park Ve Bahçeler Müdürlüğü',
    23: 'Plan Ve Proje Müdürlüğü',
    24: 'Ruhsat ve Denetim Müdürlüğü',
    25: 'Sağlık İşleri Müdürlüğü',
    26: 'Sosyal Destek Hizmetleri Müdürlüğü',
    27: 'Strateji Geliştirme Müdürlüğü',
    28: 'Teftiş Kurulu Müdürlüğü',
    29: 'Temizlik İşleri Müdürlüğü',
    30: 'Veteriner İşleri Müdürlüğü',
    31: 'Yazı İşleri Müdürlüğü',
    32: 'Zabıta Müdürlüğü',
    33: 'Yönetici Müdürlüğü'
  };

  // Görev listesini buraya ekliyoruz (AddPersonScreen ile uyumlu olsun diye)
  final Map<int, String> gorevListesi = {
    1: 'Personel',
    2: 'Şef',
    3: 'Müdür',
    4: 'Başkan',
    5: 'Başkan Yrd.',
    6: 'Yön. Sekreteri',
  };

  @override
  void initState() {
    super.initState();
    currentContact = widget.contact; // İlk veriyi al
  }

  Future<void> _makePhoneCall(BuildContext context) async {
    final municipalityUrl = Uri(scheme: 'tel', path: currentContact.belediyeNo);

    if (await canLaunchUrl(municipalityUrl)) {
      await launchUrl(municipalityUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sinyal sesinden sonra dahili numarayı tuşlayın: ${currentContact.dahiliNo}',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Arama yapılamıyor.')),
      );
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kişiyi Sil'),
          content: Text(
            '${currentContact.name} kişisini silmek istediğinize emin misiniz?',
          ),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Evet'),
              onPressed: () {
                Navigator.of(context).pop();
                _deletePerson();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePerson() async {
    if (currentContact.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kişi ID bilgisi bulunamadı!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('persons')
          .doc(currentContact.id)
          .delete();

      Navigator.pop(context, 'delete'); // Silme sinyalini gönderiyoruz
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silme işlemi başarısız: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FC),
      appBar: AppBar(
        title: Text(
          currentContact.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFDDEAFD),
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFF003366), height: 3.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Birim:', birimListesi[currentContact.birimNo] ?? 'Birim bilgisi yok'),

            const SizedBox(height: 20),
            _buildInfoRow('Görev:', gorevListesi[currentContact.gorevNo] ?? 'Bilinmiyor'),
            const SizedBox(height: 20),
            _buildInfoRow('Belediye Numarası:', currentContact.belediyeNo),
            const SizedBox(height: 20),
            _buildInfoRow('Dahili Numarası:', currentContact.dahiliNo),
            const SizedBox(height: 20),
            _buildInfoRow('E-posta:', currentContact.email),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF003366),
                  ),
                  backgroundColor: Colors.brown.shade50,
                  side: const BorderSide(color: Colors.black, width: 3),
                  foregroundColor: Colors.black,
                ),
                onPressed: () => _makePhoneCall(context),
                icon: const Icon(Icons.call),
                label: const Text('Ara'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF003366),
                  ),
                  backgroundColor: Colors.blue.shade100,
                  side: const BorderSide(color: Colors.black, width: 3),
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  final updatedPerson = await Navigator.push<Person?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditPersonScreen(person: currentContact),
                    ),
                  );
                  if (updatedPerson != null) {
                    setState(() {
                      currentContact = updatedPerson; // Güncellenen kişi ile değiştir
                    });
                    Navigator.pop(context, updatedPerson); // Üste de bildir
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Düzenle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 20, color: Colors.black87),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
