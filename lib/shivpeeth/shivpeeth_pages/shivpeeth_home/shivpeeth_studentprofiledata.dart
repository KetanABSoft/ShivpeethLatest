import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
class studentprofiledata extends StatefulWidget {
   final String ?studid;
  const studentprofiledata({
    required this.studid,
    super.key});

  @override
  State<studentprofiledata> createState() => studentprofiledataState();
}

class studentprofiledataState extends State<studentprofiledata> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
final themedata = Get.put(WireframeThemecontroler());
  String? name;
  String? birthday;
  String? email;
  String? classname;
  String? roleno;
  String? sex;
  String? mobileno;
  String? AcademicYear;
  String? AdmissionDate;
  String? mothername;
  String? fathername;
  String? permanent_address;
  String? section;
  String? bloodgroup;
  String? adminssionno;
  String? religion;
  String? caste;
  String? photo;

  
  @override
  void initState() {
    super.initState();
  
    getprofile(widget.studid.toString());
  }

 Future<void> getprofile(studid) async {
 

  try {
   
    String apiUrl = AppString.constanturl + 'Get_studentprofile_data';
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'id': studid != null ? studid.toString() : "", 
      },
    );

    var jsondata = jsonDecode(response.body);
    setState(() {
    adminssionno = jsondata['adminssionno'];
    AdmissionDate = jsondata['AdmissionDate'];
    name = jsondata['name'];
    birthday = jsondata['birthday'];
    email = jsondata['email'];
    classname = jsondata['classname'];
    roleno = jsondata['roleno'];
    AcademicYear = jsondata['AcademicYear'];
    sex = jsondata['sex'];
    mothername = jsondata['mother_name'];
    fathername = jsondata['father_name'];
    mobileno = jsondata['mobileno'];
    permanent_address = jsondata['permanent_address'];
    bloodgroup = jsondata['blood_group'];
    religion = jsondata['religion'];
    caste = jsondata['caste'];
    photo = jsondata['photo'];
      
      
    });
   
   
  } catch (e) {
    print('Error parsing date: $e');
    // Handle the error or throw it again if needed
    throw e;
  }
}

 Future<bool> doesImageExist( String photo) async {
       String imageUrl =  AppString.studentimageurl + photo;
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
              Text("Student Profile",style: sansproRegular.copyWith(fontSize: 18,color: WireframeColor.white,),),
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
                          // Container(
                          //   width: height/10,
                          //   height: height/10,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(20),
                          //     color: WireframeColor.textgray
                          //   ),
                          // ),

                         Container(
                              width: height / 10,
                              height: height / 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                //color: WireframeColor.textgray,
                              ),
                            //   child: 
                            //   Padding(
                            //     padding: EdgeInsets.all(10.0), // Adjust the margin as needed
                            //    child: Image.asset(
                            //       WireframePngimage.profilepage, // replace with your actual image path
                            //       width: 20,
                            //       height: 30,
                            //     ),
                            //   ),

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
                                     AppString.studentimageurl + photo.toString()
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
                               SizedBox(height:5),
                              Text(name.toString(),style: sansproBold.copyWith(fontSize: 15,),),
                              SizedBox(height: 10),
                              Text("Class: "+classname.toString()+" | Roll No: "+roleno.toString(),style: sansproRegular.copyWith(fontSize: 18,color: WireframeColor.textgray,),),
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
                                "Academic Year",
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
                                  hintText: AcademicYear.toString(),

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
                                "Admission Date ",
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
                                  hintText: AdmissionDate.toString(),

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
                                "Admission No",
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
                                  hintText: adminssionno.toString(),

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
                                "Blood Group",
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
                                  hintText: bloodgroup.toString(),

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
                                "Religion",
                                style: sansproRegular.copyWith(
                                    fontSize: 12, color: WireframeColor.textgray),
                              ),
                              TextField(
                                enabled: false, // Make the TextField non-editable
                              readOnly: true, 
                                style: sansproRegular.copyWith(
                                    fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                                cursorColor: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                                decoration: InputDecoration(
                                  hintText: religion.toString(),
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
                                "Mother Name",
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
                                  hintText: mothername.toString(),
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
                                "Father Name",
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
                                  hintText: fathername.toString(),
                                  
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
                           maxLines: 3,
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