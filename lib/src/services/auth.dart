import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/driver_model.dart';
import '../models/mechanic_model.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpDriver({
    required String? fname,
    required String? lname,
    required String? email,
    required String? password,
    required String? address,
    required String? phone,
  }) async {
    String result = 'Some error occurred';
    try {
      if (email!.isNotEmpty || fname!.isNotEmpty || password!.isNotEmpty) {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password!);

        DriverModel userModel = DriverModel(
          fname: fname!,
          lname: lname!,
          email: email,
          password: password,
          address: address,
          phone: phone!,
        );

        await _firestore.collection('Drivers').doc().set(
              userModel.toJson(),
            );
        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<String> logInDriver({
    required String email,
    required String password,
  }) async {
    String result = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  //---------------------------------------------------

  Future<String> signUpMechanic({
    required String? fname,
    required String? lname,
    required String? email,
    required String? password,
    required String? address,
    required String? phone,
  }) async {
    String result = 'Some error occurred';
    try {
      if (email!.isNotEmpty || fname!.isNotEmpty || password!.isNotEmpty) {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password!);

        MechanicModel userModel = MechanicModel(
          fname: fname!,
          lname: lname!,
          email: email,
          password: password,
          address: address,
          phone: phone!,
        );

        await _firestore.collection('Mechanics').doc().set(
              userModel.toJson(),
            );
        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<String> logInMechanic({
    required String email,
    required String password,
  }) async {
    String result = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }
}
