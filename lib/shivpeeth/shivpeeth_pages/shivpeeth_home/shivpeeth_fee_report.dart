import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_fullstudentfeedatashow.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';



class studentdfeereportlist {
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
  

  studentdfeereportlist(
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

  factory studentdfeereportlist.fromJson(Map<String, dynamic> json) {
    return studentdfeereportlist(
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
class studentfeereport extends StatefulWidget {
  const studentfeereport({super.key});

  @override
  State<studentfeereport> createState() => studentfeereportState();
}

class studentfeereportState extends State<studentfeereport> {
  double height = 0.00;
  double width = 0.00;
 List<studentdfeereportlist> carouselItems = [];
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
 String? session_id;
 List<studentdfeereportlist> getitem = [];
   List<studentdfeereportlist> filteredList = [];
  String ?branch_id;
    @override
  void initState() {
    super.initState();
   
    getclassdata();
    getsectiondata();
    fetchbuinesssearchlist("Select Class","Select Section");
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

  Future<void> fetchbuinesssearchlist(selectedValue, selectedValue2) async {
    print(selectedValue);
    print(selectedValue2);
     SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
    session_id = preferences.getString('session_id');
    
 String apiUrl = AppString.constanturl + 'Fectch_fees_report';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "class_id": selectedValue != null ? selectedValue : 'Select Class',
        "section_id": selectedValue2 != null ? selectedValue2 : 'Select Section',
        "branch_id": branch_id != null ? branch_id.toString() : '',
        "session_id":  session_id != Null ? session_id  : '',

      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<studentdfeereportlist> items = [];
      print(jsonData);
      for (var item in jsonData) {
        items.add(studentdfeereportlist.fromJson(item));
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
  if (selectedValueid == null || selectedValueid.isEmpty) {
    selectedValueid = "Select Class";
  }
  if (selectedValuesectionid == null || selectedValuesectionid.isEmpty) {
    selectedValuesectionid = "Select Section";
  }
 SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
    session_id = preferences.getString('session_id');
String appUrlNew = AppString.loginurl.replaceAll("https", "http") +
    'exporttoecel_feedata.php?class_id=$selectedValueid&section_id=$selectedValuesectionid&branch_id=$branch_id&session_id=$session_id';

  
   try {
      await launch(appUrlNew);
    } catch (e) {
      print('Error launching URL: $e');
    }
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
              ],
            ),
          ),
          SizedBox(width: 20),
          Column(
            children: [
              InkWell(
                onTap: () {
                  fetchbuinesssearchlist(selectedValueid,selectedValuesectionid);
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
                "Fee Reports",
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),
                bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20))
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width / 26,
                vertical: height / 36,
              ),
              child: Column(
                children: [
                  buildDropdownContainer(),
                  SizedBox(height: 10),
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
                      onTap: () async {
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
                  SizedBox(height: height / 36),
              
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
                               
                               
                                //DataCell(Text(student.name)),
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