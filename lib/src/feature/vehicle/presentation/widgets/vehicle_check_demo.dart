import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/feature/vehicle/presentation/bloc/vehicle_check_bloc.dart';
import 'package:ai_transport/src/feature/vehicle/data/data_sources/vehicle_check_data_source.dart';
import 'package:ai_transport/src/feature/vehicle/repository/vehicle_check_repository.dart';
import 'package:ai_transport/src/feature/vehicle/presentation/widgets/vehicle_check_widget.dart';

class VehicleCheckDemo extends StatelessWidget {
  const VehicleCheckDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('اختبار التحقق من لوحة السيارة'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => VehicleCheckBloc(
          repository: VehicleCheckRepository(
           VehicleCheckDataSource(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: VehicleCheckWidget(
            onVehicleFound: (vehicle, plateNumber) {
              print('Vehicle found: ${vehicle?.name}, Plate: $plateNumber');
            },
            onVehicleNotFound: () {
              print('Vehicle not found');
            },
            onNavigateToHome: () {
              print('Navigate to home');
            },
          ),
        ),
      ),
    );
  }
}
