class Patient {
  final int id;
  final String name;
  final String dateOfBirth;
  final String phoneNumber;
  final String email;
  final String address;
  final String medicalHistory;
  final String allergies;
  final DateTime createdAt;

  Patient({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.medicalHistory,
    required this.allergies,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      dateOfBirth: map['dateOfBirth'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      address: map['address'],
      medicalHistory: map['medicalHistory'],
      allergies: map['allergies'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Patient copyWith({
    int? id,
    String? name,
    String? dateOfBirth,
    String? phoneNumber,
    String? email,
    String? address,
    String? medicalHistory,
    String? allergies,
    DateTime? createdAt,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      allergies: allergies ?? this.allergies,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Patient{id: $id, name: $name, dateOfBirth: $dateOfBirth, phoneNumber: $phoneNumber, email: $email, address: $address, medicalHistory: $medicalHistory, allergies: $allergies, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Patient &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          dateOfBirth == other.dateOfBirth &&
          phoneNumber == other.phoneNumber &&
          email == other.email &&
          address == other.address &&
          medicalHistory == other.medicalHistory &&
          allergies == other.allergies &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      dateOfBirth.hashCode ^
      phoneNumber.hashCode ^
      email.hashCode ^
      address.hashCode ^
      medicalHistory.hashCode ^
      allergies.hashCode ^
      createdAt.hashCode;
}
