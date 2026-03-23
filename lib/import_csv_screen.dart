import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class ImportCsvScreen extends StatefulWidget {
  const ImportCsvScreen({super.key});

  @override
  State<ImportCsvScreen> createState() => _ImportCsvScreenState();
}

class _ImportCsvScreenState extends State<ImportCsvScreen> {
  bool _isLoading = false;
  String _message = '';

  Future<void> _importCsvData() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      // 1. CSV dosyasını yükle
      final rawData = await rootBundle.loadString('assets/persons.csv');
      final List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData, eol: '\n');

      // 2. Başlıktan sonra verileri Firestore’a yükle
      for (int i = 1; i < csvTable.length; i++) {
        final row = csvTable[i];
        if (row.length >= 5) {
          await FirebaseFirestore.instance.collection('persons').add({
            'name': row[0],
            'birim': row[1],
            'belediyeNo': row[2],
            'dahiliNo': row[3].toString(),
            'email': row[4],
          });
        }
      }

      setState(() {
        _message = 'CSV verileri başarıyla yüklendi!';
      });
    } catch (e) {
      setState(() {
        _message = 'Hata oluştu: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Veri Aktarımı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('CSV\'yi Firebase\'e Aktar'),
              onPressed: _isLoading ? null : _importCsvData,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_message.isNotEmpty)
              Text(
                _message,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
