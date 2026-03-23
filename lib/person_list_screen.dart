import 'package:flutter/material.dart';
import 'models/person.dart';
import 'contact_detail_screen.dart';
import 'add_person_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonListScreen extends StatefulWidget {
  final int? filtreliBirimNo;
  final String? filtreliBirimAdi;
  final List<int>? gorevNoFilter;  // Yeni parametre eklendi

  const PersonListScreen({
    super.key,
    this.filtreliBirimNo,
    this.filtreliBirimAdi,
    this.gorevNoFilter,
  });

  @override
  State<PersonListScreen> createState() => _PersonListScreenState();
}

class _PersonListScreenState extends State<PersonListScreen> {
  String searchQuery = '';

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
    33: 'Yönetici Müdürlüğü',
  };

  final Map<int, String> gorevListesi = {
    1: 'Personel',
    2: 'Şef',
    3: 'Müdür',
    4: 'Başkan',
    5: 'Başkan Yrd.',
    6: 'Yön. Sekreteri',
  };

  int turkishCompare(String a, String b) {
    const String alphabet =
        "AaBbCcÇçDdEeFfGgĞğHhIıİiJjKkLlMmNnOoÖöPpRrSsŞşTtUuÜüVvYyZz";
    int indexA, indexB;

    for (int i = 0; i < a.length && i < b.length; i++) {
      indexA = alphabet.indexOf(a[i]);
      indexB = alphabet.indexOf(b[i]);
      if (indexA != indexB) return indexA.compareTo(indexB);
    }
    return a.length.compareTo(b.length);
  }

  Future<void> _makePhoneCall(
    String belediyeNo,
    String dahiliNo,
    BuildContext context,
  ) async {
    final Uri municipalityUri = Uri(scheme: 'tel', path: belediyeNo);

    if (await canLaunchUrl(municipalityUri)) {
      await launchUrl(municipalityUri);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sinyal sesinden sonra dahili numarayı tuşlayın: $dahiliNo',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Arama yapılamıyor.')),
      );
    }
  }

  Widget buildPersonCard(Person person) {
    final String birimAdi = birimListesi[person.birimNo] ?? 'Birim bilgisi yok';
    final String gorevAdi = gorevListesi[person.gorevNo] ?? 'Görev bilgisi yok';

    final bool isYoneticiBirim = person.birimNo == 33;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF003366), width: 1),
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFEFF5FC),
        ),
        child: ListTile(
          leading: const Icon(Icons.person, size: 35),
          title: Text(
            person.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Birim: $birimAdi\nGörev: $gorevAdi\nDahili: ${person.dahiliNo}',
            style: const TextStyle(fontSize: 17),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactDetailScreen(contact: person),
              ),
            );
          },
          trailing: IconButton(
            icon: Icon(
              Icons.call,
              color: isYoneticiBirim ? Colors.grey : Colors.green,
              size: 28,
            ),
            onPressed: isYoneticiBirim
                ? null
                : () {
                    _makePhoneCall(person.belediyeNo, person.dahiliNo, context);
                  },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtreliBirimNo = widget.filtreliBirimNo;
    final filtreliBirimAdi = widget.filtreliBirimAdi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          filtreliBirimAdi != null
              ? '$filtreliBirimAdi Personel Listesi'
              : 'Personel Listesi',
          style: const TextStyle(
            color: Color(0xFF003366),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFDDEAFD),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF2F6FC),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'İsim ara...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF003366),
                      width: 2.0,
                    ),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),

            if (filtreliBirimAdi != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Filtre: $filtreliBirimAdi',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: filtreliBirimNo != null
                    ? FirebaseFirestore.instance
                        .collection('persons')
                        .where('birimNo', isEqualTo: filtreliBirimNo)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('persons')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Henüz kişi yok.'));
                  }

                  final firestorePersons = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Person.fromMap(doc.id, data);
                  }).toList();

                  firestorePersons.sort((a, b) => turkishCompare(a.name, b.name));

                  final displayList = firestorePersons
                      .where((person) =>
                          (widget.gorevNoFilter == null || widget.gorevNoFilter!.contains(person.gorevNo)) &&
                          (person.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                              (birimListesi[person.birimNo] ?? '')
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase())))
                      .toList();

                  if (displayList.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aradığınız isimle eşleşen personel bulunamadı.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 40, 40, 40),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return Scrollbar(
                    thickness: 12,
                    radius: const Radius.circular(8),
                    interactive: true,
                    thumbVisibility: true,
                    child: ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final person = displayList[index];
                        return buildPersonCard(person);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: filtreliBirimNo == null
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPersonScreen(
                      onPersonAdded: (newPerson) {},
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
