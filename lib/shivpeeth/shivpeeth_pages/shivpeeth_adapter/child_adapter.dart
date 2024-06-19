
import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_student/shivpeeth_studentnewdashboard.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

DecorationImage? imageset;

class childcommonlist extends StatefulWidget {
  final String? name;
  final String? classname;
  final String? divsion;
  final String? rollno;
  final String? birthdate;
  final String? photo;
  final String? role;
  final String? sessionid;
  final String? branchid;
  final String? user_id;
  final String? childcount;
  final String? id;
  final bool? isLast;
    final double opacity;

  const childcommonlist({
    Key? key,
    this.name,
    this.classname,
    this.divsion,
    this.rollno,
    this.birthdate,
    this.photo,
    this.role,
    this.sessionid,
    this.branchid,
    this.id,
    this.user_id,
    this.childcount,
    this.isLast = false,
     required this.opacity,

  }) : super(key: key);

  @override
  noticewidgetstate createState() => noticewidgetstate();
}

class noticewidgetstate extends State<childcommonlist> {
   dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  @override
  void initState() {
    super.initState();
    
  }

 
Future<bool> doesImageExist( String photo) async {
       String imageUrl =  AppString.parentimageurl + photo;
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
  return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10), // Adjust the values as needed
       decoration: BoxDecoration(
                            color: WireframeColor.lightgray,
                            borderRadius: BorderRadius.circular(20),
                          ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 66),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Column(    
             mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
           Container(
            //  margin: EdgeInsets.only(top: 25),

           width: height / 10,
            height: height / 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: WireframeColor.textgray,
            ),
          
            child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: widget.photo.toString() != ""
                        ? FutureBuilder(
                            future: doesImageExist(  widget.photo.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasError || snapshot.data != true) {
                                  // Handle error or image not found case
                                  return Image.asset(
                                    WireframePngimage.profile,
                                    width: 40,
                                    height: 40,
                                  );
                                } else {
                                  // Display the valid image
                                  return Image.network(
                                     AppString.parentimageurl +  widget.photo.toString()
                                       ,
                                    width: 40,
                                    height: 40,
                                  );
                                }
                              } else {
                                // Show a loading indicator while checking for image existence
                                return CircularProgressIndicator();
                              }
                            },
                          )
                        : Image.asset(
                            WireframePngimage.profile,
                            width: 40,
                            height: 40,
                          ),
                  )
            
          ),]),
           SizedBox(width: width/36,),
           Expanded( child:  Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(
                  width: width/1.5,
                  child: Text(
                  widget.name.toString(),
                  maxLines: 2,
                  
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: WireframeColor.appcolor),
                   ),), 
            
              SizedBox(height: 5),
             

             
                               Row(
                                          children: [
                                             Text(
                                         "Roll :", 
                                          style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,  
                                          color: WireframeColor.black,  
                                          
                                        ),
                                        ),
                                            SizedBox(width: 5,),
                                            Text(
                                             widget.rollno.toString(),
                                             style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,  
                                          color: WireframeColor.black,  
                                          
                                        ),
                                            ),
                                          ],
                                        ),
               SizedBox(height: 5,),

                                    Row(
                          children: [
                            Text(
                              "Class :", 
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,  
                                color: WireframeColor.black,  
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Container( // Wrap the Text with Container to control width
                                constraints: BoxConstraints(maxWidth: 150), // Adjust the width as per your need
                                child: Text(
                                  widget.classname.toString(),
                                  maxLines: 3, // Set to 1 line to prevent overflowing
                                  overflow: TextOverflow.ellipsis, // Overflow handling
                                  style: sansproSemibold.copyWith(
                                    fontSize: 15,
                                    color: WireframeColor.black
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                    ,
                             SizedBox(height: 5,),
              

                                       Row(
                                          children: [
                                             Text(
                                         "Section :", 
                                          style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,  
                                          color: WireframeColor.black,  
                                          
                                        ),
                                        ),
                                            SizedBox(width: 5,),
                                          
                                Expanded(
                              child: Container( // Wrap the Text with Container to control width
                                constraints: BoxConstraints(maxWidth: 150), // Adjust the width as per your need
                                child: Text(
                                  widget.divsion.toString(),
                                  maxLines: 3, // Set to 1 line to prevent overflowing
                                  overflow: TextOverflow.ellipsis, // Overflow handling
                                  style: sansproSemibold.copyWith(
                                    fontSize: 15,
                                    color: WireframeColor.black
                                  ),
                                ),
                              ),
                            )
                                          ],
                                        ),
                SizedBox(height: 5,),

                                      Row(
                                          children: [
                                              Text(
                                         "DOB :", 
                                          style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,  
                                          color: WireframeColor.black,  
                                          
                                        ),
                                        ),
                                            SizedBox(width: 5,),
                                            Text(
                                             widget.birthdate.toString(),
                                              style: sansproSemibold.copyWith(
                                                  fontSize: 15,
                                                  color: WireframeColor.black),
                                            ),
                                          ],
                                        ),  
                                 SizedBox(height: 10,),
                                            
            ],
          ),
          )
          ]
          ),
             Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              GestureDetector(
                  onTap: () async {
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.remove('id');
                      preferences.remove('user_id');
                      preferences.remove('role');
                      preferences.remove('branch_id');
                      preferences.remove('session_id');
                      preferences.remove('childcount');
                    preferences.setString('id', widget.id.toString());
                    preferences.setString('user_id', widget.user_id.toString());
                    preferences.setString('role', widget.role.toString());
                    preferences.setString('branch_id', widget.branchid.toString());
                    preferences.setString('session_id', widget.sessionid.toString());
                    preferences.setString('childcount', widget.childcount.toString());
                    String ?role = preferences.getString('role');
                    String ?id = preferences.getString('id');
                    print(role);
                    print(id);
                      if(id!="" && role=='7'){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {      
                        return const studentdashboardnew();
                      },));}
                  },
                    child:Container(
                         margin: EdgeInsets.only(top: 10, bottom: 10),
                      width: 160,
                      height: 35,
                      decoration:  BoxDecoration(
                        gradient: const LinearGradient(
                         colors: [ WireframeColor.appcolor,WireframeColor.bootomcolor],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: width/26),
                        child: Row(
                          children: [
                            SizedBox(
                              width:100,
                              child: Center(
                                child: Text(
                                  "Dashboard",
                                  style: sansproSemibold.copyWith(
                                      fontSize: 14, color: WireframeColor.white),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.arrow_forward,size:height/36,color: WireframeColor.white,)
                          ],
                        ),
                      ),
                    ))

             ],)
             
        ],
      ),
    ),
  );
}


}
