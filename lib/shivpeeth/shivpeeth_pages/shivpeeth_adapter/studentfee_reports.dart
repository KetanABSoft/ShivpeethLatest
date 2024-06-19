import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';

class adapterstudentfeereport extends StatefulWidget {
  final String due_date;
  final String totalamount;
  final String paidamount;
  final String month;
  final String paymentmode;
  final String status;
  final String discountamount;
  final String paymentdate;
  const adapterstudentfeereport({
    required this.due_date,
    required this.totalamount,
    required this.paidamount,
    required this.month,
    required this.paymentmode,
    required this.status,
    required this.discountamount,
    required this.paymentdate,
    super.key});

  @override
  State<adapterstudentfeereport> createState() => adapterstudeState();
}

class adapterstudeState extends State<adapterstudentfeereport> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  @override
  Widget build(BuildContext context) {
        size = MediaQuery.of(context).size;
        height = size.height;
        width = size.width;
    return Container(
                        margin: EdgeInsets.only(bottom: height/36),
                        decoration:  BoxDecoration(
                            border: Border.all(color: WireframeColor.bggray),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/56),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             
                              Row(
                                children: [
                                  Text("Due Date",style: sansproRegular.copyWith(fontSize: 14,color: WireframeColor.appgray,),),
                                  const Spacer(),
                                  Text(widget.due_date,style: sansproSemibold.copyWith(fontSize: 14,),),
                                ],
                              ),
                              SizedBox(height:10,),
                               Row(
                                children: [
                                  Text("Month",style: sansproRegular.copyWith(fontSize: 14,color: WireframeColor.appgray,),),
                                  const Spacer(),
                                  Text(widget.month,style: sansproSemibold.copyWith(fontSize: 14,),),
                                ],
                              ),
                              
                              SizedBox(height:10,),

                              Row(
                                children: [
                                  Text("Payment Date",style: sansproRegular.copyWith(fontSize: 14,color: WireframeColor.appgray,),),
                                  const Spacer(),
                                  Text(widget.paymentdate,style: sansproSemibold.copyWith(fontSize: 14,),),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text("Total Amount",style: sansproRegular.copyWith(fontSize: 14,color: WireframeColor.appgray,),),
                                  const Spacer(),
                                  Text(widget.totalamount,style: sansproSemibold.copyWith(fontSize: 14,),),
                                ],
                              ),
                               SizedBox(height:10,),
                               Row(
                                children: [
                                  Text("Paid Amount",style: sansproRegular.copyWith(fontSize: 14,color: WireframeColor.appgray,),),
                                  const Spacer(),
                                  Text(widget.paidamount,style: sansproSemibold.copyWith(fontSize: 14,),),
                                ],
                              ),
                               SizedBox(height:10,),

                               
                               Row(
                                children: [
                                  Text("Discount Amount",style: sansproRegular.copyWith(fontSize: 14,color: WireframeColor.appgray,),),
                                  const Spacer(),
                                  Text(widget.discountamount,style: sansproSemibold.copyWith(fontSize: 14,),),
                                ],
                              ),
                               SizedBox(height:10,),
                              Row(
                                children: [
                                  Text("Payment Mode",style: sansproRegular.copyWith(fontSize: 14,color: WireframeColor.appgray,),),
                                  const Spacer(),
                                  Text(widget.paymentmode,style: sansproSemibold.copyWith(fontSize: 14,),),
                                ],
                              ),
                              SizedBox(height: height/36,),
                              Container(
                                width: width/1,
                                height: height/18,
                                decoration:  BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [ WireframeColor.appcolor,WireframeColor.bootomcolor],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.status
                                      ,
                                    style: sansproSemibold.copyWith(
                                        fontSize: 16, color: WireframeColor.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      );
  }
}