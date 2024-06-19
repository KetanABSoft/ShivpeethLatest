import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_stafprofile.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class staffdata {
  final String id;
  final String staffid;
  final String name;
  final String designation_name;
  final String department_name;
  final String email;
  final String mobileno;
  final String photo;
  

  staffdata(
      {required this.id,
      required this.staffid,
      required this.name,
      required this.designation_name,
      required this.department_name,
      required this.email,
      required this.mobileno,
      required this.photo,
     

      
      
      });

  factory staffdata.fromJson(Map<String, dynamic> json) {
    return staffdata(
      id: json['id'],
      staffid: json['staff_id'],
      name: json['name'],
      designation_name: json['designation_name'],
      department_name: json['department_name'],
      email: json['email'],
      mobileno: json['mobileno'],
      photo: json['photo'],
    
    );
  }
}
class mystaffdata extends StatefulWidget {
  const mystaffdata({super.key});

  @override
  State<mystaffdata> createState() => mystaffdataState();
}

class mystaffdataState extends State<mystaffdata> {
  double height = 0.00;
  double width = 0.00;
 List<staffdata> carouselItems = [];
  var _classtypedata;
  List<String> classTypenew = [];
  List<String> classTypeid = [];
    String? selectedId;
    var selectedValue;
  var selectedValueid;
  List<staffdata> getitem = [];
   List<staffdata> filteredList = [];
   String? branch_id;
 @override
  void initState() {
    super.initState();
    getroledata();
    fetchstaffdata("Select Role");
   
  }

Future<void> getroledata() async {
    final response = await http.get(Uri.parse(AppString.constanturl + 'Fetchrolename'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      _classtypedata = jsonData;
      //print(_classtypedata);
      for (int i = 0; i < _classtypedata.length; i++) {
        classTypeid.add(_classtypedata[i]["id"]);
        classTypenew.add(_classtypedata[i]["rolename"]);
        setState(() {});
      }
    }
  }
   Future<void> fetchstaffdata(selectedValue) async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     branch_id = preferences.getString('branch_id');

 String apiUrl = AppString.constanturl + 'Get_staffdata';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "role": selectedValue != null ? selectedValue : 'Select Role',
        "branch_id": branch_id != null ? branch_id.toString() : '',

      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<staffdata> items = [];
      print(jsonData);
      for (var item in jsonData) {
        items.add(staffdata.fromJson(item));
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
    selectedValueid = "Select Role";
  }
 SharedPreferences preferences = await SharedPreferences.getInstance();
     branch_id = preferences.getString('branch_id');
String appUrlNew = AppString.loginurl.replaceAll("https", "http") +
    'exporttoecel_staffdata.php?role=$selectedValueid&branch_id=$branch_id';

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
                          selectedItem: selectedValue ?? "Select Role",
                        ),
                      ),
                    ),
                  ],
                ),
               // SizedBox(height: 10),
               
              ],
            ),
          ),
          SizedBox(width: 20),
          Column(
            children: [
              InkWell(
                onTap: () {
                  fetchstaffdata(selectedValueid);
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
          item.designation_name.toLowerCase().contains(query.toLowerCase());
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


  Future<bool> doesImageExist( String photo) async {
       String imageUrl =  AppString.staffimageurl + photo;
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }

    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    return checkIfImage(data['content-type']);
  }
  bool checkIfImage(String param) {
    if (param == 'image/jpeg' || param == 'image/png' || param == 'image/gif') {
      return true;
    }
    return false;
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
                "Staff Data",
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
                                'Photo',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                             DataColumn(
                              label: Text(
                                'Staff Id',
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
                                'Designation ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Department ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                             DataColumn(
                              label: Text(
                                'Email ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                             DataColumn(
                              label: Text(
                                'Mobile ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Action ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: carouselItems.map((student) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  // IconButton(
                                  //   iconSize: 5,
                                  //   icon: Image.asset(WireframePngimage.profile
                                  //   ,width: 25, 
                                  //    height: 25,),
                                  //   onPressed: () {
                                  //     // Handle edit action
                                  //   },
                                  // ),
                                  IconButton(
                              iconSize: 25,
                              icon: student.photo.toString() != ""
                                  ? FutureBuilder(
                                      future: doesImageExist(student.photo.toString()),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          if (snapshot.hasError || snapshot.data != true) {
                                            // Handle error or image not found case
                                            return Image.asset(
                                              WireframePngimage.profile,
                                              width: 25,
                                              height: 25,
                                            );
                                          } else {
                                            // Display the valid image
                                            return Image.network(
                                              AppString.staffimageurl + student.photo.toString(),
                                              width: 25,
                                              height: 25,
                                            );
                                          }
                                        } else {
                                          // Show a loading indicator while checking for image existence
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    )
                                  : Image.asset(
                                      WireframePngimage.profile,
                                      width: 25,
                                      height: 25,
                                    ),
                              onPressed: () {
                                // Handle edit action
                              },
                            )
                                ),
                                 DataCell(Text(student.staffid)),
                                DataCell(Text(student.name)),
                                DataCell(Text(student.designation_name)),
                                DataCell(Text(student.department_name)),
                                DataCell(Text(student.email)),
                                DataCell(Text(student.mobileno)),
                                DataCell(IconButton(
                                  icon: Image.asset(WireframePngimage.action,height: 20,width: 20),
                                  onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return staff_profiledata(staffid:student.id);

                                  },
                                ));
                                  },
                                )),
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