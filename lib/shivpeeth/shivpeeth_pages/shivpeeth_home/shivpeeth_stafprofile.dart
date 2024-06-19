import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
class staff_profiledata extends StatefulWidget {
   final String ?staffid;
  const staff_profiledata({
    required this.staffid,
    super.key});

  @override
  State<staff_profiledata> createState() => staff_profiledataState();
}

class staff_profiledataState extends State<staff_profiledata> {
   dynamic size;
  double height = 0.00;
  double width = 0.00;
  String? name;
  String? birthday;
  String? email;
  String? joining_date;
  String? permanent_address;
  String? present_address;
  String? total_experience;
  String? experience_details;
  String? sex;
  String? department_name;
  String? role;
  String? designation_name;
  String? mobileno;
  String? qualification;
  String? photo;
  final themedata = Get.put(WireframeThemecontroler());


@override
  void initState() {
    super.initState();
  
    getprofile(widget.staffid.toString());
  }

 Future<void> getprofile(staffid) async {
 

  try {
   
    String apiUrl = AppString.constanturl + 'Get_staffprofiledata';
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'id': staffid != null ? staffid.toString() : "", 
      },
    );

    var jsondata = jsonDecode(response.body);
    setState(() {
    name = jsondata['name'];
    birthday = jsondata['birthday'];
    email = jsondata['email'];
    joining_date = jsondata['joining_date'];
    permanent_address = jsondata['permanent_address'];
    total_experience = jsondata['total_experience'];
    experience_details = jsondata['experience_details'];
    sex = jsondata['sex'];
    department_name = jsondata['department_name'];
    role = jsondata['role'];
    designation_name = jsondata['designation_name'];
    mobileno = jsondata['mobileno'];
    qualification = jsondata['qualification'];
    photo = jsondata['photo'];
      
      
    });
   
   
  } catch (e) {
    print('Error parsing date: $e');
    // Handle the error or throw it again if needed
    throw e;
  }
}
 
 
  Future<bool> doesImageExist( String photo) async {
       String imageUrl =  AppString.staffimageurl + photo;
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
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: WireframeColor.appcolor,
      appBar: AppBar(
        backgroundColor: WireframeColor.appcolor,
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
              Text("Profile",style: sansproRegular.copyWith(fontSize: 18,color: WireframeColor.white,),),
              const Spacer(),
             
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(top: height/36),
          child: Container(
            decoration:  BoxDecoration(
                color: themedata.isdark ? WireframeColor.black : WireframeColor.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: width/26,vertical: height/36),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: WireframeColor.appcolor),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child:  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/66),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: height / 10,
                              height: height / 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: WireframeColor.textgray,
                              ),
                              // child: Padding(
                              //   padding: EdgeInsets.all(10.0), // Adjust the margin as needed
                              //   child: Image.asset(
                              //     WireframePngimage.profile, // replace with your actual image path
                              //     width: 20,
                              //     height: 20,
                              //   ),
                              // ),

                              child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: photo.toString() != ""
                        ? FutureBuilder(
                            future: doesImageExist( photo.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasError || snapshot.data != true) {
                                  // Handle error or image not found case
                                  return Image.asset(
                                    WireframePngimage.profilepage,
                                    width: 20,
                                    height: 20,
                                  );
                                } else {
                                  // Display the valid image
                                  return Image.network(
                                     AppString.staffimageurl + photo.toString()
                                       ,
                                    width: 20,
                                    height: 20,
                                  );
                                }
                              } else {
                                // Show a loading indicator while checking for image existence
                                return CircularProgressIndicator();
                              }
                            },
                          )
                        : Image.asset(
                            WireframePngimage.profilepage,
                            width: 20,
                            height: 20,
                          ),
                  )
                            ),
                          SizedBox(width: width/36,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name.toString(),style: sansproBold.copyWith(fontSize: 15,),),
                              SizedBox(height: height/96,),
                              Text(role.toString(),style: sansproRegular.copyWith(fontSize: 18,color: WireframeColor.textgray,),),
                            ],
                          ),
                          const Spacer(),
                         // Icon(Icons.camera_alt_outlined,size: height/30,color: WireframeColor.appgray,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height/36,),
                  Row(
                    children: [
                      SizedBox(
                        width: width/2.3,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height / 46,
                              bottom: height / 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender",
                                style: sansproRegular.copyWith(
                                    fontSize: 12, color: WireframeColor.textgray),
                              ),
                              TextField(
                                enabled: false,
                                 readOnly: true,
                                style: sansproRegular.copyWith(
                                    fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                cursorColor: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                                decoration: InputDecoration(
                                  hintText: sex.toString(),

                                  hintStyle:sansproRegular.copyWith(
                                      fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: width/2.3,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height / 46,
                              bottom: height / 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mobile No",
                                style: sansproRegular.copyWith(
                                    fontSize: 12, color: WireframeColor.textgray),
                              ),
                              TextField(
                                enabled: false,
                                 readOnly: true,
                                style: sansproRegular.copyWith(
                                    fontSize: 16, color:themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                cursorColor: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                                decoration: InputDecoration(
                                  hintText: mobileno.toString(),

                                  hintStyle:sansproRegular.copyWith(
                                      fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height/96,),
                  Row(
                    children: [
                      SizedBox(
                        width: width/2.3,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height / 46,
                              bottom: height / 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Designation",
                                style: sansproRegular.copyWith(
                                    fontSize: 12, color: WireframeColor.textgray),
                              ),
                              TextField(
                                enabled: false,
                                 readOnly: true,
                                style: sansproRegular.copyWith(
                                    fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                cursorColor: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                                decoration: InputDecoration(
                                  hintText: designation_name.toString(),
                                  hintStyle:sansproRegular.copyWith(
                                      fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: width/2.3,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height / 46,
                              bottom: height / 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Birthdate",
                                style: sansproRegular.copyWith(
                                    fontSize: 12, color: WireframeColor.textgray),
                              ),
                              TextField(
                                enabled: false,
                                 readOnly: true,
                                style: sansproRegular.copyWith(
                                    fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                cursorColor:themedata.isdark ? WireframeColor.white : WireframeColor.black,
                                decoration: InputDecoration(
                                  hintText: birthday.toString(),
                                
                                  hintStyle:sansproRegular.copyWith(
                                      fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height/96,),
                  Row(
                    children: [
                      SizedBox(
                        width: width/2.3,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height / 46,
                              bottom: height / 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Qualification",
                                style: sansproRegular.copyWith(
                                    fontSize: 12, color: WireframeColor.textgray),
                              ),
                              TextField(
                                enabled: false,
                                 readOnly: true,
                                style: sansproRegular.copyWith(
                                    fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                cursorColor: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                                decoration: InputDecoration(
                                  hintText: qualification.toString(),
                                  hintStyle:sansproRegular.copyWith(
                                      fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: width/2.3,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height / 46,
                              bottom: height / 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Department",
                                style: sansproRegular.copyWith(
                                    fontSize: 12, color: WireframeColor.textgray),
                              ),
                              TextField(
                                enabled: false,
                                 readOnly: true,
                                style: sansproRegular.copyWith(
                                    fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                cursorColor: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                                decoration: InputDecoration(
                                  hintText: department_name.toString(),
                                 
                                  hintStyle:sansproRegular.copyWith(
                                      fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height/96,),
                   Row(
                    children: [
                      SizedBox(
                        width: width/2.3,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height / 46,
                              bottom: height / 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date Of Joining",
                                style: sansproRegular.copyWith(
                                    fontSize: 12, color: WireframeColor.textgray),
                              ),
                              TextField(
                                enabled: false,
                                 readOnly: true,
                                style: sansproRegular.copyWith(
                                    fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                cursorColor: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                                decoration: InputDecoration(
                                  hintText: joining_date.toString(),
                                  hintStyle:sansproRegular.copyWith(
                                      fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                 
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: width/2.3,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height / 46,
                              bottom: height / 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Experience",
                                style: sansproRegular.copyWith(
                                    fontSize: 12, color: WireframeColor.textgray),
                              ),
                              TextField(
                                enabled: false,
                                 readOnly: true,
                                style: sansproRegular.copyWith(
                                    fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                cursorColor: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                                decoration: InputDecoration(
                                  hintText: total_experience.toString(),
                                  
                                  hintStyle:sansproRegular.copyWith(
                                      fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: WireframeColor.bggray),
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height/96,),

                   Padding(
                    padding: EdgeInsets.only(
                        top: height / 46,
                        bottom: height / 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: sansproRegular.copyWith(
                              fontSize: 12, color: WireframeColor.textgray),
                        ),
                        TextField(
                          enabled: false,
                                 readOnly: true,
                          style: sansproRegular.copyWith(
                              fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                          cursorColor: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                          decoration: InputDecoration(
                            hintText: email.toString(),
                            
                            hintStyle:sansproRegular.copyWith(
                                fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: WireframeColor.bggray),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: WireframeColor.bggray),
                            ),
                          ),

                        )
                      ],
                    ),
                  ),
                  SizedBox(height: height/96,),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height / 46,
                        bottom: height / 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Permanent Address",
                          style: sansproRegular.copyWith(
                              fontSize: 12, color: WireframeColor.textgray),
                        ),
                        TextField(
                          enabled: false,
                                 readOnly: true,
                          style: sansproRegular.copyWith(
                              fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                          cursorColor: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                          decoration: InputDecoration(
                            hintText: permanent_address.toString(),
                            
                            hintStyle:sansproRegular.copyWith(
                                fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: WireframeColor.bggray),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: WireframeColor.bggray),
                            ),
                          ),

                        )
                      ],
                    ),
                  ),
                 
                 
                ],
              ),
            ),
          ),
        ),
      ) ,
    );
  }
}