import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wsmb_day2_try1/models/driver.dart';
import 'package:wsmb_day2_try1/models/ride.dart';
import 'package:wsmb_day2_try1/models/rider.dart';
import 'package:wsmb_day2_try1/models/vehicle.dart';

class DatabaseService {
  static final database = FirebaseFirestore.instance;

  static Future<bool> isDuplicated(Rider rider) async {
    var query = [
      database.collection('riders').where('icno', isEqualTo: rider.icno).get(),
      database
          .collection('riders')
          .where('email', isEqualTo: rider.email)
          .get(),
      database
          .collection('riders')
          .where('phone', isEqualTo: rider.phone)
          .get(),
    ];

    var res = await Future.wait(query);
    return res.any((x) => x.docs.isNotEmpty);
  }

  static Future<Rider?> addRider(Rider rider) async {
    try {
      var collection = await database.collection('riders').get();
      var id = 'R${collection.size + 1}';

      rider.id = id;

      var doc = await database.collection('riders').doc(rider.id);
      doc.set(rider.toJson());

      var newDoc = await database.collection('riders').doc(rider.id).get();
      if (newDoc.exists && newDoc.data()!.isNotEmpty) {
        var newRider = Rider.fromJson(newDoc.data()!, rider.id!);
        return newRider;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Rider?> loginRider(String ic, String password) async {
    try {
      var doc = await database
          .collection('riders')
          .where('icno', isEqualTo: ic)
          .where('password', isEqualTo: password)
          .get();
      if (doc.docs.isEmpty) {
        return null;
      }

      var rider = Rider.fromJson(doc.docs.first.data(), doc.docs.first.id);
      rider.id = doc.docs.first.id;
      return rider;
    } catch (e) {
      return null;
    }
  }

  static Future<Rider?> validateTokenRider(String id) async {
    try {
      var doc = await database.collection('riders').doc(id).get();
      if (doc.exists) {
        return Rider.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Ride>> getRideList() async {
    try {
      var collection = await database
          .collection('rides')
          .where('status', isEqualTo: 'OK')
          .where('date',
              isGreaterThanOrEqualTo:
                  DateTime.now().add(const Duration(hours: 12)).toString())
          .get();

      //  var collection = await database
      //     .collection('rides')
      //     .where('riderIds', arrayContains: 'R2')
      //     .get();
      var list =
          collection.docs.map((e) => Ride.fromJson(e.data(), e.id)).toList();
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<(Vehicle?, Driver?)> getRideDetails(String rid) async {
    try {
      var ids = rid.split('-');
      var did = ids[2];
      var vid = ids[1] + '-' + ids[2];

      Driver? driver;
      Vehicle? vehicle;
      var driverDoc = await database.collection('drivers').doc(did).get();
      if (driverDoc.exists) {
        driver = Driver.fromJson(driverDoc.data()!);
      }

      var vehicleDoc = await database.collection('vehicles').doc(vid).get();
      if (vehicleDoc.exists) {
        vehicle = Vehicle.fromJson(vehicleDoc.data()!, vid);
      }

      return (vehicle, driver);
    } catch (e) {
      return (null, null);
    }
  }

  static Future<bool> joinRide(Ride ride, Vehicle vehicle, Rider rider) async {
    try {
      if (vehicle.capacity <= ride.riderIds!.length) {
        return false;
      }
      if (ride.riderIds!.contains(rider.id!)) {
        return false;
      }

      var riderRef = database.collection('riders').doc(rider.id!);

      ride.riderIds!.add(rider.id!);
      ride.riders!.add(riderRef);

      var doc = database.collection('rides').doc(ride.id!);
      doc.set(ride.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> cancelRide(
      Ride ride, Vehicle vehicle, Rider rider) async {
    try {
      if (!ride.riderIds!.contains(rider.id!)) {
        return false;
      }

      var riderRef = database.collection('riders').doc(rider.id!);
      ride.riderIds!.remove(rider.id!);
      ride.riders!.remove(riderRef);

      var doc = database.collection('rides').doc(ride.id!);
      doc.set(ride.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }
}