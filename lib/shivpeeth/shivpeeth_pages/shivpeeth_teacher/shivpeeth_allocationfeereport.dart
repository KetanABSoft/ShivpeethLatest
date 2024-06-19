import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_fullstudentfeedatashow.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class allocationlist {
  final String id;
  final String name;
  final String clname;
  final String totalamount;
  final String Dueamount;
  final String totalpaid;
  final String division;
  final String mobileno;
  final String status;
  final String Discount;
  

  allocationlist(
      {required this.id,
      required this.name,
      required this.clname,
      required this.totalamount,
      required this.Dueamount,
      required this.totalpaid,
      required this.division,
      required this.mobileno,
      required this.status,
      required this.Discount,
     

      
      
      });

  factory allocationlist.fromJson(Map<String, dynamic> json) {
    return allocationlist(
      id: json['student_id'].toString(),
      name: json['name'].toString(),
      clname: json['classname'].toString(),
      mobileno: json['mobileno'].toString(),
      totalamount: json['totalamount'].toString(),
      Dueamount: json['Dueamount'].toString(),
      totalpaid: json['totalpaid'].toString(),
      division: json['division'].toString(),
      status: json['status'].toString(),
      Discount: json['Discount'].toString(),
    
    );
  }
}
class teacherfeestudentfeereport extends StatefulWidget {
  final String classid;
  final String sectionid;
  const teacherfeestudentfeereport({
    required this.classid,
    required this.sectionid,
    super.key});

  @override
  State<teacherfeestudentfeereport> createState() => classteacherstate();
}

class classteacherstate extends State<teacherfeestudentfeereport> {
  double height = 0.00;
  double width = 0.00;
 List<allocationlist> carouselItems = [];
 List<allocationlist> getitem = [];
   List<allocationlist> filteredList = [];
String?roleid;
 String?userid;
 String?branch_id;
 String?session_id;

    @override
  void initState() {
    super.initState();
    getshadvalue();
    
    fetchfee();
  }

    void getshadvalue()async {
       SharedPreferences preferences = await SharedPreferences.getInstance();
     roleid = preferences.getString('role');
       userid = preferences.getString('id');
    }
  

  Future<void> fetchfee() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
     roleid = preferences.getString('role');
       userid = preferences.getString('id');
       branch_id = preferences.getString('branch_id');
       session_id = preferences.getString('session_id');
         print("Class "+widget.classid);
         print("Section "+widget.sectionid);
         print(branch_id);
     String apiUrl = AppString.constanturl + 'SF_reportclassteacherwise';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "class_id": widget.classid != Null ?  widget.classid  : 'Select Class',
        "section_id":  widget.sectionid != Null ? widget.sectionid  : 'Select Section',
        "teacher_id":  userid != Null ? userid  : 'Select Teacher',
        "branch_id":  branch_id != Null ? branch_id  : '',
        "session_id":  session_id != Null ? session_id  : '',

      },
    );
   
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<allocationlist> items = [];
      print(jsonData);
      for (var item in jsonData) {
        items.add(allocationlist.fromJson(item));
      }

      setState(() {
        carouselItems = items;
        getitem = items;
      });
    } else {
      // Handle API error
    }
  }
  
void openUrl() async {
    String classid=widget.classid;
    String  Sectionid=widget.sectionid;
  if (classid == Null || classid.isEmpty) {
     classid = "Select Class";
  }
  if (Sectionid == Null || Sectionid.isEmpty) {
      Sectionid = "Select Section";
  }
  if (userid == Null ) {
      userid = "Select Teacher";
  }
      SharedPreferences preferences = await SharedPreferences.getInstance();
       branch_id = preferences.getString('branch_id');
       session_id = preferences.getString('session_id');

String appUrlNew = AppString.loginurl.replaceAll("https", "http") +
    'exporttoecel_classteacherfeeview.php?class_id=$classid&section_id=$Sectionid&teacher_id=$userid&branch_id=$branch_id&session_id=$session_id';

  print(appUrlNew);
   try {
      await launch(appUrlNew);
    } catch (e) {
      print('Error launching URL: $e');
    }
}
  


void filterItems(String query) {
 
  if (query.isNotEmpty || query==Null) {
    filteredList = carouselItems.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.clname.toLowerCase().contains(query.toLowerCase());
    }).toList();
  } else {
   
    filteredList = List.from(getitem);
  
  }

  // setState(() {
  //   carouselItems = filteredList;
  // });
   setState(() {
    carouselItems = List.from(filteredList.isEmpty ? carouselItems : filteredList);
  });
}
 @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  final themedata = Get.put(WireframeThemecontroler());

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
                "Fees Report",
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
          padding: EdgeInsets.only(top: height / 36,bottom: 5),
          child: Container(
            decoration:  BoxDecoration(
                color: themedata.isdark ? WireframeColor.black : WireframeColor.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width / 26,
                vertical: height / 36,
              ),
              child: Column(
                children: [
                 Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     SizedBox(width: 10),
                    Expanded( // Ensure the DropdownSearch takes up available space
              child:  Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0), // Add horizontal margin
              height: 50.0, // Set the height of the TextField
              //width: 350.0, // Set the width of the TextField
              child: TextField(
                onChanged: (value) {
                  // Call a method to filter the items based on the input value
                  filterItems(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.grey, // Set border color to gray
                    ),
                  ),
                ),
                style: TextStyle(
                  // Set text field text color
                  color: Colors.black,
                ),
              ),
            ),
                    ),
                  ],
                ),
              
              ],
            ),
          ),
          SizedBox(width: 10),
            Column(
            children: [
              InkWell(
                onTap: () {
                openUrl();
                },
                child: Image.asset(
                  WireframePngimage.excel, // Replace with your image asset path
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
           SizedBox(width: 5),
          
        ],
      ),
               SizedBox(height: 10),
       ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: carouselItems.isEmpty
                      ? Center(
                          child: Text(
                            'No record found',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) => WireframeColor.listbackgroundcolor,
                          ),
                          dataRowHeight: 60.0,
                          columns: [
                            
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Class',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Div ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Total Amount ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                'Paid Amount ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                             DataColumn(
                              label: Text(
                                'Discount Amount ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Due Amount ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: carouselItems.map((student) {
                            return DataRow(
                              cells: [
                               
                            
                                DataCell(
                                 // Text(student.name)
                                 GestureDetector(
                                onTap: () {
                                  // Handle click event here
                                 // print('Clicked on ${student.name}');
                                  Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return studentfeereportteshow(studentid:student.id);

                                  },
                                ));
                                },
                                child: Text(student.name, style: TextStyle(
                                    //fontSize: 15.0, 
                                    fontWeight: FontWeight.bold,
                                    color: WireframeColor.appcolor, 
                                  ),),
                              ),
                                  ),
                                DataCell(Text(student.clname)),
                                DataCell(Text(student.division)),
                                DataCell(Text(student.totalamount)),
                                DataCell(Text(student.totalpaid)),
                                DataCell(Text(student.Discount)),
                                DataCell(Text(student.Dueamount)),
                                 DataCell(
                              Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: () {
                                    if (student.Dueamount == "0") {
                                      return WireframeColor.green;
                                    } else if (student.Dueamount == "0" && student.totalpaid == "0") {
                                      return WireframeColor.red; // Change this to the color you want for unpaid
                                    } else {
                                      return WireframeColor.bootomcolor;
                                    }
                                  }(),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    () {
                                      if (student.Dueamount == "0") {
                                        return "Paid";
                                      } else if (student.Dueamount == "0" && student.totalpaid == "0") {
                                        return "Pending";
                                      } else {
                                        return "Pending";
                                      }
                                    }(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                                
                              ],
                            );
                          }).toList(),
                        ),
                ),
              ),
            )
            ,
    //))

         


                ],
              ),
            ),
          ),
        ),
      ),
      
    );
  }
}