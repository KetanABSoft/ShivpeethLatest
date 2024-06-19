import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/gr_adapter.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';


class grlistdata {
  final String id;
  final String timetableimage;
  final String titlename;
  
 
  

  grlistdata(
      {required this.id,
      required this.timetableimage,
      required this.titlename,


 

      
      
      });

  factory grlistdata.fromJson(Map<String, dynamic> json) {
    return grlistdata(
      id: json['id'],
      timetableimage: json['imagepdf'],
      titlename: json['title'],
     
      
    
    );
  }
}
class grlist extends StatefulWidget {
  const grlist({super.key});

  @override
  State<grlist> createState() => grlistState();
}



class grlistState extends State<grlist> {
   double height = 0.00;
  double width = 0.00;
   List<grlistdata> carouselItems = [];
  String ?branch_id;

 @override
  void initState() {
    super.initState();
  
    getgrdata();
  }
   Future<void> getgrdata() async {

   
   //  final response = await http.get(Uri.parse(AppString.constanturl + 'Get_Grdetails'));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');

     var urlString = AppString.constanturl + 'Get_Grdetails';
    Uri uri = Uri.parse(urlString);

    var response = await http.post(uri, body: {
      "branch_id":'$branch_id',
    });
    
          
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      List<grlistdata> items = [];

      for (var item in jsonData) {
         if(item['imagepdf']!=""){
        items.add(grlistdata.fromJson(item));
         }
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
                "G.R",
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
          padding: EdgeInsets.only(top: height / 39,bottom: 5),
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
                
                         // SizedBox(height: 10,),
                        carouselItems.length > 0
                            ? ListView.builder(
                                itemCount: carouselItems.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                 final grlistdata item = carouselItems[index];
                                  return gradapter(
                                    imagepdf: item.timetableimage,
                                    title: item.titlename,
                                  
                                  );
                                },
                              )
                            :Container( 
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
        ),
      ),
      
    );
  }
}