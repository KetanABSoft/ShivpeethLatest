import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/staff_adapter.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class stafflist {
  final String id;
  final String name;
  final String designation;
  final String department;
  final String email;
  final String photo;

  stafflist({
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.email,
    required this.photo,
  });

  factory stafflist.fromJson(Map<String, dynamic> json) {
    return stafflist(
      id: json['id'],
      name: json['name'],
      designation: json['designation'],
      department: json['department'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}

class student_stafflist extends StatefulWidget {
  const student_stafflist({super.key});

  @override
  State<student_stafflist> createState() => student_stafflistState();
}

const double widthnew = 50.0;
const double heightnew = 60.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Colors.white;

class student_stafflistState extends State<student_stafflist> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  List<stafflist> carouselItems = [];

  late double xAlign;
  late Color loginColor;
  late Color signInColor;
  String fetchdata = "Boardmember";
  String? branch_id;
  @override
  void initState() {
    super.initState();
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
    fetchstaffdatalist(fetchdata);
  }

  Future<void> fetchstaffdatalist(selectedValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
    String apiUrl = AppString.constanturl + 'Studenthowing_stafflist';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "status": selectedValue != null ? selectedValue : 'Boardmember',
        "branch_id": branch_id != null ? branch_id : '',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<stafflist> items = [];
      print(jsonData);
      for (var item in jsonData) {
        items.add(stafflist.fromJson(item));
      }

      setState(() {
        carouselItems = items;
      });
    } else {
      // Handle API error
    }
  }

  Widget buildDropdownContainer() {
    return Container(
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
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        // Ensure the DropdownSearch takes up available space
                        child: Container(
                          width: 200,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                          ),
                          child: Stack(
                            children: [
                              AnimatedAlign(
                                alignment: Alignment(xAlign, 0),
                                duration: Duration(milliseconds: 300),
                                child: Container(
                                  width: 100,
                                  height: height,
                                  decoration: BoxDecoration(
                                    color: WireframeColor.bootomcolor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    xAlign = loginAlign;
                                    loginColor = selectedColor;
                                    signInColor = normalColor;
                                    fetchdata = "Boardmember";
                                    fetchstaffdatalist(fetchdata);
                                  });
                                },
                                child: Align(
                                  alignment: Alignment(-1, 0),
                                  child: Container(
                                    width: 100,
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Board Member',
                                      style: TextStyle(
                                        color: loginColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    xAlign = signInAlign;
                                    signInColor = selectedColor;
                                    loginColor = normalColor;
                                    fetchdata = "teacher";
                                    fetchstaffdatalist(fetchdata);
                                  });
                                },
                                child: Align(
                                  alignment: Alignment(1, 0),
                                  child: Container(
                                    width: 100,
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Teachers',
                                      style: TextStyle(
                                        color: signInColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
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
                "School Staff",
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
                    bottomRight: Radius.circular(20)),
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
                      height: 10,
                    ),
                    carouselItems.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: carouselItems.length,
                            itemBuilder: (context, index) {
                              final stafflist item = carouselItems[index];
                              return staffcommaonlist(
                                name: item.name,
                                designation: item.designation,
                                photo: item.photo,
                                opacity: 1,
                                isLast: index == carouselItems.length - 1,
                              );
                            },
                          )
                        : Container(
                            height: 300,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("No record found"),
                              ),
                            ),
                          ),
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
