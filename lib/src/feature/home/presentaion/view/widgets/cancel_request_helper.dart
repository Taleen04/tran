import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/cancel_request_data_source.dart';
import 'package:ai_transport/src/feature/home/repository/cancel_request_repo.dart';
import 'package:ai_transport/src/feature/home/domain/usecases/cancel_request_usecase.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/cancel_request_bloc/cancel_request_bloc.dart';
import 'cancel_request_dialog.dart';

class CancelRequestHelper {
  static Future<bool?> showCancelRequestDialog({
    required BuildContext context,
    required int requestId,
    required String requestOrigin,
    required String requestDestination,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocProvider(
          create: (context) => CancelRequestBloc(
            cancelRequestUseCase: CancelRequestUseCase(
              CancelRequestRepositoryImpl(
                CancelRequestDataSourceImpl(),
              ),
            ),
          ),
          child: CancelRequestDialog(
            requestId: requestId,
            requestOrigin: requestOrigin,
            requestDestination: requestDestination,
          ),
        );
      },
    );
  }
}
