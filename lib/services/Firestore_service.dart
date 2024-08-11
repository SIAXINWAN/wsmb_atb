import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:wsmb_day2_try1/models/driver.dart';
import 'package:wsmb_day2_try1/models/ride.dart';
import 'package:wsmb_day2_try1/models/vehicle.dart';

class FirestoreService {
  static final firestore = FirebaseFirestore.instance;

  static Future<bool> isDuplicated(Driver driver) async {
    final queries = [
      firestore
          .collection('drivers')
          .where('icno', isEqualTo: driver.icno)
          .get(),
      firestore
          .collection('drivers')
          .where('phone', isEqualTo: driver.phone)
          .get(),
      firestore
          .collection('drivers')
          .where('email', isEqualTo: driver.email)
          .get()
    ];

    final querySnapshot = await Future.wait(queries);

    final exists =
        querySnapshot.any((querySnapshot) => querySnapshot.docs.isNotEmpty);
    return exists;
  }

  static Future<Driver?> addDriver(Driver driver) async {
    try {
      var collection = await firestore.collection('drivers').get();
      driver.id = 'D${collection.size + 1}';
      var doc = firestore.collection('drivers').doc(driver.id);
      doc.set(driver.toJson());

      var driverDoc =
          await firestore.collection('drivers').doc(driver.id).get();
      Map<String, dynamic> data = driverDoc.data() as Map<String, dynamic>;
      Driver newDriver = Driver.fromJson(data);
      return newDriver;
    } catch (e) {
      return null;
    }
  }

  static Future<Driver?> loginDriver(String ic, String password) async {
    try {
      var collection = await firestore
          .collection('drivers')
          .where('icno', isEqualTo: ic)
          .where('password', isEqualTo: password)
          .get();

      if (collection.docs.isEmpty) {
        return null;
      }

      var doc = collection.docs.first;

      var driver = Driver.fromJson(doc.data());
      driver.id = doc.id;
      return driver;
    } catch (e) {
      return null;
    }
  }

  static Future<Driver?> validateTokenDriver(String token) async {
    try {
      var doc = await firestore.collection('drivers').doc(token).get();

      if (!doc.exists) {
        return null;
      }

      if (doc.data() != null) {
        return Driver.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> addVehicle(Vehicle vehicle) async {
    try {
      vehicle.id =
          'V${DateTime.now().millisecondsSinceEpoch}-${vehicle.driver_id}';
      var doc = firestore.collection('vehicles').doc(vehicle.id);
      doc.set(vehicle.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Vehicle>> getVehicle(String driver_id) async {
    try {
      var collection = await firestore
          .collection('vehicles')
          .where('driver_id', isEqualTo: driver_id)
          .get();

      if (collection.docs.isEmpty) {
        return [];
      }

      var list =
          collection.docs.map((e) => Vehicle.fromJson(e.data(), e.id)).toList();
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Ride>> getRide(String driver_id) async {
    try {
      var ride = await firestore.collection('rides').get();
      var collection = ride.docs.where((e) => e.id.contains(driver_id));

      if (collection.isEmpty) {
        return [];
      }

      var list = collection.map((e) => Ride.fromJson(e.data(), e.id)).toList();
      return list;
    } catch (e) {
      print('Error in getRideList: $e');
      return [];
    }
  }

  static Future<bool> addRide(Ride ride) async {
    try {
      ride.id = 'R${DateTime.now().millisecondsSinceEpoch}-${ride.vehicle_id}';
      var doc = firestore.collection('rides').doc(ride.id);
      doc.set(ride.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateVehicle(Vehicle vehicle, String id) async {
    try {
      await firestore.collection('vehicles').doc(id).update(vehicle.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteVehicle(String vehicle_id) async {
    try {
      var collection =
          await firestore.collection('vehicles').doc(vehicle_id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteRide(String ride_id) async {
    try {
      var collection =
          await firestore.collection('rides').doc(ride_id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
