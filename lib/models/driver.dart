import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsmb_day2_try1/services/Firestore_service.dart';


class Driver{
  String? id;
  final String email;
  final String address;
  final bool gender;
  final String icno;
  final String name;
  final String phone;
  String?password;
  String ? photo;

  Driver({required this.email, required this.address, required this.gender, required this.icno, required this.name, required this.phone,this.photo});
  
  static Future<Driver?>register(
    Driver driver,String password,File image)async{
      if(await FirestoreService.isDuplicated(driver)){
        return null;
      }

      var byte = utf8.encode(password);
      var hashedPassword= sha256.convert(byte).toString();

      driver.password = hashedPassword;

      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = 
      FirebaseStorage.instance.ref(fileName).putFile(image!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURl = await snapshot.ref.getDownloadURL();
      driver.photo = downloadURl;

      var newDriver = await FirestoreService.addDriver(driver);
      if(newDriver == null)return null;

      return newDriver;

    }
  
    static Future<Driver?>login(String ic,String password)async{
      var byte = utf8.encode(password);
    var hashedPassword = sha256.convert(byte).toString();

    var driver = await FirestoreService.loginDriver(ic, hashedPassword);
    if(driver ==null){
      return null;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', driver.id.toString());
    return driver;
    }

    static Future<String> getToken()async{
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token = pref.getString('token');
      if(token == null){
        return '';
      }
      return token;
    }

    static Future<bool>signOut()async{
      SharedPreferences pref = await SharedPreferences.getInstance();
      var logout = await pref.remove('token');

      return logout;
    }

  static Future<Driver?>getDriverByToken()async{
    
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    if(token ==null){
      return null;
    } 

    var driver = await FirestoreService.validateTokenDriver(token);
    return driver;
  }

  factory Driver.fromJson(Map<String,dynamic>json){
    return Driver(
      email: json['email']??'', 
      address: json['address']??'', 
      gender: json['gender']as bool, 
      icno: json['icno']??'', 
      name: json['name']??'', 
      phone: json['phone']??'',
      photo: json['photo']);
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
      'photo':photo
    };
  }
}