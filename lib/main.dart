import 'package:api_tester_app/controllers/groups_provider.dart';
import 'package:api_tester_app/controllers/history_provider.dart';
import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/screens/home_screen.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:api_tester_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.historyBox);
  await Hive.openBox(AppConstants.groupsBox);
  await Hive.openBox(AppConstants.foldersBox);
  // await Hive.box(AppConstants.historyBox).clear();
  // await Hive.box(AppConstants.groupsBox).clear();
  // await Hive.box(AppConstants.foldersBox).clear();

  runApp(const APITester());
}

class APITester extends StatelessWidget {
  const APITester({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => GroupsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "API Tester",
        theme: ThemeData(
          dropdownMenuTheme: DropdownMenuThemeData(
            textStyle: GoogleFonts.righteous(fontSize: 14),
            menuStyle: MenuStyle(
              elevation: MaterialStateProperty.all(2),
              backgroundColor:
                  MaterialStateProperty.all(AppColors.dropDownBackgroundColor),
            ),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
