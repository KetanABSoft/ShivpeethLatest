import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_teacherdashboard.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_teacher/shivpeeth_teacherhomeworklist.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_image_compress/flutter_image_compress.dart';


class addhomework extends StatefulWidget {
    final String task;
    final String id;
  const addhomework({
    required this.task,
    required this.id,
    super.key});

  @override
  State<addhomework> createState() => addhomeworkState();
}

class addhomeworkState extends State<addhomework> {
  TextEditingController date_of_homework = TextEditingController();
TextEditingController date_of_submission = TextEditingController();
TextEditingController date_of_shedule = TextEditingController();
TextEditingController fileselectname = TextEditingController();
TextEditingController Homework  = TextEditingController();
DateTime fromDate_homework = DateTime.now();
DateTime fromDate_submission = DateTime.now();
DateTime fromDate_shedule = DateTime.now();
   dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
    var _classtypedata;
    List<String> classTypenew = [];
    List<String> classTypeid = [];
    String? selectedId;
   var selectedValue;
    var selectedValueid;

  var sectiontypedata;
  List<String> sectiontypename = [];
  List<String> sectiontypeid = [];
  String? selectedIdsection;
 var selectedValuesection;
 var selectedValuesectionid;

 var subjecttypedata;
  List<String> subjecttypename = [];
  List<String> subjecttypeid = [];
  String? selectedIdsubject;
 var selectedValuesubject;
 var selectedValuesubjectid;
 String ?branch_id;
 String ?userid;
 String ?session_id;
  bool isCheckedcheck = false;
  bool isChecked = false;
String ?fileName;
String ?filePath;



@override
  void initState() {
    super.initState();
    fetchData(); // Assuming fetchData is a function that combines getclassdata, getsectiondata, and gethomeworkdata
   
  }

  Future<void> fetchData() async {
    await getclassdata();
    await getsectiondata();
    if (widget.task == "Update" || widget.task == "View") {
      await gethomeworkdata(widget.id);
    }


  }


  Future<void> gethomeworkdata(id) async {
    var urlString = AppString.constanturl + 'get_homeworkdata';
    Uri uri = Uri.parse(urlString);
    var response = await http.post(uri, body: {
      "id": '$id',
    });
    var jsondata = jsonDecode(response.body);
    print(jsondata);
    Homework.text = jsondata['description'] ?? "";
    date_of_homework.text = jsondata['date_of_homework'] ?? "";
    date_of_submission.text = jsondata['date_of_submission'] ?? "";
    date_of_shedule.text = jsondata['schedule_date'] ?? "";
    String checktext = jsondata['status'] ?? "0";
    String class_name = jsondata['class_name'] ?? "Select Class";
    String section_name = jsondata['section_name'] ?? "Select Section";
    String subject_name = jsondata['subject_name'] ?? "Select Subject";
    String class_id = jsondata['class_id'] ?? "Select Class";
    String section_id = jsondata['section_id'] ?? "Select Section";
    String document = jsondata['document'] ?? "";
    fileselectname.text=document;
    
 
   setState(() {
        fileName = document;
        filePath = AppString.homework_imageurl + document;
      });
        print("isCheckedcheck"+checktext.toString());

        if(checktext=="true"){
          isCheckedcheck=true;
        }else{
           isCheckedcheck=false;
        }

       if (classTypenew.contains(class_name)) {
        
          int selectedIndex = classTypenew.indexOf(class_name);
         
          selectedId = classTypeid[selectedIndex];
          setState(() {
            selectedValue = class_name ?? "Select Class";
            selectedValueid = selectedId;
          });
        }

       // print(sectiontypename);
         if (sectiontypename.contains(section_name)) {
        // print(section_name);
          int selectedIndexnew = sectiontypename.indexOf(section_name);
             selectedIdsection = sectiontypeid[selectedIndexnew];
          setState(() {
            selectedValuesection = section_name ?? "Select Section";
            selectedValuesectionid = selectedIdsection;
          
 
          });
        }
        
        setState(() {
       
        getsubjectdata(class_id, section_id,subject_name);
        print(subject_name);
        print(subjecttypename);
        
        });
        
   
    
  }
  void savedata(String classid,String sectionid,String subjectid,String dateofhoemwork,String dateofsubmission
          ,String dateofshedule,bool checkboxchecked,String Homeworkdes,String fileselectname)async {
     print(classid);
     print(sectionid);
     print(subjectid);
     print(fileselectname);
      SharedPreferences preferences = await SharedPreferences.getInstance();
       userid = preferences.getString('user_id');
       branch_id = preferences.getString('branch_id');
       session_id = preferences.getString('session_id');
          if(classid=="null"){
             Fluttertoast.showToast(
            backgroundColor:WireframeColor.listbackgroundcolor,
            textColor: Colors.white,
            msg: 'The Class field is required.',
            toastLength: Toast.LENGTH_SHORT,
           );

          }else if(sectionid=="null"){
             Fluttertoast.showToast(
            backgroundColor:WireframeColor.listbackgroundcolor,
            textColor: Colors.white,
            msg: 'The Section field is required.',
            toastLength: Toast.LENGTH_SHORT,
           );

          }else if(subjectid=="null"){
            Fluttertoast.showToast(
            backgroundColor:WireframeColor.listbackgroundcolor,
            textColor: Colors.white,
            msg: 'The Subject field is required.',
            toastLength: Toast.LENGTH_SHORT,
           );
          }else if(dateofhoemwork==""){
            Fluttertoast.showToast(
              backgroundColor:WireframeColor.listbackgroundcolor,
              textColor: Colors.white,
              msg: 'The Date Of Homework field is required.',
              toastLength: Toast.LENGTH_SHORT,
            );
          }else if(dateofsubmission==""){
            Fluttertoast.showToast(
              backgroundColor:WireframeColor.listbackgroundcolor,
              textColor: Colors.white,
              msg: 'The Date Of Submission  field is required.',
              toastLength: Toast.LENGTH_SHORT,
            );
          }else if(Homeworkdes==""){
               Fluttertoast.showToast(
              backgroundColor:WireframeColor.listbackgroundcolor,
              textColor: Colors.white,
              msg: 'The Homework field is required.',
              toastLength: Toast.LENGTH_SHORT,
            );
          }
          // else if(fileselectname==""){
          //     Fluttertoast.showToast(
          //     backgroundColor:WireframeColor.listbackgroundcolor,
          //     textColor: Colors.white,
          //     msg: 'Please Select Attachment File First.',
          //     toastLength: Toast.LENGTH_SHORT,
          //   );
          // }
          else{
            var urlString = AppString.constanturl + 'Add_homework_Teacher';
            Uri uri = Uri.parse(urlString);
             var response = await http.post(uri, body: {
              "class_id":classid,
              "section_id":sectionid,
              "subject_id":subjectid,
              "date_of_homework":dateofhoemwork,
              "date_of_submission":dateofsubmission,
              "description":Homeworkdes,
              "status":checkboxchecked.toString(),
              "schedule_date":dateofshedule,
              "created_by":userid,
              "session_id":session_id,
              "branch_id":branch_id,
             });
              var jsonResponse = json.decode(response.body);
    
      if (jsonResponse['result'] == "sucess") {
        if (fileName != "") {
       //int id = jsonResponse['id'];
          saveFileOnServer(jsonResponse['id'],fileName.toString(),filePath.toString());
        }
      Fluttertoast.showToast(
        backgroundColor: const Color.fromARGB(255, 0, 255, 55),
        textColor: Colors.white,
        msg: jsonResponse['message'],
        toastLength: Toast.LENGTH_SHORT,
      );
      setState(() {
       
      
        Homework.text = "";
        date_of_homework.text = "";
        date_of_submission.text = "";
        date_of_shedule.text = "";
        isCheckedcheck = false;
        selectedValue = "";
        selectedValuesection = "";
        selectedValuesubject = "";
        
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => teacherdashboard()),
      );
    }else{
        Fluttertoast.showToast(
        backgroundColor: const Color.fromARGB(255, 0, 255, 55),
        textColor: Colors.white,
        msg: jsonResponse['message'],
        toastLength: Toast.LENGTH_SHORT,
       );
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => teacherdashboard()),
      );
    }
          }





  }

  void updateData(String classid,String sectionid,String subjectid,String dateofhoemwork,String dateofsubmission
          ,String dateofshedule,bool checkboxchecked,String Homeworkdes,String fileselectname)async {
    
      SharedPreferences preferences = await SharedPreferences.getInstance();
       userid = preferences.getString('user_id');
       branch_id = preferences.getString('branch_id');
       session_id = preferences.getString('session_id');
          if(classid=="Select Class"){
             Fluttertoast.showToast(
            backgroundColor:WireframeColor.listbackgroundcolor,
            textColor: Colors.white,
            msg: 'The Class field is required.',
            toastLength: Toast.LENGTH_SHORT,
           );

          }else if(sectionid=="Select Section"){
             Fluttertoast.showToast(
            backgroundColor:WireframeColor.listbackgroundcolor,
            textColor: Colors.white,
            msg: 'The Section field is required.',
            toastLength: Toast.LENGTH_SHORT,
           );

          }else if(subjectid=="Select Subject"){
            Fluttertoast.showToast(
            backgroundColor:WireframeColor.listbackgroundcolor,
            textColor: Colors.white,
            msg: 'The Subject field is required.',
            toastLength: Toast.LENGTH_SHORT,
           );
          }else if(dateofhoemwork==""){
            Fluttertoast.showToast(
              backgroundColor:WireframeColor.listbackgroundcolor,
              textColor: Colors.white,
              msg: 'The Date Of Homework field is required.',
              toastLength: Toast.LENGTH_SHORT,
            );
          }else if(dateofsubmission==""){
            Fluttertoast.showToast(
              backgroundColor:WireframeColor.listbackgroundcolor,
              textColor: Colors.white,
              msg: 'The Date Of Submission  field is required.',
              toastLength: Toast.LENGTH_SHORT,
            );
          }else if(Homeworkdes==""){
               Fluttertoast.showToast(
              backgroundColor:WireframeColor.listbackgroundcolor,
              textColor: Colors.white,
              msg: 'The Homework field is required.',
              toastLength: Toast.LENGTH_SHORT,
            );
          }
          // else if(fileselectname==""){
          //      Fluttertoast.showToast(
          //     backgroundColor:WireframeColor.listbackgroundcolor,
          //     textColor: Colors.white,
          //     msg: 'Please Select Attachment File First.',
          //     toastLength: Toast.LENGTH_SHORT,
          //   );

          // }
          else{
            var urlString = AppString.constanturl + 'Update_homework_Teacher';
            Uri uri = Uri.parse(urlString);
             var response = await http.post(uri, body: {
              "id":widget.id,
              "class_id":classid,
              "section_id":sectionid,
              "subject_id":subjectid,
              "date_of_homework":dateofhoemwork,
              "date_of_submission":dateofsubmission,
              "description":Homeworkdes,
              "status":checkboxchecked.toString(),
              "schedule_date":dateofshedule,
              "created_by":userid,
              "session_id":session_id,
              "branch_id":branch_id,
             });
              var jsonResponse = json.decode(response.body);
       
      if (jsonResponse['result'] == "sucess") {
         if (fileName != "") {
          int id = int.parse(jsonResponse['id']);
            saveFileOnServer(id,fileName.toString(),filePath.toString());
          }
      Fluttertoast.showToast(
        backgroundColor: const Color.fromARGB(255, 0, 255, 55),
        textColor: Colors.white,
        msg: jsonResponse['message'],
        toastLength: Toast.LENGTH_SHORT,
      );
      setState(() {
       
      
        Homework.text = "";
        date_of_homework.text = "";
        date_of_submission.text = "";
        date_of_shedule.text = "";
        isCheckedcheck = false;
        selectedValue = "";
        selectedValuesection = "";
        selectedValuesubject = "";
        
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => teacherdashboard()),
      );
    }else{
        Fluttertoast.showToast(
        backgroundColor: const Color.fromARGB(255, 0, 255, 55),
        textColor: Colors.white,
        msg: jsonResponse['message'],
        toastLength: Toast.LENGTH_SHORT,
       );
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => teacherdashboard()),
      );
    }
          }





  }

Future<void> saveFileOnServer(int id, String fileName, String filePath) async {
  try {
    var urlString = AppString.constanturl + 'Add_homework_image';
    Uri uri = Uri.parse(urlString);
    var request = http.MultipartRequest('POST', uri);
     print("filepath == "+filePath);
    if (filePath != null) {
      // Compress the selected file if it's an image (you may need different handling for different file types)
      String fileExt = fileName.substring(fileName.lastIndexOf('.'));
      if(fileExt==".pdf"){
            request.files.add(await http.MultipartFile.fromPath(
                  'file', // Field name for the file in your API
                  filePath, // Use the file path
                  filename: fileName,
                ));
      }else{
          
           List<int> compressedImage = await FlutterImageCompress.compressWithFile(
              filePath,
              quality: 80,
            ) ?? <int>[];

            var compressedFile = await http.MultipartFile.fromBytes(
              'file', // Field name for the file in your API
              compressedImage, // Use the compressed file bytes
              filename: fileName,
            );

           
            request.files.add(compressedFile);
     
     
      }
     
    } 

     
     
    request.fields['id'] = id.toString();
   
      print("requesteddata == "+request.toString());
    var response = await request.send();

    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error during file upload: $e');
  }
}


 Future<void> getclassdata() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
   var urlString = AppString.constanturl + 'fecthclassname';
    Uri uri = Uri.parse(urlString);
     var response = await http.post(uri, body: {
      "branch_id":'$branch_id',
    });
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      _classtypedata = jsonData;
      //print(_classtypedata);
      for (int i = 0; i < _classtypedata.length; i++) {
        classTypeid.add(_classtypedata[i]["id"]);
        classTypenew.add(_classtypedata[i]["classname"]);
        setState(() {});
      }
    }
  }

  Future<void> getsectiondata() async {
   // final response = await http.get(Uri.parse(AppString.constanturl + 'fetchsection'));
   SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
    var urlString = AppString.constanturl + 'fetchsection';
    Uri uri = Uri.parse(urlString);
     var response = await http.post(uri, body: {
      "branch_id":'$branch_id',
    });
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      sectiontypedata = jsonData;
     // print(sectiontypedata);
      for (int i = 0; i < sectiontypedata.length; i++) {
        sectiontypeid.add(sectiontypedata[i]["id"]);
        sectiontypename.add(sectiontypedata[i]["name"]);
        setState(() {});
      }
    }
  }

  Future<void> getsubjectdata(String classid,String sectionid,String subject_name) async {
    print(classid);
    print(sectionid);
   SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
    var urlString = AppString.constanturl + 'fetchsubject';
    Uri uri = Uri.parse(urlString);
    print(branch_id);
     var response = await http.post(uri, body: {
      "class_id":classid,"section_id":sectionid,"branch_id":branch_id
    });
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      subjecttypedata = jsonData;
      print(subjecttypedata);
      for (int i = 0; i < subjecttypedata.length; i++) {
        subjecttypeid.add(subjecttypedata[i]["id"]);
        subjecttypename.add(subjecttypedata[i]["name"]);
        setState(() {});
      }
    }

     if(widget.task=="Update" ||widget.task=="View"){
       if (subjecttypename.contains(subject_name)) {
         
          int selectedIndexthree = subjecttypename.indexOf(subject_name);
             selectedIdsubject = subjecttypeid[selectedIndexthree];
          setState(() {
            selectedValuesubject = subject_name ?? "Select Subject";
            selectedValuesubjectid = selectedIdsubject;
 
 
          });
        }
     }
  }

  Future<void> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpeg', 'jpg'],
  );

  if (result != null) {
    // Handle the picked file
     fileName = result.files.single.name;
     filePath = result.files.single.path.toString();
    fileselectname.text=fileName.toString();
    var size = await File(filePath.toString()).length();
       print("getsize"+size.toString());

    print('File Name: $fileName');
    print('File Path: $filePath');

  } else {
    // User canceled the file picking
    print('User canceled file picking');
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
        leadingWidth:width/1 ,
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
                  child: Icon(Icons.arrow_back_ios_new,size: height/36,color: WireframeColor.white,)),
              SizedBox(width: width/36,),
              Text("Homework",style: sansproRegular.copyWith(fontSize: 18,color: WireframeColor.white,),),

            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: height / 36,bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: themedata.isdark ? WireframeColor.black : WireframeColor.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                       bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 26, vertical: height / 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
              Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [ Container(
                       margin: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                    child:Text(
                      "Select Class",
                       style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )),]),
                 
                  Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    // Ensure the DropdownSearch takes up available space
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                      child: DropdownSearch<String>(
                        items: classTypenew,
                        onChanged: (String? value) {
                          if (value != null) {
                            int selectedIndex = classTypenew.indexOf(value);
                            selectedId = classTypeid[selectedIndex];
                            setState(() {
                              selectedValue = value;
                              selectedValueid = selectedId;
                            });
                          }
                        },

                         

                       
                        selectedItem: selectedValue ?? "Select Class",
                        // Check the condition and set enabled accordingly
                        enabled: !(widget.task == "View"),
                      ),
                    ),
                  ),
                ],
              ),

               Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [ Container(
                       margin: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                    child:Text(
                      "Select Section",
                       style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )),]),

                      Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                      child: DropdownSearch<String>(
                        items: sectiontypename,
                        onChanged: (String? value) {
                          if (value != null) {
                            int selectedIndex = sectiontypename.indexOf(value);
                            selectedIdsection = sectiontypeid[selectedIndex];
                            setState(() {
                              selectedValuesection = value;
                              selectedValuesectionid = selectedIdsection;
                              getsubjectdata(selectedValueid, selectedValuesectionid,"");
                            });
                          }
                        },
                        selectedItem: selectedValuesection ?? "Select Section",
                        // Check the condition and set enabled accordingly
                        enabled: !(widget.task == "View"),
                      ),
                    ),
                  ),
                ],
              )
              ,

              Row(
                  
                  children: [ Container(
                  margin: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                    child:Text(
                      "Select Subject",
                       style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )),]),

                    Row(
                
                children: [
                  Expanded(
                    // Ensure the DropdownSearch takes up available space
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                      child: DropdownSearch<String>(
                        items: subjecttypename,
                        onChanged: (String? value) {
                          if (value != null) {
                            int selectedIndex = subjecttypename.indexOf(value);
                            selectedIdsubject = subjecttypeid[selectedIndex]; // Corrected variable here
                            setState(() {
                              selectedValuesubject = value;
                              selectedValuesubjectid = selectedIdsubject;
                            });
                          }
                        },
                        selectedItem: selectedValuesubject ?? "Select Subject",
                        // Check the condition and set enabled accordingly
                         enabled: !(widget.task == "View"),
                      ),
                    ),
                  ),
                ],
              ),


               
                 Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [ Container(
                  margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child:Text(
                      "Date Of Homework ",
                       style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )),]),

                  
              Row(
              children: [
                Expanded(
                   child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    
                    decoration: const InputDecoration(
                      icon: Icon(Icons.date_range),
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    controller: date_of_homework,
                    readOnly: widget.task == "View",
                     keyboardType: TextInputType.none,
                    onTap: () async {
                       if (widget.task != "View") {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: fromDate_homework,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                      );
                     
                       if (pickedDate != null) {
                              setState(() {
                                fromDate_homework = pickedDate;
                                date_of_homework.text =
                                    DateFormat('dd-MM-yyyy').format(fromDate_homework);
                              });
                            }
                       }
                    },
                  ),
                 ) ),
              ],
            ),

             Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [ Container(
                  margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child:Text(
                      "Date Of Submission",
                       style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )),]),

                     Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                   
                    child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.date_range),
                        //labelText: 'Start Date',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey), // Set transparent to hide default underline
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      controller: date_of_submission,
                     //readOnly: widget.task == "View",
                      keyboardType: TextInputType.none,
                      onTap: () async {
                         if (widget.task != "View") {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: fromDate_submission,
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2100),
                        );
                       
                        if (pickedDate != null) {
                              setState(() {
                                fromDate_submission = pickedDate;
                                date_of_submission.text =
                                    DateFormat('dd-MM-yyyy').format(fromDate_submission);
                              });
                            }
                         }
                      },
                    ),
                  ),
                ),
              ],
            ),

             Row(
                children: [
                  Checkbox(
                    value: isCheckedcheck,
                    onChanged: (bool? value) {
                       if (widget.task != "View") {
                      setState(() {
                        isCheckedcheck = value!;
                        if (!isCheckedcheck) {
                          // Set scheduled date to blank if checkbox is unchecked
                          date_of_shedule.text = '';
                        } else {
                          // Set scheduled date to homework date if checkbox is checked
                          date_of_shedule.text = date_of_homework.text;
                        }
                      });
                    }
                    },
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Published later ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),


                Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Text(
                      "Schedule Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),


               Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          
                          child: TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.date_range),
                              labelStyle: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            controller: date_of_shedule,
                             keyboardType: TextInputType.none,
                            readOnly: !isChecked, // Set readOnly based on the checkbox state
                            onTap: () async {
                              
                              if (isChecked) {
                                 if (widget.task != "View") {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: fromDate_shedule,
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2100),
                                );
  

                                if (pickedDate != null) {
                                setState(() {
                                fromDate_shedule = pickedDate;
                                date_of_submission.text =
                                    DateFormat('dd-MM-yyyy').format(fromDate_shedule);
                              });
                            }
                                 }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                   Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [ Container(
                  margin: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 5.0),
                    child:Text(
                      "Homework ",
                       style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )),]),


                      Row(
                  children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                      child: TextField(
                        readOnly: widget.task == "View",
                        maxLines: 5,
                        controller: Homework,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          labelText: 'Homework',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                       
                      ),
                    ),
                  ),
                ],
              ),

               Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [ Container(
                  margin: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 5.0),
                    child:Text(
                      "Attachment File ",
                       style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )),]),


                    
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
                   ElevatedButton(
                      onPressed: pickFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Button color
                      ),
                      child: Row(
                        children: [
                           Icon(
                                  Icons.file_upload,
                                  color: Colors.white,
                              size: height / 30,
                                ),
                          SizedBox(width: 8), // Adjust the spacing between icon and text
                          Text('Select File',
                          style: TextStyle(color:Colors.white),),
                        ],
                      ),
                    ),

                   
                  
                   
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                   child:TextFormField(
                              readOnly: widget.task == "View",
                              controller: fileselectname,
                              maxLines: 1,
                              keyboardType: TextInputType.none,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                    ))]),
               
        SizedBox(height: 20,),
           if(widget.task!="View")
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                        height: 40,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            // Check the value of the 'task' variable
                            if (widget.task == 'Update') {
                              // If 'task' is 'update', perform the update action
                               updateData(selectedValueid.toString(), selectedValuesectionid.toString(), selectedValuesubjectid.toString(), date_of_homework.text,
                                   date_of_submission.text, date_of_shedule.text, isCheckedcheck, Homework.text,fileselectname.text);
                            } else if(widget.task == 'Add'){
                              // If 'task' is not 'update', perform the save action
                              savedata(selectedValueid.toString(), selectedValuesectionid.toString(), selectedValuesubjectid.toString(), date_of_homework.text,
                                  date_of_submission.text, date_of_shedule.text, isCheckedcheck, Homework.text,fileselectname.text);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WireframeColor.appcolor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                // Change button text based on the 'task' variable
                                widget.task == 'Update' ? 'Update' : 'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
                      ,
                      SizedBox(width:10),
                        Container(
                          height: 40, // Set the desired height
                          width: 150, // Set the desired width
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const Wireteacherhomeworklist();
                                    },
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WireframeColor.appcolor, // Button color
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // You can add any additional widgets or styling here
                                Text(
                                  'Showlist',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
SizedBox(height: 20,),
                      
                      ],
                    ),
                  ),
                ),
              ),
            )
            , 
    );
  }
}