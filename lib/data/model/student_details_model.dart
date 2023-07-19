// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StudentDetailsModel {
  final String name;
  final String age;
  final String date;
  final String country;
  final String gender;
  final String imagePath;
  StudentDetailsModel({
    required this.name,
    required this.age,
    required this.date,
    required this.country,
    required this.gender,
    required this.imagePath,
  });

  StudentDetailsModel copyWith({
    String? name,
    String? age,
    String? date,
    String? country,
    String? gender,
    String? imagePath,
  }) {
    return StudentDetailsModel(
      name: name ?? this.name,
      age: age ?? this.age,
      date: date ?? this.date,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'age': age,
      'date': date,
      'country': country,
      'gender': gender,
      'imagePath': imagePath,
    };
  }

  factory StudentDetailsModel.fromMap(Map<dynamic, dynamic> map) {
    return StudentDetailsModel(
      name: map['name'] as String,
      age: map['age'] as String,
      date: map['date'] as String,
      country: map['country'] as String,
      gender: map['gender'] as String,
      imagePath: map['imagePath'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentDetailsModel.fromJson(String source) =>
      StudentDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StudentDetailsModel(name: $name, age: $age, date: $date, country: $country, gender: $gender, imagePath: $imagePath)';
  }

  @override
  bool operator ==(covariant StudentDetailsModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.age == age &&
        other.date == date &&
        other.country == country &&
        other.gender == gender &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        age.hashCode ^
        date.hashCode ^
        country.hashCode ^
        gender.hashCode ^
        imagePath.hashCode;
  }
}
