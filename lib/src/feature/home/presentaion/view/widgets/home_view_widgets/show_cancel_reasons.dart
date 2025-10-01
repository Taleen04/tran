import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/feature/home/domain/entities/cancellation_reason_entity.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/cancellation_reasons/cacellation_reasons_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/cancellation_reasons/cacellation_reasons_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/cancellation_reasons/cacellation_reasons_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowCancelReasons extends StatelessWidget {
  const ShowCancelReasons({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger the load when the dialog opens
    context.read<CancellationReasonsBloc>().add(LoadCancellationReasons());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text("تعديل الطلب:"),
        content: SizedBox(
          width: double.maxFinite,
          child: BlocBuilder<CancellationReasonsBloc, CancellationReasonsState>(
            builder: (context, state) {
              if (state is CancellationReasonsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CancellationReasonsLoaded) {
                final List<CancellationReasonEntity> reasons = state.reasons;

                if (reasons.isEmpty) {
                  return const Text("لا يوجد أسباب متاحة");
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: reasons.length,
                  itemBuilder: (context, index) {
                    final CancellationReasonEntity reason = reasons[index];
                    // Choose icon based on code or requiresPhoto
                    IconData icon;
                    Color color;

                    switch (reason.code) {
                      case "client_refused_boarding":
                        icon = Icons.close;
                        color = AppColors.red;
                        break;
                      case "driver_emergency":
                        icon = Icons.add;
                        color = AppColors.green;
                        break;
                      case "vehicle_breakdown":
                        icon = Icons.car_repair;
                        color = AppColors.orange;
                        break;
                      case "unsuitable_cargo":
                        icon = Icons.warning;
                        color = AppColors.lightOrange;
                        break;
                      case "client_not_found":
                        icon = Icons.person_off;
                        color = Colors.blue;
                        break;
                      default:
                        icon = Icons.info;
                        color = Colors.grey;
                    }

                    return ListTile(
                      leading: Icon(icon, color: color),
                      title: Text(reason.nameAr),
                      onTap: () {
                        Navigator.pop(context, reason.nameAr);
                      },
                    );
                  },
                );
              } else if (state is CancellationReasonsError) {
                return Text("خطأ: ${state.message}");
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
