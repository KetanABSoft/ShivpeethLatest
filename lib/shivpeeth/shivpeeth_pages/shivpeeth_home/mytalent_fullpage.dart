import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class mytalentfullpage extends StatefulWidget {
   final String title;
   final String image;
  const mytalentfullpage({
    required this.title,
    required this.image,
    super.key});

  @override
  State<mytalentfullpage> createState() => mytalentfullpageState();
}

class mytalentfullpageState extends State<mytalentfullpage> {
 dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());

Future<bool> doesImageExist( String photo) async {
       String imageUrl =  AppString.imageurltalent + photo;
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
        print(widget.image);
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
             // Text("My Talents",style: sansproRegular.copyWith(fontSize: 18,color: WireframeColor.white,),),

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
                        
                         Container(
            margin: EdgeInsets.only(top: 10, bottom: 10), // Adjust the values as needed
         decoration: BoxDecoration(
            border: Border.all(color: WireframeColor.bggray),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                      widget.title.toString(),
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,),
                    ),
                    ),
                    // Text(
                    //   widget.title.toString(),
                    //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),
                    // ),  
                  ],
                ),

                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 5), 
                width: width/1.2,
                height: 200.0,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                image: NetworkImage(
                  AppString.imageurltalent + widget.image.toString(),
                ),
               fit: BoxFit.fitWidth,
                )
                ),
                    ),
                  ],
                ),
                Row(children: [
                   Image.asset(
                                  WireframePngimage.likeimage,                                    
                              
                                )
                ],)
           
         ],
            ),
          )),

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