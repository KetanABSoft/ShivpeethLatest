import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_dailyattendence.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_monthlyattendance.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class Wireframeattendance_report extends StatefulWidget {
  final String?classid;
  final String?sectionid;
  final String?type;
  final String?date_pass;

  const Wireframeattendance_report({
    required this.classid,
    required this.sectionid,
    required this.type,
    required this.date_pass,
    Key? key}) : super(key: key);

  @override
  State<Wireframeattendance_report> createState() => _WireframeattaendancereortState();
}
const double widthnew = 50.0;
const double heightnew = 60.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Colors.white;

class _WireframeattaendancereortState extends State<Wireframeattendance_report> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
 late double xAlign;
  late Color loginColor;
 late  Color signInColor;
   String fetchdata="Daily";
   String? id;
   String? role;
   String? branch_id;
@override
void initState() {
  super.initState();
   xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
    getshadpreference();
  
}
   void getshadpreference()async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     id = preferences.getString('id');
     role = preferences.getString('role');
     branch_id = preferences.getString('branch_id');
   }
   
void openUrl() async {
   //print(fetchdata);
  if (fetchdata == 'Daily') {
     String class_id= widget.classid != null ? widget.classid.toString() : 'Select Class';
    String section_id=widget.sectionid != null ? widget.sectionid.toString() : 'Select Section';
    //  String class_id=widget.classid.toString()?;
    //  String section_id=widget.sectionid.toString();
     String status=widget.type.toString();
     DateTime date;
    if (widget.date_pass != null) {
      date = DateTime.parse(widget.date_pass.toString());
    } else {
      print('Start date is null');
      // Handle the case when startdate is null
      return;
    }
     String ?datepass= date != null ? date.toUtc().toIso8601String() : null;
    String appUrlNew = AppString.loginurl.replaceAll("https", "http") +
    'exporttoecel_studattDaily.php?Daily=$fetchdata&id=$id&role=$role&branch_id=$branch_id&classid=$class_id&sectionid=$section_id&status=$status&date=$datepass';

  
   try {
      await launch(appUrlNew);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }else{
     String class_id= widget.classid != null ? widget.classid.toString() : 'Select Class';
    String section_id=widget.sectionid != null ? widget.sectionid.toString() : 'Select Section';
     String status=widget.type.toString();
  DateTime date;
    if (widget.date_pass != null) {
      date = DateTime.parse(widget.date_pass.toString());
    } else {
      print('Start date is null');
      // Handle the case when startdate is null
      return;
    }
     String ?datepass= date != null ? date.toUtc().toIso8601String() : null;
     String appUrlNew = AppString.loginurl.replaceAll("https", "http") +
    'exporttoecel_studattMonthly.php?Monthly=$fetchdata&id=$id&role=$role&branch_id=$branch_id&classid=$class_id&sectionid=$section_id&status=$status&date=$datepass';
      print("appurl:"+appUrlNew);
  
   try {
      await launch(appUrlNew);
    } catch (e) {
      print('Error launching URL: $e');
    }

  }
  


}

Widget buildDropdownContainer() {
  return Container(
  
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width / 36,
        vertical: height / 66,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center( // Ensure the DropdownSearch takes up available space
                      child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            alignment: Alignment(xAlign, 0),
                            duration: Duration(milliseconds: 300),
                            child: Container(
                              width: 100,
                              height: height,
                              decoration: BoxDecoration(
                                color: WireframeColor.bootomcolor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                xAlign = loginAlign;
                                loginColor = selectedColor;
                                signInColor = normalColor;
                                fetchdata="Daily";
                              });
                            },
                            child: Align(
                              alignment: Alignment(-1, 0),
                              child: Container(
                                width: 100,
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  'Daily',
                                  style: TextStyle(
                                    color: loginColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                xAlign = signInAlign;
                                signInColor = selectedColor;
                                loginColor = normalColor;
                                fetchdata="Monthly";
                              });
                            },
                            child: Align(
                              alignment: Alignment(1, 0),
                              child: Container(
                                width: 100,
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  'Monthly',
                                  style: TextStyle(
                                    color: signInColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                  ],
                ),
              
             
              ],
            ),
          ),
          SizedBox(width: 20),
          Column(
            children: [
              InkWell(
                 onTap: () async {
                    openUrl();
                    },
                child: Image.asset(
                  WireframePngimage.excel, // Replace with your image asset path
                  width: 30,
                  height: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

      @override
      Widget build(BuildContext context) {
        size = MediaQuery.of(context).size;
        height = size.height;
        width = size.width;
        return Scaffold(
          backgroundColor: WireframeColor.appcolor,
          appBar: AppBar(
            backgroundColor: WireframeColor.appcolor,
            leadingWidth: width / 1,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    highlightColor: WireframeColor.transparent,
                    splashColor: WireframeColor.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: height / 36,
                      color: WireframeColor.white,
                    ),
                  ),
                  SizedBox(
                    width: width / 36,
                  ),
                  Text(
                    "Attendance Report",
                    style: sansproBold.copyWith(
                      fontSize: 18,
                      color: WireframeColor.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              //color: WireframeColor.white, // Set white color here
              child: Padding(
                padding: EdgeInsets.only(top: height / 36,bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: themedata.isdark ? WireframeColor.black : WireframeColor.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                       bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width / 26,
                      vertical: height / 56,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDropdownContainer(),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: fetchdata == "Daily"
                              ? dailyattendance(classid:widget.classid,sectionid:widget.sectionid,type:widget.type,date_pass:widget.date_pass)
                              : fetchdata == "Monthly"
                                  ? monthlyattendance(classid:widget.classid,sectionid:widget.sectionid,type:widget.type,date_pass:widget.date_pass)
                                  : Container(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }


}