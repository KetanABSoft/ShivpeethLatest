import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/homework_adapter.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_add_homework.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class homeworkssearchlist {
  final String id;
  final String classnamedata;
  final String sectionname;
  final String subjectname;
  final String description;
 final String assignedate;
  final String submissiondate;
  final String creator_name;
  final String document;
  

  homeworkssearchlist(
      {required this.id,
      required this.classnamedata,
      required this.sectionname,
      required this.subjectname,
      required this.description,
      required this.assignedate,
      required this.submissiondate,
      required this.creator_name,
      required this.document,
 

      
      
      });

  factory homeworkssearchlist.fromJson(Map<String, dynamic> json) {
    return homeworkssearchlist(
      id: json['id'].toString(),
      classnamedata: json['classnamedata'].toString(),
      sectionname: json['sectionname'].toString(),
      subjectname: json['subject'].toString(),
      description: json['description'].toString(),
       assignedate: json['date_of_homework'].toString(),
      submissiondate: json['date_of_submission'].toString(),
      creator_name: json['creator_name'].toString(),
      document: json['document'].toString(),
    
    );
  }
}

class Wireframehomework extends StatefulWidget {
  
 final String classid;
  final String sectionid;
  const Wireframehomework({
     required this.classid,
     required this.sectionid,
    Key? key}) : super(key: key);

  @override
  State<Wireframehomework> createState() => _WireframeworkState();
}

class _WireframeworkState extends State<Wireframehomework> {
    List<homeworkssearchlist> carouselItems = [];
TextEditingController startdate =  TextEditingController();
TextEditingController studentfroamdate =  TextEditingController();

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
 String?session_id;
  String formattedDate = '';
 DateTime toDate = DateTime.now();
 DateTime studenttoDate = DateTime.now();
void getshadpre()async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
      roleid = preferences.getString('role');
      userid = preferences.getString('id');
 }
@override
void initState() {
  super.initState();
  getclassdata();
  getsectiondata(); 
 getshadpre();
 getdata();
 
 formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  startdate.text = formattedDate;
  studentfroamdate.text = formattedDate;
}
 
void getdata()async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
      roleid = preferences.getString('role');
      userid = preferences.getString('id');
      if(roleid == '7'){
        searchfilter("Select Class","Select Section",studenttoDate);
      }
      // if(roleid == '7'){
      //   searchfilter("Select Class","Select Section",studenttoDate);
      //   searchfilter("Select Class","Select Section",studenttoDate);
      // }
 }

 Future<void> searchfilter(
      selectedValue, selectedValue2,DateTime ? fromDatedate) async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     roleid = preferences.getString('role');
       userid = preferences.getString('id');
       branch_id = preferences.getString('branch_id');
       session_id = preferences.getString('session_id');
       String clas_iddd;
       String section_iddd;
      if(roleid=='7'){
      clas_iddd=widget.classid.toString();
      section_iddd=widget.sectionid.toString();
      }else{
        clas_iddd=selectedValue.toString();
      section_iddd=selectedValue2.toString();
      }
      print("selectedValue "+clas_iddd);
      print("selectedValue2 "+section_iddd);
     
    String apiUrl = AppString.constanturl + 'Fetchhomeworkdata_classwise';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "class_id": clas_iddd.toString() != null ? clas_iddd.toString() : 'Select Class',
        "section_id": section_iddd.toString() != null ? section_iddd.toString() : 'Select Section',
        "branch_id": branch_id != null ? branch_id.toString() : '',
        "session_id": session_id != null ? session_id.toString() : '',
        "fromDate":fromDatedate != null ? DateFormat('yyyy-MM-dd').format(fromDatedate) : '',

      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<homeworkssearchlist> items = [];

      for (var item in jsonData) {
        items.add(homeworkssearchlist.fromJson(item));
      }

      setState(() {
        carouselItems = items;
      });
    } else {
      // Handle API error
    }
  }
 Future<void> getclassdata() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
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
   // final response = await http.get(Uri.parse(AppString.constanturl + 'fetchsection'));
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

   Widget studentsearch() {
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
               

                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded( // Ensure the DropdownSearch takes up available space
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
                        child:TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.date_range),
                            labelText: 'Date',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          controller: studentfroamdate,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:studenttoDate,
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              studenttoDate = pickedDate;
                              studentfroamdate.text = DateFormat('dd-MM-yyyy')
                                                  .format(studenttoDate);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(width: 20),
          Column(
            children: [
              InkWell(
                onTap: () {
                  searchfilter("Select Class","Select Section",studenttoDate);
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

                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded( // Ensure the DropdownSearch takes up available space
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
                        child:TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.date_range),
                            labelText: 'Date',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          controller: startdate,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:toDate,
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              toDate = pickedDate;
                              startdate.text = DateFormat('dd-MM-yyyy')
                                                  .format(toDate);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(width: 20),
          Column(
            children: [
              InkWell(
                onTap: () {
                  searchfilter(selectedValueid,selectedValuesectionid,toDate);
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
              Text("Homework",style: sansproRegular.copyWith(fontSize: 18,color: WireframeColor.white,),),

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
                       roletype=='7'?
                        studentsearch():
                      buildDropdownContainer(),
                        SizedBox(height: 10,),
                         roletype=='3'?
                          Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                     ""
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return  addhomework(task:"Add",id:"");
                            },
                          ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Button color
                      ),
                      child: Row(
                        children: [
                           Icon(
                                  Icons.note_add,
                                  color: Colors.white,
                              size: height / 30,
                                ),
                          SizedBox(width: 8), // Adjust the spacing between icon and text
                          Text('Add',
                          style: TextStyle(color:Colors.white),),
                        ],
                      ),
                    ),
                  ],
                ): SizedBox(height: 10,),


                 SizedBox(height: 10,),
                        carouselItems.length > 0
                            ? ListView.builder(
                                itemCount: carouselItems.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final homeworkssearchlist item = carouselItems[index];
                                  return Commonhomeworklist(
                                    subjecttitle: item.subjectname,
                                    description: item.description,
                                    homeassignedate: item.assignedate,
                                    homesubmissiondate: item.submissiondate,
                                     creator_name: item.creator_name,
                                    opacity: 1,
                                    isLast: index == carouselItems.length - 1,
                                    document:item.document
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
