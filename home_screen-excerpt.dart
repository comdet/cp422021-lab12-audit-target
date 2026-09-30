// =============================================================================
// home_screen-excerpt.dart
// ยกมาจาก lib/screens/home/home.dart ของโปรเจคที่ต้องตรวจ
//
// ตัดออกเฉพาะ: import ของชิ้นส่วนหน้าตาที่ไม่เกี่ยวกับสิทธิ์ และเมธอด build()
// โค้ดที่เหลือ **ไม่ได้แก้แม้ตัวอักษรเดียว** รวมทั้งช่องว่างและการตั้งชื่อ
// ชื่อแพ็กเกจของโปรเจคเดิมถูกเปลี่ยนเป็น food_order เท่านั้น
//
// จอนี้คือหน้าแรกของแอป · ตัวแปร location ที่เห็นข้างล่างถูกนำไปแสดงบนแถบหัวจอ
// ว่า "Deliver to <ที่อยู่>"
// =============================================================================
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String location = "Loading...";
  
  @override
  void initState() {
    super.initState();
    checkLocationPermission(context);
  }

  //check location permission
  Future<void> checkLocationPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      showLocationDialog(context, false);
    } else if (status.isPermanentlyDenied) {      
      showLocationDialog(context, true);
    } else {
      RequestLocation();    
    }
  }
  
  void showLocationDialog(BuildContext context, bool forceSetting){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,      
      title: 'Location Permission',
      desc: 'เพื่อให้แอพพลิเคชั่นทำงานได้อย่างถูกต้อง กรุณาอนุญาตให้แอพพลิเคชั่นเข้าถึงตำแหน่งของคุณ',      
      btnOkOnPress: () async {
        if(forceSetting){
          openAppSettings();
        }else{
          await Permission.location.onDeniedCallback((){
            Fluttertoast.showToast(msg: 'ไม่สามารถใช้งานแอพพลิเคชั่นได้ กรุณาตั้งค่าระบบเพื่อเปิดใช้งานตำแหน่ง');
            openAppSettings();
          }).onGrantedCallback((){
            RequestLocation();
          }).request();          
        }
      }
    ).show();
  }

  void RequestLocation() async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }    
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    String loc = await reverseSearchLocation(position.latitude, position.longitude);
    setState((){
      location = loc;
    });
  }

  Future<String> reverseSearchLocation(double lat, double lon) async {
    Response res = await get(
        Uri.parse(
            "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=jsonv2&accept-language=th"),
        headers: {'Accept-Language': 'th'});
    dynamic json = jsonDecode(res.body);
    print(json);
    String output =
        "${json['name']}, ${json['address']['road']}";

    return output;
  }

  // ... เมธอด build() ตัดออก ไม่เกี่ยวกับงานตรวจนี้ ...
}
