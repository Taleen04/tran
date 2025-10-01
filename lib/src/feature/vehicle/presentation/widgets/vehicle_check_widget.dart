import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/feature/vehicle/presentation/bloc/vehicle_check_bloc.dart';
import 'package:ai_transport/src/feature/vehicle/domain/entities/vehicle_check_entity.dart';

class VehicleCheckWidget extends StatefulWidget {
  final Function(VehicleInfoEntity?, String)? onVehicleFound;
  final Function()? onVehicleNotFound;
  final Function()? onNavigateToHome;

  const VehicleCheckWidget({
    super.key,
    this.onVehicleFound,
    this.onVehicleNotFound,
    this.onNavigateToHome,
  });

  @override
  State<VehicleCheckWidget> createState() => _VehicleCheckWidgetState();
}

class _VehicleCheckWidgetState extends State<VehicleCheckWidget> {
  final TextEditingController _plateController = TextEditingController();
  final FocusNode _plateFocusNode = FocusNode();
  VehicleCheckState? _lastProcessedState;

  @override
  void dispose() {
    _plateController.dispose();
    _plateFocusNode.dispose();
    super.dispose();
  }

  void _checkPlate() {
    if (_plateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال رقم اللوحة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<VehicleCheckBloc>().add(
      CheckVehiclePlate(plateNumber: _plateController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'التحقق من لوحة السيارة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _plateController,
            focusNode: _plateFocusNode,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'أدخل رقم اللوحة (مثال: 123-456)',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: _checkPlate,
              ),
            ),
            onSubmitted: (_) => _checkPlate(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _checkPlate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'التحقق من اللوحة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<VehicleCheckBloc, VehicleCheckState>(
            builder: (context, state) {
              if (state is VehicleCheckLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is VehicleCheckSuccess) {
                final vehicleCheck = state.vehicleCheck;
                
                if (vehicleCheck.exists && vehicleCheck.vehicle != null) {
                  // تجنب استدعاء callback متكرر لنفس الـ state
                  if (_lastProcessedState != state) {
                    _lastProcessedState = state;
                    // استخدام addPostFrameCallback لتجنب استدعاء callback أثناء البناء
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.onVehicleFound?.call(vehicleCheck.vehicle, _plateController.text.trim());
                    });
                  }
                  
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              'تم العثور على السيارة',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildVehicleInfo(vehicleCheck.vehicle!),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // استدعاء callback لملء النموذج أولاً
                              widget.onVehicleFound?.call(vehicleCheck.vehicle, _plateController.text.trim());
                              // ثم الانتقال للهوم
                              widget.onNavigateToHome?.call();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('استخدام بيانات السيارة'),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // تجنب استدعاء callback متكرر لنفس الـ state
                  if (_lastProcessedState != state) {
                    _lastProcessedState = state;
                    // استخدام addPostFrameCallback لتجنب استدعاء callback أثناء البناء
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.onVehicleNotFound?.call();
                    });
                  }
                  
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'لم يتم العثور على السيارة في النظام',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }

              if (state is VehicleCheckError) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'خطأ: ${state.message}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo(VehicleInfoEntity vehicle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('النوع:', vehicle.type),
        _buildInfoRow('الاسم:', vehicle.name),
        _buildInfoRow('اللون:', vehicle.color),
        _buildInfoRow('الماركة:', vehicle.make),
        _buildInfoRow('الموديل:', vehicle.model),
        _buildInfoRow('السنة:', vehicle.year.toString()),
        _buildInfoRow('مُعيّن:', vehicle.isAssigned ? 'نعم' : 'لا'),
        _buildInfoRow('مُعيّن للسائق الحالي:', vehicle.assignedToCurrentDriver ? 'نعم' : 'لا'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
