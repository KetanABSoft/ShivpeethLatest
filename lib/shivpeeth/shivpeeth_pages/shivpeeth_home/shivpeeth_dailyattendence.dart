import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class studentdailyattendancelist {
  final String id;
  final String date;
  final String name;
  final String clname;
  final String divsion;
  final String report;
  

  studentdailyattendancelist(
      {required this.id,
      required this.date,
      required this.name,
      required this.clname,
      required this.divsion,
      required this.report,
     

      
      
      });

  factory studentdailyattendancelist.fromJson(Map<String, dynamic> json) {
    return studentdailyattendancelist(
      id: json['id'],
      date: json['date'],
      name: json['name'],
      clname: json['clname'],
      divsion: json['divsion'],
      report: json['report'],
    
    );
  }
}
class dailyattendance extends StatefulWidget {
 final String?classid;
 final String?sectionid;
 final String?type;
 final String?date_pass;
  const dailyattendance({
    required this.classid,
    required this.sectionid,
    required this.type,
    required this.date_pass,
    super.key});

  @override
  State<dailyattendance> createState() => dailyattendanceState();
}



class dailyattendanceState extends State<dailyattendance> {
   List<studentdailyattendancelist> carouselItems = [];

   dynamic size;
  double height = 0.00;
  double width = 0.00;
  String?id;
   String?role;
   String?branch_id;
  
  
   @override
  void initState() {
    super.initState();
   
  
    fetchdailyattendance("Daily",widget.date_pass);
  }
  Future<void> fetchdailyattendance(selectedValue,startdate) async {
    print(selectedValue);
SharedPreferences preferences = await SharedPreferences.getInstance();
     id = preferences.getString('id');
     role = preferences.getString('role');
     branch_id = preferences.getString('branch_id');
      DateTime date;
    if (startdate != null) {
      date = DateTime.parse(startdate.toString());
      print('Parsed date: $date');
    } else {
      print('Start date is null');
      // Handle the case when startdate is null
      return;
    }
    // print(widget.classid);
    // print(widget.sectionid);
    //  print("datedata"+ widget.classid.toString());
    //  print("sectionid"+ widget.sectionid.toString());
  
 String apiUrl = AppString.constanturl + 'fetchdaily_attendancestudent';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "Daily": selectedValue != null ? selectedValue : 'Daily',
        "id": id != null ? id : '',
        "role": role != null ? role : '',
        "branch_id": branch_id != null ? branch_id : '',
        "classid": widget.classid != null ? widget.classid : 'Select Class',
        "sectionid": widget.sectionid != null ? widget.sectionid : 'Select Section',
        "type":widget.type,
        'date': date != null ? date.toUtc().toIso8601String() : null,
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<studentdailyattendancelist> items = [];
      print(jsonData);
      for (var item in jsonData) {
        items.add(studentdailyattendancelist.fromJson(item));
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
    return  Container(
           
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width / 26,
                vertical: height / 36,
              ),
              child: Column(
                children: [
                
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
                                'Date',
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
                                'Report ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: carouselItems.map((student) {
                            return DataRow(
                              cells: [
                                
                                DataCell(Text(student.date)),
                                DataCell(Text(student.name)),
                                DataCell(Text(student.clname)),
                                DataCell(Text(student.divsion)),
                               DataCell(
                                Container(
                                  width: 60,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: student.report == "Present"
                                        ? WireframeColor.green
                                        : WireframeColor.red,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      student.report,
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
        );
      
      
   
  }
}