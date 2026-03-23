import 'package:flutter/material.dart';
import '../models/person.dart';
import '../contact_detail_screen.dart';
import '../add_person_screen.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  String searchQuery = '';
  List<Person> personList = []; // 🔹 Dummy veri kaynağı artık burada
  List<Person> filteredPersons = [];

  // ✅ birimNo -> birimAdi eşlemesi
  final Map<int, String> birimAdlari = {
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
  };

  @override
  void initState() {
    super.initState();
    filteredPersons = List.from(personList); // Başlangıçta liste boş
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredPersons = personList.where((person) {
        final fullName = person.name.toLowerCase();
        final input = query.toLowerCase();
        return fullName.contains(input);
      }).toList();
    });
  }

  void addNewPerson(Person person) {
    setState(() {
      personList.add(person);
      filteredPersons = List.from(personList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telefon Rehberi'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'İsim ara...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: updateSearch,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPersons.length,
              itemBuilder: (context, index) {
                final person = filteredPersons[index];
                final birimAdi = birimAdlari[person.birimNo] ?? 'Birim yok';

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF003366),
                    ),
                    child: ListTile(
                      title: Text(
                        person.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        birimAdi,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                      ),
                      onTap: () async {
                        final updatedPerson = await Navigator.push<Person?>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactDetailScreen(
                              contact: person,
                            ),
                          ),
                        );

                        if (updatedPerson != null) {
                          setState(() {
                            int originalIndex = personList.indexOf(person);
                            if (originalIndex != -1) {
                              personList[originalIndex] = updatedPerson;
                              filteredPersons = List.from(personList);
                            }
                          });
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF003366),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPersonScreen(onPersonAdded: addNewPerson),
            ),
          );
        },
      ),
    );
  }
}
