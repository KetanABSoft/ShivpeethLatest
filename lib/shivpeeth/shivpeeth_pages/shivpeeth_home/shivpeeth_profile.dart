import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_Authentication/shivpeeth_login.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class loginprofile extends StatefulWidget {
  const loginprofile({super.key});

  @override
  State<loginprofile> createState() => loginprofileState();
}

class loginprofileState extends State<loginprofile> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  
String? name="";
  String? birthday="";
  String? email="";
  String? religion="";
  String? blood_group="";
  String? mobileno="";
  String? permanent_address="";
  String? role="";
  String? id;
  String? photo;
 
  String? roleid;

  Future<void> onbackpressed() async {
    return await showDialog(
        builder: (context) => AlertDialog(
              title: Center(
                child: Text("Prashala",
                    textAlign: TextAlign.end,
                    style: sansproSemibold.copyWith(fontSize: 18)),
              ),
              content: Text(
                "Are_You_sure_to_logout_from_this_app".tr,
                style: sansproRegular.copyWith(fontSize: 13),
              ),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: WireframeColor.appcolor),
                    onPressed: () {
                     // Get.back();
                      Navigator.pop(context, 'Cancel');
                     
                    },
                    child: Text(
                      "No",
                      style:
                          sansproSemibold.copyWith(color: WireframeColor.white),
                    )),
                ElevatedButton(
                  onPressed: () {
                    logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: WireframeColor.appcolor),
                  child: Text("Yes",
                      style: sansproSemibold.copyWith(
                          color: WireframeColor.white)),
                )
              ],
            ),
        context: context);
  }

  
  
@override
  void initState() {
    super.initState();
    getprofile();
  }
  

  Future logout(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove('id');
  preferences.remove('user_id');
  preferences.remove('role');
  preferences.remove('branch_id');
  preferences.remove('session_id');
  await preferences.clear();
  Fluttertoast.showToast(
    backgroundColor: Colors.green,
    textColor: Colors.white,
    msg: 'Logout Successfully.',
    toastLength: Toast.LENGTH_SHORT,
  );
   //SystemNavigator.pop();
    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        
                        //return const WireframeSplash();
                        return const WireframeLogin();
                      },
                    ));
}
 Future<void> getprofile() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
      roleid = preferences.getString('role');
       id = preferences.getString('id');
       if(id==""){
        Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        
                        //return const WireframeSplash();
                        return const WireframeLogin();
                      }, ));
       }
  try {
   //SharedPreferences preferences = await SharedPreferences.getInstance();
    
    String apiUrl = AppString.constanturl + 'Getloginprofiledata';
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'id': id != null ? id.toString() : "", 
        'role': roleid != null ? roleid.toString() : "", 
      },
    );

    var jsondata = jsonDecode(response.body);
    setState(() {
    name = jsondata['name']?? '';
    birthday = jsondata['birthday']?? '';
    email = jsondata['email']?? '';
    religion = jsondata['religion']?? '';
    blood_group = jsondata['blood_group']?? '';
    mobileno = jsondata['mobileno']?? '';
    permanent_address = jsondata['permanent_address']?? '';
    birthday = jsondata['birthday']?? '';
    role = jsondata['role']?? '';
    photo = jsondata['photo'];
    
    
      
      
    });
   
   
  } catch (e) {
    print('Error parsing date: $e');
    // Handle the error or throw it again if needed
    throw e;
  }
}

// Future<bool> doesImageExist(String role, String photo) async {
//   print(photo.toString());
//   String imageUrl = role == "Student"
//       ? AppString.studentimageurl + photo
//       : AppString.staffimageurl + photo;
    
//   try {
//     final response = await http.head(Uri.parse(imageUrl));
//       print(response.statusCode.toString());  
//     // Check if the HTTP status code is 200 and the image exists in the database
//     if (response.statusCode == 200) {
//       // You may add additional checks based on the database information here
//       return true;
//     } else {
//       return false;
//     }
//   } catch (e) {
//     // Handle exceptions (e.g., network issues)
//     return false;
//   }
// }

 Future<bool> doesImageExist(String role, String photo) async {
       String imageUrl = role == "Student"
      ? AppString.studentimageurl + photo
      : AppString.staffimageurl + photo;
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
              Text("My Profile",style: sansproRegular.copyWith(fontSize: 18,color: WireframeColor.white,),),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    
                    onbackpressed();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: WireframeColor.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: height / 150),
                      child: Column(
                        children: [
                          Image.asset(
                            WireframePngimage.iclogout,
                            height: 26,
                            width: 26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
     body:
      SingleChildScrollView(
        child:
         Padding(
          padding:  EdgeInsets.only(top: height/36),
          child: Container(
            decoration:  BoxDecoration(
                color: themedata.isdark ? WireframeColor.black : WireframeColor.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
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
                               // color: WireframeColor.textgray,
                              ),
                              

                                      child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: photo.toString() != ""
                        ? FutureBuilder(
                            future: doesImageExist(role.toString(), photo.toString()),
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
                                    role.toString() == "Student"
                                        ? AppString.studentimageurl + photo.toString()
                                        : AppString.staffimageurl + photo.toString(),
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
                                  hintText: role.toString(),
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
                   Padding(
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
                              fontSize: 16, color: themedata.isdark ? WireframeColor.white : WireframeColor.black),
                          cursorColor: themedata.isdark ? WireframeColor.white : WireframeColor.black,
                          decoration: InputDecoration(
                            hintText: blood_group.toString(),
                            
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