import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class socialmedia extends StatefulWidget {
  const socialmedia({Key? key}) : super(key: key);

  @override
  State<socialmedia> createState() => _WireframeDatesheetState();
}

class _WireframeDatesheetState extends State<socialmedia> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;

  final themedata = Get.put(WireframeThemecontroler());

 
   String ?googleurl;
   String ?youtube_url ;
   String? facebook_url;
   String ?twitter_url;
   String ?google_plus;
   String ?linkedin_url;
   String ?pinterest_url;
   String ?instagram_url;
   String ?branch_id;
  

@override
void initState() {
  super.initState();
  Getsocialmedialink();
}
  
 Future<void> Getsocialmedialink() async {
  
SharedPreferences preferences = await SharedPreferences.getInstance();
     branch_id = preferences.getString('branch_id');

  try {
    

    String apiUrl = AppString.constanturl + 'Get_socialmedia_link';
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'branch_id':branch_id
      },
    );

    var jsondata = jsonDecode(response.body);
    setState(() {
  facebook_url = jsondata['facebook_url'] ?? '';
  twitter_url = jsondata['twitter_url'] ?? '';
  youtube_url = jsondata['youtube_url'] ?? '';
  google_plus = jsondata['google_plus'] ?? '';
  linkedin_url = jsondata['linkedin_url'] ?? '';
  pinterest_url = jsondata['pinterest_url'] ?? '';
  instagram_url = jsondata['instagram_url'] ?? '';
  });

   
   
  } catch (e) {
    print('Error parsing date: $e');
    // Handle the error or throw it again if needed
    throw e;
  }
}

_launchURL(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }

        try {
      await launch(url);
    } catch (e) {
      print('Error launching URL: $e');
    }

    
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: WireframeColor.appcolor,
      appBar: AppBar(
        leadingWidth: width / 1,
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
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: height / 36,
                    color: WireframeColor.white,
                  )),
              SizedBox(
                width: width / 36,
              ),
              Text(
                "Social Media Links",
                style: sansproRegular.copyWith(
                  fontSize: 18,
                  color: WireframeColor.white,
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
        padding: EdgeInsets.only(top: height / 36,bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              color: themedata.isdark
                  ? WireframeColor.black
                  : WireframeColor.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20),
                   bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20))),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 26, vertical: height / 56),
              child: Column(
                children: [
                  // itemCount: sub.length,
                  // physics: const NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  // itemBuilder: (context, index) {
                  Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Google',
                                style: sansproSemibold.copyWith(fontSize: 16),
                              ),
                              SizedBox(
                                height: height / 200,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(google_plus.toString());
                                },
                                child:
                                 SizedBox(
                                   width: width/1.3,
                                 //Padding(
                                  //padding: EdgeInsets.all(0),
                                  child: Text(
                                    google_plus.toString(),
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
                            Image.asset(
                                  WireframePngimage.google,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
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
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Youtube',
                                style: sansproSemibold.copyWith(fontSize: 16),
                              ),
                              SizedBox(
                                height: height / 200,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(youtube_url.toString());
                                },
                                child:
                                  SizedBox(
                                   width: width/1.3,
                                //   padding: EdgeInsets.all(0),
                                  child: Text(
                                    youtube_url.toString(),
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
                        Image.asset(
                                  WireframePngimage.youtube,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                )
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
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Facebook',
                                style: sansproSemibold.copyWith(fontSize: 16),
                              ),
                              SizedBox(
                                height: height / 200,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(facebook_url.toString());
                                },
                                child: 
                                SizedBox(
                                   width: width/1.3,
                                //Padding(
                                 // padding: EdgeInsets.all(0),
                                  child: Text(
                                    facebook_url.toString(),
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
                          Image.asset(
                                  WireframePngimage.facebook,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
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

                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Twitter',
                                style: sansproSemibold.copyWith(fontSize: 16),
                              ),
                              SizedBox(
                                height: height / 200,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(twitter_url.toString());
                                },
                                child: 
                                SizedBox(
                                   width: width/1.3,
                                //Padding(
                                  //padding: EdgeInsets.all(0),
                                  child: Text(
                                    twitter_url.toString(),
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
                          Image.asset(
                                  WireframePngimage.twitter,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
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

                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pinterest',
                                style: sansproSemibold.copyWith(fontSize: 16),
                              ),
                              SizedBox(
                                height: height / 200,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(pinterest_url.toString());
                                },
                                child: 
                                SizedBox(
                                   width: width/1.3,
                               // Padding(
                               //   padding: EdgeInsets.all(0),
                                  child: Text(
                                    pinterest_url.toString(),
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
                          Image.asset(
                                  WireframePngimage.pinterest,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
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

                       Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Linked In',
                                style: sansproSemibold.copyWith(fontSize: 16),
                              ),
                              SizedBox(
                                height: height / 200,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(linkedin_url.toString());
                                },
                                child: 
                                SizedBox(
                                   width: width/1.3,
                                //Padding(
                                //  padding: EdgeInsets.all(0),
                                  child: Text(
                                    linkedin_url.toString(),
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
                          Image.asset(
                                  WireframePngimage.linkedin,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
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

                       Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Instagram',
                                style: sansproSemibold.copyWith(fontSize: 16),
                              ),
                              SizedBox(
                                height: height / 200,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(instagram_url.toString());
                                },
                                child:
                                SizedBox(
                                   width: width/1.3,
                                // Padding(
                                //  padding: EdgeInsets.all(0),
                                  child: Text(
                                    instagram_url.toString(),
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
                          Image.asset(
                                  WireframePngimage.instagram,
                                  height: height / 20,
                                  fit: BoxFit.fitHeight,
                                ),
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
                ],
              )),
        ),
       ), 
       ),
    );
  }
}
