import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/feature/home/data/models/service_model.dart';
import 'package:ai_transport/src/feature/home/domain/entities/location_status_entity.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/location_status/location_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;

class DriversCondition extends StatefulWidget {
  const DriversCondition({super.key});

  @override
  State<DriversCondition> createState() => _DriversConditionState();
}

class _DriversConditionState extends State<DriversCondition> {
  final List<ServiceItem> services = [
    ServiceItem(
      icon: Icons.flight_takeoff,
      status: LocationStatusEnum.toAirport,
      color: AppColors.backGroundIcon,
      isActive: false,
    ),
    ServiceItem(
      icon: Icons.flight_land,
      status: LocationStatusEnum.inAirport,
      color: AppColors.backGroundIcon,
      isActive: false,
    ),
    ServiceItem(
      icon: Icons.location_on,
      status: LocationStatusEnum.inGarage,
      color: AppColors.backGroundIcon,
      isActive: false,
    ),
    ServiceItem(
      icon: Icons.local_parking,
      status: LocationStatusEnum.toGarage,
      color: AppColors.textWhite,
      isActive: false,
    ),
  ];

  void toggleService(int index) {
    setState(() {
      if (services[index].isActive) {
        services[index].isActive = false;
      } else {
        for (var s in services) {
          s.isActive = false;
        }
        services[index].isActive = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationStatusBloc, LocationState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: services.asMap().entries.map((entry) {
              final index = entry.key;
              final service = entry.value;

              final isActive = state is LocationStateSuccess
                  ? state.status == service.status
                  : service.isActive;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.read<LocationStatusBloc>().add(
                          UpdateLocationStatusEvent(service.status),
                        );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: isActive
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.lightOrange,
                                AppColors.lightOrange.withOpacity(0.8),
                              ],
                            )
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.15),
                                Colors.white.withOpacity(0.08),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? AppColors.lightOrange.withOpacity(0.5)
                            : Colors.white.withOpacity(0.2),
                        width: isActive ? 2 : 1,
                      ),
                      boxShadow: [
                        if (isActive) ...[
                          BoxShadow(
                            color: AppColors.lightOrange.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ] else ...[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon Container
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white.withOpacity(0.2)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            service.icon,
                            color: isActive
                                ? Colors.white
                                : AppColors.textWhite,
                            size: 28,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Status Text
                        Text(
                          _getStatusLabel(service.status),
                          style: AppTextStyling.font14W500TextInter.copyWith(
                            color: isActive
                                ? Colors.white
                                : AppColors.textWhite,
                            fontSize: 11,
                            fontWeight: isActive 
                                ? FontWeight.bold 
                                : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        // Active Indicator
                        if (isActive) ...[
                          const SizedBox(height: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _getStatusLabel(LocationStatusEnum status) {
    switch (status) {
      case LocationStatusEnum.toAirport:
        return 'إلى المطار';
      case LocationStatusEnum.inAirport:
        return 'في المطار';
      case LocationStatusEnum.inGarage:
        return 'في الكراج';
      case LocationStatusEnum.toGarage:
        return 'إلى الكراج';
      default:
        return status.name;
    }
  }
}