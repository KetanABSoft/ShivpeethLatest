import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_adapter/child_adapter.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_parent/shivpeeth_parentprofile.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shivpeeth_erp_system/notification_services.dart';
import 'package:url_launcher/url_launcher.dart';


class childlist {
  final String id;
  final String user_id;
  final String name;
  final String classname;
  final String divsion;
  final String rollno;
  final String birthdate;
  final String photo;
  final String sessionid;
  final String branchid;
  final String role;
  final String childcount;
 
  

  childlist(
      {required this.id,
      required this.user_id,
      required this.name,
      required this.rollno,
      required this.classname,
      required this.divsion,
      required this.birthdate,
      required this.photo,
      required this.sessionid,
      required this.branchid,
      required this.role,
      required this.childcount,

 

      
      
      });

  factory childlist.fromJson(Map<String, dynamic> json) {
    return childlist(
      id: json['id'].toString(),
      user_id: json['user_id'].toString(),
      name: json['name'].toString(),
      rollno: json['roll'].toString(),
      classname: json['class_name'].toString(),
      divsion: json['section_name'].toString(),
      birthdate: json['birthday'].toString(),
      photo: json['photo'].toString(),
      sessionid: json['session_id'].toString(),
      branchid: json['branch_id'].toString(),
      role: json['role'].toString(),
      childcount: json['childcount'].toString(),
      
    
    );
  }
}
class parentdashboard extends StatefulWidget {
  const parentdashboard({super.key});

  @override
  State<parentdashboard> createState() => parentdashboardState();
}

class parentdashboardState extends State<parentdashboard> {
  List<childlist> carouselItems = [];

  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  bool isDark = true;
  String? id;
  String? roleid;
  String? username="";
  String? designation="";
  String? class_id;
  String? section_id;
  String? photo;
  String? branch_id;
  String? session_id;

  //late NotificationServices notificationServices;
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
 @override
  void initState() {
    super.initState();
     Firebase.initializeApp();
    // notificationServices = NotificationServices(context);
    notificationServices.requestNotificationPermission();
    FirebaseMessaging.instance.requestPermission();
   // notificationServices.firebaseInit();
     notificationServices.firebaseInitnew(context);

     //fcmtoken();

    fetchstoryData();
    fetchstuentlist();
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
     print(roleid);
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

  
   

  
Future<void> fetchstuentlist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
     id = preferences.getString('id');
     session_id = preferences.getString('session_id');
     branch_id = preferences.getString('branch_id');
 String apiUrl = AppString.constanturl + 'Fetch_childlistwithdata';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "id": id != null ? id : '',
        "branch_id": branch_id != null ? branch_id : '',
        "session_id": session_id != null ? session_id : '',
       

      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<childlist> items = [];
      print(jsonData);
      for (var item in jsonData) {
        items.add(childlist.fromJson(item));
      }

      setState(() {
        carouselItems = items;
      });
    } else {
      // Handle API error
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
          )
        ],
      ),
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
             // height: height /2.3,
              height: 250,
              child: Stack(
                children: [
                  Container(
                     width: MediaQuery.of(context).size.width,
                   height: 200,
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
              padding: EdgeInsets.all(2),
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
                          return const loginprofileparent();
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
          
          ],
        ),
      ),
    ),
  ),
)
                 
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 26, vertical: height / 46),
              child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        carouselItems.length > 0
                            ?
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: carouselItems.length,
                  itemBuilder: (context, index) {
                    final childlist item = carouselItems[index];
                                  return childcommonlist(
                                    name: item.name,
                                    classname: item.classname,
                                    divsion: item.divsion,
                                    rollno: item.rollno,
                                    birthdate: item.birthdate,
                                    photo: item.photo,
                                    role :item.role,
                                    sessionid :item.sessionid,
                                    branchid :item.branchid,
                                    id :item.id,
                                    user_id :item.user_id,
                                    childcount :item.childcount,
                                    opacity: 1,
                                    isLast: index == carouselItems.length - 1,
                                  );
                  },
                ): Container( 
                              height: 300,
                              child:Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("No record found"),
                            ),
                          ),),
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