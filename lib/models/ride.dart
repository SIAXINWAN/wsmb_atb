import 'package:cloud_firestore/cloud_firestore.dart';

class Ride {
  final DateTime date;
  final String origin;
  final String destination;
  final double fare;
  final String vehicle_id;
  String status;
  String? id;
  List<String> riderIds;
  List<DocumentReference> riders;

  Ride({
    this.id,
    List<String>? riderIds,
    List<DocumentReference>? riders,
    required this.status,
    required this.date,
    required this.origin,
    required this.destination,
    required this.fare,
    required this.vehicle_id
  }) : 
    this.riderIds = riderIds ?? [],
    this.riders = riders ?? [];

  factory Ride.fromJson(Map<String, dynamic> json, String rid) {
    return Ride(
      id: rid,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String? ?? 'Cancelled',
      origin: json['origin'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      fare: (json['fare'] as num?)?.toDouble() ?? 0.0,
      vehicle_id: json['vehicle_id'] as String? ?? '',
      riderIds: (json['riderIds'] as List<dynamic>?)?.map((x) => x.toString()).toList() ?? [],
      riders: (json['riders'] as List<dynamic>?)?.map((x) => x as DocumentReference).toList() ?? []
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicle_id,
      'fare': fare,
      'destination': destination,
      'origin': origin,
      'date': date.toIso8601String(),
      'status': status,
      'riderIds': riderIds,
      'riders': riders
    };
  }
}