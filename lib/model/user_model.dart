import 'package:flutter/foundation.dart';
import 'package:interrupt/utils/date_formatter.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String name;
  final String userID;
  final String imgUrl;
  final String email;
  final int age;
  final String dateOfPregrancy;
  final String complicationDesc;
  final List<String> medicines;
  final List<String> diseases;
  final List<String> allergies;
  UserModel({
    required this.name,
    required this.userID,
    required this.imgUrl,
    required this.email,
    required this.age,
    required this.dateOfPregrancy,
    required this.complicationDesc,
    required this.medicines,
    required this.diseases,
    required this.allergies,
  });

  UserModel copyWith({
    String? name,
    String? userID,
    String? imgUrl,
    String? email,
    int? age,
    String? dateOfPregrancy,
    String? complicationDesc,
    List<String>? medicines,
    List<String>? diseases,
    List<String>? allergies,
  }) {
    return UserModel(
      name: name ?? this.name,
      userID: userID ?? this.userID,
      imgUrl: imgUrl ?? this.imgUrl,
      email: email ?? this.email,
      age: age ?? this.age,
      dateOfPregrancy: dateOfPregrancy ?? this.dateOfPregrancy,
      complicationDesc: complicationDesc ?? this.complicationDesc,
      medicines: medicines ?? this.medicines,
      diseases: diseases ?? this.diseases,
      allergies: allergies ?? this.allergies,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'userID': userID,
      'imgUrl': imgUrl,
      'email': email,
      'age': age,
      'dateOfPregrancy': dateOfPregrancy,
      'complicationDesc': complicationDesc,
      'medicines': medicines,
      'diseases': diseases,
      'allergies': allergies,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      userID: map['uid'] as String,
      imgUrl: map['image'] as String,
      email: map['email'] as String,
      age: map['age'] as int,
      dateOfPregrancy:
          convertFirebaseTimestampToFormattedString(map['date_of_pregnancy']),
      complicationDesc: map['complications_description '] as String,
      medicines: List<String>.from(map['medicines ']),
      diseases: List<String>.from(map['diseases ']),
      allergies: List<String>.from(map['allegies ']),
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, userID: $userID, imgUrl: $imgUrl, email: $email, age: $age, dateOfPregrancy: $dateOfPregrancy, complicationDesc: $complicationDesc, medicines: $medicines, diseases: $diseases, allergies: $allergies)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.userID == userID &&
        other.imgUrl == imgUrl &&
        other.email == email &&
        other.age == age &&
        other.dateOfPregrancy == dateOfPregrancy &&
        other.complicationDesc == complicationDesc &&
        listEquals(other.medicines, medicines) &&
        listEquals(other.diseases, diseases) &&
        listEquals(other.allergies, allergies);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        userID.hashCode ^
        imgUrl.hashCode ^
        email.hashCode ^
        age.hashCode ^
        dateOfPregrancy.hashCode ^
        complicationDesc.hashCode ^
        medicines.hashCode ^
        diseases.hashCode ^
        allergies.hashCode;
  }
}
