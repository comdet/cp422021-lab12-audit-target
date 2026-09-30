// =============================================================================
// profile_body-excerpt.dart
// ยกมาจาก lib/screens/profile/profile_body.dart ของโปรเจคที่ต้องตรวจ
//
// ตัดออกเฉพาะ: import ของชิ้นส่วนหน้าตาที่ไม่เกี่ยวกับสิทธิ์ และเมธอด build()
// โค้ดที่เหลือ **ไม่ได้แก้แม้ตัวอักษรเดียว**
//
// จอนี้คือหน้าตั้งค่าบัญชีของผู้ใช้ · ปุ่มบนจอเรียก requestCamera() เพื่อถ่ายรูป
// โปรไฟล์ · CameraPage คือจอกล้องที่เขียนขึ้นเองด้วยแพ็กเกจ camerawesome
// =============================================================================
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:food_order/screens/profile/capture.dart'; // จอกล้องที่เขียนเอง (CameraPage)
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  bool isPictureTaken = false;
  String imagePath = "";

  void logout() {
    print("user click");
  }

  void requestCamera(BuildContext context) async {
    var status = await Permission.camera.status;
    if(!status.isGranted){
      await Permission.camera.onDeniedCallback((){
        //แสดงข้อความ
        Fluttertoast.showToast(msg: "ไม่สามารถถ่ายรูปภาพได้");
      }).onGrantedCallback((){
        takePhoto(context);
      }).request();
    }else if(status.isGranted){
      takePhoto(context);
    }else{
      Fluttertoast.showToast(msg: "ไม่สามารถถ่ายรูปได้");
    }
  }

  void takePhoto(BuildContext context) async{
    final res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraPage()),
    );
    if(res != null){
      setState(() {
        imagePath = res;
        isPictureTaken = true;
      });
    }
  }

  // ... เมธอด build() ตัดออก ไม่เกี่ยวกับงานตรวจนี้ ...
}
