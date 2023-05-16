import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  final String fname;
  final String lname;
  final String email;
  final String? address;
  final String phone;

  DriverModel(
      {required this.fname,
      required this.lname,
      required this.email,
      required this.address,
      required this.phone});

  Map<String, dynamic> toJson() => {
        "fname": fname,
        "lname": lname,
        "email": email,
        "address": address,
        "phone": phone,
      };

  static DriverModel? fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return DriverModel(
      fname: snapshot['fname'],
      lname: snapshot['lname'],
      email: snapshot['email'],
      address: snapshot['address'],
      phone: snapshot['phone'],
    );
  }
}
