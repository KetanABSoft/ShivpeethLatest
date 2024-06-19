import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';

class pdfviewver extends StatefulWidget {
  final String setpdfname;
  final String titlename;
  const pdfviewver({
    required this.setpdfname,
    required this.titlename,
    super.key});

  @override
  State<pdfviewver> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<pdfviewver> {
 double height = 0.00;
  double width = 0.00;
   late File Pfile;
  bool isLoading = false;
  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = widget.setpdfname;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });

    print(Pfile);
    setState(() {
      isLoading = false;
    });
  }
  
   @override
  void initState() {
    loadNetwork();

    super.initState();
  }
  late PDFViewController pdfViewController;
  @override
  Widget build(BuildContext context) {
    print('PDF URL: ${widget.setpdfname}');
     var size = MediaQuery.of(context).size;
      height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: WireframeColor.appcolor,
      appBar: AppBar(
        backgroundColor: WireframeColor.appcolor,
        leadingWidth: width, // or set to a specific value
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
                child: Icon(Icons.arrow_back_ios_new,
                    size: height / 36, color: WireframeColor.white),
              ),
              SizedBox(width: width / 36),
              Text(
                widget.titlename,
                style: sansproRegular.copyWith(
                  fontSize: 18,
                  color: WireframeColor.white,
                ),
              ),
            ],
          ),
        ),
      ),
     body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Center(
                child: PDFView(
                  filePath: Pfile.path,
                ),
              ),
            ),
    );
  }
}