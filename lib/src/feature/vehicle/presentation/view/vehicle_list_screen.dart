// import 'package:ai_transport/src/core/constants/app_colors.dart';
// import 'package:ai_transport/src/core/constants/app_text_styling.dart';
// import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
// import 'package:ai_transport/src/feature/home/data/data_sources/vehicle_data_source.dart';
// import 'package:ai_transport/src/feature/vehicle/presentation/bloc/vehicle_bloc.dart';
// import 'package:ai_transport/src/feature/vehicle/repository/vehicle_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class VehicleListWrapper extends StatelessWidget {
//   const VehicleListWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => VehicleBloc(VehicleRepository(VehicleDataSource()))
//         ..add(LoadVehicles()),
//       child: const VehicleListScreen(),
//     );
//   }
// }

// class VehicleListScreen extends StatelessWidget {
//   const VehicleListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: AppBar(
//           backgroundColor: AppColors.background,
//           elevation: 0,
//           title: Text(
//             'مركباتي',
//             style: AppTextStyling.heading1.copyWith(fontSize: 24),
//           ),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               onPressed: () => context.push('/vehicle_form'),
//               icon: const Icon(Icons.add, color: AppColors.lightOrange),
//             ),
//           ],
//         ),
//         body: BlocConsumer<VehicleBloc, VehicleState>(
//           listener: (context, state) {
//             if (state is VehicleError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state is VehicleLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   color: AppColors.lightOrange,
//                 ),
//               );
//             }

//             if (state is VehicleError) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.error_outline,
//                       size: 64,
//                       color: Colors.red.withOpacity(0.7),
//                     ),
//                     SizedBox(height: responsiveHeight(context, 20)),
//                     Text(
//                       'حدث خطأ في تحميل المركبات',
//                       style: AppTextStyling.bodyLarge.copyWith(
//                         color: Colors.white.withOpacity(0.8),
//                       ),
//                     ),
//                     SizedBox(height: responsiveHeight(context, 20)),
//                     ElevatedButton(
//                       onPressed: () => context.read<VehicleBloc>().add(LoadVehicles()),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.lightOrange,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text('إعادة المحاولة'),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             if (state is VehicleLoaded) {
//               if (state.vehicles.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.directions_car_outlined,
//                         size: 64,
//                         color: Colors.white.withOpacity(0.5),
//                       ),
//                       SizedBox(height: responsiveHeight(context, 20)),
//                       Text(
//                         'لا توجد مركبات مسجلة',
//                         style: AppTextStyling.bodyLarge.copyWith(
//                           color: Colors.white.withOpacity(0.8),
//                         ),
//                       ),
//                       SizedBox(height: responsiveHeight(context, 20)),
//                       ElevatedButton(
//                         onPressed: () => context.push('/vehicle_form'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.lightOrange,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Text('إضافة مركبة'),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: () async {
//                   context.read<VehicleBloc>().add(LoadVehicles());
//                 },
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: state.vehicles.length,
//                   itemBuilder: (context, index) {
//                     final vehicle = state.vehicles[index];
//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       color: Colors.white.withOpacity(0.1),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   vehicle.name,
//                                   style: AppTextStyling.heading2.copyWith(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: AppColors.lightOrange.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(
//                                     vehicle.type,
//                                     style: AppTextStyling.caption.copyWith(
//                                       color: AppColors.lightOrange,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: responsiveHeight(context, 10)),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.confirmation_number,
//                                   color: Colors.white.withOpacity(0.7),
//                                   size: 16,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   vehicle.plateNumber,
//                                   style: AppTextStyling.bodyMedium.copyWith(
//                                     color: Colors.white.withOpacity(0.8),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: responsiveHeight(context, 5)),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.color_lens,
//                                   color: Colors.white.withOpacity(0.7),
//                                   size: 16,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   vehicle.color,
//                                   style: AppTextStyling.bodyMedium.copyWith(
//                                     color: Colors.white.withOpacity(0.8),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: responsiveHeight(context, 5)),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.people,
//                                   color: Colors.white.withOpacity(0.7),
//                                   size: 16,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   '${vehicle.capacityPassengers} راكب',
//                                   style: AppTextStyling.bodyMedium.copyWith(
//                                     color: Colors.white.withOpacity(0.8),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Icon(
//                                   Icons.luggage,
//                                   color: Colors.white.withOpacity(0.7),
//                                   size: 16,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   '${vehicle.capacityBags} حقيبة',
//                                   style: AppTextStyling.bodyMedium.copyWith(
//                                     color: Colors.white.withOpacity(0.8),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }

//             return const Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.lightOrange,
//               ),
//             );
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => context.push('/vehicle_form'),
//           backgroundColor: AppColors.lightOrange,
//           child: const Icon(Icons.add, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
