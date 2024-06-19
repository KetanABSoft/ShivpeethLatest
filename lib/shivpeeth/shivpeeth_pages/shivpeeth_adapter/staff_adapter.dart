
import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
DecorationImage? imageset;

class staffcommaonlist extends StatefulWidget {
  final String? name;
  final String? designation;
  final String? photo;
  final bool? isLast;
    final double opacity;

  const staffcommaonlist({
    Key? key,
    this.name,
    this.designation,
    this.photo,
    this.isLast = false,
     required this.opacity,

  }) : super(key: key);

  @override
  noticewidgetstate createState() => noticewidgetstate();
}

class noticewidgetstate extends State<staffcommaonlist> {
   dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  @override
  void initState() {
    super.initState();
    
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
  return Container(
    margin: EdgeInsets.only(top: 7, bottom: 7), // Adjust the values as needed
    decoration: BoxDecoration(
      border: Border.all(color: WireframeColor.appcolor),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 66),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: height / 15,
            height: height / 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: WireframeColor.textgray,
            ),
            // child: Padding(
            //   padding: EdgeInsets.all(10.0),
            //   child: Image.asset(
            //     WireframePngimage.profile,
            //     width: 10,
            //     height: 10,
            //   ),
            // ),
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
                                    width: 10,
                                    height: 10,
                                  );
                                } else {
                                  // Display the valid image
                                  return Image.network(
                                     AppString.staffimageurl +  widget.photo.toString()
                                       ,
                                    width: 10,
                                    height: 10,
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
                            width: 10,
                            height: 10,
                          ),
                  )
            
          ),
          SizedBox(width: width / 36),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(
                  width: width/1.5,
                  child: Text(
                  widget.name.toString(),
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,),
                   ),), 
              // Text(
              //   widget.name.toString(),
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,),
              // ),
              SizedBox(height: height / 96),
              Text(
                widget.designation.toString(),
                style: sansproRegular.copyWith(
                  fontSize: 15,
                  color: WireframeColor.textgray,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


}
