import 'package:cloud_firestore/cloud_firestore.dart';

class MechanicModel {
  final String fname;
  final String lname;
  final String email;
  final String password;
  final String? address;
  final String phone;

  MechanicModel(
      {required this.fname,
      required this.lname,
      required this.email,
      required this.password,
      required this.address,
      required this.phone});

  Map<String, dynamic> toJson() => {
        "fname": fname,
        "lname": lname,
        "email": email,
        "password": password,
        "address": address,
        "phone": phone,
      };

  static MechanicModel? fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return MechanicModel(
      fname: snapshot['fname'],
      lname: snapshot['lname'],
      email: snapshot['email'],
      password: snapshot['password'],
      address: snapshot['address'],
      phone: snapshot['phone'],
    );
  }
}