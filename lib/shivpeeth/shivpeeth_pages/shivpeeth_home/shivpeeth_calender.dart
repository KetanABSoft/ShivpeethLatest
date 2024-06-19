import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/calenderholiday.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class calenderlist {
  final String id;
  final String titledata;
  final String dayname;
  final String startdate;
 
  

  calenderlist(
      {required this.id,
      required this.titledata,
      required this.dayname,
      required this.startdate,

 

      
      
      });

  factory calenderlist.fromJson(Map<String, dynamic> json) {
    return calenderlist(
      id: json['id'],
      titledata: json['title'],
      dayname: json['dayname'],
      startdate: json['date'],
    
      
    
    );
  }
}
class WireframeCalender extends StatefulWidget {
  const WireframeCalender({Key? key}) : super(key: key);

  @override
  State<WireframeCalender> createState() => _WireframeCalenderState();
}

class _WireframeCalenderState extends State<WireframeCalender> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
 List<DateTime> startDates = [];
  DateTime? _selectedDay;
  String? selectdate;
  String? branch_id;

 
 List<calenderlist> carouselItems = [];
@override
void initState() {
  super.initState();
  calenderdata();
}

Future<void> calenderdata() async {
 //final response = await http.get(Uri.parse(AppString.constanturl + 'fetch_calendar_data'));
      SharedPreferences preferences = await SharedPreferences.getInstance();
      branch_id = preferences.getString('branch_id');
    
    var urlString = AppString.constanturl + 'fetch_calendar_data';
    Uri uri = Uri.parse(urlString);
    var response = await http.post(uri, body: {
      "branch_id":'$branch_id',
    });
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
       print(jsonData);
      List<calenderlist> items = [];
 final dateFormat = DateFormat('dd MMM yyyy');
      for (var item in jsonData) {
        items.add(calenderlist.fromJson(item));
      }

      setState(() {
        carouselItems = items;
       
        startDates = carouselItems
            .map((item) => dateFormat.parse(item.startdate))
            .toList();
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
                  )),
              SizedBox(
                width: width / 36,
              ),
              Text(
                "Calendar",
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
            decoration: BoxDecoration(
                color: themedata.isdark ? WireframeColor.black : WireframeColor.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20), bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20))),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 26, vertical: height / 56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    firstDay: DateTime.now(),
                    focusedDay: DateTime.now(),
                    lastDay: DateTime.utc(2050, 3, 14),
                    headerVisible: true,
                    daysOfWeekVisible: true,
                   
                     eventLoader: (date) {
                            List<DateTime> events = [];
                            Set<DateTime> addedDates = Set(); // Keep track of added dates

                            for (DateTime startDate in startDates) {
                              if (isSameDay(startDate, date) && !addedDates.contains(startDate)) {
                                events.add(startDate);
                                addedDates.add(startDate); // Mark the date as added
                              }
                            }

                            return events;
                          },

                    calendarStyle: CalendarStyle(
                      
                      // weekendDecoration: BoxDecoration(
                      //   color: Colors.blue, // Change this color as needed
                      //   shape: BoxShape.circle,
                      // ),
                      todayDecoration: BoxDecoration(
                        color: WireframeColor.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      todayTextStyle: const TextStyle(
                        color: WireframeColor.white,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: WireframeColor.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      selectedTextStyle: const TextStyle(
                        color: WireframeColor.white,
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
                        child: Icon(
                          Icons.chevron_right,
                          color: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                        ),
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

                    
                    // selectedDayPredicate: (day) {
                    //   return isSameDay(_selectedDay, day);
                    // },
                    // onDaySelected: (selectedDay, focusedDay) {
                    //   setState(() {
                    //     _selectedDay = selectedDay;
                    //     String convertdate = (_selectedDay.toString());
                    //     selectdate = convertdate;
                    //   });
                    // },
                    
                               
                                  
                  ),
                  SizedBox(
                    height: height / 26,
                  ),
                  Text(
                    "List_of_Holiday".tr,
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,),
                  ),
                  SizedBox(
                    height: height / 36,
                  ),
                    carouselItems.length > 0
                            ?
                  ListView.builder(
                    itemCount: carouselItems.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final calenderlist item = carouselItems[index];
                                  return Comcalenderholidaylist(
                                    titledata: item.titledata,
                                    assignedate: item.startdate,
                                    dayname: item.dayname,
                                    opacity: 1,
                                    isLast: index == carouselItems.length - 1,
                                  );
                    },
                  ): Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("No record found"),
                              ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
