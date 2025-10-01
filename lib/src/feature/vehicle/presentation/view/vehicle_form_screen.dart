// import 'dart:developer';

// import 'package:ai_transport/main.dart';
// import 'package:ai_transport/src/core/constants/app_colors.dart';
// import 'package:ai_transport/src/core/constants/app_text_styling.dart';
// import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
// import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
// import 'package:ai_transport/src/core/widgets/custom_text_form_field.dart';
// import 'package:ai_transport/src/feature/home/data/data_sources/vehicle_data_source.dart';
// import 'package:ai_transport/src/feature/vehicle/presentation/bloc/vehicle_bloc.dart';
// import 'package:ai_transport/src/feature/vehicle/presentation/bloc/vehicle_check_bloc.dart';
// import 'package:ai_transport/src/feature/vehicle/repository/vehicle_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class VehicleFormWrapper extends StatelessWidget {
//   const VehicleFormWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return VehicleFormScreen();
//     //BlocProvider(
//     //   create: (context) => VehicleBloc(VehicleRepository(VehicleDataSource())),
//     //   child: const VehicleFormScreen(),
//     // );
//   }
// }

// class VehicleFormScreen extends StatefulWidget {
//   const VehicleFormScreen({super.key});

//   @override
//   State<VehicleFormScreen> createState() => _VehicleFormScreenState();
// }

// class _VehicleFormScreenState extends State<VehicleFormScreen> {
//   final _formKey = GlobalKey<FormState>();
  
//   final TextEditingController _typeController = TextEditingController();
//   final TextEditingController _plateNumberController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _colorController = TextEditingController();

//   @override
//   void dispose() {
//     _typeController.dispose();
//     _plateNumberController.dispose();
//     _nameController.dispose();
//     _colorController.dispose();
//     super.dispose();
//   }

//   void _submitForm() async { // ✅ أضف async
//   if (_formKey.currentState!.validate()) {
//     final vehicleData = {
//       'vehicle_type': _typeController.text.trim(),
//       'plate_number': _plateNumberController.text.trim(),
//       'name': _nameController.text.trim(),
//       'color': _colorController.text.trim(),
//       'make': 'غير محدد', // Default value
//       'model': 'غير محدد', // Default value
//       'year': DateTime.now().year, // Current year as default
//       'capacity_passengers': 4, // Default value
//       'capacity_bags': 2, // Default value
//       'was_existing': false,
//     };

    
//     try {
//       await SharedPrefHelper.setData(
//         StorageKeys.vehicle_type, 
//         _typeController.text.trim(),
//       );
      
      
//       log('Vehicle type saved: ${_typeController.text.trim()}');
      
//     } catch (e) {
//       log('Error saving vehicle type: $e');
//     }

//     context.read<VehicleBloc>().add(AddVehicle(vehicleData));
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: AppBar(
//           backgroundColor: AppColors.background,
//           elevation: 0,
//           title: Text(
//             'إضافة مركبة',
//             style: AppTextStyling.heading1.copyWith(fontSize: 24),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             onPressed: () => context.pop(),
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//           ),
//         ),
//         body: BlocConsumer<VehicleCheckBloc, VehicleCheckState>(
//           listener: (context, state) {
//             if (state is VehicleCheckLoading) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('تمت العملية بنجاح'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//               context.pop();
//             }
//             if (state is VehicleCheckError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             final isLoading = state is VehicleCheckLoading;
            
//             return SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20),
//                       child: Center(
//                         child: Text(
//                           'معلومات المركبة',
//                           style: AppTextStyling.heading1.copyWith(fontSize: 30),
//                         ),
//                       ),
//                     ),
//                     Text(
//                       'أدخل تفاصيل مركبتك للمتابعة',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white.withOpacity(0.8),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: responsiveHeight(context, 20)),
                    
//                     // Container شفاف للحقول
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30),
//                       child: Container(
//                         padding: const EdgeInsets.all(25),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(25),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.2),
//                             width: 1,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 20,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             CustomTextField(
//                               textEditingController: _typeController,
//                               iconPath: Icons.car_crash,
//                               iconColor: AppColors.lightOrange,
//                               label: "نوع المركبة",
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يرجى إدخال نوع المركبة';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 20),
                            
//                             CustomTextField(
//                               textEditingController: _plateNumberController,
//                               iconPath: Icons.numbers,
//                               iconColor: AppColors.lightOrange,
//                               label: "رقم المركبة",
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يرجى إدخال رقم المركبة';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 20),
                            
//                             CustomTextField(
//                               textEditingController: _nameController,
//                               iconPath: Icons.edit,
//                               iconColor: AppColors.lightOrange,
//                               label: "اسم المركبة",
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يرجى إدخال اسم المركبة';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 20),
                            
//                             CustomTextField(
//                               textEditingController: _colorController,
//                               iconPath: Icons.color_lens,
//                               iconColor: AppColors.lightOrange,
//                               label: "لون المركبة",
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يرجى إدخال لون المركبة';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
                    
//                     const SizedBox(height: 40),
                    
//                     // زر المتابعة خارج الكونتينر
//                     // ElevatedButton(
//                     //   onPressed: isLoading ? null : _submitForm,
//                     //   style: ElevatedButton.styleFrom(
//                     //     padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
//                     //     backgroundColor: AppColors.lightOrange,
//                     //     shape: RoundedRectangleBorder(
//                     //       borderRadius: BorderRadius.circular(10),
//                     //     ),
//                     //     elevation: 8,
//                     //     shadowColor: AppColors.textPrimary.withOpacity(0.6),
//                     //   ),
//                     //   child: isLoading
//                     //       ? const SizedBox(
//                     //           width: 20,
//                     //           height: 20,
//                     //           child: CircularProgressIndicator(
//                     //             color: Colors.white,
//                     //             strokeWidth: 2,
//                     //           ),
//                     //         )
//                     //       : const Text(
//                     //           'تسجيل المركبة',
//                     //           style: AppTextStyling.heading3,
//                     //         ),
//                     // ),
                    
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
