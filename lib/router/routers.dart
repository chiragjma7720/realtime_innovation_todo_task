import 'package:flutter/cupertino.dart';
import 'package:todo/models/employee_data.dart';
import 'package:todo/screens/home_page.dart';

import '../constants/string.dart';
import '../screens/add_employee_details.dart';

Map<String, WidgetBuilder>? routes = {
  //routerStrings['homePageScreen']!: (context) => const HomePage(),
  '/': (context) => const HomePageScreen(),
  //sirf ye delete krna h baad m
  // routerStrings['addEmployeeDetailsScreen']!: (context) => const AddEmployeeDetailsScreen(),
  routerStrings['addEmployeeDetailsScreen']!: (context) {
    EmployeeData? employeeData =
        ModalRoute.of(context)!.settings.arguments as EmployeeData?;
    return AddEmployeeDetailsScreen(employeeData: employeeData,);
  },
  //routerStrings['homePageScreen']!: (context) => const HomePage(),
  //routerStrings['addEmployeeDetailsScreen']!: (context) => const SigninScreen(),
};
