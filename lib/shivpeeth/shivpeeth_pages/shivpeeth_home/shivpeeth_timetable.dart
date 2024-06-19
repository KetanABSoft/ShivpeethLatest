import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/timetable_adapter.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class timetablelist {
  final String id;
  final String timetableimage;
  
 
  

  timetablelist(
      {required this.id,
      required this.timetableimage,


 

      
      
      });

  factory timetablelist.fromJson(Map<String, dynamic> json) {
    return timetablelist(
      id: json['id'],
      timetableimage: json['timetableimage'],
     
      
    
    );
  }
}
class timetable extends StatefulWidget {
    
 final String classid;
  final String sectionid;
  const timetable({
     required this.classid,
     required this.sectionid,
    super.key});

  @override
  State<timetable> createState() => timetableState();
}

class timetableState extends State<timetable> {
  double height = 0.00;
  double width = 0.00;
var _classtypedata;
  List<String> classTypenew = [];
  List<String> classTypeid = [];
    String? selectedId;
 var selectedValue;
 var selectedValueid;
 List<timetablelist> carouselItems = [];
String?roleid;
 String?userid;
 String?branch_id;
  

   @override
  void initState() {
    super.initState();
   getshadpre();
    getteacher();
   // noticedata("Select Teacher","Select Class","Select Section");
  }


Future<void> getteacher() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
          branch_id = preferences.getString('branch_id');

   // final response = await http.get(Uri.parse(AppString.constanturl + 'fetchteachername'));
   String apiUrl = AppString.constanturl + 'fetchteachername';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "branch_id": branch_id != null ? branch_id : '',

      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      _classtypedata = jsonData;
      //print(_classtypedata);
      for (int i = 0; i < _classtypedata.length; i++) {
        classTypeid.add(_classtypedata[i]["id"]);
        classTypenew.add(_classtypedata[i]["name"]);
        setState(() {});
      }
    }
  }
void getshadpre()async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
      roleid = preferences.getString('role');
      userid = preferences.getString('id');
 }

   Future<void> noticedata(String teacher,String class_id,String section_id) async {

   SharedPreferences preferences = await SharedPreferences.getInstance();
     roleid = preferences.getString('role');
       userid = preferences.getString('id');
    branch_id = preferences.getString('branch_id');

      if(roleid=='7'){
     class_id=widget.classid;
     section_id=widget.sectionid;
    
      }
      String apiUrl = AppString.constanturl + 'Gettimetable';
          final response = await http.post(
            Uri.parse(apiUrl),
            body: {
              "teacher": teacher != Null ? teacher : 'Select Teacher',
              "section_id": section_id != Null ? section_id : 'Select Section',
              "class_id": class_id != Null ? class_id : 'Select Class',
              "roleid": roleid != Null ? roleid : 'roleid',
              "branch_id":'$branch_id',

            },
          );
          
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<timetablelist> items = [];

      for (var item in jsonData) {
        items.add(timetablelist.fromJson(item));
      }

      setState(() {
        carouselItems = items;
      });
    } else {
      // Handle API error
    }
  }
 
 Widget buildDropdownContainer() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: WireframeColor.appcolor),
      borderRadius: BorderRadius.circular(20),
    ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded( // Ensure the DropdownSearch takes up available space
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
                        child: DropdownSearch<String>(
                          items: classTypenew,
                          onChanged: (String? value) {
                            if (value != null) {
                              int selectedIndex = classTypenew.indexOf(value);
                              selectedId = classTypeid[selectedIndex];
                              setState(() {
                                selectedValue = value;
                                selectedValueid = selectedId;
                              });
                            }
                          },
                          selectedItem: selectedValue ?? "Select Teacher",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              
              ],
            ),
          ),
          SizedBox(width: 20),
          Column(
            children: [
              InkWell(
                onTap: () {
                  noticedata(selectedValueid,"Select Class","Select Section");
                },
                child: Image.asset(
                  WireframePngimage.filter, // Replace with your image asset path
                  width: 40,
                  height: 40,
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
void dispose() {
  // Reset preferred orientations when the page is disposed
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
     var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    String roletype = '$roleid';
    
    final themedata = Get.put(WireframeThemecontroler());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
     return Scaffold(
      backgroundColor: WireframeColor.appcolor,
      appBar: AppBar(
        backgroundColor: WireframeColor.appcolor,
        leadingWidth: width, // or set to a specific value
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
                child: Icon(Icons.arrow_back_ios_new,
                    size: height / 36, color: WireframeColor.white),
              ),
              SizedBox(width: width / 36),
              Text(
                "Timetable",
                style: sansproRegular.copyWith(
                  fontSize: 18,
                  color: WireframeColor.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: height / 39,bottom: 5),
          child: Container(
            decoration:  BoxDecoration(
                color: themedata.isdark ? WireframeColor.black : WireframeColor.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),
                 bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20))
            ),
            child: Padding(
               padding: EdgeInsets.symmetric(horizontal: width / 26, vertical: height / 56),
              child: Column(
                children: [
                  roletype!='7'?
                        buildDropdownContainer():
                        SizedBox(height: 10,),
                          SizedBox(height: 10,),
                        carouselItems.length > 0
                            ? ListView.builder(
                                itemCount: carouselItems.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final timetablelist item = carouselItems[index];
                                  return timetableadapter(
                                    timetableimage: item.timetableimage,
                                  
                                  );
                                },
                              )
                            : Container( 
                              height: 300,
                              child:Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("No record found"),
                            ),
                          ),)
          

         


                ],
              ),
            ),
          ),
        ),
      ),
      
    );
  }
}