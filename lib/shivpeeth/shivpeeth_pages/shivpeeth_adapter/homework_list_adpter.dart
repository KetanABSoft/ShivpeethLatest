

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/pdfviewver.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_add_homework.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_imageview.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_teacherhomeworklist.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


DecorationImage? imageset;

class adapterhomeworklist extends StatefulWidget {
  final String? id;
  final String? subjecttitle;
  final String? description;
  final String? homeassignedate;
  final String? homesubmissiondate;
  final String? creator_name;
  final bool? isLast;
    final double opacity;
    final String document;

  const adapterhomeworklist({
    Key? key,
    this.id,
    this.subjecttitle,
    this.description,
    this.homeassignedate,
    this.homesubmissiondate,
    this.creator_name,
    this.isLast = false,
     required this.opacity,
     required this.document,

  }) : super(key: key);

  @override
  hoemworkapadaterstate createState() => hoemworkapadaterstate();
}

class hoemworkapadaterstate extends State<adapterhomeworklist> {
   dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());

  
  @override
  void initState() {
    super.initState();
   // requestPermission();
   
  }

 void deletedata(String rowid,BuildContext context)async {

      var urlString = AppString.constanturl + 'homeworkdelete';
            Uri uri = Uri.parse(urlString);
        var response = await http.post(uri, body: {
            "id":rowid

        });

  var jsonResponse = json.decode(response.body);
      if (jsonResponse['result'] == "success") {
           Fluttertoast.showToast(
        backgroundColor: const Color.fromARGB(255, 0, 255, 55),
        textColor: Colors.white,
        msg: jsonResponse['message'],
        toastLength: Toast.LENGTH_SHORT,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Wireteacherhomeworklist()),
      );

      }else{


      }



  }

  String getFileExtension(String filePath) {
  int dotIndex = filePath.lastIndexOf('.');
  if (dotIndex != -1 && dotIndex < filePath.length - 1) {
    return filePath.substring(dotIndex + 1);
  }
  return '';
}

IconData getIconForExtension(String extension) {
  switch (extension.toLowerCase()) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'doc':
    case 'docx':
      return Icons.description;
    // Add more cases for other file extensions if needed
    default:
      return Icons.insert_drive_file;
  }
}




// Future<void> downloadFile() async {

//   try {
//       final String fileUrl = AppString.homework_imageurl+widget.document;

//     // Get the external storage directory
//     Directory? externalDir = await getExternalStorageDirectory();

//     if (externalDir != null) {
//       // Specify the desired subdirectory in the external storage
//       String subdirectory = "shivpeeth";
//       String directoryPath = join(externalDir.path, subdirectory);

//       // Create the specified directory if it doesn't exist
//       Directory(directoryPath).create(recursive: true).then((Directory directory) async {
//         // Construct the file path within the specified directory
//         String filePath = join(directoryPath, widget.document);

//         // Send a GET request to download the file
//         var response = await http.get(Uri.parse(fileUrl));

//         // Check if the request was successful (status code 200)
//         if (response.statusCode == 200) {
//           // Write the file to the specified directory
//           File file = File(filePath);
//           await file.writeAsBytes(response.bodyBytes);
//           print('File downloaded to: $filePath');
//         } else {
//           // Handle the error if the request was not successful
//           print('Failed to download file. Status code: ${response.statusCode}');
//         }
//       });
//     } else {
//       // Handle the case where external storage directory is not available
//       print('External storage directory not available.');
//     }
//   } catch (e) {
//     // Handle any exceptions that may occur
//     print('Error: $e');
//   }
// }




      @override
      Widget build(BuildContext context) {
        size = MediaQuery.of(context).size;
        height = size.height;
        width = size.width;

      String fileExtension = getFileExtension(widget.document);

        IconData documentIcon = getIconForExtension(fileExtension);

        return Container(
          margin: EdgeInsets.only(bottom: height/36),
          decoration: BoxDecoration(
            border: Border.all(color: WireframeColor.bggray),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width/36, vertical: height/56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffE6EFFF),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36, vertical: height/150),
                    child: Column(
                    children: [
                      
                    
                     Row(
                    children: [
                    Text(
                      widget.subjecttitle.toString(),
                      style: sansproBold.copyWith(fontSize: 14, color: WireframeColor.appcolor),
                    ),
                     Spacer(),
                   SizedBox(
                     width: width/3,
                    child: 
                     Text(
                      widget.creator_name?.toString() ?? 'N/A',
                       maxLines: 2,
                      // style: sansproSemibold.copyWith(fontSize: 14),
                    ),)
                    ]
                    ),
                    Divider(
                        color: WireframeColor.textgrayline,
                      ),
                    Row(
                    children: [
                      Spacer(),

                   

                      GestureDetector(
                onTap: () {
                  if (widget.document.isNotEmpty) {
                    if (fileExtension == "pdf") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return pdfviewver(
                              setpdfname: AppString.homework_imageurl + widget.document,
                              titlename: widget.document,
                            );
                          },
                        ),
                      );
                    } else if (fileExtension == "png" ||
                        fileExtension == "jpg" ||
                        fileExtension == "jpeg") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ImageViewer(
                              setImageUrl: AppString.homework_imageurl + widget.document,
                              titleName: widget.document,
                            );
                          },
                        ),
                      );
                    }
                  }
                },
                child: widget.document.isNotEmpty
                    ? Icon(
                        documentIcon,
                        color: WireframeColor.appgray,
                        size: 30,
                      )
                    : Container(), // You can replace Container() with any widget you want when widget.document is blank
              ),

                             SizedBox(width: 10,),
                            GestureDetector(
                            onTap: () {
                             Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return  addhomework(task:"View",id:widget.id.toString());
                            },
                          ));
                            },
                            child: Icon(
                              Icons.remove_red_eye,
                              color: WireframeColor.appgray,
                              size: 20,
                            ),
                          ),

                          //updatedata
                     SizedBox(width: 10,),
                           GestureDetector(
                            onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return  addhomework(task:"Update",id:widget.id.toString());
                            },
                          ));
                            },
                            child: Icon(
                              Icons.edit,
                              color: WireframeColor.appgray,
                              size: 20,
                            ),
                          ),
                             
                            //deletedata  
                          SizedBox(width: 10,),
                           GestureDetector(
                            onTap: () {
                             
                              deletedata(widget.id.toString(),context);
                            
                            },
                            child: Icon(
                              Icons.delete,
                              color: WireframeColor.appgray,
                              size: 20,
                            ),
                          )
                                 
                     
                  
                    ]
                    )
                  
                    ]
                    ),
                    
                    
                  ),
                ),
                   SizedBox(height: 10),
                // Description
                Row(
                  children: [
                    Expanded(child: 
                    Text(
                      widget.description.toString(),
                       style: sansproSemibold.copyWith(fontSize: 14),
                    ),
                    ),
                   
                  ],
                ),
               
                   SizedBox(height: 10),
                // Assign Date
                Row(
                  children: [
                    Text(
                      'Assign Date: '
                      // style: sansproSemibold.copyWith(fontSize: 14),
                    ),
                    Spacer(),
                    Text(
                      widget.homeassignedate?.toString() ?? 'N/A',
                      // style: sansproSemibold.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Last Submission Date
                Row(
                  children: [
                    Text(
                      'Last Submission Date: '
                      // style: sansproSemibold.copyWith(fontSize: 14),
                    ),
                    Spacer(),
                    Text(
                      widget.homesubmissiondate?.toString() ?? 'N/A'
                      // style: sansproSemibold.copyWith(fontSize: 14),
                    ),
                  ],
                ),
               
              ],
            ),
          ),
        );
      }


}
