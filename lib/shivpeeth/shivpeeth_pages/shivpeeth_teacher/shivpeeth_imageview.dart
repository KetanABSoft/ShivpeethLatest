import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';

class ImageViewer extends StatefulWidget {
  final String setImageUrl;
  final String titleName;

  const ImageViewer({
    required this.setImageUrl,
    required this.titleName,
    Key? key,
  }) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late File imageFile;
  bool isLoading = false;

  Future<void> loadImage() async {
    setState(() {
      isLoading = true;
    });

    var url = widget.setImageUrl;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);

    setState(() {
      imageFile = file;
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Scaffold(
      backgroundColor: WireframeColor.white,
      appBar: AppBar(
        backgroundColor: WireframeColor.appcolor,
        leadingWidth: width,
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
                ),
              ),
              SizedBox(width: width / 36),
              Text(
                widget.titleName,
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
                child: Image.file(
                  imageFile,
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                ),
              ),
            ),
    );
  }
}
