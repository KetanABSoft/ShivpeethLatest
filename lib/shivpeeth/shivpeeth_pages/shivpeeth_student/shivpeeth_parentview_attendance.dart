import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_studentattendencereport.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_student/student_att_dashscreen.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class Wireframe_student_att extends StatefulWidget {
  final String classid;
  final String sectionid;
  const Wireframe_student_att(
      {required this.classid, required this.sectionid, Key? key})
      : super(key: key);

  @override
  State<Wireframe_student_att> createState() => Wireframe_student_attstate();
}

class Wireframe_student_attstate extends State<Wireframe_student_att> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  List<DateTime> startDates = [];
  DateTime? _selectedDay;
  String? selectdate;
  var selectdatedate = DateTime.now();
  String? formattedDate;
  String? Presenty = '0';
  String? Absenty = '0';
  String? total = '0';
  String? roleid;
  String? userid;
  String? branch_id;

  void getshadpre() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      roleid = preferences.getString('role');

      Getattendencedata(
          widget.classid.toString(), widget.sectionid.toString, DateTime.now());
      userid = preferences.getString('id');
      branch_id = preferences.getString('branch_id');
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message.data["MyName"].toString()),
        duration: Duration(seconds: 10),
        backgroundColor: Colors.green,
      ));
      print("Messege Recieved! ${message.notification!.title}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("App is Open By Notification"),
        duration: Duration(seconds: 10),
        backgroundColor: Colors.green,
      ));
      print("Messege Recieved! ${message.notification!.title}");
    });

    print("count: " + widget.classid + "  " + widget.sectionid);
    getshadpre();
  }

  Future<void> Getattendencedata(class_id, section_id, startdate) async {
    print("rolwid:${roleid}");
    print('Received startdate: $startdate');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    roleid = preferences.getString('role');
    userid = preferences.getString('id');
    branch_id = preferences.getString('branch_id');

    if (roleid == '7') {
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

      print(branch_id.toString());
      String apiUrl = AppString.constanturl + 'Get_Attendenancecount_student';
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'class_id': class_id != null ? class_id.toString() : "Select Class",
          'section_id':
              section_id != null ? section_id.toString() : "Select Section",
          'date': date != null ? date.toUtc().toIso8601String() : null,
          'branch_id': branch_id != null ? branch_id.toString() : null,
          'userid': userid != null ? userid.toString() : null,
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
      print(Presenty);
      print(Absenty);
    } catch (e) {
      print('Error parsing date: $e');
      // Handle the error or throw it again if needed
      throw e;
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
          padding: EdgeInsets.only(top: height / 36, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                color: themedata.isdark
                    ? WireframeColor.black
                    : WireframeColor.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 26, vertical: height / 56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(
                        2000, 1, 1), // Adjust the start date as needed
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
                          color: themedata.isdark
                              ? WireframeColor.white
                              : WireframeColor.black,
                        ),
                      ),
                      rightChevronIcon: SizedBox(
                        height: height / 26,
                        width: height / 26,
                        child: Icon(
                          Icons.chevron_right,
                          color: themedata.isdark
                              ? WireframeColor.white
                              : WireframeColor.black,
                        ),
                      ),
                      formatButtonVisible: false,
                      decoration: const BoxDecoration(
                        color: WireframeColor.transparent,
                      ),
                      titleCentered: true,
                      titleTextStyle: sansproRegular.copyWith(
                        fontSize: 15,
                        color: themedata.isdark
                            ? WireframeColor.white
                            : WireframeColor.black,
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
                        DateTime parsedDate =
                            DateTime.parse(_selectedDay.toString());

                        // Now assign it to selectdatedate
                        selectdatedate = parsedDate;

                        // Continue with your other code
                        Getattendencedata(widget.classid.toString(),
                            widget.sectionid.toString(), selectdatedate);
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
                      SizedBox(
                        width: 10,
                      ),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Wir_student_att_dash(
                                      classid: widget.classid,
                                      sectionid: widget.sectionid,
                                      type: 'absent',
                                      date_pass: selectdatedate.toString());
                                },
                              ),
                            );
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
                                    border:
                                        Border.all(color: WireframeColor.red),
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
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                        color: WireframeColor.redback),
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
                      Expanded(
                          // Ensure the DropdownSearch takes up available space
                          child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Wir_student_att_dash(
                                  classid: widget.classid,
                                  sectionid: widget.sectionid,
                                  type: 'present',
                                  date_pass: selectdatedate.toString(),
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: WireframeColor.green),
                            ),
                            child: Row(children: [
                              Container(
                                height: 60,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border:
                                      Border.all(color: WireframeColor.green),
                                  color: WireframeColor.green,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Present",
                                style: TextStyle(
                                  fontFamily:
                                      'sansproSemibold', // Make sure 'sansproSemibold' is the correct font family
                                  fontWeight: FontWeight
                                      .w600, // Adjust the weight as needed
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 60,
                                width: 40,
                                margin: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    right: 10), // Adjust the margin as needed
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      color: WireframeColor.greenback),
                                  color: WireframeColor
                                      .greenback, // Set the background color as needed
                                ),
                                child: Center(
                                  child: Text(
                                    Presenty.toString(),
                                    style: TextStyle(
                                      fontFamily: 'sansproSemibold',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors
                                          .green, // Set the text color as needed
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          // Ensure the DropdownSearch takes up available space
                          child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Wir_student_att_dash(
                                    classid: widget.classid,
                                    sectionid: widget.sectionid,
                                    type: 'all',
                                    date_pass: selectdatedate.toString());
                              },
                            ),
                          );
                        },
                        child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border:
                                  Border.all(color: WireframeColor.bootomcolor),
                            ),
                            child: Row(children: [
                              Container(
                                height: 60,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: WireframeColor.bootomcolor),
                                  color: WireframeColor.bootomcolor,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Total",
                                style: TextStyle(
                                  fontFamily:
                                      'sansproSemibold', // Make sure 'sansproSemibold' is the correct font family
                                  fontWeight: FontWeight
                                      .w600, // Adjust the weight as needed
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 60,
                                width: 40,
                                margin: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    right: 10), // Adjust the margin as needed
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      color:
                                          WireframeColor.listbackgroundcolor),
                                  color: WireframeColor
                                      .listbackgroundcolor, // Set the background color as needed
                                ),
                                child: Center(
                                  child: Text(
                                    total.toString(),
                                    style: TextStyle(
                                      fontFamily: 'sansproSemibold',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: WireframeColor
                                          .bootomcolor, // Set the text color as needed
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                      )),
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
