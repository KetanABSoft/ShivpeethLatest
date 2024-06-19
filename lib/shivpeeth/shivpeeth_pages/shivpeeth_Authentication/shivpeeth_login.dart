import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_admin/shivpeeth_admindashboard.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_home.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_parent/shivpeeth_parentdashboard.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_student/shivpeeth_studentdashboard.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_teacherdashboard.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WireframeLogin extends StatefulWidget {
  const WireframeLogin({Key? key}) : super(key: key);

  @override
  State<WireframeLogin> createState() => _WireframeLoginState();
}

class _WireframeLoginState extends State<WireframeLogin> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  bool _obscureText = true;
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future login(String username, String password) async {
    var urlString = AppString.constanturl + 'login';
    Uri uri = Uri.parse(urlString);
    var response = await http.post(uri, body: {
      "username": username,
      "password": password,
    });
    final jsondata = json.decode(response.body);
    print(jsondata);
    if (jsondata['result'] == "failure") {
      Fluttertoast.showToast(
        backgroundColor: Color.fromARGB(255, 255, 94, 0),
        textColor: Colors.white,
        msg: jsondata['message'],
        toastLength: Toast.LENGTH_SHORT,
      );
    } else if (jsondata['result'] == "success") {
      Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: jsondata['message'],
        toastLength: Toast.LENGTH_SHORT,
      );
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('id', jsondata['userdata']['id']);
      preferences.setString('user_id', jsondata['userdata']['user_id']);
      preferences.setString('role', jsondata['userdata']['role']);
      preferences.setString('branch_id', jsondata['branch_id']);
      preferences.setString('session_id', jsondata['session_id']);
      preferences.setString('childcount', jsondata['childcount']);
      print("role:" + jsondata['userdata']['role']);
      if (jsondata['userdata']['role'] == '6') {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const parentdashboard();
          },
        ));
      } else if (jsondata['userdata']['role'] == '7') {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const studentdashboard();
          },
        ));
      } else if (jsondata['userdata']['role'] == '3') {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const teacherdashboard();
          },
        ));
      } else if (jsondata['userdata']['role'] == '2') {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const admindashboard();
          },
        ));
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const WireframeHome();
          },
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          //  backgroundColor: WireframeColor.appcolor,
          body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [WireframeColor.appcolor, WireframeColor.bootomcolor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SingleChildScrollView(
                  child: Container(
                constraints: BoxConstraints(
                  maxHeight: height,
                  maxWidth: width,
                ),
                child: Column(
                  children: [
                    SizedBox(
                        height:
                            height * 0.05), // Adjusted based on screen height

                    Flexible(
                      flex: isPortrait
                          ? 2
                          : 1, // Adjust flex based on orientation
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isPortrait ? height * 0.05 : height * 0.025,
                          horizontal: width * 0.1,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                width: isPortrait
                                    ? 180
                                    : 120, // Adjusted width based on orientation
                                height: isPortrait
                                    ? 180
                                    : 120, // Adjusted height based on orientation
                                child: Image(
                                    image: AssetImage(
                                        WireframePngimage.androidlogo)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                        flex: isPortrait
                            ? 3
                            : 3, // Adjust flex based on orientation
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: isPortrait
                                              ? 2
                                              : 1, // Adjust flex based on orientation
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Username",
                                                style: sansproRegular.copyWith(
                                                  fontSize: 12,
                                                  color:
                                                      WireframeColor.textgray,
                                                ),
                                              ),
                                              //SizedBox(height: height / 96),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      width, // Adjust the value as needed
                                                ),
                                                child: TextField(
                                                  controller: username,
                                                  style:
                                                      sansproRegular.copyWith(
                                                    fontSize: 16,
                                                    color: themedata.isdark
                                                        ? WireframeColor.white
                                                        : WireframeColor.black,
                                                  ),
                                                  cursorColor: themedata.isdark
                                                      ? WireframeColor.white
                                                      : WireframeColor.black,
                                                  decoration: InputDecoration(
                                                    hintText: "Enter Username",
                                                    hintStyle:
                                                        sansproRegular.copyWith(
                                                      fontSize: 16,
                                                      color: themedata.isdark
                                                          ? WireframeColor.white
                                                          : WireframeColor
                                                              .black,
                                                    ),
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: WireframeColor
                                                              .bggray),
                                                    ),
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: WireframeColor
                                                              .bggray),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width /
                                              8, // Adjust the value as needed
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.mail,
                                                color: WireframeColor.textgray,
                                                size: height / 36,
                                              ),
                                              onPressed: _togglePasswordStatus,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 96,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: height / 46,
                                    ),
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Password",
                                                style: sansproRegular.copyWith(
                                                  fontSize: 12,
                                                  color:
                                                      WireframeColor.textgray,
                                                ),
                                              ),
                                              //SizedBox(height: height / 96),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      width, // Adjust the value as needed
                                                ),
                                                child: TextField(
                                                  controller: password,
                                                  obscureText: _obscureText,
                                                  style:
                                                      sansproRegular.copyWith(
                                                    fontSize: 16,
                                                    color: themedata.isdark
                                                        ? WireframeColor.white
                                                        : WireframeColor.black,
                                                  ),
                                                  cursorColor: themedata.isdark
                                                      ? WireframeColor.white
                                                      : WireframeColor.black,
                                                  decoration: InputDecoration(
                                                    hintText: "Enter Password",
                                                    hintStyle:
                                                        sansproRegular.copyWith(
                                                      fontSize: 16,
                                                      color: themedata.isdark
                                                          ? WireframeColor.white
                                                          : WireframeColor
                                                              .black,
                                                    ),
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: WireframeColor
                                                              .bggray),
                                                    ),
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: WireframeColor
                                                              .bggray),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width /
                                              8, // Adjust the value as needed
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 1),
                                            child: IconButton(
                                              icon: Icon(
                                                _obscureText
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: WireframeColor.textgray,
                                                size: height / 36,
                                              ),
                                              onPressed: _togglePasswordStatus,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  InkWell(
                                    highlightColor: WireframeColor.transparent,
                                    splashColor: WireframeColor.transparent,
                                    onTap: () {
                                      login(username.text, password.text);
                                    },
                                    child: Container(
                                      width: width, // Adjust width here
                                      height: height / 15,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            WireframeColor.appcolor,
                                            WireframeColor.bootomcolor
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width / 26),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween, // Ensure contents are spaced evenly
                                          children: [
                                            Expanded(
                                              // Use Expanded to occupy available space
                                              child: Center(
                                                child: Text(
                                                  "Login",
                                                  style:
                                                      sansproSemibold.copyWith(
                                                    fontSize: 16,
                                                    color: WireframeColor.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              size: height / 36,
                                              color: WireframeColor.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ), // Column
                            )))
                  ],
                ),
              )))),
    );
  }
}

//   @override
// Widget build(BuildContext context) {
//   size = MediaQuery.of(context).size;
//   height = size.height;
//   width = size.width;
//   return WillPopScope(
//     onWillPop: _onWillPop,
//   child: Scaffold(
//     resizeToAvoidBottomInset: false,
//   //  backgroundColor: WireframeColor.appcolor,
//     body: Container(
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [WireframeColor.appcolor, WireframeColor.bootomcolor],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//       ),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: height / 10,
//         ),
//         Center(
//                 child: Container(
//                   width: 150,
//                   height: 150,
//                   child: Image(image: AssetImage(WireframePngimage.androidlogo)),
//                 ),
//               ),
//         SizedBox(
//           height: height / 10,
//         ),

//         // const Spacer(),

//         Container(
//           height: height / 1.6,
//           width: width / 1,
//           decoration: BoxDecoration(
//               color:
//               themedata.isdark ? WireframeColor.black : WireframeColor.white,
//               borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(35),
//                   topLeft: Radius.circular(35),
//                  // bottomLeft: Radius.circular(18),
//                  // bottomRight: Radius.circular(18)
//                  ),
//                   ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: width / 26, vertical: height / 36),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [

//                   Padding(
//                     padding: EdgeInsets.only(
//                       top: height / 46,
//                       //right: width / 30,
//                       //bottom: height / 100,
//                       //left:width / 30,
//                     ),
//                     child: Row(
//                      // crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Username",
//                                 style: sansproRegular.copyWith(
//                                   fontSize: 12,
//                                   color: WireframeColor.textgray,
//                                 ),
//                               ),
//                               //SizedBox(height: height / 96),
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(
//                                   maxWidth: width , // Adjust the value as needed
//                                 ),
//                                 child: TextField(
//                                   controller: username,

//                                   style: sansproRegular.copyWith(
//                                     fontSize: 16,
//                                     color: themedata.isdark
//                                         ? WireframeColor.white
//                                         : WireframeColor.black,
//                                   ),
//                                   cursorColor: themedata.isdark
//                                       ? WireframeColor.white
//                                       : WireframeColor.black,
//                                   decoration: InputDecoration(
//                                     hintText: "Enter Username",
//                                     hintStyle: sansproRegular.copyWith(
//                                       fontSize: 16,
//                                       color: themedata.isdark
//                                           ? WireframeColor.white
//                                           : WireframeColor.black,
//                                     ),
//                                     enabledBorder: const UnderlineInputBorder(
//                                       borderSide: BorderSide(color: WireframeColor.bggray),
//                                     ),
//                                     focusedBorder: const UnderlineInputBorder(
//                                       borderSide: BorderSide(color: WireframeColor.bggray),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: width / 8, // Adjust the value as needed
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 10),
//                             child:
//                             IconButton(
//                               icon: Icon(

//                                      Icons.mail,

//                                 color: WireframeColor.textgray,
//                                 size: height / 36,
//                               ),
//                               onPressed: _togglePasswordStatus,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 SizedBox(height: height/96,),

//                        Padding(
//                     padding: EdgeInsets.only(
//                       top: height / 46,
//                      // right: width / 30,
//                      // bottom: height / 100,
//                      //left:width / 30,
//                     ),
//                     child: Row(
//                       //crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Password",
//                                 style: sansproRegular.copyWith(
//                                   fontSize: 12,
//                                   color: WireframeColor.textgray,
//                                 ),
//                               ),
//                               //SizedBox(height: height / 96),
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(
//                                   maxWidth: width , // Adjust the value as needed
//                                 ),
//                                 child: TextField(
//                                   controller: password,
//                                   obscureText: _obscureText,
//                                   style: sansproRegular.copyWith(
//                                     fontSize: 16,
//                                     color: themedata.isdark
//                                         ? WireframeColor.white
//                                         : WireframeColor.black,
//                                   ),
//                                   cursorColor: themedata.isdark
//                                       ? WireframeColor.white
//                                       : WireframeColor.black,
//                                   decoration: InputDecoration(
//                                     hintText: "Enter Password",
//                                     hintStyle: sansproRegular.copyWith(
//                                       fontSize: 16,
//                                       color: themedata.isdark
//                                           ? WireframeColor.white
//                                           : WireframeColor.black,
//                                     ),
//                                     enabledBorder: const UnderlineInputBorder(
//                                       borderSide: BorderSide(color: WireframeColor.bggray),
//                                     ),
//                                     focusedBorder: const UnderlineInputBorder(
//                                       borderSide: BorderSide(color: WireframeColor.bggray),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: width / 8, // Adjust the value as needed
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 1),
//                             child: IconButton(
//                               icon: Icon(
//                                 _obscureText
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: WireframeColor.textgray,
//                                 size: height / 36,
//                               ),
//                               onPressed: _togglePasswordStatus,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

// SizedBox(height: height/26,),
// InkWell(
//   highlightColor: WireframeColor.transparent,
//   splashColor: WireframeColor.transparent,
//   onTap: () {

//     login(username.text,password.text);
//   },
//   child: Container(
//     width: width/1,
//     height: height/15,
//     decoration:  BoxDecoration(
//       gradient: const LinearGradient(
//        colors: [ WireframeColor.appcolor,WireframeColor.bootomcolor],
//         begin: Alignment.bottomLeft,
//         end: Alignment.topRight
//       ),
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Padding(
//       padding:  EdgeInsets.symmetric(horizontal: width/26),
//       child: Row(
//         children: [
//           SizedBox(
//             width: width/1.3,
//             child: Center(
//               child: Text(
//                 "Login",
//                 style: sansproSemibold.copyWith(
//                     fontSize: 16, color: WireframeColor.white),
//               ),
//             ),
//           ),
//           const Spacer(),
//           Icon(Icons.arrow_forward,size:height/36,color: WireframeColor.white,)
//         ],
//       ),
//     ),
//   ),
// ),

//               ],
//             )
//           ),
//         )
//       ],
//     ),
//  ) ),
//  );
// }

Future<bool> _onWillPop() async {
  SystemNavigator.pop();
  return true;
  // return (await showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: Text('Exit App', style: TextStyle(fontFamily: 'Poppins')),
  //         content: Text('Do you want to exit the app?', style: TextStyle(fontFamily: 'Poppins')),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(false),
  //             child: Text('No', style: TextStyle(fontFamily: 'Poppins')),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //                SystemNavigator.pop();
  //             },
  //             child: Text('Yes', style: TextStyle(fontFamily: 'Poppins')),
  //           ),
  //         ],
  //       ),
  //     )) ??
  //     false;
}
