import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/homework_list_adpter.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


class homeworkssearchlistteacher {
  final String id;
  final String classnamedata;
  final String sectionname;
  final String subjectname;
  final String description;
 final String assignedate;
  final String submissiondate;
  final String creator_name;
  final String document;
  

  homeworkssearchlistteacher(
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

  factory homeworkssearchlistteacher.fromJson(Map<String, dynamic> json) {
    return homeworkssearchlistteacher(
      id: json['id'],
      classnamedata: json['classnamedata'],
      sectionname: json['sectionname'],
      subjectname: json['subject'],
      description: json['description'],
       assignedate: json['date_of_homework'],
      submissiondate: json['date_of_submission'],
      creator_name: json['creator_name'],
      document: json['document'],
    
    );
  }
}

class Wireteacherhomeworklist extends StatefulWidget {
  
 
  const Wireteacherhomeworklist({
    
    Key? key}) : super(key: key);

  @override
  State<Wireteacherhomeworklist> createState() => _WireframeworkState();
}

class _WireframeworkState extends State<Wireteacherhomeworklist> {
    List<homeworkssearchlistteacher> carouselItems = [];

  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());

 String?roleid;
 String?userid;
 String?branch_id;
 String?session_id;

void getshadpre()async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
      roleid = preferences.getString('role');
      userid = preferences.getString('id');
 }
@override
void initState() {
  super.initState();
   searchfilter();
 getshadpre();

}
 


 Future<void> searchfilter(
      ) async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     roleid = preferences.getString('role');
       userid = preferences.getString('user_id');
       branch_id = preferences.getString('branch_id');
       session_id = preferences.getString('session_id');
      
    String apiUrl = AppString.constanturl + 'Fetchhomeworkdata_teacheradded';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "branch_id": branch_id != null ? branch_id.toString() : '',
        "userid": userid != null ? userid.toString() : '',
        "session_id": session_id != null ? session_id.toString() : '',

      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<homeworkssearchlistteacher> items = [];

      for (var item in jsonData) {
        items.add(homeworkssearchlistteacher.fromJson(item));
      }

      setState(() {
        carouselItems = items;
      });
    } else {
      // Handle API error
    }
  }





 
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

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
              Text("Homework List",style: sansproRegular.copyWith(fontSize: 18,color: WireframeColor.white,),),

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
                      
                       

                 SizedBox(height: 10,),
                        carouselItems.length > 0
                            ? ListView.builder(
                                itemCount: carouselItems.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final homeworkssearchlistteacher item = carouselItems[index];
                                  return adapterhomeworklist(
                                    id: item.id,
                                    subjecttitle: item.subjectname,
                                    description: item.description,
                                    homeassignedate: item.assignedate,
                                    homesubmissiondate: item.submissiondate,
                                     creator_name: item.creator_name,
                                    opacity: 1,
                                    isLast: index == carouselItems.length - 1,
                                      document: item.document,
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
