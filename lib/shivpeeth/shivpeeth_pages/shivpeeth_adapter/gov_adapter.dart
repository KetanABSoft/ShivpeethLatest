import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:url_launcher/url_launcher.dart';

class govadapter extends StatefulWidget {
  final String id;
  final String title;
  final String linkdata;
  final bool? isLast;
    final double opacity;
  const govadapter({
    required this.id,
    required this.title,
    required this.linkdata,
    this.isLast = false,
     required this.opacity,
    super.key});

  @override
  State<govadapter> createState() => govadapterState();
}

class govadapterState extends State<govadapter> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;

 
_launchURL(String url) async {
  
        try {
      await launch(url);
    } catch (e) {
      print('Error launching URL: $e');
    }

    
  }
  @override
  Widget build(BuildContext context) {
    final themedata = Get.put(WireframeThemecontroler());
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return 
    // Padding(
    //     padding: EdgeInsets.only(top: height / 40),
    //     child: 
        Container(
          decoration: BoxDecoration(
              color: themedata.isdark
                  ? WireframeColor.black
                  : WireframeColor.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: 
         
              
                  Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               SizedBox(
                                width: width/1.2,
                                child:
                              Text(
                                widget.title.toString(),
                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                              ),
                              ),
                              SizedBox(
                                height: height / 200,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(widget.linkdata.toString());
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    widget.linkdata.toString(),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blue),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 200,
                              ),
                            ],
                          ),
                           const Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: height / 120,
                      ),
                      const Divider(
                        color: WireframeColor.textgray,
                      ),
                      SizedBox(
                        height: height / 120,
                      ),
                     
                     
                    ],
                  ),
                  // },
              //   ],
              // )
              // ),
        );
      //);
  }
}