import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_studentattendencereport.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_teacheradd_attendance.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wireframeattendance extends StatefulWidget {
  final String classid;
  final String sectionid;
  final String attendecnt;
  const Wireframeattendance({
    required this.classid,
    required this.sectionid,
    required this.attendecnt,
    Key? key}) : super(key: key);

  @override
  State<Wireframeattendance> createState() => _WireframeattaendanceState();
}

class _WireframeattaendanceState extends State<Wireframeattendance> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
 List<DateTime> startDates = [];
  DateTime? _selectedDay;
  String? selectdate;
  var selectdatedate=DateTime.now();
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
 String? Presenty='0';
 String? Absenty='0';
 String? total='0';
 String?roleid;
 String?userid;
 String?branch_id;

 
@override
void initState() {
  super.initState();
  
  getshadpre();
  getclassdata();
  getsectiondata();
 
 
}



 void getshadpre()async {
   print("count: "+widget.classid+"  "+widget.sectionid);
   SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
     roleid = preferences.getString('role');
    
        if(roleid == '3'){
          if((widget.classid.toString()=="null" && widget.sectionid.toString() =="null")){
            Getattendencedata("Select Class","Select Section",DateTime.now());
          
          }else{

            Getattendencedata(widget.classid.toString(),widget.sectionid,DateTime.now());
          }
          
        }
      userid = preferences.getString('id');
       branch_id = preferences.getString('branch_id');
   });
      
 }

Future<void> getclassdata() async {
   
   SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
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

 Getattendencedata(class_id, section_id, startdate) async {
  print("rolwid:${roleid}");

  SharedPreferences preferences = await SharedPreferences.getInstance();
  roleid = preferences.getString('role');
  userid = preferences.getString('id');
  branch_id = preferences.getString('branch_id');

  if (roleid == '7') {
    class_id = widget.classid;
    section_id = widget.sectionid;
  }else if(roleid == '3' && (widget.classid!='null' && widget.sectionid!='null' )){
    
      class_id = widget.classid;
      section_id = widget.sectionid;  
  }
  
   try {
   
    DateTime date;
    if (startdate != null) {
      date = DateTime.parse(startdate.toString());
      print('Parsed date: $date');
    } else {
      print('Start date is null');
      // Handle the case when startdate is null
      return;
    }
 
  
 
    String apiUrl = AppString.constanturl + 'Get_Attendenancecount';
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'class_id': class_id != null ? class_id.toString() : "Select Class",
        'section_id': section_id != null ? section_id.toString() : "Select Section",
        'date': date != null ? date.toUtc().toIso8601String() : null,
        'branch_id': branch_id != null ? branch_id.toString() : null,
        'userid': userid != null ? userid.toString() : null,
        'roleid': roleid != null ? roleid.toString() : null,
      },
    );

    var jsondata = jsonDecode(response.body);
    setState(() {
      Presenty = jsondata['Presenty'].toString();
      Absenty = jsondata['Absenty'].toString();
      total = jsondata['totalpresent'].toString();
      print(Presenty);
      print(Absenty);
    });

    // print(Presenty);
    // print(Absenty);
  } catch (e) {
    print('Error parsing date: $e');
    // Handle the error or throw it again if needed
    throw e;
  }
}




Widget buildDropdpresenty() {
 return GestureDetector(
  onTap: () {
   
       Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return  teadd_attendance(class_id:widget.classid.toString(),section_id:widget.sectionid.toString(),attendecnt:widget.attendecnt.toString());
                            },
                          ));         
              
  },
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(color: WireframeColor.textgrayline),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width / 36,
        vertical: height / 66,
      ),
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Image.asset(
                  WireframePngimage.attendanceicon,
                  height: 30,
                  width: 30,
                ),
              ),
              SizedBox(width: 10),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  "Add Student Attendance",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(width: 10),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.arrow_forward_sharp,
                  size: height / 36,
                  color: WireframeColor.textgray,
                ),
              )
            ],
          ),
        ],
      ),
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
                                getsectiondata();
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
                 // searchfilter(selectedValueid,selectedValuesectionid);
              
                 Getattendencedata(selectedValueid,selectedValuesectionid,selectdate);
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
    String roletype = '$roleid';
    print(widget.classid.toString());
    print(widget.sectionid.toString());
    print("roledata"+roletype);
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
                  )),
              SizedBox(
                width: width / 36,
              ),
              Text(
                "Student Attendance",
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
        child: Padding(
          padding: EdgeInsets.only(top: height / 36,bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                color: themedata.isdark ? WireframeColor.black : WireframeColor.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                     bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20))),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 26, vertical: height / 56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
             

                     if (roletype == "3")
                        if (widget.classid != 'Select Class' && widget.sectionid != 'Select Section')
                          Container()
                        else
                          buildDropdownContainer()
                      else if (roletype == "7")
                        Container()
                      else
                        buildDropdownContainer(),
                      SizedBox(height: 10),
                   
         

                        if(roletype == '3')
                    if (widget.classid != 'Select Class' && widget.sectionid != 'Select Section')
                          buildDropdpresenty()
                        else
                         SizedBox(height: 10)
                        else
                          SizedBox(height: 10),
               
                  
                     TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1), // Adjust the start date as needed
                    focusedDay: selectdatedate,
                    lastDay: DateTime.utc(2050, 3, 14),
                    headerVisible: true,
                    daysOfWeekVisible: true,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                          color: WireframeColor.green,
                           shape: BoxShape.rectangle, // Specify the shape
                          borderRadius: BorderRadius.circular(10)),
                      todayTextStyle: const TextStyle(
                        color: WireframeColor.white,
                      ),
                      selectedDecoration: BoxDecoration(
                          color: WireframeColor.green,
                           shape: BoxShape.rectangle, // Specify the shape
                          borderRadius: BorderRadius.circular(10)),
                      selectedTextStyle: const TextStyle(
                        color: WireframeColor.white,
                      ),
                      defaultDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    shouldFillViewport: false,
                    currentDay: _selectedDay,
                    calendarFormat: CalendarFormat.month,
                    pageAnimationEnabled: false,
                    headerStyle: HeaderStyle(
                      leftChevronIcon: SizedBox(
                        height: height / 26,
                        width: height / 26,
                        child: Icon(
                          Icons.chevron_left,
                          color: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                        ),
                      ),
                      rightChevronIcon: SizedBox(
                        height: height / 26,
                        width: height / 26,
                        child: Icon(Icons.chevron_right,
                            color: themedata.isdark ? WireframeColor.white : WireframeColor.black,),
                      ),
                      formatButtonVisible: false,
                      decoration: const BoxDecoration(
                        color: WireframeColor.transparent,
                      ),
                      titleCentered: true,
                      titleTextStyle: sansproRegular.copyWith(
                        fontSize: 15,
                        color: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                      ),
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    // onDaySelected: (selectedDay, focusedDay) {
                    //   setState(() {
                    //     _selectedDay = selectedDay;
                    //     String convertdate = (_selectedDay.toString());
                    //     selectdate = convertdate;
                    //     selectdatedate=selectdate;
                    //      Getattendencedata(selectedValueid,selectedValuesectionid,selectdate);
                    //   });
                    // },
                    onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    String convertdate = (_selectedDay.toString());
                    selectdate = convertdate;

                    // Convert selectdate to DateTime
                    DateTime parsedDate = DateTime.parse(_selectedDay.toString());

                    // Now assign it to selectdatedate
                    selectdatedate = parsedDate;

                    // Continue with your other code
                    Getattendencedata(selectedValueid, selectedValuesectionid, selectdatedate);
                  });
                },

                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                      CalendarFormat.week: 'Week',
                    },
                  ),
                  SizedBox(
                    height: height / 26,
                  ),
                 

                  Divider(),
                  Row(
                            children: [
                             
                              SizedBox(width: 10),
                              Text(
                                "Presenty Date : ",
                                style: TextStyle(
                                  fontFamily: 'sansproSemibold',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              //Spacer(),
                              SizedBox(width: 10,),
                             Text(
                                   DateFormat('dd-MM-yyyy').format(selectdatedate),
                                    style: TextStyle(
                                      fontFamily: 'sansproSemibold',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: WireframeColor.appcolor,
                                    ),
                                  )
                            ],
                          ),
                 Divider(),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      // Ensure the DropdownSearch takes up available space
                      child: GestureDetector(
                        // onTap: () {
                        //    Navigator.push(context, MaterialPageRoute(
                        //      builder: (context) {
                        //        return  Wireframeattendance_report(classid:widget.classid,sectionid:widget.sectionid);
                        //      },
                        //    ));
                        // },

                        onTap: () {
                          
                    if (roletype == "3") {
                      if(widget.classid.toString()!="null" && widget.sectionid.toString !="null"){
                                    print("hello");
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Wireframeattendance_report(
                                          classid: widget.classid,
                                          sectionid: widget.sectionid,
                                          type: 'absent',
                                          date_pass:selectdatedate.toString()
                                        );
                                      },
                                    ),
                                  );
                      }
                                 
                                }else if(roletype=='7'){

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Wireframeattendance_report(
                                          classid: widget.classid,
                                          sectionid: widget.sectionid,
                                          type: 'absent',
                                          date_pass:selectdatedate.toString()
                                        );
                                      },
                                    ),
                                  );

                                }
                                 else {
                                   print("hii");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Wireframeattendance_report(
                                          classid: selectedValueid,
                                          sectionid: selectedValuesectionid,
                                          type: 'absent',
                                          date_pass:selectdatedate.toString()
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: WireframeColor.red),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 60,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: WireframeColor.red),
                                  color: WireframeColor.red,
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                "Absent",
                                style: TextStyle(
                                  fontFamily: 'sansproSemibold',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 60,
                                width: 40,
                                margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(color: WireframeColor.redback),
                                  color: WireframeColor.redback,
                                ),
                                child: Center(
                                  child: Text(
                                    Absenty.toString(),
                                    style: TextStyle(
                                      fontFamily: 'sansproSemibold',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              

                SizedBox(
                    height: 20,
                  ),
                 
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded( // Ensure the DropdownSearch takes up available space
                     child: GestureDetector(
                      //  onTap: () {
                          
                      //      Navigator.push(context, MaterialPageRoute(
                      //        builder: (context) {
                      //          return  Wireframeattendance_report(classid:widget.classid,sectionid:widget.sectionid);
                      //        },
                      //      ));
                      //   },

                     

                              onTap: () {
                                if (roletype=="3") {
                                    if(widget.classid.toString()!="null" && widget.sectionid.toString !="null"){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Wireframeattendance_report(
                                          classid: widget.classid,
                                          sectionid: widget.sectionid,
                                          type: 'present',
                                          date_pass:selectdatedate.toString()
                                        );
                                      },
                                    ),
                                  );
                                  }
                                } else if(roletype=='7'){

                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Wireframeattendance_report(
                                          classid: widget.classid,
                                          sectionid: widget.sectionid,
                                          type: 'present',
                                          date_pass:selectdatedate.toString()
                                        );
                                      },
                                    ),
                                  );
                                

                                }else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Wireframeattendance_report(
                                          classid: selectedValueid,
                                          sectionid: selectedValuesectionid,
                                          type: 'present',
                                          date_pass:selectdatedate.toString()
                                        );
                                      },
                                    ),
                                  );
                                }
                              },

                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                           border: Border.all(color: WireframeColor.green),
                        ),
                        child :Row(
                        children: [
                      Container(
                        height: 60,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                           border: Border.all(color: WireframeColor.green),
                           color: WireframeColor.green,
                           
                        ),),
                          SizedBox(width: 20,),

                                 Text(
                                  "Present",
                                     style: TextStyle(
                                fontFamily: 'sansproSemibold', // Make sure 'sansproSemibold' is the correct font family
                                fontWeight: FontWeight.w600, // Adjust the weight as needed
                                fontSize: 16,
                                    ),
                                  ),

                              
                         Spacer(),

                      Container(
                    height: 60,
                    width: 40,
                    margin: EdgeInsets.only(top: 10, bottom: 10,right: 10), // Adjust the margin as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: WireframeColor.greenback),
                      color: WireframeColor.greenback, // Set the background color as needed
                    ),
                    child: Center(
                      child: Text(
                        Presenty.toString(),
                        style: TextStyle(
                          fontFamily: 'sansproSemibold',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.green, // Set the text color as needed
                        ),
                      ),
                    ),
                  ),


                            ])
                        
                      ),
                     ) ),
                  ],
                ),

                 SizedBox(
                    height: 20,
                  ),

                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded( // Ensure the DropdownSearch takes up available space
                     child: GestureDetector(
                      

                     

                              onTap: () {
                                  if (roletype=="3") {
                                    if(widget.classid.toString()!="null" && widget.sectionid.toString !="null"){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Wireframeattendance_report(
                                          classid: widget.classid,
                                          sectionid: widget.sectionid,
                                          type: 'all',
                                         date_pass:selectdatedate.toString()
                                        );
                                      },
                                    ),
                                  );
                                    }
                                    } else if(roletype=='7'){
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Wireframeattendance_report(
                                          classid: widget.classid,
                                          sectionid: widget.sectionid,
                                          type: 'all',
                                         date_pass:selectdatedate.toString()
                                        );
                                      },
                                    ),
                                  );
                                    }else{
                                       Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Wireframeattendance_report(
                                          classid: selectedValueid,
                                          sectionid: selectedValuesectionid,
                                          type: 'all',
                                         date_pass:selectdatedate.toString()
                                        );
                                      },
                                    ),
                                  );
                                    }
                               
                              },

                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                           border: Border.all(color: WireframeColor.bootomcolor),
                        ),
                        child :Row(
                        children: [
                      Container(
                        height: 60,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                           border: Border.all(color: WireframeColor.bootomcolor),
                           color: WireframeColor.bootomcolor,
                           
                        ),),
                          SizedBox(width: 20,),

                                 Text(
                                  "Total",
                                     style: TextStyle(
                                fontFamily: 'sansproSemibold', // Make sure 'sansproSemibold' is the correct font family
                                fontWeight: FontWeight.w600, // Adjust the weight as needed
                                fontSize: 16,
                                    ),
                                  ),

                              
                         Spacer(),

                      Container(
                    height: 60,
                    width: 40,
                    margin: EdgeInsets.only(top: 10, bottom: 10,right: 10), // Adjust the margin as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: WireframeColor.listbackgroundcolor),
                      color: WireframeColor.listbackgroundcolor, // Set the background color as needed
                    ),
                    child: Center(
                      child: Text(
                        total.toString(),
                        style: TextStyle(
                          fontFamily: 'sansproSemibold',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: WireframeColor.bootomcolor, // Set the text color as needed
                        ),
                      ),
                    ),
                  ),


                            ])
                        
                      ),
                     ) ),
                  ],
                )
                   
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}