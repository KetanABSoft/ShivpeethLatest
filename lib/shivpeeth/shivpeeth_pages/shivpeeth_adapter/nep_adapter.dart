import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/pdfviewver.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
class nepadapter extends StatefulWidget {
  final String imagepdf;
  final String title;
  const nepadapter({
    required this.imagepdf,
    required this.title,
    super.key,
  });

  @override
  State<nepadapter> createState() => nepadapterState();
}

class nepadapterState extends State<nepadapter> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  List<String> entries = [];

  @override
  void initState() {
    super.initState();
   // entries = widget.imagepdf.split(",");
     if (widget.imagepdf.isNotEmpty) {
    entries = widget.imagepdf.split(",");
  }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    print(entries);

    return Container(
     decoration: BoxDecoration(
                              border: Border.all(color: WireframeColor.bggray),
                              borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(
              width: width/1.3,
              child: 
             Text(
              widget.title, // Display title before the GridView
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            ),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // You can adjust the number of columns
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                String entry = entries[index];
                 List<String> entryParts = entry.split('.');
              if (entryParts.length < 2) {
                // Handle the case where the split result is invalid
                return Container(); // or any other appropriate widget
              }
                String fileName = entry.split('.')[0];
                String fileType = entry.split('.')[1];
                IconData iconData;
                Function() onClick;

                if (fileType == 'pdf') {
                  iconData = Icons.picture_as_pdf;
                  onClick = () {
                    
                    // Handle PDF click (e.g., open PDF viewer)
                    print('Open PDF viewer for $fileName.pdf');
                     Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return  pdfviewver(setpdfname: AppString.imageurlnep + entry,titlename:entry);
                            },
                          ));
                  };
                } else if (fileType == 'jpeg' ||
                    fileType == 'jpg' ||
                    fileType == 'png') {
                  iconData = Icons.image;
                  onClick = () {
                    // Handle image click (e.g., open image viewer)
                     showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Image.network(
                            AppString.imageurlnep + entry,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  };
                } else {
                  // You can add more conditions for other file types if needed
                  iconData = Icons.description;
                  onClick = () {
                    // Handle click for other file types
                    print('Open viewer for $fileName.$fileType');
                  };
                }

                return GestureDetector(
                  onTap: onClick,
                  child: Card(
                    elevation: 2.0,
                    child: Center(
                      child: fileType == 'pdf'
                          ?  Image.asset(
                                  WireframePngimage.pdfimg, // replace with your actual image path
                                  width: 70,
                                  height: 70,
                                )
                          : (fileType == 'jpeg' ||
                                  fileType == 'jpg' ||
                                  fileType == 'png')
                              ? Image.network(
                                  AppString.imageurlnep + entry,
                                  width: 70, // Adjust the width as needed
                                  height: 70, // Adjust the height as needed
                                  fit: BoxFit.cover, // Adjust the fit property as needed
                                )
                              : Icon(Icons.description),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

   
}
