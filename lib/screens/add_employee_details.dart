import 'package:flutter/material.dart';
import 'package:todo/models/employee_data.dart';
import 'package:todo/utills/validateString.dart';
import 'package:todo/widgets/snackbar.dart';

import '../constants/app_colors.dart';
import '../constants/string.dart';
import '../services/local_db.dart';
import '../widgets/textWidget.dart';

class AddEmployeeDetailsScreen extends StatefulWidget {
  EmployeeData? employeeData;
  AddEmployeeDetailsScreen({Key? key, this.employeeData, }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddEmployeeDetailsScreenState();
}

class AddEmployeeDetailsScreenState extends State<AddEmployeeDetailsScreen> {
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController selectRoleController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  @override
  void initState() {
    setFields();
    super.initState();
  }

  setFields()
  {
    if(widget.employeeData != null)
      {
        employeeNameController.text = widget.employeeData!.name;
        selectRoleController.text = widget.employeeData!.role;
        fromDateController.text = widget.employeeData!.fromDate;
        toDateController.text = widget.employeeData!.toDate;
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: getAppDrawer(0, context, user: user),
      //drawer: const DrawerMenu(currScreen: 0),
      /*appBar: getAppbar(user, context),*/

      appBar: AppBar(
        title: Text(widget.employeeData!=null?"Edit Employee Details":"Add Employee Details"),
        actions: [
          if(widget.employeeData!=null)IconButton(onPressed: () async {
                await LocalDB()
                    .deleteEmployeeData(widget.employeeData!);
                Navigator.pop(context,true);
                showSneakBar(context, "Employee data has been deleted", Colors.red);
              }, icon: Icon(Icons.delete_outlined))
        ],

      ),
      backgroundColor: addEmployeePageBackgroundColor,
      body: Container(
        height: double.maxFinite,
        child: Stack(
          children: <Widget>[
            Positioned(
                child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  getTextInputWidget("Employee name", employeeNameController,
                      Icons.person_outline),
                  SizedBox(
                    height: 20,
                  ),
                  getTextInputBottomSheetSelectWidget("Select role",
                      selectRoleController, Icons.cases_outlined, context),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          child: getIconBasedTextField("openingTime",
                              "openingTime", context, fromDateController)),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.arrow_forward_outlined, color: Colors.blue),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          child: getIconBasedTextField("closingTime",
                              "closingTime", context, toDateController)),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
            Positioned(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Divider(thickness: 1.5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    /*List<EmployeeData> list =
                                        await LocalDB().getEmployeeDataList();
                                    print(list);*/
                                    /*EmployeeData d = EmployeeData(name: "name", role: "role", fromDate: 'fromDate', toDate: "toDate");
                                    d.id = 4;
                                    int count = await LocalDB().deleteEmployeeData(d);
                                    print("-count  $count");*/
                                    Navigator.pop(context, false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: cancelButtonColor,
                                  ),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal),
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    if(widget.employeeData != null)
                                      {
                                        await updateData();
                                      }
                                    else
                                      {
                                        await saveData();
                                      }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text(
                                    widget.employeeData == null ? "Save": "Update",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ))
                            ],
                          ),
                        )
                      ])),
            )
          ],
        ),
      ),
      /*ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                getTextInputWidget("Employee name", TextEditingController(), Icons.person_outline),
                SizedBox(height: 20,),
                getTextInputWidget("Select role", TextEditingController(), Icons.cases_outlined),

                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: getIconBasedTextField("openingTime", "openingTime",
                            context, TextEditingController())),
                    SizedBox(width: 10,),
                    Icon(Icons.arrow_forward_outlined,color: Colors.blue),
                    SizedBox(width: 10,),
                    Flexible(
                        child: getIconBasedTextField("closingTime", "closingTime",
                            context, TextEditingController())),
                  ],
                ),
              ],
            ),

            Column(
              children: [
                Icon(Icons.safety_check)
              ],
            )


          ],
        )*/
    );
  }

  saveData()
  async {
    if (checkString(
        employeeNameController.text) &&
        checkString(
            selectRoleController.text) &&
        checkString(fromDateController.text) &&
        checkString(toDateController.text)) {
      EmployeeData employeeData = EmployeeData(
          name: employeeNameController.text,
          role: selectRoleController.text,
          fromDate: fromDateController.text,
          toDate: toDateController.text);
      print(employeeData);
      int count = await LocalDB().insertEmployeeData(employeeData);
      print("--------------$count");
      if(count > 0)
      {
        showSneakBar(context, "Employee added successfully", Colors.green);
        Navigator.pop(context);
      }
      else
      {
        showSneakBar(context, "Something went wrong", Colors.red);

      }
    }
    else
    {
      showSneakBar(context, "Please fill all the fields", Colors.red);
    }
  }

  updateData() async {
    if (checkString(
        employeeNameController.text) &&
        checkString(
            selectRoleController.text) &&
        checkString(fromDateController.text) &&
        checkString(toDateController.text)) {
      EmployeeData employeeData = EmployeeData(
          name: employeeNameController.text,
          role: selectRoleController.text,
          fromDate: fromDateController.text,
          toDate: toDateController.text);
      employeeData.id = widget.employeeData!.id;
      print(employeeData);
      int count = await LocalDB().updateEmployeeData(employeeData);
      print("--------------$count");
      if(count > 0)
      {
        showSneakBar(context, "Employee updated successfully", Colors.green);
        Navigator.pop(context);
      }
      else
      {
        showSneakBar(context, "Something went wrong", Colors.red);

      }
    }
    else
    {
      showSneakBar(context, "Please fill all the fields", Colors.red);
    }
  }
}
