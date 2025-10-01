import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPhoneInput extends StatelessWidget {
  final TextEditingController controller;

  const CustomPhoneInput({super.key, required this.controller});

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رقم الهاتف';
    }
    if (value.length != 10) {
      return 'رقم الهاتف يجب أن يكون 10 أرقام';
    }
    return null; // صحيح
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: responsiveWidth(context, 350),
      child: TextFormField(
        textAlign: TextAlign.right,
        controller: controller,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // أرقام فقط
          LengthLimitingTextInputFormatter(10), // أقصى طول 10 أرقام
        ],
        style: const TextStyle(color: Colors.white, fontSize: 16),
        validator: validatePhone,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.phone_android,
            color: Colors.white.withOpacity(0.8),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: AppColors.textWhite,
              width: 2,
            ),
          ),
          errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 14),
        ),
      ),
    );
  }
}
