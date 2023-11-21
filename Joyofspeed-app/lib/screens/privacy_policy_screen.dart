import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

  @override
  Widget build(BuildContext context) {

    String privacy ="A privacy policy is a statement or legal document (in privacy law) that discloses"
        " some or all of the ways a party gathers, uses, discloses, and manages a customer or client's "
        "data.[1] Personal information can be anything that can be used to identify an individual, not limited to the person's name, address, date of birth, "
        "marital status, contact information, ID issue, and expiry date, financial records, credit information,"
        " medical history, where one travels, and intentions to acquire goods and services A privacy policy is a statement or legal document (in privacy law) that discloses"
        " some or all of the ways a party gathers, uses, discloses, and manages a customer or client's "
        "data.[1] Personal information can be anything that can be used to identify an individual, not limited to the person's name, address, date of birth, "
        "marital status, contact information, ID issue, and expiry date, financial records, credit information,"
        " medical history, where one travels, and intentions to acquire goods and services A privacy policy is a statement or legal document (in privacy law) that discloses"
        " some or all of the ways a party gathers, uses, discloses, and manages a customer or client's "
        "data.[1] Personal information can be anything that can be used to identify an individual, not limited to the person's name, address, date of birth, "
        "marital status, contact information, ID issue, and expiry date, financial records, credit information,"
        " medical history, where one travels, and intentions to acquire goods and services";

    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
        backgroundColor:  Color(0xfff6ab36).withOpacity(0.9),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w,vertical: 20.h),
          child: Text(privacy,style: TextStyle(color: Colors.black,fontSize: 16.w,fontWeight: FontWeight.w400,fontFamily: 'Raleway'),),
        ),
      ),
    );
  }
}

