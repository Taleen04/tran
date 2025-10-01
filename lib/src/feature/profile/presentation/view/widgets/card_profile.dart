import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_shadow.dart';
import 'package:ai_transport/src/core/constants/app_spacing.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/constants/font_weight_helper.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/widgets/card_profile_task.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/widgets/row_item_card.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/widgets/row_item_card_document.dart';
import 'package:flutter/material.dart';

class CardProfile extends StatelessWidget {
  final String title;
  final IconData icon; // أيقونة الكارد الرئيسية
  final List<Map<String, dynamic>> rows; // كل صف يحتوي على أيقونة خاصة به
  final int visible;
  final VoidCallback? onTap;

  const CardProfile({
    super.key,
    required this.title,
    required this.icon,
    required this.rows,
    required this.visible,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.backGroundIcon,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.medium,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: AppTextStyling.font14W500TextInter.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: FontWeightHelper.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Icon(icon, color: AppColors.primaryText, size: 40),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Divider(height: 1, color: Colors.grey[200]),
              SizedBox(height: AppSpacing.lg),

              ...rows.map((row) {
                final IconData rowIcon = row['icon'] ?? Icons.info;

                return Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.lg),
                  child:
                      visible == 1
                          ? ProfileRowItem(
                            icon: rowIcon,
                            label: row['label'] ?? '',
                            value: row['value'] ?? '',
                          )
                          : visible == 2
                          ? RowItemCardDocument(
                            icon: rowIcon,
                            label: row['label'] ?? '',
                            value: row['value'] ?? '',
                          )
                          : CardProfileTask(
                            icon: rowIcon,
                            label: row['label'] ?? '',
                            value: row['value'] ?? '',
                            items: [
                              "العنصر الأول",
                              "العنصر الثاني",
                              "العنصر الثالث",
                            ],
                            
                          ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
