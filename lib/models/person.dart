class Person {
  final String? id;
  final String name;
  final int birimNo;    // Burada int türünde
  final int gorevNo;    // Burada int türünde
  final String belediyeNo;
  final String dahiliNo;
  final String email;

  Person({
    this.id,
    required this.name,
    required this.birimNo,
    required this.gorevNo,
    required this.belediyeNo,
    required this.dahiliNo,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birimNo': birimNo,
      'gorevNo': gorevNo,
      'belediyeNo': belediyeNo,
      'dahiliNo': dahiliNo,
      'email': email,
    };
  }

  factory Person.fromMap(String id, Map<String, dynamic> data) {
    return Person(
      id: id,
      name: data['name'] ?? '',
      birimNo: data['birimNo'] ?? 0,
      gorevNo: data['gorevNo'] ?? 0,
      belediyeNo: data['belediyeNo'] ?? '',
      dahiliNo: data['dahiliNo'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
