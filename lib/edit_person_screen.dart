import 'package:flutter/material.dart';
import '../models/person.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Gorev {
  final int gorevNo;
  final String gorevAdi;

  Gorev({required this.gorevNo, required this.gorevAdi});

  @override
  String toString() => gorevAdi;
}

class EditPersonScreen extends StatefulWidget {
  final Person person;

  const EditPersonScreen({super.key, required this.person});

  @override
  _EditPersonScreenState createState() => _EditPersonScreenState();
}

class _EditPersonScreenState extends State<EditPersonScreen> {
  late TextEditingController nameController;
  late TextEditingController belediyeNoController;
  late TextEditingController dahiliNoController;
  late TextEditingController emailController;

  int? selectedBirimNo;
  int? selectedGorevNo;

  final List<String> birimListesi = [
    'Afet İşleri Müdürlüğü',
    'Arge Müdürlüğü',
    'Bilgi İşlem Müdürlüğü',
    'Destek Hizmetleri Müdürlüğü',
    'Emlak İstimlak Müdürlüğü',
    'Evlendirme Memurluğu',
    'Fen İşleri Müdürlüğü',
    'Gençlik ve Spor Hizmetleri Müdürlüğü',
    'Hukuk İşleri Müdürlüğü',
    'İklim Değişikliği ve Sıfır Atık Müdürlüğü',
    'İmar ve Şehircilik Müdürlüğü',
    'İnsan Kaynakları ve Eğitim Müdürlüğü',
    'İşletme ve İştirakler Müdürlüğü',
    'Kadın ve Aile Hizmetleri Müdürlüğü',
    'Kentsel Dönüşüm Müdürlüğü',
    'Kırsal Hizmetler Müdürlüğü',
    'Kültür İşleri Müdürlüğü',
    'Kütüphane Müdürlüğü',
    'Mali Hizmetler Müdürlüğü',
    'Muhtarlık İşleri Müdürlüğü',
    'Özel Kalem Müdürlüğü',
    'Park Ve Bahçeler Müdürlüğü',
    'Plan Ve Proje Müdürlüğü',
    'Ruhsat ve Denetim Müdürlüğü',
    'Sağlık İşleri Müdürlüğü',
    'Sosyal Destek Hizmetleri Müdürlüğü',
    'Strateji Geliştirme Müdürlüğü',
    'Teftiş Kurulu Müdürlüğü',
    'Temizlik İşleri Müdürlüğü',
    'Veteriner İşleri Müdürlüğü',
    'Yazı İşleri Müdürlüğü',
    'Zabıta Müdürlüğü',
  ];

  final List<Gorev> gorevListesi = [
    Gorev(gorevNo: 1, gorevAdi: 'Personel'),
    Gorev(gorevNo: 2, gorevAdi: 'Şef'),
    Gorev(gorevNo: 3, gorevAdi: 'Müdür'),
    Gorev(gorevNo: 4, gorevAdi: 'Başkan'),
    Gorev(gorevNo: 5, gorevAdi: 'Başkan Yrd.'),
    Gorev(gorevNo: 6, gorevAdi: 'Yön. Sekreteri'),
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.person.name);
    belediyeNoController = TextEditingController(text: widget.person.belediyeNo);
    dahiliNoController = TextEditingController(text: widget.person.dahiliNo);
    emailController = TextEditingController(text: widget.person.email);

    // Güvenli atanması için kontrol:
    selectedBirimNo = (widget.person.birimNo != null &&
            widget.person.birimNo! >= 0 &&
            widget.person.birimNo! < birimListesi.length)
        ? widget.person.birimNo
        : null;

    // Görev varsa, gorevListesinde bul, yoksa null
    final gorevBulundu =
        gorevListesi.where((g) => g.gorevNo == widget.person.gorevNo).toList();
    selectedGorevNo = gorevBulundu.isNotEmpty ? gorevBulundu.first.gorevNo : null;
  }

  @override
  void dispose() {
    nameController.dispose();
    belediyeNoController.dispose();
    dahiliNoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _savePerson() async {
    final updatedPerson = Person(
      id: widget.person.id,
      name: nameController.text.trim(),
      birimNo: selectedBirimNo ?? 0,
      belediyeNo: belediyeNoController.text.trim(),
      dahiliNo: dahiliNoController.text.trim(),
      email: emailController.text.trim(),
      gorevNo: selectedGorevNo ?? 0,
    );

    await FirebaseFirestore.instance.collection('persons').doc(updatedPerson.id).update({
      'name': updatedPerson.name,
      'birimNo': updatedPerson.birimNo,
      'belediyeNo': updatedPerson.belediyeNo,
      'dahiliNo': updatedPerson.dahiliNo,
      'email': updatedPerson.email,
      'gorevNo': updatedPerson.gorevNo,
    });

    Navigator.pop(context, updatedPerson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kişiyi Düzenle'),
        backgroundColor: const Color(0xFFDDEAFD),
      ),
      backgroundColor: const Color(0xFFF2F6FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            DropdownSearch<String>(
              items: birimListesi,
              selectedItem: (selectedBirimNo != null &&
                      selectedBirimNo! >= 0 &&
                      selectedBirimNo! < birimListesi.length)
                  ? birimListesi[selectedBirimNo!]
                  : null,
              onChanged: (val) {
                setState(() {
                  selectedBirimNo = birimListesi.indexOf(val!);
                });
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Birim",
                  border: OutlineInputBorder(),
                ),
              ),
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(autofocus: true),
              ),
            ),

            const SizedBox(height: 16),

            DropdownSearch<String>(
              items: gorevListesi.map((g) => g.gorevAdi).toList(),
              selectedItem: (selectedGorevNo != null &&
                      gorevListesi.any((g) => g.gorevNo == selectedGorevNo))
                  ? gorevListesi
                      .firstWhere((g) => g.gorevNo == selectedGorevNo)
                      .gorevAdi
                  : null,
              onChanged: (val) {
                setState(() {
                  final secilenGorev = gorevListesi.firstWhere(
                    (g) => g.gorevAdi == val,
                    orElse: () => Gorev(gorevNo: 0, gorevAdi: ''),
                  );
                  selectedGorevNo = secilenGorev.gorevNo;
                });
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Görev",
                  border: OutlineInputBorder(),
                ),
              ),
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(autofocus: true),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: belediyeNoController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Belediye Numarası'),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),

            TextField(
              controller: dahiliNoController,
              decoration: const InputDecoration(labelText: 'Dahili Numara'),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _savePerson,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
