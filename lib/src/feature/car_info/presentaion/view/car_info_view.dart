import 'dart:developer';

import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/vehicle_data_source.dart';
import 'package:ai_transport/src/feature/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'package:ai_transport/src/feature/vehicle/repository/vehicle_repository.dart';
import 'package:ai_transport/src/feature/vehicle/presentation/bloc/vehicle_check_bloc.dart';
import 'package:ai_transport/src/feature/vehicle/data/data_sources/vehicle_check_data_source.dart';
import 'package:ai_transport/src/feature/vehicle/repository/vehicle_check_repository.dart';
import 'package:ai_transport/src/feature/vehicle/presentation/widgets/vehicle_check_widget.dart';
import 'package:ai_transport/src/feature/vehicle/domain/entities/vehicle_check_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CarInfoWrapper extends StatelessWidget {
  const CarInfoWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => VehicleBloc(VehicleRepository(VehicleDataSource())),
        ),
        BlocProvider(
          create:
              (context) => VehicleCheckBloc(
                repository: VehicleCheckRepository(
                   VehicleCheckDataSource(),
                ),
              ),
        ),
      ],
      child: const CarInfoView(),
    );
  }
}

class CarInfoView extends StatefulWidget {
  const CarInfoView({super.key});

  @override
  State<CarInfoView> createState() => _CarInfoViewState();
}

class _CarInfoViewState extends State<CarInfoView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController vehicleType = TextEditingController();
  TextEditingController vehicleNum = TextEditingController();
  TextEditingController vehicleName = TextEditingController();
  TextEditingController vehicleColor = TextEditingController();

  bool _isFormFilled = false;

  void _fillFormWithVehicleData(
  VehicleInfoEntity? vehicle,
  String plateNumber,
) {
  

  if (vehicle != null && !_isFormFilled) {
    log("✅ vehicle != null and form not filled");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          vehicleType.text = vehicle.type;
          vehicleName.text = vehicle.name;
          vehicleColor.text = vehicle.color;
          vehicleNum.text = plateNumber;
          _isFormFilled = true;
        });

        log("📝 Form filled with vehicle data"); 

        
        _registerVehicleAutomatically(vehicle, plateNumber);
      }
    });
  } else {
    log(" vehicle is null OR form already filled");
  }
}

void _registerVehicleAutomatically(
  VehicleInfoEntity vehicle,
  String plateNumber,
) async {
  log(" Register vehicle automatically called"); 

  final vehicleData = {
    'vehicle_type': vehicle.type,
    'plate_number': plateNumber,
    'name': vehicle.name,
    'color': vehicle.color,
    'make': vehicle.make,
    'model': vehicle.model,
    'year': vehicle.year,
    'capacity_passengers': 4,
    'capacity_bags': 2,
    'was_existing': true,
  };

  try {
    await SharedPrefHelper.setData(
      StorageKeys.vehicle_type,
      vehicle.type,
    );

    log('Vehicle type saved: ${vehicle.type}'); 
  } catch (e) {
    log(' Error saving vehicle type: $e');
  }

  context.read<VehicleBloc>().add(AddVehicle(vehicleData));
  log(" Vehicle data sent to Bloc"); 
}
  @override
  void dispose() {
    vehicleColor.dispose();
    vehicleName.dispose();
    vehicleNum.dispose();
    vehicleType.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<VehicleBloc, VehicleState>(
          listener: (context, state) {
            if (state is VehicleLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تسجيل المركبة بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
              context.push("/main_screen");
            }
            if (state is VehicleError) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text(state.message),
              //     backgroundColor: Colors.red,
              //   ),
              // );
            }
          },
          builder: (context, state) {
            final isLoading = state is VehicleLoading;

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Center(
                        child: Text(
                          "معلومات المركبة",
                          style: AppTextStyling.heading1.copyWith(fontSize: 30),
                        ),
                      ),
                    ),
                    Text(
                      'أدخل تفاصيل مركبتك للمتابعة',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsiveHeight(context, 20)),

                    // Vehicle Check Widget
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: VehicleCheckWidget(
                        onVehicleFound: _fillFormWithVehicleData,
                        onVehicleNotFound: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'لم يتم العثور على السيارة في النظام',
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                        onNavigateToHome: () {
                          // الانتقال مباشرة للهوم بعد ملء البيانات
                          context.push("/main_screen");
                        },
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
