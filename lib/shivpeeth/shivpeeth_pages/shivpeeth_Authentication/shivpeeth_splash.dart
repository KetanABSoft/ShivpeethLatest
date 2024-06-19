import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_Authentication/shivpeeth_login.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_admin/shivpeeth_admindashboard.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_home.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_parent/shivpeeth_parentdashboard.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_student/shivpeeth_studentdashboard.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_student/shivpeeth_studentnewdashboard.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_teacherdashboard.dart';
import '../../shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WireframeSplash extends StatefulWidget {
  const WireframeSplash({Key? key}) : super(key: key);

  @override
  State<WireframeSplash> createState() => _WireframeSplashState();
}

class _WireframeSplashState extends State<WireframeSplash> {
  @override
  void initState() {
    super.initState();
    goup();
  }
      Future<bool> checkUserLoggedIn() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var id = preferences.getString('id');
      var role = preferences.getString('role');
      return id != null && role != null; // Check both id and role
    }

    goup() async {
      var navigator = Navigator.of(context);
      await Future.delayed(const Duration(seconds: 10));

      bool isLoggedIn = await checkUserLoggedIn(); // Use await here

      if (isLoggedIn) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var role = preferences.getString('role');
        var childcount = preferences.getString('childcount');
         print("childcount"+childcount.toString());
    if(role=='6'){
             Navigator.push(context, MaterialPageRoute(builder: (context) {      
                        return const parentdashboard();
                      },));
        }else
        if (role == '7') {
          if(childcount=='1'){
          navigator.push(MaterialPageRoute(
            builder: (context) {
              return const studentdashboard();
            },
          ));
          }else{
              navigator.push(MaterialPageRoute(
            builder: (context) {
              return const studentdashboardnew();
            },
          ));

          }
          
        }else if(role=='3'){

            Navigator.push(context, MaterialPageRoute(builder: (context) {      
                        return const teacherdashboard();
                      },));
        } else if(role=='2'){
              Navigator.push(context, MaterialPageRoute(builder: (context) {      
                        return const admindashboard();
                      },));
        }else {
          navigator.push(MaterialPageRoute(
            builder: (context) {
              return const WireframeHome();
            },
          ));
        }
      } else {
        navigator.push(MaterialPageRoute(
          builder: (context) {
            return const WireframeLogin();
          },
        ));
      }
    }



  dynamic size;
  double height = 0.00;
  double width = 0.00;@override
Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: WireframeColor.appcolor,
      body:Center( child:Stack(
        children: [
          Image.network(
            AppString.app_imageurl,
            //height: ,
           // width: width,
            fit: BoxFit.cover, // Ensure the image covers the entire container
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                // Image is loaded successfully
                return child;
              } else {
                // Image is still loading, you can show a loading indicator here
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              }
            },
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              // If the network image fails to load, show a fallback asset image
              return Image.asset(WireframePngimage.androidlogo);
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 26),
                child: Container(
                  child: Text(
                    "Copyright © 2023 Shivpeeth Foundation All rights reserved",
                    style: sansproBold.copyWith(
                      fontSize: 12,
                      color: WireframeColor.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ],
      ),
    ));
  }
}
