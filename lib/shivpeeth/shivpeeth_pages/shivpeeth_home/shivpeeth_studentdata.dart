import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/constant/conurl.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_icons.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_studentprofiledata.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class studentdatalist {
  final String id;
  final String name;
  final String clname;
  final String photo;
  

  studentdatalist(
      {required this.id,
      //required this.photo,
      required this.name,
      required this.clname,
      required this.photo,
     

      
      
      });

  factory studentdatalist.fromJson(Map<String, dynamic> json) {
    return studentdatalist(
      id: json['id'],
      //photo: json['photo'],
      name: json['name'],
      clname: json['clname'],
      photo: json['photo'],
    
    );
  }
}


class Wireframestudentdata extends StatefulWidget {
  const Wireframestudentdata({Key? key}) : super(key: key);

  @override
  State<Wireframestudentdata> createState() => WireframestudentdataState();
}

class WireframestudentdataState extends State<Wireframestudentdata> {

  double height = 0.00;
  double width = 0.00;
 List<studentdatalist> carouselItems = [];
 List<studentdatalist> getitem = [];
   List<studentdatalist> filteredList = [];

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
 String? id;
 String? roleid;
 String? branch_id;


   @override
  void initState() {
    super.initState();
   
    getclassdata();
    getsectiondata();
    fetchbuinesssearchlist("Select Class","Select Section");
  }
 

   void getshade() async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     id = preferences.getString('id');
     roleid = preferences.getString('role');
   }
Future<void> getclassdata() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
    print(branch_id);
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

  Future<void> fetchbuinesssearchlist(selectedValue, selectedValue2) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
 String apiUrl = AppString.constanturl + 'fetchstudentdatareport';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "class_id": selectedValue != null ? selectedValue : 'Select Class',
        "section_id": selectedValue2 != null ? selectedValue2 : 'Select Section',
        "branch_id": branch_id != null ? branch_id : '',

      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<studentdatalist> items = [];
      print(jsonData);
      for (var item in jsonData) {
        items.add(studentdatalist.fromJson(item));
      }

      setState(() {
        carouselItems = items;
        getitem = items;
        
      });
    } else {
      // Handle API error
    }
  }
  Widget buildDropdownContainer() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: WireframeColor.appcolor),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width / 36,
        vertical: height / 66,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded( 
                      child: Container(
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
     
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded( // Ensure the DropdownSearch takes up available space
                      child: Container(
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
                              });
                            }
                          },
                          selectedItem: selectedValuesection ?? "Select Section",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Column(
            children: [
              InkWell(
                onTap: () {
                  fetchbuinesssearchlist(selectedValueid,selectedValuesectionid);
                },
                child: Image.asset(
                  WireframePngimage.filter, // Replace with your image asset path
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void filterItems(String query) {
 
  if (query.isNotEmpty || query==Null) {
    filteredList = carouselItems.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.clname.toLowerCase().contains(query.toLowerCase());
    }).toList();
  } else {
   
    filteredList = List.from(getitem);
  
  }

  // setState(() {
  //   carouselItems = filteredList;
  // });
   setState(() {
    carouselItems = List.from(filteredList.isEmpty ? carouselItems : filteredList);
  });
}

void openUrl() async {
  if (selectedValueid == null || selectedValueid.isEmpty) {
    selectedValueid = "Select Class";
  }
  if (selectedValuesectionid == null || selectedValuesectionid.isEmpty) {
    selectedValuesectionid = "Select Section";
  }
   SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');

  // String appUrlNew =
  //    AppString.loginurl.replace("https", "http")  + 'exporttoecel.php?class_id=$selectedValueid&section_id=$selectedValuesectionid';
String appUrlNew = AppString.loginurl.replaceAll("https", "http") +
    'exporttoecel_studentdata.php?class_id=$selectedValueid&section_id=$selectedValuesectionid&branch_id=$branch_id';

   try {
      await launch(appUrlNew);
    } catch (e) {
      print('Error launching URL: $e');
    }
}

 List<studentdatalist> getYourData() {
    // Implement a function to get your data
    // For example, return a dummy list for demonstration
    return List.generate(
      10,
      (index) => studentdatalist(
        id: index.toString(),
        name: 'Student $index',
        clname: 'Class $index',
        photo: 'photo $index',
      ),
    );
  }

  Future<bool> doesImageExist( String photo) async {
       String imageUrl =  AppString.studentimageurl + photo;
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
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  final themedata = Get.put(WireframeThemecontroler());
   String? roletype='$roleid';
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
                "Student's Data",
                style: sansproRegular.copyWith(
                  fontSize: 18,
                  color: WireframeColor.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: height / 36,bottom: 5),
          child: Container(
            decoration:  BoxDecoration(
                color: themedata.isdark ? WireframeColor.black : WireframeColor.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),
                bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20))
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width / 26,
                vertical: height / 36,
              ),
              child: Column(
                children: [
                  buildDropdownContainer(),
                  SizedBox(height: 10),

                  Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     SizedBox(width: 10),
                    Expanded( // Ensure the DropdownSearch takes up available space
              child:  Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0), // Add horizontal margin
              height: 50.0, // Set the height of the TextField
              //width: 350.0, // Set the width of the TextField
              child: TextField(
                onChanged: (value) {
                  // Call a method to filter the items based on the input value
                  filterItems(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.grey, // Set border color to gray
                    ),
                  ),
                ),
                style: TextStyle(
                  // Set text field text color
                  color: Colors.black,
                ),
              ),
            ),
                    ),
                  ],
                ),
              
              ],
            ),
          ),
          SizedBox(width: 10),
           roletype!='7' ? Column(
            children: [
              InkWell(
                 onTap: () async {
               
                openUrl();
                   //List<studentdatalist> carouselItems = getYourData();

        // Call the exportToExcel function
             // await excelExport.exportToExcel(carouselItems);

                },
                child: Image.asset(
                  WireframePngimage.excel, // Replace with your image asset path
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ):
           SizedBox(width: 5),
          
        ],
      ),
                


                  SizedBox(height: height / 36),
              
       ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: carouselItems.isEmpty
                      ? Center(
                          child: Text(
                            'No record found',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) => WireframeColor.listbackgroundcolor,
                          ),
                          dataRowHeight: 60.0,
                          columns: [
                            DataColumn(
                              label: Text(
                                'Photo',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Class',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Action ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: carouselItems.map((student) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  // IconButton(
                                  //   iconSize: 5,
                                  //   icon: Image.asset(WireframePngimage.profile,
                                  //    width: 25, 
                                  //    height: 25,),
                                  //   onPressed: () {
                                  //     // Handle edit action
                                  //   },
                                  // ),

                                  IconButton(
                              iconSize: 25,
                              icon: student.photo.toString() != ""
                                  ? FutureBuilder(
                                      future: doesImageExist(student.photo.toString()),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          if (snapshot.hasError || snapshot.data != true) {
                                            // Handle error or image not found case
                                            return Image.asset(
                                              WireframePngimage.profile,
                                              width: 25,
                                              height: 25,
                                            );
                                          } else {
                                            // Display the valid image
                                            return Image.network(
                                              AppString.studentimageurl + student.photo.toString(),
                                              width: 25,
                                              height: 25,
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
                                      width: 25,
                                      height: 25,
                                    ),
                              onPressed: () {
                                // Handle edit action
                              },
                            )

                                ),
                                DataCell(Text(student.name)),
                                DataCell(Text(student.clname)),
                                DataCell(IconButton(
                                  icon: Image.asset(WireframePngimage.action,height: 20,width: 20,),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return studentprofiledata(studid:student.id);

                                  },
                                ));
                                  },
                                )),
                              ],
                            );
                          }).toList(),
                        ),
                ),
              ),
            )
            ,
            SizedBox(height: 10,),
          
    //))

         


                ],
              ),
            ),
          ),
        ),
      ),
      
    );
  }
}
