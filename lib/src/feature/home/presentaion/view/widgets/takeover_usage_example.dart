// // مثال على استخدام نظام سحب الطلبات
// import 'package:ai_transport/src/feature/home/domain/entities/request_takeover_entity.dart';
// import 'package:ai_transport/src/feature/home/presentaion/view_model/request_takeover_bloc/request_takeover_bloc.dart';
// import 'package:ai_transport/src/feature/home/presentaion/view_model/request_takeover_bloc/request_takeover_event.dart';
// import 'package:ai_transport/src/feature/home/presentaion/view_model/request_takeover_bloc/request_takeover_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class TakeoverUsageExample extends StatelessWidget {
//   const TakeoverUsageExample({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RequestTakeoverBloc, RequestTakeoverState>(
//       builder: (context, state) {
//         if (state is RequestTakeoverLoading) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text('جاري سحب الطلب...'),
//               ],
//             ),
//           );
//         } else if (state is RequestTakeoverSuccess) {
//           return _buildSuccessMessage(state.takeoverResponse);
//         } else if (state is RequestTakeoverError) {
//           return _buildErrorMessage(state.message);
//         }
//         return _buildInitialMessage();
//       },
//     );
//   }

//   Widget _buildSuccessMessage(RequestTakeoverEntity response) {
//     return Card(
//       color: Colors.green.shade50,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Icon(Icons.check_circle, color: Colors.green, size: 48),
//             SizedBox(height: 16),
//             Text(
//               'تم سحب الطلب بنجاح!',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green.shade800,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text('طلب رقم: ${response.data.requestId}'),
//             Text('من السائق: ${response.data.previousDriver}'),
//             Text('إلى السائق: ${response.data.newDriver}'),
//             Text('السبب: ${response.data.reason}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorMessage(String message) {
//     return Card(
//       color: Colors.red.shade50,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Icon(Icons.error, color: Colors.red, size: 48),
//             SizedBox(height: 16),
//             Text(
//               'خطأ في سحب الطلب',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red.shade800,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(message),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInitialMessage() {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Icon(Icons.swap_horiz, color: Colors.orange, size: 48),
//             SizedBox(height: 16),
//             Text(
//               'سحب الطلبات',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text('يمكنك سحب الطلبات المقبولة من سائقين آخرين'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // زر سحب الطلب
// class TakeoverRequestButton extends StatelessWidget {
//   final int requestId;
//   final String previousDriverName;

//   const TakeoverRequestButton({
//     Key? key,
//     required this.requestId,
//     required this.previousDriverName,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       onPressed: () {
//         _showTakeoverDialog(context);
//       },
//       icon: Icon(Icons.swap_horiz),
//       label: Text('سحب الطلب'),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.orange,
//         foregroundColor: Colors.white,
//       ),
//     );
//   }

//   void _showTakeoverDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('تأكيد سحب الطلب'),
//         content: Text('هل أنت متأكد أنك تريد سحب الطلب من "$previousDriverName"؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('إلغاء'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               context.read<RequestTakeoverBloc>().add(
//                 TakeoverRequestEvent(
//                   requestId: requestId,
//                   reason: 'سحب الطلب من $previousDriverName',
//                   previousDriverName: previousDriverName,
//                 ),
//               );
//             },
//             child: Text('تأكيد'),
//           ),
//         ],
//       ),
//     );
//   }
// }
