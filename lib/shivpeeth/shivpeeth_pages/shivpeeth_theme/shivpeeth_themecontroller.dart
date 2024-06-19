import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_prefsname.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_theme.dart';



class WireframeThemecontroler extends GetxController{
  @override
  void onInit()
  {
    // SharedPreferences.getInstance().then((value) {
    //   isdark = value.getBool(wireframeDarkMode)!;
    // });

    try {
  SharedPreferences.getInstance().then((value) {
    if (value != Null) {
      isdark = value.getBool(wireframeDarkMode) ?? false;
    } else {
      // Handle the case where SharedPreferences instance is null.
      // You might want to set a default value for isdark or handle it differently.
    }
  });
} catch (e) {
  // Handle exceptions here.
  print("Error fetching SharedPreferences: $e");
}

    update();
    super.onInit();
  }

  var isdark = false;
  Future<void> changeTheme (state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isdark = prefs.getBool(wireframeDarkMode) ?? true;
    isdark = !isdark;

    if (state == true) {
      Get.changeTheme(WireframeMythemes.darkTheme);
      isdark = true;
    }
    else {
      Get.changeTheme(WireframeMythemes.lightTheme);
      isdark = false;
    }
    update();
  }

}