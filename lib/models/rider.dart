import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsmb_day2_try1/services/databaseService.dart';


class Rider {
  String? id;
  final String email;
  final String address;
  final bool? gender;
  final String icno;
  final String name;
  final String phone;
  String? password;
  String? photo;

  Rider(
      {this.id,
      required this.email,
      required this.address,
      required this.gender,
      required this.icno,
      required this.name,
      required this.phone,
      this.photo});

      static Future<Rider?>register(Rider rider,String password, File image)async {
        if(await DatabaseService.isDuplicated(rider)){
          return null;
        }

        var byte = utf8.encode(password);
        var hashedPassword = sha256.convert(byte).toString();

        rider.password = hashedPassword;
        String fileName = 'rider/${DateTime.now().microsecondsSinceEpoch}.jpg';
        UploadTask uploadTask = 
        FirebaseStorage.instance.ref(fileName).putFile(image!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadURL = await snapshot.ref.getDownloadURL();
        rider.photo = downloadURL;

        var newrider = await DatabaseService.addRider(rider);
        if(newrider == null)return null;
        return newrider;
      }

      static Future<Rider?>login(String ic,String password)async{
        var byte = utf8.encode(password);
        var hashedPassword = sha256.convert(byte).toString();

        var rider = await DatabaseService.loginRider(ic,hashedPassword);
        if(rider==null){
          return null;
        }
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('rider_token', rider.id.toString());
        return rider;
      }

      static Future<String>getToken()async{
        SharedPreferences pref = await SharedPreferences.getInstance();
        var token = pref.getString('rider_token');
        if(token ==null){
          return '';
        }
        return token;
      }
      static Future<bool>signOut()async{
        SharedPreferences pref = await SharedPreferences.getInstance();
        var logout = await pref.remove('rider_token');
        return logout;
      }

      static Future<Rider?>getRiderByToken()async{
        SharedPreferences pref = await SharedPreferences.getInstance();
        var token =  pref.getString('rider_token');
        if(token == null){
          return null;
        }
        var rider = await DatabaseService.validateTokenRider(token);
        return rider;
      }

      
      factory Rider.fromJson(Map<String,dynamic>json,String id){
        return Rider(
          id: id,
          email: json['email']??'', 
          address: json['address']??'', 
          gender: json['gender']as bool, 
          icno: json['icno']??'', 
          name: json['name']??'', 
          phone: json['phone']??'',
          photo: json['photo']??'');
      }

      toJson(){
        return{
          'email':email,
          'address':address,
          'gender':gender,
          'icno':icno,
          'name':name,
          'phone':phone,
          'password':password,
          'photo':photo,
        };
      }

}
