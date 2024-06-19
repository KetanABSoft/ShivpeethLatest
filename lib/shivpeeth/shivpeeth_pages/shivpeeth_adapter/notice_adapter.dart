
import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/pdfviewver.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_imageview.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
DecorationImage? imageset;

class Commonnoticelist extends StatefulWidget {
  final String? titledata;
  final String? remarkdata;
  final String? assignedate;
  final String document;
  final bool? isLast;
    final double opacity;

  const Commonnoticelist({
    Key? key,
    this.titledata,
    this.remarkdata,
    this.assignedate,
   required this.document,
    this.isLast = false,
     required this.opacity,

  }) : super(key: key);

  @override
  noticewidgetstate createState() => noticewidgetstate();
}

class noticewidgetstate extends State<Commonnoticelist> {
   dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  @override
  void initState() {
    super.initState();
    
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

 @override
Widget build(BuildContext context) {
   size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
      String fileExtension = getFileExtension(widget.document);

        IconData documentIcon = getIconForExtension(fileExtension);
            return Padding(
                      padding: EdgeInsets.only(bottom: height/56),
                      child: InkWell(
                        highlightColor: WireframeColor.transparent,
                        splashColor: WireframeColor.transparent,
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) {
                          //   return const WireframeEventDetails();
                          // },));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: WireframeColor.bggray),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 36, vertical: height / 96),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                              
                               
                                  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                             
                                    SizedBox(
                                   width: width/1.3,
                                  child: Text(
                                  widget.titledata.toString(),
                                  maxLines: 3,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,),
                                ),), 
                                  SizedBox(
                                    height: height / 120,
                                  ),
                                 
                                

                                ],
                              ),
                              const Spacer(),
                               GestureDetector(
                            onTap: () {
                              if (widget.document.isNotEmpty) {
                                if (fileExtension == "pdf") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return pdfviewver(
                                          setpdfname: AppString.noticeimageurl + widget.document,
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
                                          setImageUrl: AppString.noticeimageurl + widget.document,
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
                            ],
                          ),
                                SizedBox(
                                  height: height / 96,
                                ),
                                Row(
                                  children: [
                                   
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              WireframePngimage.ictime,
                                              color: WireframeColor.appcolor,
                                              height: height / 46,
                                            ),
                                            SizedBox(width: 5,),
                                            Text(
                                             widget.assignedate.toString(),
                                              style: sansproSemibold.copyWith(
                                                  fontSize: 13,
                                                  color: WireframeColor.appcolor),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height / 200,
                                        ),
                                        SizedBox(
                                         width: width/1.2,
                                          child: Text(
                                            widget.remarkdata.toString(),
                                           // overflow: TextOverflow.ellipsis,
                                            //maxLines: 5,
                                            overflow: TextOverflow.visible, // Change overflow to visible
                                            textAlign: TextAlign.justify, // Set text justification
                                            style: sansproRegular.copyWith(
                                                fontSize: 13,
                                                color: WireframeColor.textgray),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
}

}
