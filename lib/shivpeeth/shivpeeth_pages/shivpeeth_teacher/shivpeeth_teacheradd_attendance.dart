import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_teacherdashboard.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController startdate =  TextEditingController();

class studentattenddatalist {

  final String studentname;
  final String roll;
  final String enroll_id;
  final String student_id;
  final String register_no;
  final String att_id;
  final String att_status;
  final String att_remark;
  

  studentattenddatalist(
      {
      required this.studentname,
      required this.roll,
      required this.enroll_id,
      required this.student_id,
      required this.register_no,
      required this.att_id,
      required this.att_status,
      required this.att_remark,
     

      
      
      });

  factory studentattenddatalist.fromJson(Map<String, dynamic> json) {
    return studentattenddatalist(
     
      studentname: json['studentname'],
      roll: json['roll'],
      enroll_id: json['enroll_id'],
      student_id: json['student_id'],
      register_no: json['register_no'],
      att_id: json['att_id'],
      att_status: json['att_status'],
      att_remark: json['att_remark'],
    
    );
  }
}
class teadd_attendance extends StatefulWidget {
  final String class_id;
  final String section_id;
  final String attendecnt;
  const teadd_attendance({
    required this.class_id,
    required this.section_id,
    required this.attendecnt,
    super.key});

  @override
  State<teadd_attendance> createState() => teadd_attendanceState();
}

class teadd_attendanceState extends State<teadd_attendance> {
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
   List<studentattenddatalist> carouselItems = [];
  String selectedStatus = 'P'; // Default to 'Present'
List<Map<String, dynamic>> attendanceData = [];
 // Create a Map to store the status of each student
  Map<String, String> studentStatusMap = {};
  // Create a Map to store the remark of each student
  Map<String, String> studentRemarkMap = {};
List<Map<String, dynamic>> attendencelist = []; // Replace with the actual type of your data
  String formattedDate = '';
 String?roleid;
 String?userid;
 String?branch_id;
@override
void initState() {
  super.initState();
  formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  startdate.text = formattedDate;

  WidgetsBinding.instance.addPostFrameCallback((_) {
   // getclassdata();
    //getsectiondata();
    print(widget.class_id);
    print(widget.section_id);
    getshadprefernce();
    Getattendencedata("Select Class", "Select Section", DateTime.now());
  });
}
  void getshadprefernce() async{
         SharedPreferences preferences = await SharedPreferences.getInstance();
        roleid = preferences.getString('role');
        userid = preferences.getString('id');
        branch_id = preferences.getString('branch_id');          
  }


Future<void> getclassdata() async {
    final response = await http.get(Uri.parse(AppString.constanturl + 'fecthclassname'));
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
    final response = await http.get(Uri.parse(AppString.constanturl + 'fetchsection'));
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
  
 Future<void> Getattendencedata(class_id, section_id, startdate) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  branch_id = preferences.getString('branch_id');  
  try {
     DateTime date;


    if (startdate != null) {
      // Provide a custom format string based on your date format
      final format = DateFormat('dd-MM-yyyy');
      date = format.parse(startdate.toString());
      print('Parsed date: $date');
    } else {
      print('Start date is null');
      return;
    }

   print(class_id);
   print(section_id);
   print(DateFormat('dd-MM-yyyy').format(date));
  

    String apiUrl = AppString.constanturl + 'Get_student_attlist';
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'class_id': class_id != null ? class_id.toString() : "Select Class",
        'section_id': section_id != null ? section_id.toString() : "Select Section",
        'date': date != null ? DateFormat('yyyy-MM-dd').format(date) : null,
        'branch_id': branch_id != null ? branch_id.toString() : null,

      },
    );
   
   if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<studentattenddatalist> items = [];
      print(jsonData);
      for (var item in jsonData) {
        items.add(studentattenddatalist.fromJson(item));
      }

      setState(() {
        carouselItems = items;
        studentStatusMap = {};
        studentRemarkMap = {};
        
      });
    } else {
      // Handle API error
    }
   
    
  } catch (e) {
    print('Error parsing date: $e');
    // Handle the error or throw it again if needed
    throw e;
  }
}
  

  
Future savedata(List<Map<String, dynamic>> attendanceList) async {
  var urlString = AppString.constanturl + 'Save_Attendance';
  Uri uri = Uri.parse(urlString);
  print("attendence "+json.encode(attendanceList));
  var response = await http.post(uri, body: {
    "attendance": json.encode(attendanceList), // Convert List to JSON string
  });

  final jsondata = json.decode(response.body);
 // print(jsondata);

  if (jsondata['result'] == "failed") {
    Fluttertoast.showToast(
      backgroundColor: Color.fromARGB(255, 255, 94, 0),
      textColor: Colors.white,
      msg: jsondata['message'],
      toastLength: Toast.LENGTH_SHORT,
    );
  } else if (jsondata['result'] == "success") {
    Fluttertoast.showToast(
      backgroundColor: Colors.green,
      textColor: Colors.white,
      msg: jsondata['message'],
      toastLength: Toast.LENGTH_SHORT,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return const teacherdashboard();
      }),
    );
  }
}
  Widget buildDropdownContainer() {
  return Container(
    constraints: BoxConstraints(
      minWidth: 0,
      minHeight: 0,
    ),
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Expanded(
                //       child: Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(17.0),
                //         ),
                //         child: DropdownSearch<String>(
                //           items: classTypenew,
                //           onChanged: (String? value) {
                //             if (value != null) {
                //               int selectedIndex = classTypenew.indexOf(value);
                //               selectedId = classTypeid[selectedIndex];
                //               setState(() {
                //                 selectedValue = value;
                //                 selectedValueid = selectedId;
                //               });
                //             }
                //           },
                //           selectedItem: selectedValue ?? "Select Class",
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Expanded(
                //       child: Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(17.0),
                //         ),
                //         child: DropdownSearch<String>(
                //           items: sectiontypename,
                //           onChanged: (String? value) {
                //             if (value != null) {
                //               int selectedIndex = sectiontypename.indexOf(value);
                //               selectedIdsection = sectiontypeid[selectedIndex];
                //               setState(() {
                //                 selectedValuesection = value;
                //                 selectedValuesectionid = selectedIdsection;
                //               });
                //             }
                //           },
                //           selectedItem: selectedValuesection ?? "Select Section",
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                
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
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                              startdate.text = formattedDate;
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
                  // Add your logic for the filter action
                  // searchfilter(selectedValueid, selectedValuesectionid);
                  
                    if (widget.class_id == Null || widget.class_id.toString().isEmpty ||
      widget.section_id == Null || widget.section_id.toString().isEmpty) {
    // Show toast message
             
                    Fluttertoast.showToast(
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      msg: "You are not a class teacher, so attendance cannot be added",
                      toastLength: Toast.LENGTH_SHORT,
                    );
                 } else {
              Getattendencedata(widget.class_id.toString(), widget.section_id.toString(), startdate.text);
               }
                   
                },
                child: Image.asset(
                  WireframePngimage.filter,
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

 Widget buildRadio(String value, String label, String studentStatus, String attId,String attendance) {
  print(studentStatus);
    return Row(
      children: [
        Radio(
          value: value,
         
         //studentStatus.isNotEmpty == true ? studentStatus : 'P'
          // groupValue: studentStatusMap[attId] ?? 'P', // Use individual status
         // groupValue: attId != 0 ? studentStatusMap[attId] : 'P',
          //first time without click present 'p lagte ti backendne keli ahe 
                      // if($attendanceItem['status']=="0"){
											//	$attendanceItem['status']="P";
										//	}'


        groupValue: attendance != "0" ? studentStatusMap[attId] ?? studentStatus : studentStatusMap[attId] ??'P',
        //groupValue: attendance != "0" ? studentStatusMap[attId] ?? studentStatus : 'P',
  
          onChanged: (String? value) {
            setState(() {
              print(value);
              studentStatusMap[attId] = value ?? 'P';
            });
          },

         
        ),
        Text(label),
      ],
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
                    "Attendance",
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
                                'No.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Roll',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Register No ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Status ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                             DataColumn(
                              label: Text(
                                'Remark ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: carouselItems.map((student) {
                          print(student.att_status);
                            return DataRow(
                              // key: UniqueKey(),
                              cells: [
                            
                                DataCell(Text((carouselItems.indexOf(student) + 1).toString())),
                                DataCell(Text(student.studentname)),
                                DataCell(Text(student.roll)),
                                DataCell(Text(student.register_no)),
                                // DataCell(Text(student.att_status)),
                                // DataCell(Text(student.att_remark)),
                                 DataCell(
                                  Row(
                                    
                                    children: [
                                      
                                      if (student.att_id != Null)
                                      
                                        buildRadio('P', 'Present', student.att_status,student.roll,student.att_id),
                                        buildRadio('A', 'Absent', student.att_status, student.roll,student.att_id),
                                        buildRadio('L', 'Late', student.att_status, student.roll,student.att_id),
                                        buildRadio('HD', 'Half Day', student.att_status, student.roll,student.att_id),
                                    ],
                                  ),
                                ),
                                DataCell(
                                TextFormField(
                                 
                                  decoration: InputDecoration(
                                   // hintText: 'Remarks',
                                  ),
                                  //initialValue: studentRemarkMap[student.roll] ?? student.att_remark,
                                 //initialValue:  student.att_id != "0" ? studentRemarkMap[student.roll] ?? student.att_remark : studentRemarkMap[student.roll] ??'',
                                  // onChanged: (value) {
                                  //   setState(() {
                                  //     studentRemarkMap[student.roll] = value;
                                  //   });
                                  // },
                              initialValue: studentRemarkMap[student.roll] ?? student.att_remark,
                                  onChanged: (value) {
                                  print('Value changed: $value');
                                  setState(() {
                                    studentRemarkMap[student.roll] = value;
                                    print('studentRemarkMap updated: $studentRemarkMap');
                                  });
                                },
                                                                ),
                              )

                              
                              ],
                            );
                          }).toList(),
                        ),
                ),
              ),
            ),
              SizedBox(height: 10,),
              Divider(height: 1,
              color: WireframeColor.textgrayline,),
              SizedBox(height: 10,),
            if(widget.attendecnt=='0') Center(
          child: ElevatedButton(
            onPressed: () {
              // Add your button click logic here
             
             attendanceData = carouselItems.map((student) {
               print(studentStatusMap[student.roll] );
                return {
                  'attendance_id': student.att_id,
                  'enroll_id': student.enroll_id,
                  'student_id': student.student_id,
                  'status': studentStatusMap[student.roll] ?? student.att_status,
                  //'status': student.att_status != "0" ? studentStatusMap[student.roll] ?? student.att_status : 'P',
                  'remark': studentRemarkMap[student.roll] ?? student.att_remark,
                  'date':startdate.text,
                  'branch_id':branch_id.toString(),
                };
              }).toList();
              // print(attendanceData);
               savedata(attendanceData);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WireframeColor.appcolor, // Background color
              foregroundColor: Colors.white, // Text color
              fixedSize: Size(200.0, 50.0), // Width and height
            ),
            child: Text('Submit', style: TextStyle(fontSize: 18.0)),
          ),
        ) else SizedBox(height: 10,)
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

