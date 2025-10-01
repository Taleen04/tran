import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:flutter/material.dart';

class HeaderTitle extends StatefulWidget {
  const HeaderTitle({
    super.key,
  });

  @override
  State<HeaderTitle> createState() => _HeaderTitleState();
}

class _HeaderTitleState extends State<HeaderTitle> {
  bool isSwitched=false;
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.only(right: 20,left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Center(child: workModeSwitch()),
          Text("حالة السائق الأن",
          
          style:AppTextStyling.heading1,),
        ],
      ),
    );
  }

Switch workModeSwitch() {
    return Switch(
      value: isSwitched,
      activeColor:AppColors.green,
    
      inactiveThumbColor: AppColors.dark,
      onChanged:(
        bool value
      ){
        setState(() {
          isSwitched=value;
        });
      } ,
    );
  }


}



