import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:get/get.dart';
class lessonadapter extends StatefulWidget {
  final String?subjectname;
  final String?datename;
  final String?time;
  final String?description;
  final String?days;
  final String?month;
  const lessonadapter({
    this.subjectname,
    this.datename,
    this.time,
    this.description,
    this.days,
    this.month,
    super.key});

  @override
  State<lessonadapter> createState() => lessonadapterState();
}

class lessonadapterState extends State<lessonadapter> {
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
        
        return Column(
                        children: [
                    Row(
                            children: [
                              Column(
                                children: [
                                  Text(widget.datename.toString(),style: sansproBold.copyWith(fontSize: 26),),
                                  Text(widget.month.toString(),style: sansproSemibold.copyWith(fontSize: 13),),
                                ],
                              ),
                              SizedBox(width: width/20,),
                            Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.subjectname.toString(), style: sansproSemibold.copyWith(fontSize: 16)),
                          SizedBox(height: height / 200),
                          Text(widget.days.toString(), style: sansproRegular.copyWith(fontSize: 12, color: WireframeColor.textgray)),
                          
                        ],
                      ),

                              const Spacer(),
                              Icon(Icons.watch_later_outlined,size: height/36,color: WireframeColor.textgray,),
                              SizedBox(width: width/56,),
                              Text(widget.time.toString(),
                              style: sansproRegular.copyWith(fontSize: 13,color: WireframeColor.textgray),
                              ),
                            ],
                          ) ,

                          Row(
                            children: [
                              // Spacer(),
                               SizedBox(width: 50,), 
                                Container(
                        child:  Column(
                        children: [
                              SizedBox(
                                          width: width/1.3,
                                          child: Text(
                                          "Description : "+widget.description.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 7,
                                            textAlign: TextAlign.justify, // Set text justification
                                            style: sansproRegular.copyWith(
                                                fontSize: 12,
                                                color: WireframeColor.textgray),
                                          ),
                                        ),             
                         ],
                         ),)
                          ]),
                          SizedBox(height: height/120,),
                          const Divider(color: WireframeColor.textgray,indent: 45),
                          SizedBox(height: height/120,),
                        ],
                      );
      }





}