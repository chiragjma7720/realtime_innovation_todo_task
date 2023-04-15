import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo/widgets/circular_progress_indicator.dart';

import '../constants/app_colors.dart';
import '../constants/string.dart';
import '../models/employee_data.dart';
import '../services/local_db.dart';
import '../utills/getDateWithComma.dart';
import '../widgets/textWidget.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen> {
  bool isDataLoaded = false;
  List<EmployeeData> employeeList = [];
  List<EmployeeData> currentEmployeeList = [];
  List<EmployeeData> previousEmployeeList = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    employeeList = [];
    currentEmployeeList = [];
    previousEmployeeList = [];
    setState(() {
      isDataLoaded = false;
    });
    List<EmployeeData> list = await LocalDB().getEmployeeDataList();
    if (list != null) {
      employeeList = list;
    }
    for (EmployeeData employeeData in employeeList) {
      if (compareDates(employeeData.toDate)) {
        currentEmployeeList.add(employeeData);
      } else {
        previousEmployeeList.add(employeeData);
      }
    }
    //sleep(Duration(seconds: 10));
    print("cutrrent employee --- $currentEmployeeList");
    print("previous employee --- $previousEmployeeList");

    /* previousEmployeeList = [];
    currentEmployeeList = [];*/
    setState(() {
      isDataLoaded = true;
    });
  }

  bool compareDates(String date1Str) {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat(dateFormat2);
    String currDateStr = format.format(now);
    DateTime date1 = format.parse(date1Str);
    DateTime currDate = format.parse(currDateStr);
    return date1.compareTo(currDate) >= 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
                    context, routerStrings['addEmployeeDetailsScreen']!)
                .then((value) {
              getData();
            });
          },
          child: Icon(Icons.add),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        appBar: AppBar(
          title: Text("Employee List"),
        ),
        backgroundColor: homePageBackgroundColor,
        body: previousEmployeeList.isNotEmpty || currentEmployeeList.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: headingBgColor,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Current employees",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.blue),
                    ),
                  ),
                  currentEmployeeList.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => Divider(
                                height: 0,
                              ),
                          itemCount: currentEmployeeList.length,
                          itemBuilder: (context, int index) {
                            String fromDateStr = getDateWithComma(
                                currentEmployeeList[index].fromDate.toString());
                            /*String fromDateStr = getDateWithComma(currentEmployeeList[index].fromDate.toString());
                    String toDateStr = getDateWithComma(currentEmployeeList[index].toDate.toString());*/
                            return Slidable(
                              key: ValueKey(index),
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    //flex: 2,
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    //label: 'Delete',
                                    onPressed: (BuildContext context) async {
                                      EmployeeData data =
                                          currentEmployeeList.removeAt(index);
                                      print("deleted");
                                      setState(() {});
                                      int preIndex = index;
                                      final snackBar = SnackBar(
                                        content: Text(
                                            'Employee data has been deleted'),
                                        duration: Duration(seconds: 5),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {
                                            currentEmployeeList.insert(
                                                preIndex, data);
                                          },
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar)
                                          .closed
                                          .then((reason) async {
                                        if (reason.name ==
                                            SnackBarClosedReason.timeout.name) {
                                          print("User Deleted from DB");
                                          await LocalDB()
                                              .deleteEmployeeData(data);
                                        }

                                        setState(() {});
                                      });
                                    },
                                  ),
                                ],
                              ),
                              child: ListTile(
                                isThreeLine: true,
                                title: Text(
                                  currentEmployeeList[index].name,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(currentEmployeeList[index].role),
                                    SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                      "From ${fromDateStr}",
                                      style: TextStyle(fontSize: 12),
                                    )

                                    //Text("$fromDateStr - $toDateStr", style: TextStyle(fontSize: 12),)
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                          context,
                                          routerStrings[
                                              'addEmployeeDetailsScreen']!,
                                          arguments: currentEmployeeList[index])
                                      .then((value) {
                                    getData();
                                  });
                                },
                              ),
                            );
                          })
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "No Data Found",
                          ),
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: headingBgColor,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Previous employees",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.blue),
                    ),
                  ),
                  previousEmployeeList.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => Divider(
                                height: 0,
                              ),
                          itemCount: previousEmployeeList.length,
                          itemBuilder: (context, int index) {
                            String fromDateStr = getDateWithComma(
                                previousEmployeeList[index]
                                    .fromDate
                                    .toString());
                            String toDateStr = getDateWithComma(
                                previousEmployeeList[index].toDate.toString());

                            return Slidable(
                              key: ValueKey(index),
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    //flex: 2,
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    //label: 'Delete',
                                    onPressed: (BuildContext context) {
                                      EmployeeData data =
                                          previousEmployeeList.removeAt(index);
                                      print("deleted");
                                      setState(() {});
                                      int preIndex = index;
                                      final snackBar = SnackBar(
                                        content: Text(
                                            'Employee data has been deleted'),
                                        duration: Duration(seconds: 5),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {
                                            previousEmployeeList.insert(
                                                preIndex, data);
                                          },
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar)
                                          .closed
                                          .then((reason) async {
                                        if (reason.name ==
                                            SnackBarClosedReason.timeout.name) {
                                          print("User Deleted from DB");
                                          await LocalDB()
                                              .deleteEmployeeData(data);
                                        }

                                        setState(() {});
                                      });
                                    },
                                  ),
                                ],
                              ),
                              child: ListTile(
                                isThreeLine: true,
                                title: Text(
                                  previousEmployeeList[index].name,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(previousEmployeeList[index].role),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "$fromDateStr - $toDateStr",
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                          context,
                                          routerStrings[
                                              'addEmployeeDetailsScreen']!,
                                          arguments:
                                              previousEmployeeList[index])
                                      .then((value) {
                                    getData();
                                  });
                                },
                              ),
                            );
                          })
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "No Data Found",
                          ),
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: headingBgColor,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Swip left to delete",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey),
                    ),
                  ),
                ],
              ))
            : SafeArea(
                child: Center(
                child: isDataLoaded
                    ? Image.asset(
                        'assets/images/no_data_found.png',
                        height: 150,
                        width: 150,
                      )
                    : Container(
                        height: 30.0,
                        child: Text("Loading..."),
                      ),
              )));
  }
}
