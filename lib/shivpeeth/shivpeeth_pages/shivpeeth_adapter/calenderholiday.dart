
import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
DecorationImage? imageset;

class Comcalenderholidaylist extends StatefulWidget {
  final String? titledata;
  final String? assignedate;
  final String? dayname;
  final bool? isLast;
    final double opacity;

  const Comcalenderholidaylist({
    Key? key,
    this.titledata,
    this.assignedate,
    this.dayname,
    this.isLast = false,
     required this.opacity,

  }) : super(key: key);

  @override
  _DetailsListWidgetState createState() => _DetailsListWidgetState();
}

class _DetailsListWidgetState extends State<Comcalenderholidaylist> {
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
                        margin: EdgeInsets.only(bottom: height / 36),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: WireframeColor.bggray)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width / 26, vertical: height / 70),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.titledata.toString(),
                                style: TextStyle(
                                fontFamily: 'sansproSemibold', // Make sure 'sansproSemibold' is the correct font family
                                fontWeight: FontWeight.w600, // Adjust the weight as needed
                                fontSize: 16,
                              ),
                              ),
                              SizedBox(
                                height: height / 96,
                              ),
                              Row(
                                children: [
                                  Text(
                                   widget.assignedate.toString(),
                                    style: sansproRegular.copyWith(
                                        fontSize: 14,
                                        color: WireframeColor.textgray),
                                  ),
                                  const Spacer(),
                                  Text(
                                    widget.dayname.toString(),
                                    style: sansproRegular.copyWith(
                                        fontSize: 14,
                                        color: WireframeColor.textgray),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
}

}
