import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/mytalent_adapter.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class mytalentlist {
  final String id;
  final String title;
  final String image;

  

  mytalentlist(
      {required this.id,
      required this.title,
      required this.image,
     

      
      
      });

  factory mytalentlist.fromJson(Map<String, dynamic> json) {
    return mytalentlist(
      id: json['id'],
      title: json['title'].toString(),
      image: json['image'].toString(),
     
    
    );
  }
}
class mytalent extends StatefulWidget {
  const mytalent({super.key});

  @override
  State<mytalent> createState() => mytalentState();
}

class mytalentState extends State<mytalent> {
     List<mytalentlist> carouselItems = [];
dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  String? branch_id;
  @override
void initState() {
  super.initState();
searchfilter();
}


 Future<void> searchfilter(
     ) async {
    
     SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');


    String apiUrl = AppString.constanturl + 'Mytalent';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "branch_id":'$branch_id',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<mytalentlist> items = [];

      for (var item in jsonData) {
        items.add(mytalentlist.fromJson(item));
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
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    

    return Scaffold(
      backgroundColor: WireframeColor.appcolor,
      appBar: AppBar(
        leadingWidth:width/1 ,
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
                  child: Icon(Icons.arrow_back_ios_new,size: height/36,color: WireframeColor.white,)),
              SizedBox(width: width/36,),
              Text("My Talents",style: sansproRegular.copyWith(fontSize: 18,color: WireframeColor.white,),),

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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                       bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 26, vertical: height / 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        carouselItems.length > 0
                            ? ListView.builder(
                                itemCount: carouselItems.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final mytalentlist item = carouselItems[index];
                                  return mytalentadapter(
                                    id: item.id,
                                    title: item.title,
                                    image: item.image,
                                   
                                    
                                  );
                                },
                              )
                            : Container( 
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
            )
            , 
    );
  }
}