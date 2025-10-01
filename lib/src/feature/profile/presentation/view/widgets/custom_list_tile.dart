import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_spacing.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLogout;
  final bool isLanguageSwitch;
  final bool isActive;
  final bool isSwitch; // لتفعيل وضع Switch
  final bool switchValue; // قيمة المفتاح
  final ValueChanged<bool>? onSwitchChanged; // دالة عند تغيير القيمة
  final VoidCallback? onTap;
  final ValueChanged<bool>? onStatusChanged;
  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    this.isLogout = false,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.onTap,
    this.isLanguageSwitch = false,
    this.isActive = false,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          textDirection: TextDirection.rtl, // مهم للعربي
          children: [
            // الأيقونة على اليمين
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isLogout
                        ? const Color(0xFFEF4444).withOpacity(0.1)
                        : AppColors.primaryText,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color:
                    isLogout ? const Color(0xFFEF4444) : AppColors.textWhite,
                size: 20,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Text(
              title,
              style: AppTextStyling.font14W500TextInter.copyWith(
                color:
                    isLogout ? const Color(0xFFEF4444) : AppColors.textWhite,
                fontSize: 12,
              ),
            ),

            Spacer(),
            if (isLanguageSwitch) ...[
              Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeColor: AppColors.primaryText,
              ),
              SizedBox(width: 8),
              Text(
                switchValue ? 'English' : 'العربية',
                style: AppTextStyling.font14W500TextInter.copyWith(),
              ),
            ],

            if (!isLogout && !isLanguageSwitch && !isActive)
              const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: AppColors.primaryText,
                size: 16,
              ),
            if (isActive) ...[
              Switch(
                value: switchValue,
                onChanged: onStatusChanged,
                activeColor: AppColors.primaryText,
              ),
              SizedBox(width: 8),
              Text(
                switchValue ? AppLocalizations.of(context)!.on : AppLocalizations.of(context)!.off,
                style: AppTextStyling.font14W500TextInter.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
