import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class studentmonthlytendancelist {
  final String id;
  final String name;
  final String clname;
  final String divsion;
  final String report;
  final String totaldays;
  final String presentday;
  final String absentday;
  

  studentmonthlytendancelist(
      {required this.id,
      required this.name,
      required this.clname,
      required this.divsion,
      required this.report,
      required this.totaldays,
      required this.presentday,
      required this.absentday,
     

      
      
      });

  factory studentmonthlytendancelist.fromJson(Map<String, dynamic> json) {
    return studentmonthlytendancelist(
      id: json['id'].toString(),
      name: json['name'].toString(),
      clname: json['clname'].toString(),
      divsion: json['divsion'].toString(),
      report: json['report'].toString(),
      totaldays: json['gettotaldays'].toString(),
      presentday: json['presentcount'].toString(),
      absentday: json['absentcount'].toString(),
    
    );
  }
}
class monthlyattendance extends StatefulWidget {
  final String? classid;
  final String? sectionid;
   final String?type;
   final String?date_pass;

  const monthlyattendance({
    required this.classid,
    required this.sectionid,
    required this.type,
    required this.date_pass,
    super.key});

  @override
  State<monthlyattendance> createState() => monthattendanceState();
}



class monthattendanceState extends State<monthlyattendance> {
   List<studentmonthlytendancelist> carouselItems = [];

   dynamic size;
   double height = 0.00;
   double width = 0.00;
   String?id;
   String?role;
   String?branch_id;
  
   @override
  void initState() {
    super.initState();
   
  
    fetchdailyattendance("Monthly",widget.date_pass);
  }
  Future<void> fetchdailyattendance(selectedValue,startdate) async {
 SharedPreferences preferences = await SharedPreferences.getInstance();
     id = preferences.getString('id');
     role = preferences.getString('role');
     branch_id = preferences.getString('branch_id');
     print(id);
       DateTime date;
    if (startdate != null) {
      date = DateTime.parse(startdate.toString());
      print('Parsed date: $date');
    } else {
      print('Start date is null');
      // Handle the case when startdate is null
      return;
    }
    String apiUrl = AppString.constanturl + 'fetchmonthly_attendancestudent';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "Monthly": selectedValue != null ? selectedValue : 'Monthly',
        "id": id != null ? id : '',
        "role": role != null ? role : '',
        "branch_id": branch_id != null ? branch_id : '',
        "classid": widget.classid != null ? widget.classid.toString() : 'Select Class',
        "sectionid": widget.sectionid != null ? widget.sectionid.toString() : 'Select Section',
        "type":widget.type ,
        'date': date != null ? date.toUtc().toIso8601String() : null,
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<studentmonthlytendancelist> items = [];
      print(jsonData);
      for (var item in jsonData) {
        items.add(studentmonthlytendancelist.fromJson(item));
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
                                'Total days ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                             DataColumn(
                              label: Text(
                                'Present days ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                             DataColumn(
                              label: Text(
                                'Absent days ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: carouselItems.map((student) {
                            return DataRow(
                              cells: [
                                
                               
                                DataCell(Text(student.name)),
                                DataCell(Text(student.clname)),
                                DataCell(Text(student.divsion)),
                                DataCell(Text(student.totaldays)),
                                DataCell(Text(student.presentday)),
                                DataCell(Text(student.absentday)),
                               

                                
                               
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