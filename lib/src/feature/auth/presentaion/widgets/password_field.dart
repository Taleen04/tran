import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordField extends StatefulWidget {
  final String text;
  final TextEditingController? controller; // اختياري

  const PasswordField({
    super.key,
    required this.text,
    this.controller,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;
  late final TextEditingController _controller;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
      _isInternalController = true;
    } else {
      _controller = widget.controller!;
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Validation لكلمة المرور
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
    }
    return null; // صحيح
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: responsiveWidth(context, 350),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            widget.text,
            style: AppTextStyling.font14W500TextInter.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _controller,
            textAlign: TextAlign.right,
            obscureText: !_isPasswordVisible,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            validator: validatePassword,
            decoration: InputDecoration(
              hintText: "••••••••",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              prefixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white.withOpacity(0.8),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                  HapticFeedback.lightImpact();
                },
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
                borderSide: const BorderSide(
                  color: AppColors.textPrimary,
                  width: 2,
                ),
              ),
              errorStyle:
                  const TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
