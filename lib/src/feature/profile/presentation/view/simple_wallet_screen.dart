// import 'package:flutter/material.dart';
// import 'package:ai_transport/src/feature/profile/domain/entity/wallet_entity.dart';
// import 'package:ai_transport/src/feature/profile/domain/entity/Transaction_entity.dart';

// class SimpleWalletScreen extends StatefulWidget {
//   const SimpleWalletScreen({Key? key}) : super(key: key);

//   @override
//   State<SimpleWalletScreen> createState() => _SimpleWalletScreenState();
// }

// class _SimpleWalletScreenState extends State<SimpleWalletScreen> {
//   // Mock data for demonstration
//   final WalletEntity mockWallet = WalletEntity(
//     id: 'company_wallet',
//     companyBalance: 1250.75,
//     currency: 'USD',
//     status: 'active',
//     recentTransactions: [
//       TransactionEntity(
//         id: '5055',
//         type: 'penalty',
//         amount: -25.0,
//         currency: 'USD',
//         date: DateTime.parse('2025-09-07T21:00:00Z'),
//         description: 'عقوبة تأخير قبول الطلب',
//         status: 'completed',
//         reference: '789',
//       ),
//     ],
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wallet'),
//         backgroundColor: Colors.blue[600],
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             WalletBalanceCard(wallet: mockWallet),
//             const SizedBox(height: 24),
//             const Text(
//               'Recent Transactions',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             TransactionListWidget(transactions: mockWallet.recentTransactions),
            
          
//           ],
//         ),
//       ),
//     );
//   }
// }

// class WalletBalanceCard extends StatelessWidget {
//   final WalletEntity wallet;

//   const WalletBalanceCard({
//     Key? key,
//     required this.wallet,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue[600]!, Colors.blue[400]!],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Total Balance',
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '${wallet.balance.toStringAsFixed(2)} ${wallet.currency}',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Wallet ID: ${wallet.id}',
//                 style: const TextStyle(
//                   color: Colors.white70,
//                   fontSize: 12,
//                 ),
//               ),
//               if (wallet.status != null)
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     wallet.status!.toUpperCase(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TransactionListWidget extends StatelessWidget {
//   final List<TransactionEntity> transactions;

//   const TransactionListWidget({
//     Key? key,
//     required this.transactions,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (transactions.isEmpty) {
//       return const Center(
//         child: Column(
//           children: [
//             Icon(Icons.receipt_long, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'No transactions yet',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }

//     return Column(
//       children: transactions.map((transaction) => TransactionCard(transaction: transaction)).toList(),
//     );
//   }
// }

// class TransactionCard extends StatelessWidget {
//   final TransactionEntity transaction;

//   const TransactionCard({
//     Key? key,
//     required this.transaction,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isPositive = transaction.amount > 0;
//     final amountColor = isPositive ? Colors.green : Colors.red;
//     final amountIcon = isPositive ? Icons.add : Icons.remove;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: amountColor.withOpacity(0.1),
//           child: Icon(amountIcon, color: amountColor),
//         ),
//         title: Text(
//           transaction.description,
//           style: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//         subtitle: Text(
//           transaction.date.toString().split(' ')[0], // Show only date
//           style: TextStyle(color: Colors.grey[600]),
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               '${isPositive ? '+' : ''}${transaction.amount.toStringAsFixed(2)} ${transaction.currency}',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: amountColor,
//                 fontSize: 16,
//               ),
//             ),
//             if (transaction.status != null)
//               Text(
//                 transaction.status!,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


