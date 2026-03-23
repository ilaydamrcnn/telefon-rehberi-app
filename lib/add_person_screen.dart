import 'package:flutter/material.dart';
import 'models/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddPersonScreen extends StatefulWidget {
  final Function(Person) onPersonAdded;
  final int? birimNo;   // ✅ Yeni parametre
  final String? birimAdi; // ✅ Yeni parametre

  const AddPersonScreen({
    super.key,
    required this.onPersonAdded,
    this.birimNo,
    this.birimAdi,
  });

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  int? selectedBirimNo;
  int? selectedGorevNo;
  String belediyeNo = '';
  String dahiliNo = '';

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
  };

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
    belediyeNo = '0324 327 33 00';

    // Eğer birimNo parametresi geldiyse onu seçili yap
    if (widget.birimNo != null) {
      selectedBirimNo = widget.birimNo;
    } else {
      selectedBirimNo = birimListesi.keys.first;
    }

    selectedGorevNo = gorevListesi.keys.first;
  }

  String generateEmail(String fullName) {
    final normalized = fullName
        .toLowerCase()
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u')
        .replaceAll(' ', '.');
    return '$normalized@yenisehir.bel.tr';
  }

  void _savePerson() async {
    if (_formKey.currentState!.validate()) {
      final email = generateEmail(name.trim());

      final newPerson = Person(
        name: name.trim(),
        birimNo: selectedBirimNo!,
        gorevNo: selectedGorevNo!,
        belediyeNo: belediyeNo.trim(),
        dahiliNo: dahiliNo.trim(),
        email: email,
      );

      try {
        final docRef = await FirebaseFirestore.instance
            .collection('persons')
            .add(newPerson.toMap());

        final personWithId = Person(
          id: docRef.id,
          name: newPerson.name,
          birimNo: newPerson.birimNo,
          gorevNo: newPerson.gorevNo,
          belediyeNo: newPerson.belediyeNo,
          dahiliNo: newPerson.dahiliNo,
          email: newPerson.email,
        );

        widget.onPersonAdded(personWithId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kişi başarıyla eklendi.')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kişi eklenirken hata oluştu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Kişi Ekle'),
        backgroundColor: const Color(0xFFDDEAFD),
      ),
      backgroundColor: const Color(0xFFF2F6FC),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'İsim Soyisim'),
                onChanged: (val) => name = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Bu alan zorunludur' : null,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              DropdownSearch<int>(
                items: birimListesi.keys.toList(),
                selectedItem: selectedBirimNo,
                onChanged: widget.birimNo != null
                    ? null // ✅ Parametre geldiyse değiştirmeyi kapat
                    : (val) {
                        setState(() {
                          selectedBirimNo = val;
                        });
                      },
                dropdownBuilder: (context, selectedItem) =>
                    Text(birimListesi[selectedItem] ?? ''),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected) => ListTile(
                    title: Text(birimListesi[item]!),
                  ),
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Birim",
                    border: OutlineInputBorder(),
                  ),
                ),
                validator: (val) =>
                    val == null ? 'Lütfen birim seçiniz' : null,
              ),
              const SizedBox(height: 16),
              DropdownSearch<int>(
                items: gorevListesi.keys.toList(),
                selectedItem: selectedGorevNo,
                onChanged: (val) {
                  setState(() {
                    selectedGorevNo = val;
                  });
                },
                dropdownBuilder: (context, selectedItem) =>
                    Text(gorevListesi[selectedItem] ?? ''),
                popupProps: PopupProps.menu(
                  showSearchBox: false,
                  itemBuilder: (context, item, isSelected) => ListTile(
                    title: Text(gorevListesi[item]!),
                  ),
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Görev",
                    border: OutlineInputBorder(),
                  ),
                ),
                validator: (val) =>
                    val == null ? 'Lütfen görev seçiniz' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Belediye No'),
                readOnly: true,
                initialValue: '0324 327 33 00',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Dahili No'),
                keyboardType: TextInputType.phone,
                onChanged: (val) => dahiliNo = val,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                child: const Text("Kaydet"),
                onPressed: _savePerson,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
