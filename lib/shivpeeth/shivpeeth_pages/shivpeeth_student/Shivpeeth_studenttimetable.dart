import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/studenttimetable_adapter.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class timetablelist {
  final String id;
  final String timetableimage;

  timetablelist({
    required this.id,
    required this.timetableimage,
  });

  factory timetablelist.fromJson(Map<String, dynamic> json) {
    return timetablelist(
      id: json['id'],
      timetableimage: json['timetableimage'],
    );
  }
}

class studenttimetable extends StatefulWidget {
  final String classid;
  final String sectionid;
  const studenttimetable(
      {required this.classid, required this.sectionid, super.key});

  @override
  State<studenttimetable> createState() => studenttimetableState();
}

class studenttimetableState extends State<studenttimetable> {
  double height = 0.00;
  double width = 0.00;
  List<String> classTypenew = [];
  List<String> classTypeid = [];
  String? selectedId;
  var selectedValue;
  var selectedValueid;
  List<timetablelist> carouselItems = [];
  String? roleid;
  String? userid;
  String? branch_id;

  @override
  void initState() {
    super.initState();
    getshadpre();
    noticedata("Select Teacher", widget.classid, widget.sectionid);
  }

  void getshadpre() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    roleid = preferences.getString('role');
    userid = preferences.getString('id');
  }

  Future<void> noticedata(
      String teacher, String class_id, String section_id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    roleid = preferences.getString('role');
    userid = preferences.getString('id');
    branch_id = preferences.getString('branch_id');

    if (roleid == '7') {
      class_id = widget.classid;
      section_id = widget.sectionid;
    }
    String apiUrl = AppString.constanturl + 'Gettimetable';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "teacher": teacher != Null ? teacher : 'Select Teacher',
        "section_id": section_id != Null ? section_id : 'Select Section',
        "class_id": class_id != Null ? class_id : 'Select Class',
        "roleid": roleid != Null ? roleid : 'roleid',
        "branch_id": '$branch_id',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      List<timetablelist> items = [];

      for (var item in jsonData) {
        items.add(timetablelist.fromJson(item));
      }

      setState(() {
        carouselItems = items;
      });
    } else {
      // Handle API error
    }
  }

  @override
  void dispose() {
    // Reset preferred orientations when the page is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final themedata = Get.put(WireframeThemecontroler());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
                "Timetable",
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
          padding: EdgeInsets.only(top: 2),
          child: Container(
            decoration: BoxDecoration(
                color: themedata.isdark
                    ? WireframeColor.black
                    : WireframeColor.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 26, vertical: height / 56),
              child: Column(
                children: [
                  carouselItems.length > 0
                      ? ListView.builder(
                          itemCount: carouselItems.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final timetablelist item = carouselItems[index];
                            return stutimetableadapter(
                              timetableimage: item.timetableimage,
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
