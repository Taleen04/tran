import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/feature/profile/domain/repositories/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/wallet_entity.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/Transaction_entity.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_wallet_bloc/wallet_bloc.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_wallet_bloc/wallet_event.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_wallet_bloc/wallet_state.dart';
import 'package:go_router/go_router.dart';

class WalletScreen extends StatefulWidget {
  final WalletRepository walletRepository;

  const WalletScreen({super.key, required this.walletRepository});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(const LoadWallet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundPrimary,
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: AppColors.backGroundPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            try {
              context.pop();
            } catch (e) {
              // Go to main screen with chat tab (tab index 1)
              context.go('/main_screen?tab=2');
            }
          },
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WalletBloc>().add(const RefreshWallet());
            },
          ),
        ],
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WalletError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WalletBloc>().add(const LoadWallet());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is WalletLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WalletBloc>().add(const RefreshWallet());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WalletBalanceCard(wallet: state.wallet),
                    const SizedBox(height: 24),
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TransactionListWidget(
                      transactions: state.wallet.transactions,
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class WalletBalanceCard extends StatelessWidget {
  final WalletEntity wallet;

  const WalletBalanceCard({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryText,
            const Color.fromARGB(255, 241, 171, 79),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${wallet.companyBalance.toStringAsFixed(2)} ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wallet ID: ${wallet.id}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              if (wallet.status != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    wallet.status!.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class TransactionListWidget extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const TransactionListWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Column(
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children:
          transactions
              .map((transaction) => TransactionCard(transaction: transaction))
              .toList(),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount > 0;
    final amountColor = isPositive ? Colors.green : Colors.red;
    final amountIcon = isPositive ? Icons.add : Icons.remove;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.1),
          child: Icon(amountIcon, color: amountColor),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          transaction.date.toString().split(' ')[0], // Show only date
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isPositive ? '+' : ''}${transaction.amount.toStringAsFixed(2)} ${transaction.currency}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: amountColor,
                fontSize: 16,
              ),
            ),
            if (transaction.status != null)
              Text(
                transaction.status!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }
}
