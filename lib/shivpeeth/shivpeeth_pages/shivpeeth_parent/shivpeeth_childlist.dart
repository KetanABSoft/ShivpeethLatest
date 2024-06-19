import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/child_adapter.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class childlist {
  final String id;
  final String user_id;
  final String name;
  final String classname;
  final String divsion;
  final String rollno;
  final String birthdate;
  final String photo;
  final String sessionid;
  final String branchid;
  final String role;
  final String childcount;
 
  

  childlist(
      {required this.id,
      required this.user_id,
      required this.name,
      required this.rollno,
      required this.classname,
      required this.divsion,
      required this.birthdate,
      required this.photo,
      required this.sessionid,
      required this.branchid,
      required this.role,
      required this.childcount,

 

      
      
      });

  factory childlist.fromJson(Map<String, dynamic> json) {
    return childlist(
      id: json['id'].toString(),
      user_id: json['user_id'].toString(),
      name: json['name'].toString(),
      rollno: json['roll'].toString(),
      classname: json['class_name'].toString(),
      divsion: json['section_name'].toString(),
      birthdate: json['birthday'].toString(),
      photo: json['photo'].toString(),
      sessionid: json['session_id'].toString(),
      branchid: json['branch_id'].toString(),
      role: json['role'].toString(),
      childcount: json['childcount'].toString(),
      
    
    );
  }
}
class childpraentlist extends StatefulWidget {
  const childpraentlist({super.key});

  @override
  State<childpraentlist> createState() => childpraentlistState();
}
const double widthnew = 50.0;
const double heightnew = 60.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Colors.white;
class childpraentlistState extends State<childpraentlist> {
 dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
   List<childlist> carouselItems = [];

  late double xAlign;
  late Color loginColor;
 late  Color signInColor;
   String? branch_id;
   String? id;
   String? session_id;
@override
void initState() {
  super.initState();
   xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
 fetchstuentlist();
}


  
Future<void> fetchstuentlist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
     id = preferences.getString('id');
     session_id = preferences.getString('session_id');
     branch_id = preferences.getString('branch_id');
 String apiUrl = AppString.constanturl + 'Fetch_childlistwithdata_parent';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "id": id != null ? id : '',
        "branch_id": branch_id != null ? branch_id : '',
        "session_id": session_id != null ? session_id : '',
       

      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<childlist> items = [];
      print(jsonData);
      for (var item in jsonData) {
        items.add(childlist.fromJson(item));
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
                    "Change Children",
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
                       
                        carouselItems.length > 0
                            ?
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: carouselItems.length,
                  itemBuilder: (context, index) {
                    final childlist item = carouselItems[index];
                                  return childcommonlist(
                                    name: item.name,
                                    classname: item.classname,
                                    divsion: item.divsion,
                                    rollno: item.rollno,
                                    birthdate: item.birthdate,
                                    photo: item.photo,
                                    role :item.role,
                                    sessionid :item.sessionid,
                                    branchid :item.branchid,
                                    id :item.id,
                                    user_id :item.user_id,
                                    childcount :item.childcount,
                                    opacity: 1,
                                    isLast: index == carouselItems.length - 1,
                                  );
                  },
                ): Container( 
                              height: 300,
                              child:Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("No record found"),
                            ),
                          ),),
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