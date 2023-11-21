import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  TextEditingController name= TextEditingController();
  TextEditingController email= TextEditingController();
  TextEditingController mobile= TextEditingController();


  File? _image;


  @override
  void initState() {
    super.initState();
    handleData();
    _loadImage();
  }

  void _loadImage() async {
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/my_image.jpg');
    if (file.existsSync()) {
      setState(() {
        _image = file;
      });
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'my_image.jpg';
      final savedImage = await pickedFile.saveTo('${appDir.path}/$fileName');
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  void handleData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileT = await prefs.getString('mobile')??'';
    String? nameT = await prefs.getString('name')??'';
    String? emailT = await prefs.getString('email')??'';
    setState(() {
      name.text = nameT;
      mobile.text = mobileT;
      email.text = emailT;
    });

  }

  void saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile', mobile.text);
    await prefs.setString('name', name.text);
    await prefs.setString('email', email.text);
    Fluttertoast.showToast(
        msg: "Your profile has been updated successfully.",
        timeInSecForIosWeb: 4);
    Navigator.pop(context);
  }


  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     FirebaseFirestore.instance.collection("Registered Users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
  //       setState((){
  //         image = value['user_profile_image'];
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Color(0xfff6ab36),
        title: Text(
          'Edit Profile',
          style: TextStyle(
              fontSize: 18.w,
              fontFamily: 'Raleway',
              letterSpacing: 1.4
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  await _getImage();
                },
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _getImage();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 50.h),
                        child: _image == null
                            ? CircleAvatar(
                          minRadius: 80.w,
                          maxRadius: 80.w,
                          backgroundImage:
                          AssetImage('assets/images/user2.png'),
                        )
                            : CircleAvatar(
                          minRadius: 80.w,
                          maxRadius: 80.w,
                          backgroundImage: FileImage(_image!),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 160.h,
                        left: 110.w,
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: Color(0xfff6ab36),
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                          child: Icon(Icons.edit),
                        )
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              personalDetailInputField(
                  text: 'Name-',
                  initText: "",
                  tController: name,
                  enabled: true,
                  numberInput: false
              ),
              SizedBox(height: 20.h),
              personalDetailInputField(
                  text: 'Email-',
                  initText: "",
                  tController: email,
                  enabled: true,
                  numberInput: false
              ),
              SizedBox(height: 20.h),
              personalDetailInputField(
                  text: 'Mobile No.-',
                  initText: "",
                  tController: mobile,
                  enabled: false,
                  numberInput: true

              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  saveData();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 45.h,
                  width: 170.w,
                  decoration: BoxDecoration(
                    color: Color(0xfff6ab36),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 200.h,)

            ],
          ),
        ),
      ),
    );
  }

  Column personalDetailInputField({
    required String text,
    required String initText,
    required TextEditingController tController,
    required bool enabled,
    required bool numberInput,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18.w,
              letterSpacing: 1,
            ),
          ),
        ),
        SizedBox(height:8.h),
        Container(
          child: TextField(
            controller: tController,
            enabled: enabled,
            keyboardType: numberInput?TextInputType.number:TextInputType.name,
            autofocus: false,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 15.w,top: 10.h,bottom: 10.h),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black54,
                  width: 0.5,
                ),

                borderRadius: BorderRadius.circular(10.w),
              ),
              // errorBorder: OutlineInputBorder(
              //   borderSide: const BorderSide(
              //     color: Color(0xFFEB5757),
              //     width: 0.8,
              //   ),
              //   borderRadius: BorderRadius.circular(25.0),
              // ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.brown,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10.w),
              ),
              fillColor: Colors.grey.shade100,
              focusColor: const Color(0xFFF2F2F3),
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}