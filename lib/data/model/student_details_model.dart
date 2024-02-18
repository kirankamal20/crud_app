// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StudentDetailsModel {
  final int id;
  final String name;
  final String age;
  final String dob;
  final String country;
  final String gender;
  final String imagepath;
  final String countrycode;
  StudentDetailsModel({
    required this.id,
    required this.name,
    required this.age,
    required this.dob,
    required this.country,
    required this.gender,
    required this.imagepath,
    required this.countrycode,
  });

  StudentDetailsModel copyWith({
    int? id,
    String? name,
    String? age,
    String? dob,
    String? country,
    String? gender,
    String? imagepath,
    String? countrycode,
  }) {
    return StudentDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      dob: dob ?? this.dob,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      imagepath: imagepath ?? this.imagepath,
      countrycode: countrycode ?? this.countrycode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'dob': dob,
      'country': country,
      'gender': gender,
      'imagepath': imagepath,
      'countrycode': countrycode,
    };
  }

  factory StudentDetailsModel.fromMap(Map<dynamic, dynamic> map) {
    return StudentDetailsModel(
      id: map['id'] as int,
      name: map['name'] as String,
      age: map['age'] as String,
      dob: map['dob'] as String,
      country: map['country'] as String,
      gender: map['gender'] as String,
      imagepath: map['imagepath'] as String,
      countrycode: map['countrycode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentDetailsModel.fromJson(String source) =>
      StudentDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StudentDetailsModel(id: $id, name: $name, age: $age, dob: $dob, country: $country, gender: $gender, imagepath: $imagepath, countrycode: $countrycode)';
  }

  @override
  bool operator ==(covariant StudentDetailsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.age == age &&
        other.dob == dob &&
        other.country == country &&
        other.gender == gender &&
        other.imagepath == imagepath &&
        other.countrycode == countrycode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        age.hashCode ^
        dob.hashCode ^
        country.hashCode ^
        gender.hashCode ^
        imagepath.hashCode ^
        countrycode.hashCode;
  }
}
