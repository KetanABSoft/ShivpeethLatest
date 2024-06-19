import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_attendence.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_calender.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_homework.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_lessionplanning.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_profile.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_social_media_link.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeethnotic.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_student/Shivpeeth_studenttimetable.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_student/shivpeeth_parentview_attendance.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_student/shivpeeth_studentfee_report.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_student/shivpeeth_studentstafflist.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shivpeeth_erp_system/notification_services.dart';
import 'package:url_launcher/url_launcher.dart';

class studentdashboard extends StatefulWidget {
  const studentdashboard({super.key});

  @override
  State<studentdashboard> createState() => studentdashboardState();
}

class studentdashboardState extends State<studentdashboard> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  bool isDark = true;
  String? id;
  String? roleid;
  String? username;
  String? designation;
  String? class_id;
  String? section_id;
  String? Attendence;
  String? fessdue;
  String? photo;
  String? branch_id;
  String? session_id;

 // late NotificationServices notificationServices;
  NotificationService notificationServices=NotificationService();
  ImageProvider? _imageProvider;
  String? dashboardimageUrl;
bool _isImageLoaded = false;
bool _isLoading = true; // Add this variable to track loading state

    String ?email;
    String? mobileno;
    String? youtube;
    String? twiter;
    String? facebook;
    String? instgram;
    String? instutuename;
    String? domain;
    static FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    
 @override
  void initState() {
    super.initState();
     Firebase.initializeApp();
    //  notificationServices = NotificationServices(context);
    notificationServices.requestNotificationPermission();
    FirebaseMessaging.instance.requestPermission();
   // notificationServices.firebaseInit();
     notificationServices.firebaseInitnew(context);

     fcmtoken();

    fetchstoryData();
    fetchamountpaid();
   setState(() {
      fetchDashboardImage();
      fetch_drawerdata();
    });
    
  }

  
  @override
void didChangeDependencies() {
  super.didChangeDependencies();
 // notificationServices = NotificationServices(context);
  notificationServices.requestNotificationPermission();
  //notificationServices.firebaseInit();
  notificationServices.firebaseInitnew(context);
}

    
    void fetch_drawerdata() async {
    var urlString = AppString.constanturl + 'Get_drawerdata';
    Uri uri = Uri.parse(urlString);
 
    var response = await http.post(uri, body: {
     
    });

    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      setState(() {
       
         email = jsondata['institute_email']??"";
         mobileno = jsondata['mobileno']??"";
         youtube = jsondata['youtube_url']??"";
         facebook  = jsondata['facebook_url']??"";
        instgram  = jsondata['twitter_url']??"";
        instutuename  = jsondata['institute_name']??"";
        domain = jsondata['footer_text']??"";
         
       
      });
    }
  }
 void fetchDashboardImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
      String type = 'report-card-logo'; // Assuming type and id are provided somehow
 

        String filePath = AppString.baseurl+'uploads/app_image/$type-$branch_id.png';
        String newfilepath = 'uploads/app_image/$type-$branch_id.png';
      

            bool fileExists = await doesFileExist(filePath);
        
            if (fileExists && branch_id != null) {
              dashboardimageUrl = baseUrl(newfilepath);
              _isImageLoaded = true;
              _setImageProvider(dashboardimageUrl.toString());
            } else {
              dashboardimageUrl = baseUrl('uploads/app_image/$type.png');
              _isImageLoaded = true;
              _setImageProvider(dashboardimageUrl.toString());
            }
          setState(() {
          _isLoading = false;
        });
       
      // Use imageUrl as needed
    }
    String baseUrl(String path) {
      return AppString.baseurl+path; // Replace with your base URL
    }

// Mocking the file_exists function
Future<bool> doesFileExist( String finewlepath) async {
       String imageUrl =  finewlepath;
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }

    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    return checkIfImagenew(data['content-type']);
  }
  bool checkIfImagenew(String param) {
    if (param == 'image/jpeg' || param == 'image/png' || param == 'image/gif') {
      return true;
    }
    return false;
  }

 void _setImageProvider(String dashboardimageUrl) async{
  
    if (dashboardimageUrl != "") {
      
       _imageProvider = NetworkImage(dashboardimageUrl.toString());
    } else {
      
      _imageProvider = AssetImage(WireframePngimage.prashalaback);
    }

    setState(() {
    _isLoading = false;
  });
    
 }
  void fetchstoryData() async {
    var urlString = AppString.constanturl + 'getdashboarddata';
    Uri uri = Uri.parse(urlString);
     SharedPreferences preferences = await SharedPreferences.getInstance();
     id = preferences.getString('id');
     roleid = preferences.getString('role');
     branch_id = preferences.getString('branch_id');
      print(branch_id.toString());
    var response = await http.post(uri, body: {
      "id": '$id',"role":'$roleid',"branch_id":'$branch_id'
    });

    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      setState(() {
        username = jsondata['name'];
        designation = jsondata['designation'];
        class_id = jsondata['class_id'];
        section_id = jsondata['section_id'];
        photo = jsondata['photo'];
        

       
      });
    }
  }

  
   void fetchamountpaid() async {
    var urlString = AppString.constanturl + 'Fetch_amount_atview_stud';
    Uri uri = Uri.parse(urlString);
     SharedPreferences preferences = await SharedPreferences.getInstance();
     id = preferences.getString('id');
     session_id = preferences.getString('session_id');
     branch_id = preferences.getString('branch_id');
    var response = await http.post(uri, body: {
        "id":id,"branch_id":branch_id,"session_id":session_id
    });

    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      setState(() {
        
        Attendence = jsondata['studentpresent'].toString();;
        fessdue = jsondata['dueamount'].toString();;
      
       
        

       
      });
    }
  }
 
  Future fcmtoken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  
  String? token = await FirebaseMessaging.instance.getToken();

  id = preferences.getString('id');
  var urlString = AppString.constanturl + 'update_fcm';

  Uri uri = Uri.parse(urlString);
  var response = await http.post(uri,
      body: {"fcm_token": '$token', "id": '$id'});
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // Set your desired height here
          child: AppBar(
           // backgroundColor:WireframeColor.appbarcolor,
            backgroundColor:     WireframeColor.appcolor,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    WireframeColor.bootomcolor,
                    WireframeColor.appcolor
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.menu,color: Colors.white,),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
        ),
      drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  WireframeColor.bootomcolor,
                  WireframeColor.appcolor,
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Column(
                 // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image(
                      //  image: AssetImage(WireframePngimage.drawerimage), // Replace 'assets/android_logo.png' with your actual image path
                        image: NetworkImage(AppString.drawerimage), // Replace 'assets/android_logo.png' with your actual image path
                        width: 100, // Adjust the size as needed
                        height: 100, // Adjust the size as needed
                      ),
                    ),
                    SizedBox(height: 10,),
                   if(instutuename.toString()!="") 
                    Text(
                   instutuename.toString(), style: TextStyle(
                      color: Colors.white, 
                      fontSize: 15, 
                      fontWeight: FontWeight.bold, 
                    )),
                    SizedBox(width: 16), // Adjust the spacing as needed
                  ],
                )
              ],
            ),
          ),
           ListTile(
            leading: SizedBox(
              width: 25, // Specify the width as per your preference
              height: 25, // Specify the height as per your preference
              child: Image.asset(WireframePngimage.mail), // Use AssetImage for preloading
            ),
            title:  Text(
             email.toString(),
              style: TextStyle(
                color: Colors.black, // Change color as per your preference
                fontSize: 14, // Change font size as per your preference
                fontWeight: FontWeight.normal, // Apply bold style
              ),
            ),
           
          ),
            Divider(), // Add a divider here
          ListTile(
            leading: SizedBox(
              width: 25, // Specify the width as per your preference
              height: 25, // Specify the height as per your preference
              child: Icon(Icons.language,color: Colors.blue), // Use AssetImage for preloading
            ),
           
            title:  Text(
              domain.toString(),
              style: TextStyle(
                color: Colors.black, // Change color as per your preference
                fontSize: 14, // Change font size as per your preference
                fontWeight: FontWeight.normal, // Apply bold style
              ),
            ),
            onTap: () {
              launch(domain.toString());
            },
          ),
           Divider(), 
          ListTile(
            leading: Icon(
              Icons.phone,
              size: 25,
                color: Colors.blue,
            ),
            title:  Text(
              mobileno.toString(),
              style: TextStyle(
                color: Colors.black, // Change color as per your preference
                fontSize: 14, // Change font size as per your preference
                fontWeight: FontWeight.normal, // Apply bold style
              ),
            ),
            onTap: () {
              launch("tel:$mobileno");
            },
          ),
           Divider(), 
          ListTile(
           leading: SizedBox(
              width: 25, // Specify the width as per your preference
              height: 25, // Specify the height as per your preference
              child: Image.asset(WireframePngimage.youtube), // Use AssetImage for preloading
            ),
                      title:  Text(
                      youtube.toString(),
              style: TextStyle(
                color: Colors.black, // Change color as per your preference
                fontSize: 14, // Change font size as per your preference
                fontWeight: FontWeight.normal, // Apply bold style
              ),
            ),
            onTap: () {
              launch(youtube.toString());
            },
          ),
           Divider(), 
          ListTile(
            leading: SizedBox(
              width: 25, // Specify the width as per your preference
              height: 25, // Specify the height as per your preference
              child: Image.asset(WireframePngimage.instagram), // Use AssetImage for preloading
            ),
            title:  Text(
              instgram.toString(),
              style: TextStyle(
                color: Colors.black, // Change color as per your preference
                fontSize: 14, // Change font size as per your preference
                fontWeight: FontWeight.normal, // Apply bold style
              ),
            ),
            onTap: () {
              launch(instgram.toString());
            },
          ),
           Divider(), 
          ListTile(
            leading: SizedBox(
              width: 25, // Specify the width as per your preference
              height: 25, // Specify the height as per your preference
              child: Image.asset(WireframePngimage.facebook), // Use AssetImage for preloading
            ),
            title:  Text(
              facebook.toString(),
              style: TextStyle(
                color: Colors.black, // Change color as per your preference
                fontSize: 14, // Change font size as per your preference
                fontWeight: FontWeight.normal, // Apply bold style
              ),
            ),
            onTap: () {
              launch(facebook.toString());
            },
          ),
        ],
      ),
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              //height: height / 2.2,
              height: 370,
              child: Stack(
                children: [
                  Container(
                    width: width / 1,
                     height: MediaQuery.of(context).size.height / 2.9,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        WireframeColor.bootomcolor,
                        WireframeColor.appcolor
                      ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                        
                            

                    // In your build method
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                // Show progress indicator if isLoading is true
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                // Show image if it's loaded
                if (!_isLoading)
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _isImageLoaded ? _imageProvider! : AssetImage(WireframePngimage.prashalaback),
                       fit: BoxFit.fill,
                      ),
                    ),
                  ),
              ],
            ),
          ),
                        
                        ],
                      ),
                    ),
                  ),
                  
                  Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: WireframeColor.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: WireframeColor.appcolor,
                    ),
                  ),
                  child: Column(
                    children: [SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.all( 1),
                        
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width/1.4,
                                  child: Text(
                                    username.toString(),
                                    maxLines: 2,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),
                        ),
                      ), 
                      SizedBox(
                        height: height / 120,
                      ),
                      Text(
                        designation.toString(),
                        style: sansproRegular.copyWith(
                          fontSize: 12,
                          color: WireframeColor.black,
                        ),
                      ),
                      SizedBox(
                        height: height / 96,
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    highlightColor: WireframeColor.transparent,
                    splashColor: WireframeColor.transparent,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const loginprofile();
                        },
                      ));
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: WireframeColor.white,
                      child: photo.toString() != ""
                        ? FutureBuilder(
                            future: doesImageExist(photo.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasError || snapshot.data != true) {
                                  return Image.asset(
                                    WireframePngimage.loginprofile,
                                    width: 40,
                                    height: 40,
                                  );
                                } else {
                                  return Image.network(
                                    AppString.staffimageurl + photo.toString(),
                                    width: 40,
                                    height: 40,
                                  );
                                }
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          )
                        : Image.asset(
                            WireframePngimage.loginprofile,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
                            color: WireframeColor.textgrayline,
                            height: 2,
                          ),
             Row(
              children: [
                   Expanded(
                             child: InkWell(
                                highlightColor: WireframeColor.transparent,
                                splashColor: WireframeColor.transparent,
                             
                                child: Container(
                               
                                 
                                  
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5,),
                           Container(
                           margin: EdgeInsets.only(left: 20),
                           child:Text("Fees/Attendance Details ", 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),
                           textAlign: TextAlign.left) ,)
                             ,
                             
                             SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Container(
                                           margin: EdgeInsets.only(left: 10),         
                                           child:  Image.asset(
                                              WireframePngimage.attendanceicon,
                                              height: 25,
                                              width: 25,
                                            ),),
                                  SizedBox(width:5),
                                              Container(
                                            margin: EdgeInsets.only(left: 10),         
                                            child:Text(
                                             "Attendance - "+Attendence.toString()+"%",
                                              style: sansproSemibold.copyWith(
                                                  fontSize: 15,
                                                  color: WireframeColor.lightblack),
                                            ),),
                                      
                                            
                                          ],
                                        )
                                        ,
                                        SizedBox(height: 10,),

                                        Divider(color: WireframeColor.textgrayline,
                                        height: 2,),
                                         
                                   SizedBox(height: 10,),
                                         Row(
                                          children: [
                                            Container(
                                             margin: EdgeInsets.only(left: 10),         
                                           child:
                                            Image.asset(
                                              WireframePngimage.rsicon,
                                              height: 25,
                                              width: 25,
                                            ),),
                                      SizedBox(width:5),
                                           Container(
                                           margin: EdgeInsets.only(left: 10),         
                                            child:
                                            Text(
                                             "Fees Due - ₹"+fessdue.toString(),
                                              style: sansproSemibold.copyWith(
                                                  fontSize: 15,
                                                  color: WireframeColor.lightblack),
                                            ),
                                           ),
                                   
                                     
                                              Spacer(),
                                          ],
                                        ),
                                  SizedBox(height: 10,),
                     
                                        
                                      ],
                                    ),
                                 
                                ),
                              ),
                             
                              
                           ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
)

                    //  Positioned(
                    //   //top: 200,
                    //   bottom: 0,
                    //  left: 10,
                    //   right: 10,
                    //   child: Padding(
                    //       padding:   EdgeInsets.all(7),
                    //        child: Container(
                    //    width: MediaQuery.of(context).size.width,
                    //  // height:200, // Add your desired height,
                    //       child: Row(
                    //          //mainAxisAlignment: MainAxisAlignment.center,
                             
                    //         children: [
                    //            Expanded(
                    //          child: InkWell(
                    //             highlightColor: WireframeColor.transparent,
                    //             splashColor: WireframeColor.transparent,
                             
                    //             child: Container(
                               
                    //               decoration: BoxDecoration(
                    //                   color: WireframeColor.white,
                    //                   borderRadius: BorderRadius.circular(20),
                    //                   border: Border.all(
                    //                     color: WireframeColor.appcolor,
                    //                   )),
                                  
                    //                 child: Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     SizedBox(height: 20,),
                    //        Container(
                    //        margin: EdgeInsets.only(left: 20),
                    //        child:Text("Fees/Attendance Details ", 
                    //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
                    //        textAlign: TextAlign.left) ,)
                    //          ,
                             
                    //          SizedBox(height: 20,),
                    //                     Row(
                    //                       children: [
                    //                         Container(
                    //                        margin: EdgeInsets.only(left: 10),         
                    //                        child:  Image.asset(
                    //                           WireframePngimage.attendanceicon,
                    //                           height: 40,
                    //                           width: 40,
                    //                         ),),
                    //               SizedBox(width:5),
                    //                           Container(
                    //                         margin: EdgeInsets.only(left: 10),         
                    //                         child:Text(
                    //                          "Attendance - "+Attendence.toString()+"%",
                    //                           style: sansproSemibold.copyWith(
                    //                               fontSize: 18,
                    //                               color: WireframeColor.lightblack),
                    //                         ),),
                                      
                                            
                    //                       ],
                    //                     )
                    //                     ,
                    //                     SizedBox(height: 10,),

                    //                     Divider(color: WireframeColor.textgrayline,
                    //                     height: 2,),
                                         
                    //                SizedBox(height: 10,),
                    //                      Row(
                    //                       children: [
                    //                         Container(
                    //                          margin: EdgeInsets.only(left: 10),         
                    //                        child:
                    //                         Image.asset(
                    //                           WireframePngimage.rsicon,
                    //                           height: 40,
                    //                           width: 40,
                    //                         ),),
                    //                   SizedBox(width:5),
                    //                        Container(
                    //                        margin: EdgeInsets.only(left: 10),         
                    //                         child:
                    //                         Text(
                    //                          "Fees Due - ₹"+fessdue.toString(),
                    //                           style: sansproSemibold.copyWith(
                    //                               fontSize: 18,
                    //                               color: WireframeColor.lightblack),
                    //                         ),
                    //                        ),
                                   
                                     
                    //                           Spacer(),
                    //                       ],
                    //                     ),
                    //               SizedBox(height: 10,),
                     
                                        
                    //                   ],
                    //                 ),
                                 
                    //             ),
                    //           ),
                             
                              
                    //        ) ],
                    //       )
                    //       )
                    //       )
                    //       )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 26, vertical: height / 36),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        highlightColor: WireframeColor.transparent,
                        splashColor: WireframeColor.transparent,
                      
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return  Wireframe_student_att(classid:class_id.toString(),sectionid:section_id.toString());
                            },
                          ));
                        },
                        child: Container(
                          width: width / 3.5,
                          decoration: BoxDecoration(
                            color: WireframeColor.lightgray,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 36, vertical: height / 36),
                            child: Column(
                             // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  WireframePngimage.student_attendance_admin,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(
                                  height: height / 36,
                                ),
                                Center(child:  Text(
                                  "Attendance",
                                  style: sansproRegular.copyWith(
                                    fontSize: 15,
                                    color: WireframeColor.black,
                                  ),
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        highlightColor: WireframeColor.transparent,
                        splashColor: WireframeColor.transparent,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return  Wireframehomework(classid:class_id.toString(),sectionid:section_id.toString());
                            },
                          ));
                        },
                        child: Container(
                          width: width / 3.5,
                          decoration: BoxDecoration(
                            color: WireframeColor.lightgray,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 36, vertical: height / 36),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  WireframePngimage.homeworkdash,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(
                                  height: height / 36,
                                ),
                                Center(child:  Text(
                                  "Homework",
                                  style: sansproRegular.copyWith(
                                    fontSize: 15,
                                    color: WireframeColor.black,
                                  ),
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                        const Spacer(),
                         InkWell(
                        highlightColor: WireframeColor.transparent,
                        splashColor: WireframeColor.transparent,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return  studenttimetable(classid:class_id.toString(),sectionid:section_id.toString());
                            },
                          ));
                        },
                        child: Container(
                          width: width / 3.5,
                          decoration: BoxDecoration(
                            color: WireframeColor.lightgray,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 36, vertical: height / 36),
                            child: Column(
                             // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  WireframePngimage.time_dash,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(
                                  height: height / 36,
                                ),
                                 Center(child: Text(
                                  "Timetable",
                                  style: sansproRegular.copyWith(
                                    fontSize: 15,
                                    color: WireframeColor.black,
                                  ),
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 56,
                  ),
                 
                 Row(
                    children: [
                     
                     
                      InkWell(
                        highlightColor: WireframeColor.transparent,
                        splashColor: WireframeColor.transparent,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const WireframeEvents();
                            },
                          ));
                        },
                        child: Container(
                          width: width / 3.5,
                          decoration: BoxDecoration(
                            color: WireframeColor.lightgray,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 36, vertical: height / 36),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  WireframePngimage.notice_admin,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(
                                  height: height / 36,
                                ),
                                 Center(child: Text(
                                  "Notice",
                                  style: sansproRegular.copyWith(
                                    fontSize: 15,
                                    color: WireframeColor.black,
                                  ),
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ), const Spacer(),
                      InkWell(
                        highlightColor: WireframeColor.transparent,
                        splashColor: WireframeColor.transparent,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const WireframeCalender();
                            },
                          ));
                        },
                        child: Container(
                          width: width / 3.5,
                          decoration: BoxDecoration(
                            color: WireframeColor.lightgray,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 36, vertical: height / 36),
                            child: Column(
                             // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  WireframePngimage.calendar_admin,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(
                                  height: height / 36,
                                ),
                                Center(child:  Text(
                                  "Calendar",
                                  style: sansproRegular.copyWith(
                                    fontSize: 15,
                                    color: WireframeColor.black,
                                  ),
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        highlightColor: WireframeColor.transparent,
                        splashColor: WireframeColor.transparent,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const studentfeereportpersonal();
                            },
                          ));
                        },
                        child: Container(
                          width: width / 3.5,
                          decoration: BoxDecoration(
                            color: WireframeColor.lightgray,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 36, vertical: height / 36),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  WireframePngimage.feestatus_dash,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(
                                  height: height / 36,
                                ),
                                 Center(child: Text(
                                  "Fee Status",
                                  style: sansproRegular.copyWith(
                                    fontSize: 15,
                                    color: WireframeColor.black,
                                  ),
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                
                   SizedBox(
                    height: height / 56,
                  ),
                 
                
                 
                 Row(
                    children: [
                      InkWell(
                        highlightColor: WireframeColor.transparent,
                        splashColor: WireframeColor.transparent,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const socialmedia();
                            },
                          ));
                        },
                        child: Container(
                          width: width / 3.5,
                          decoration: BoxDecoration(
                            color: WireframeColor.lightgray,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 36, vertical: height / 36),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  WireframePngimage.social_link_admin,
                                  height: height/20,
                                  //width: 30,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(
                                  height: height / 36,
                                ),
                                Center(child: Text(
                                  "Social Links",
                                  style: sansproRegular.copyWith(
                                    fontSize: 15,
                                    color: WireframeColor.black,
                                  ),
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        highlightColor: WireframeColor.transparent,
                        splashColor: WireframeColor.transparent,
                        onTap: () {
                         Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                            return lessionplan(classid:"Select Class",sectionid:"Select Section");
                            },
                          ));
                        },
                        child: Container(
                          width: width / 3.5,
                          decoration: BoxDecoration(
                            color: WireframeColor.lightgray,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 36, vertical: height / 36),
                            child: Column(
                             // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  WireframePngimage.ledash,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(
                                  height: height / 36,
                                ),
                               Center(child:  Text(
                               "Lesson PL.",
                                  style: sansproRegular.copyWith(
                                    fontSize: 15,
                                    color: WireframeColor.black,
                                  ),
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                        const Spacer(),
                      InkWell(
                        highlightColor: WireframeColor.transparent,
                        splashColor: WireframeColor.transparent,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const student_stafflist();
                            },
                          ));
                        },
                        child: Container(
                          width: width / 3.5,
                          decoration: BoxDecoration(
                            color: WireframeColor.lightgray,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 36, vertical: height / 36),
                            child: Column(
                             // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  WireframePngimage.staff_admin,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(
                                  height: height / 36,
                                ),
                                Center(child: Text(
                                  "Staff",
                                  style: sansproRegular.copyWith(
                                    fontSize: 15,
                                    color: WireframeColor.black,
                                  ),
                                ),)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ), 

                     SizedBox(
                    height: height / 56,
                  ),
                 
                
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Exit App', style: TextStyle(fontFamily: 'Poppins')),
            content: Text('Do you want to exit the app?', style: TextStyle(fontFamily: 'Poppins')),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No', style: TextStyle(fontFamily: 'Poppins')),
              ),
              TextButton(
                onPressed: () {
                   SystemNavigator.pop();
                },
                child: Text('Yes', style: TextStyle(fontFamily: 'Poppins')),
              ),
            ],
          ),
        )) ??
        false;
  }

}