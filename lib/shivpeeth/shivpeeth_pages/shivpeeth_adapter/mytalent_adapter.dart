import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/mytalent_fullpage.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:get/get.dart';
class mytalentadapter extends StatefulWidget {
  final String?id;
  final String?title;
  final String?image;
 
  const mytalentadapter({
    this.id,
    this.title,
    this.image,
  
    super.key});

  @override
  State<mytalentadapter> createState() => mytalentadapterState();
}

class mytalentadapterState extends State<mytalentadapter> {
   dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());

  @override
  void initState() {
    super.initState();
    
  }
 
   @override
      Widget build(BuildContext context) {
        size = MediaQuery.of(context).size;
        height = size.height;
        width = size.width;
        return Container(
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
                    SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () {
                         Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return mytalentfullpage(title: widget.title.toString(),image:widget.image.toString(),);
                            },
                          ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Button color
                      ),
                      child: Row(
                        children: [
                           Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                              size: height / 30,
                                ),
                          SizedBox(width: 8), // Adjust the spacing between icon and text
                          Text('View',
                          style: TextStyle(color:Colors.white),),
                        ],
                      ),
                    ),
                  ],
                )
           
         ],
            ),
          ));
      }





}