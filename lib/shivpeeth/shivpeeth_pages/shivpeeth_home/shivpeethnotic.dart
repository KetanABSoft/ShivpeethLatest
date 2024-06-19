import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/notice_adapter.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';



class notilist {
  final String id;
  final String titledata;
  final String remarkdata;
  final String startdate;
  final String document;
 
  

  notilist(
      {required this.id,
      required this.titledata,
      required this.remarkdata,
      required this.startdate,
      required this.document,

 

      
      
      });

  factory notilist.fromJson(Map<String, dynamic> json) {
    return notilist(
      id: json['id'],
      titledata: json['title'],
      remarkdata: json['remark'],
      startdate: json['start_date'],
      document: json['document'],
      
    
    );
  }
}
class WireframeEvents extends StatefulWidget {
  const WireframeEvents({super.key});

  @override
  State<WireframeEvents> createState() => _WireframeEventsState();
}

class _WireframeEventsState extends State<WireframeEvents> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
 List<notilist> carouselItems = [];
   String ?branch_id;

@override
void initState() {
  super.initState();
  noticedata();
}

 Future<void> noticedata() async {
SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');

     //final response = await http.get(Uri.parse(AppString.constanturl + 'Notice_showdata'));

   var urlString = AppString.constanturl + 'Notice_showdata';
    Uri uri = Uri.parse(urlString);

    var response = await http.post(uri, body: {
      "branch_id":'$branch_id',
    });
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<notilist> items = [];

      for (var item in jsonData) {
        items.add(notilist.fromJson(item));
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
    size = MediaQuery
        .of(context)
        .size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: WireframeColor.appcolor,
      appBar: AppBar(
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
                "Notice",
                style: sansproRegular.copyWith(
                  fontSize: 18,
                  color: WireframeColor.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body:SingleChildScrollView(
       child:Padding(
        padding: EdgeInsets.only(top: height / 36,bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              color: themedata.isdark ? WireframeColor.black : WireframeColor.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20),bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20))),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width / 26, vertical: height / 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  carouselItems.length > 0
                            ?
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: carouselItems.length,
                  itemBuilder: (context, index) {
                    final notilist item = carouselItems[index];
                                  return Commonnoticelist(
                                    titledata: item.titledata,
                                    remarkdata: item.remarkdata,
                                    assignedate: item.startdate,
                                    document: item.document,
                                    opacity: 1,
                                    isLast: index == carouselItems.length - 1,
                                  );
                  },
                ): Container( 
                              height: 300,
                              child:Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("No record found"),
                            ),
                          ),)
              ],
            ),
          ),
        ),
      ),),
    );
  }
}
