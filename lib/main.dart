import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/screens/home_screen.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const APITester());
}

class APITester extends StatelessWidget {
  const APITester({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
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
        home: const HomeScreen(),
      ),
    );
  }
}
