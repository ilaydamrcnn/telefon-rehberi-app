import 'package:flutter/material.dart';
import 'models/person.dart'; // Eğer person.dart başka klasördeyse yolu düzelt

class PersonCard extends StatelessWidget {
  final Person person;

  const PersonCard({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(person.name[0]),
        ),
        title: Text(person.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Belediye No: ${person.belediyeNo}'),
            Text('Dahili No: ${person.dahiliNo}'),
            Text('Email: ${person.email}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
