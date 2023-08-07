class UserModel {
  final String name;
  final String userID;
  final String imgUrl;
  final String email;
  final int age;
  final String dateOfPregrancy;
  final String complicationDesc;
  final String bloodGroup;
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
    required this.bloodGroup,
    required this.medicines,
    required this.diseases,
    required this.allergies,
  });

  UserModel copyWith({
    String? name,
    String? userID,
    String? imgUrl,
    String? email,
    String? bloodGroup,
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
      bloodGroup: bloodGroup ?? this.bloodGroup,
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
      'bloodGroup': bloodGroup,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      userID: map['uid'] as String,
      imgUrl: map['image'] as String,
      email: map['email'] as String,
      bloodGroup: map['bloodGroup'] as String,
      age: map['age'] as int,
      dateOfPregrancy: map['date_of_pregnancy'],
      complicationDesc: map['complications_description'] as String,
      medicines: List<String>.from(map['medicines']),
      diseases: List<String>.from(map['diseases']),
      allergies: List<String>.from(map['allegies']),
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, userID: $userID, imgUrl: $imgUrl,bloodGroup:$bloodGroup, email: $email, age: $age, dateOfPregrancy: $dateOfPregrancy, complicationDesc: $complicationDesc, medicines: $medicines, diseases: $diseases, allergies: $allergies)';
  }
}
