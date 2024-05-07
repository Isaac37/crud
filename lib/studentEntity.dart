import 'package:http/http.dart' as http;

class Student {
  final id;
  final String name;
  final String surname;

  Student( {required this.name, required this.surname, required this.id});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        surname: json['surname'] ?? ''
    );
  }
}