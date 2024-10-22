import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? userId;
  String fullName;
  String email;
  String password;

  CustomerModel({
    this.userId,
    required this.fullName,
    required this.email,
    required this.password,
  });

  factory CustomerModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CustomerModel(
      userId: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'password': password,
    };
  }
}
