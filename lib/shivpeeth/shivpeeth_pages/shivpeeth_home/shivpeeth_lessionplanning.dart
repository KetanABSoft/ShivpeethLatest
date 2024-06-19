import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/lesson_adpter.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class lessonlist {
  final String id;
  final String subjectname;
  final String date;
  final String time;
  final String description;
 final String days;
  final String month;
  final String datename;
  

  lessonlist(
      {required this.id,
      required this.subjectname,
      required this.date,
      required this.time,
      required this.description,
      required this.days,
      required this.month,
      required this.datename,
 

      
      
      });

  factory lessonlist.fromJson(Map<String, dynamic> json) {
    return lessonlist(
      id: json['id'],
      subjectname: json['subjectname'].toString(),
      date: json['date'].toString(),
      time: json['time'].toString(),
       description: json['description'].toString(),
      days: json['days'].toString(),
      month: json['month'].toString(),
      datename: json['datename'].toString(),
    
    );
  }
}
class lessionplan extends StatefulWidget {
 final String classid;
 final String sectionid;
  const lessionplan({
   required this.classid,
   required this.sectionid,
    super.key});

  @override
  State<lessionplan> createState() => lessionplanState();
}

class lessionplanState extends State<lessionplan> {
      List<lessonlist> carouselItems = [];

  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  var _classtypedata;
  List<String> classTypenew = [];
  List<String> classTypeid = [];
    String? selectedId;
 var selectedValue;
 var selectedValueid;

  var sectiontypedata;
  List<String> sectiontypename = [];
  List<String> sectiontypeid = [];
    String? selectedIdsection;
 var selectedValuesection;
 var selectedValuesectionid;
 String?roleid;
 String?userid;
 String?branch_id;

@override
void initState() {
  super.initState();
  getclassdata();
  getsectiondata(); 
  searchfilter("Select Class","Select Section");
}

  void getshadpre()async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
      roleid = preferences.getString('role');
      userid = preferences.getString('id');
 }
 Future<void> getclassdata() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
    roleid = preferences.getString('role');

    print(branch_id);
   var urlString = AppString.constanturl + 'fecthclassname';
    Uri uri = Uri.parse(urlString);
     var response = await http.post(uri, body: {
      "branch_id":'$branch_id',
    });
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      _classtypedata = jsonData;
      //print(_classtypedata);
      for (int i = 0; i < _classtypedata.length; i++) {
        classTypeid.add(_classtypedata[i]["id"]);
        classTypenew.add(_classtypedata[i]["classname"]);
        setState(() {});
      }
    }
  }

  Future<void> getsectiondata() async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
    var urlString = AppString.constanturl + 'fetchsection';
    Uri uri = Uri.parse(urlString);
     var response = await http.post(uri, body: {
      "branch_id":'$branch_id',
    });
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      sectiontypedata = jsonData;
     // print(sectiontypedata);
      for (int i = 0; i < sectiontypedata.length; i++) {
        sectiontypeid.add(sectiontypedata[i]["id"]);
        sectiontypename.add(sectiontypedata[i]["name"]);
        setState(() {});
      }
    }
  }  
  
 Future<void> searchfilter(
      selectedValue, selectedValue2) async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     roleid = preferences.getString('role');
       userid = preferences.getString('id');
       branch_id = preferences.getString('branch_id');
       String clas_iddd;
       String section_iddd;
     if(roleid=='7'){
      clas_iddd=widget.classid.toString();
      section_iddd=widget.sectionid.toString();
      }else{
        clas_iddd=selectedValue.toString();
      section_iddd=selectedValue2.toString();
      }
    String apiUrl = AppString.constanturl + 'Get_Lesson_Planning';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "class_id": clas_iddd.toString() != null ? clas_iddd.toString() : 'Select Class',
        "section_id": section_iddd.toString() != null ? section_iddd.toString() : 'Select Section',
        "branch_id": branch_id != null ? branch_id : '',

      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<lessonlist> items = [];

      for (var item in jsonData) {
        items.add(lessonlist.fromJson(item));
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
                          selectedItem: selectedValue ?? "Select Class",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded( // Ensure the DropdownSearch takes up available space
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
                        child: DropdownSearch<String>(
                          items: sectiontypename,
                          onChanged: (String? value) {
                            if (value != null) {
                              int selectedIndex = sectiontypename.indexOf(value);
                              selectedIdsection = sectiontypeid[selectedIndex];
                              setState(() {
                                selectedValuesection = value;
                                selectedValuesectionid = selectedIdsection;
                              });
                            }
                          },
                          selectedItem: selectedValuesection ?? "Select Section",
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
                onTap: () {
                  searchfilter(selectedValueid,selectedValuesectionid);
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
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    String roletype = '$roleid';

    return Scaffold(
      backgroundColor: WireframeColor.appcolor,
      appBar: AppBar(
        leadingWidth:width/1 ,
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
                  child: Icon(Icons.arrow_back_ios_new,size: height/36,color: WireframeColor.white,)),
              SizedBox(width: width/36,),
              Text("Lesson Planning",style: sansproRegular.copyWith(fontSize: 18,color: WireframeColor.white,),),

            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: height / 36,bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: themedata.isdark ? WireframeColor.black : WireframeColor.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                       bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 26, vertical: height / 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       if(roletype!='7')
                        buildDropdownContainer()else
                        SizedBox(height: 10,),
                         SizedBox(height: 20,),
                        carouselItems.length > 0
                            ? ListView.builder(
                                itemCount: carouselItems.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final lessonlist item = carouselItems[index];
                                  return lessonadapter(
                                    subjectname: item.subjectname,
                                    datename: item.datename,
                                    time: item.time,
                                    description: item.description,
                                     days: item.days,
                                    month: item.month,
                                    
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
            )
            , 
    );
  }
}