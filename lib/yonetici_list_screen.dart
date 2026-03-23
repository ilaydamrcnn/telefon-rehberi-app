import 'package:flutter/material.dart';
import 'person_list_screen.dart';

class YoneticiListScreen extends StatelessWidget {
  const YoneticiListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PersonListScreen(
      filtreliBirimNo: null,
      filtreliBirimAdi: 'Yöneticiler',
      gorevNoFilter: [2, 3, 5],  // Sadece bu görevlerdeki kişiler gösterilecek
    );
  }
}
