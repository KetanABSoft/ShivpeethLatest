import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/studentfee_reports.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';

class feereportlist {
  final String status;
  final String monthName;
  final String due_date;
  final String name;
  final String totalamount;
  final String paidamount;
  final String paymentmethode;
  final String discountamount;
  final String paymentdate;

  feereportlist({
    required this.status,
    required this.monthName,
    required this.due_date,
    required this.name,
    required this.totalamount,
    required this.paidamount,
    required this.paymentmethode,
    required this.discountamount,
    required this.paymentdate,
  });

  factory feereportlist.fromJson(Map<String, dynamic> json) {
    return feereportlist(
      status: json['status'].toString(),
      monthName: json['monthName'].toString(),
      due_date: json['due_date'].toString(),
      name: json['name'].toString(),
      totalamount: json['totalamount'].toString(),
      paidamount: json['paidamount'].toString(),
      paymentmethode: json['paymentmethode'].toString(),
      discountamount: json['discountamount'].toString(),
      paymentdate: json['paymentdate'].toString(),
    );
  }
}

class studentfeereportpersonal extends StatefulWidget {
  const studentfeereportpersonal({super.key});

  @override
  State<studentfeereportpersonal> createState() => studentfeereportState();
}

class studentfeereportState extends State<studentfeereportpersonal> {
  double height = 0.00;
  double width = 0.00;
  List<feereportlist> carouselItems = [];
  String? roleid;
  String? userid;
  String? branch_id;
  String? session_id;
  @override
  void initState() {
    super.initState();
    studentfeereport();
  }

  Future<void> studentfeereport() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    roleid = preferences.getString('role');
    userid = preferences.getString('id');
    branch_id = preferences.getString('branch_id');
    session_id = preferences.getString('session_id');
    print(userid);
    print(session_id);
    String apiUrl = AppString.constanturl + 'Fetch_studentfeesdata';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "id": userid != null ? userid : 'userid',
        "branch_id": branch_id != null ? branch_id : '',
        "session_id": session_id != null ? session_id : '',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<feereportlist> items = [];
      print(jsonData);
      for (var item in jsonData) {
        items.add(feereportlist.fromJson(item));
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
                "Fees Status",
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
          padding: EdgeInsets.only(top: height / 39),
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
                horizontal: width / 26,
                vertical: height / 36,
              ),
              child: Column(
                children: [
                  carouselItems.length > 0
                      ? ListView.builder(
                          itemCount: carouselItems.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final feereportlist item = carouselItems[index];
                            return adapterstudentfeereport(
                              due_date: item.due_date,
                              totalamount: item.totalamount,
                              paidamount: item.paidamount,
                              month: item.monthName,
                              paymentmode: item.paymentmethode,
                              status: item.status,
                              discountamount: item.discountamount,
                              paymentdate: item.paymentdate,
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
