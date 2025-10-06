import 'dart:async';
import 'dart:developer';

import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/constants/font_weight_helper.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/core/utils/snack_bar_helper.dart';
import 'package:ai_transport/src/feature/home/domain/entities/order_entity.dart';
import 'package:ai_transport/src/feature/home/domain/entities/request_status_update_entity.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/cancel_request_helper.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/stat_item.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/user_location_container.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_bloc/request_status_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_bloc/request_status_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_update_bloc/request_status_update_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_update_bloc/request_status_update_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_update_bloc/request_status_update_state.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/tasks_bloc/tasks_bloc.dart';
import 'package:ai_transport/src/feature/home/repository/request_status_update_repo.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/request_status_update_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToDoListCardsInfo extends StatefulWidget {
  final RequestEntity order;
  const ToDoListCardsInfo({super.key, required this.order});

  @override
  State<ToDoListCardsInfo> createState() => _OrderListCardsInfoState();
}

class _OrderListCardsInfoState extends State<ToDoListCardsInfo> {
  int seconds = 300;
  Timer? _timer;
  // final player = AudioPlayer();
  //bool hasPlayed = false;
  bool acceptButton = false;
  //late int remainingSeconds;

  // Future<void> playNotificationSound() async {
  //   for (int i = 0; i < 10; i++) {
  //     await Future.delayed(const Duration(seconds: 60));
  //     player.play(AssetSource("sounds/new-notification-025-380251.mp3"));
  //   }
  // }

  // void startTimer() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (acceptButton) {
  //       _timer?.cancel();
  //     } else if (seconds > 0) {
  //       setState(() {
  //         seconds--;
  //       });

  //       if (seconds == 120 && !hasPlayed) {
  //         hasPlayed = true;
  //         playNotificationSound();
  //       }
  //     } else {
  //       _timer?.cancel();
  //     }
  //   });
  // }

  @override
  void initState() {
    //  startTimer();
    // remainingSeconds = widget.order.minutesRemaining * 60;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getButtonText() {
    switch (widget.order.status.toLowerCase()) {
      case 'accepted':
        return 'وصلت للموقع';
      case 'arrived':
        return 'ركب في المركبة';
      case 'picked_up':
        return 'تم التسليم';
      case 'dropped_off':
        return 'اكتمل الطلب';
      default:
        return 'ركب في المركبة';
    }
  }

  RequestStatus _getNextStatus() {
    switch (widget.order.status.toLowerCase()) {
      case 'accepted':
        return RequestStatus.arrived;
      case 'arrived':
        return RequestStatus.pickedUp;
      case 'picked_up':
        return RequestStatus.droppedOff;
      case 'dropped_off':
        return RequestStatus.completed;
      default:
        return RequestStatus.arrived;
    }
  }

  void _handleStatusUpdate(BuildContext context) {
    final nextStatus = _getNextStatus();

    // Show confirmation dialog for certain status changes
    if (nextStatus == RequestStatus.arrived ||
        nextStatus == RequestStatus.pickedUp) {
      _showConfirmationDialog(context, nextStatus);
    } else {
      _updateStatus(context, nextStatus);
    }
  }

  void _showConfirmationDialog(BuildContext context, RequestStatus status) {
    String message = '';
    switch (status) {
      case RequestStatus.arrived:
        message = 'هل وصلت إلى موقع الاستلام؟';
        break;
      case RequestStatus.pickedUp:
        message = 'هل ركب العميل في المركبة؟';
        break;
      default:
        message = 'هل تريد تحديث حالة الطلب؟';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد العملية'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateStatus(context, status);
                context.read<RequestStatusBloc>().add(
                  RefreshRequestStatusEvent(),
                );
              },
              child: Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  void _updateStatus(BuildContext context, RequestStatus status) {
    context.read<RequestStatusUpdateBloc>().add(
      UpdateRequestStatusEvent(
        requestId: widget.order.id,
        status: status,
        notes: 'تم تحديث الحالة من ${widget.order.status} إلى ${status.value}',
      ),
    );
    SnackbarUtils.showSuccess(context, "تم تحديث الحالة ");
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        log('Could not launch phone call');
      }
    } catch (e) {
      log('Error launching phone call: $e');
    }
  }

  Future<void> launchWhatsApp(String phone) async {
    final Uri url = Uri.parse("https://wa.me/$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'لا يمكن فتح واتساب';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                widget.order.client.name,
                style: AppTextStyling.font14W500TextInter.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeightHelper.bold,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _makePhoneCall(widget.order.client.phone);
                  },
                  icon: Icon(
                    Icons.phone,
                    color: AppColors.green.withOpacity(0.5),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    launchWhatsApp(widget.order.client.phone);
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: AppColors.green.withOpacity(0.5),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.go(
                      '/chat/${widget.order.id}?clientName=${widget.order.client.name}&requestId=${widget.order.client}',
                    );
                  },
                  icon: Icon(Icons.chat, color: AppColors.backGroundIcon),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textPrimary, width: 0.1),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.textWhite.withOpacity(0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userLocationContainer("من  : ", widget.order.origin),
                  SizedBox(height: responsiveHeight(context, 8)),

                  userLocationContainer("إلى :  ", widget.order.destination),
                  SizedBox(height: responsiveHeight(context, 8)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        "حالة الطلب:  ",
                        style: AppTextStyling.font14W500TextInter.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.order.status,
                        style: AppTextStyling.font14W500TextInter.copyWith(
                          color: AppColors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.timelapse, color: AppColors.orange),

                  Text(
                    formatTime(
                      widget.order.minutesRemaining * 60,
                    ), //! change to time remaining
                    style: TextStyle(color: AppColors.textWhite),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: responsiveHeight(context, 20)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.green.withOpacity(0.5),
              width: 0.5,
            ),
          ),
          child: Text(
            widget.order.notes ?? AppLocalizations.of(context)!.ThereAreNoNotes,
            style: AppTextStyling.font14W500TextInter.copyWith(
              color: AppColors.green,
              shadows: [
                Shadow(
                  color: AppColors.green.withOpacity(0.7),
                  blurRadius: 6,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: responsiveHeight(context, 20)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.green.withOpacity(0.5),
              width: 0.5,
            ),
          ),
          child: Text(
            widget.order.currentStatus,
            style: AppTextStyling.font14W500TextInter.copyWith(
              color: AppColors.green,
              shadows: [
                Shadow(
                  color: AppColors.green.withOpacity(0.7),
                  blurRadius: 6,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: responsiveHeight(context, 50)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            statusButton(
              AppLocalizations.of(context)!.editOrder,
              AppTextStyling.font14W500TextInter.copyWith(color: AppColors.red),
              () async {
                log("تم الضغط على زر تعديل الطلب");
                final result =
                    await CancelRequestHelper.showCancelRequestDialog(
                      context: context,
                      requestId: widget.order.id,
                      requestOrigin: widget.order.origin,
                      requestDestination: widget.order.destination,
                    );

                if (result == true) {
                  // ✅ الطلب انلغى بنجاح
                  log("تم إلغاء الطلب بنجاح");
                  //! refresh tasks list
                  if (context.mounted) {
                    context.read<TasksBloc>().add(
                      GetMyRequests(status: widget.order.status),
                    );
                    log("status: ${widget.order.status}");
                  }
                }
              },
            ),

            SizedBox(width: responsiveWidth(context, 10)),
            BlocProvider(
              create:
                  (context) => RequestStatusUpdateBloc(
                    repository: RequestStatusUpdateRepositoryImpl(
                      dataSource: RequestStatusUpdateDataSource(),
                    ),
                  ),
              child: BlocConsumer<
                RequestStatusUpdateBloc,
                RequestStatusUpdateState
              >(
                listener: (context, state) {
                  if (state is RequestStatusUpdateSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.response.message),
                        backgroundColor: AppColors.green,
                      ),
                    );
                    log(
                      'Status updated successfully: ${state.response.message}',
                    );
                  } else if (state is RequestStatusUpdateError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('خطأ: ${state.message}'),
                        backgroundColor: AppColors.red,
                      ),
                    );
                    log('Error updating status: ${state.message}');
                  }
                },
                builder: (context, state) {
                  return statusButton(
                    _getButtonText(),
                    AppTextStyling.font14W500TextInter.copyWith(
                      color:
                          state is RequestStatusUpdateLoading
                              ? AppColors.textSecondary
                              : AppColors.textWhite,
                    ),
                    state is RequestStatusUpdateLoading
                        ? null
                        : () => _handleStatusUpdate(context),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            statItem(
              Icon(Icons.group, color: AppColors.textSecondary),
              widget.order.passengers.toString(),
            ),
            const SizedBox(width: 15),
            statItem(
              widget.order.vehicleType == 'car'
                  ? Icon(Icons.directions_car, color: AppColors.textSecondary)
                  : Icon(Icons.directions_bus, color: AppColors.textSecondary),
              " ",
            ),
            const SizedBox(width: 15),
            statItem(
              Icon(Icons.shopping_bag, color: AppColors.textSecondary),
              widget.order.bags.toString(),
            ),
            const SizedBox(width: 15),
            statItem(
              Icon(Icons.timelapse_outlined, color: AppColors.textSecondary),
              formatTime(
                widget.order.acceptanceDeadline
                        ?.difference(DateTime.now())
                        .inSeconds ??
                    0,
              ),
            ),
            const SizedBox(width: 15),
            // statItem(
            //   vehicleCount(),
            //   "",
            // ), //! change rely on num. of bags from dashboard between car and van
          ],
        ),
      ],
    );
  }

  ElevatedButton statusButton(
    String text,
    TextStyle style,
    final void Function()? onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.textWhite.withOpacity(0.1),
        //foregroundColor:AppColors.error,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      onPressed: onPressed,
      child: Text(text, style: style),
    );
  }
}

String formatTime(int seconds) {
  if (seconds <= 0) return "00:00";

  final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
  final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');

  // لو ما بدك الساعات، رجّعي "$minutes:$secs"
  return hours != "00" ? "$hours:$minutes:$secs" : "$minutes:$secs";
}
