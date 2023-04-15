import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/string.dart';

getTextInputWidget(String hintText, TextEditingController controller, IconData iconData) {
  return SizedBox(
    height: 40,
    child: TextField(
      controller: controller,
      textAlignVertical: TextAlignVertical.top,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData, color: Colors.blue,),
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(color: textWidgetBorderColor,),
        //hintTextDirection: TextDirection.ltr,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: textWidgetBorderColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              width: 1,
              color: textWidgetBorderColor
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.0),
        ),
      ),
    ),
  );
}

getTextInputBottomSheetSelectWidget(String hintText, TextEditingController controller, IconData iconData, BuildContext context) {
  return SizedBox(
    height: 40,
    child: TextField(
      onTap: (){

        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder( // <-- SEE HERE
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15.0),
              ),
            ),
            builder: (context) {
              return SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: roleLookup.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Text(roleLookup[index]),
                          ),
                          Divider(),
                        ],
                      ),
                      onTap: (){
                        controller.text = roleLookup[index];

                        Navigator.pop(context);
                      },
                    );

                  },
                ),
              );
            });
      },
      readOnly: true,
      controller: controller,
      textAlignVertical: TextAlignVertical.top,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData, color: Colors.blue,),
        suffixIcon: Icon(Icons.arrow_drop_down_sharp, color: Colors.blue,),
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(color: textWidgetBorderColor,),
        //hintTextDirection: TextDirection.ltr,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: textWidgetBorderColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              width: 1,
              color: textWidgetBorderColor
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.0),
        ),
      ),
    ),
  );
}


Widget getIconBasedTextField(String hintText, String initialTime,BuildContext context, TextEditingController controller)
{
  return SizedBox(
    height: 40,
    child: TextField(
      readOnly: true,
      controller: controller,
      textAlignVertical: TextAlignVertical.top,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.calendar_month_outlined, color: Colors.blue,size: 20,),
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(color: textWidgetBorderColor,),
        //hintTextDirection: TextDirection.ltr,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: textWidgetBorderColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              width: 1,
              color: textWidgetBorderColor
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.0),
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(), //get today's date
            firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101)
        );
        print(pickedDate);
        DateFormat format = new DateFormat("yyyy-MM-dd");
        DateTime formattedDate = format.parse(pickedDate.toString());
        print("formatted date : $formattedDate");
        String d = DateFormat('d MMM yyyy').format(formattedDate);
        print("d : $d");
        controller.text = d;

        /*DateFormat format1 = new DateFormat("d MMM yyyy");
        DateTime formattedDate1 = format1.parse(d.toString());
        print("formatted date1 : $formattedDate1");
        String d1 = DateFormat('yyyy-MM-dd').format(formattedDate1);
        print("d1 : $d1");*/

      },
    ),
  );
}
