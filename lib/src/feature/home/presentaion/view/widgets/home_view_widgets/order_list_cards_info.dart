import 'dart:async';
import 'dart:developer';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/constants/font_weight_helper.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/auth/data/models/staff_model.dart';
import 'package:ai_transport/src/feature/home/domain/entities/order_entity.dart';
import 'package:ai_transport/src/feature/home/domain/entities/request_status_entity.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/stat_item.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/user_location_container.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_bloc/request_status_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_bloc/request_status_event.dart'
    as request_status;
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_bloc/request_status_state.dart';
import 'package:ai_transport/src/feature/home/repository/request_status_repo.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/request_status_data_source.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_takeover_bloc/request_takeover_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_takeover_bloc/request_takeover_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_takeover_bloc/request_takeover_state.dart';
import 'package:ai_transport/src/feature/home/repository/request_takeover_repo.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/request_takeover_data_source.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/takeover_confirmation_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderListCardsInfo extends StatefulWidget {
  final RequestEntity order;
  final RequestStatusEntity? requestStatus;
  final Staff staff;
  const OrderListCardsInfo({
    super.key,
    required this.order,
    this.requestStatus,
    required this.staff
  });

  @override
  State<OrderListCardsInfo> createState() => _OrderListCardsInfoState();
}

class _OrderListCardsInfoState extends State<OrderListCardsInfo> {
  int seconds = 300;
  int remainingSeconds = 900;
  Timer? _timer5;
  Timer? _timer10;
  Timer? _remainingTimer;
  Timer? _alertTimer;
  final player = AudioPlayer();
  bool acceptButton = false;
  bool isAlertPlaying = false;
  String? staffLocation;

  Future<void> playAlertSound() async {
    player.play(AssetSource("sounds/new-notification-025-380251.mp3"));
  }

  void startAlertTimer() {
    if (!isAlertPlaying) {
      isAlertPlaying = true;
      _alertTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (seconds <= 150 && seconds > 0) {
          // Less than 2.5 minutes (150 seconds)
          playAlertSound();
        } else {
          _alertTimer?.cancel();
          isAlertPlaying = false;
        }
      });
    }
  }

  void startTimer() {
    // Get the original remaining time in seconds
    int originalTimeInSeconds = 0;
    if (widget.order.timeRemaining != null &&
        widget.order.timeRemaining!.length >= 2) {
      originalTimeInSeconds =
          widget.order.timeRemaining![0] * 60 + widget.order.timeRemaining![1];
    } else {
      originalTimeInSeconds = widget.order.minutesRemaining * 60;
    }

    // Calculate the bottom timer: original time - 10 minutes
    seconds = originalTimeInSeconds - (10 * 60);

    // Ensure the timer doesn't go below 0
    if (seconds < 0) {
      seconds = 0;
    }

    _timer5 = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!acceptButton && seconds > 0) {
        setState(() {
          seconds--;

          // Start alert sound every 5 seconds when less than 2.5 minutes (150 seconds)
          if (seconds <= 150 && seconds > 0) {
            startAlertTimer();
          }
        });
      } else if (acceptButton) {
        stopAllSounds();
        log("تم القبول والوقت المتبقي: $seconds ثانية");
      } else {
        _timer5?.cancel();
        _alertTimer?.cancel();
      }
    });
  }

  void startRemainingTimer() {
    _remainingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _remainingTimer?.cancel();
        log("انتهى الوقت المتبقي للطلب");
      }
    });
  }

  @override
  void initState() {
    startTimer();
    // Use timeRemaining array [minutes, seconds] if available, otherwise fall back to minutesRemaining
    if (widget.order.timeRemaining != null &&
        widget.order.timeRemaining!.length >= 2) {
      remainingSeconds =
          (widget.order.timeRemaining![0] * 60) +
          widget.order.timeRemaining![1];
    } else {
      // Fallback to minutesRemaining if timeRemaining is null
      remainingSeconds = widget.order.minutesRemaining * 60;
    }
    startRemainingTimer();
    super.initState();
    //staffLocation = SharedPrefHelper.getString(StorageKeys.locationStaff);
  }

  void stopAllSounds() {
    // Stop all timers
    _timer5?.cancel();
    _timer10?.cancel();
    _remainingTimer?.cancel();
    _alertTimer?.cancel();

    // Stop audio player
    player.stop();

    // Reset flags
    isAlertPlaying = false;
  }

  @override
  void dispose() {
    stopAllSounds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  log("Request status: ${widget.requestStatus?.status}");
  log("Accepted by current driver: ${widget.requestStatus?.isAcceptedByCurrentDriver}");
  log("Can show takeover button: ${((widget.requestStatus?.status.toLowerCase() ?? '') == 'accepted' && !(widget.requestStatus?.isAcceptedByCurrentDriver ?? false))}");
  log("Driverid: ${widget.order.driverIds}");
  log("StaffId: ${widget.staff.id}");
    String localizePlace(String? code) {
      switch ((code ?? '').toLowerCase()) {
        case 'airport':
          return 'المطار';
        case 'garage':
          return 'الكراج';
        case 'downtown':
          return 'وسط البلد';
        default:
          return code ?? '-';
      }
    }

    String localizeStatus(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return 'قيد الانتظار';
        case 'accepted':
          return 'مقبول';
        case 'completed':
          return 'مكتمل';
        case 'cancelled':
          return 'ملغي';
        default:
          return status;
      }
    }

    if (staffLocation != null && staffLocation == widget.order.origin) {
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.red, width: 1),
        ),
        child: Text(
          "🚫 هذا الطلب غير مخصص لموقعك الحالي (${staffLocation ?? "غير محدد"})",
          style: AppTextStyling.font14W500TextInter.copyWith(
            color: AppColors.red,
            fontWeight: FontWeightHelper.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Column(
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            CircleAvatar(maxRadius: 20),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    widget.order.client.name,
                    style: AppTextStyling.font14W500TextInter.copyWith(
                      color: AppColors.textWhite,
                      fontWeight: FontWeightHelper.bold,
                    ),
                  ),
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
                  userLocationContainer(
                    AppLocalizations.of(context)!.from,
                    localizePlace(widget.order.origin),
                  ),
                  SizedBox(height: responsiveHeight(context, 8)),

                  userLocationContainer(
                    AppLocalizations.of(context)!.to,
                    localizePlace(widget.order.destination),
                  ),
                  SizedBox(height: responsiveHeight(context, 8)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.OrderList,
                        style: AppTextStyling.font14W500TextInter.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        localizeStatus(widget.order.status),
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
                    formatTime(remainingSeconds),
                    style: TextStyle(color: AppColors.textWhite),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: responsiveHeight(context, 50)),
        Row(
          children: [
            statItem(
              Icon(Icons.timer, color: AppColors.textSecondary),
              formatTime(seconds),
            ),
            const SizedBox(width: 15),
           

               
            // زر سحب الطلب (يظهر فقط للطلبات المقبولة من سائق آخر)
          if ((widget.requestStatus?.status.toLowerCase() ?? '') == 'accepted' &&
    !(widget.requestStatus?.isAcceptedByCurrentDriver ?? false)&& !(widget.order.driverIds.contains(widget.staff.id)))
  _buildTakeoverButton(context),
              
            const SizedBox(width: 15),
            BlocProvider(
              create:
                  (context) => RequestStatusBloc(
                    repository: RequestStatusRepositoryImpl(
                      dataSource: RequestStatusDataSource(),
                    ),
                  ),
              child: BlocConsumer<RequestStatusBloc, RequestStatusState>(
                listener: (context, state) {
                  if (state is RequestAcceptedSuccess) {
                    // Stop all sounds and timers when request is accepted
                    stopAllSounds();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم قبول الطلب بنجاح'),
                        backgroundColor: AppColors.green,
                      ),
                    );
                    setState(() {
                      acceptButton = true;
                    });
                    DefaultTabController.of(context).animateTo(0);
                  } else if (state is RequestStatusError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('خطأ: ${state.message}'),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isAccepted = widget.requestStatus?.status == 'accepted';
                  final isAcceptedByCurrentDriver =
                      widget.requestStatus?.isAcceptedByCurrentDriver ?? false;
                  final canAccept = widget.requestStatus?.canAccept ?? true;

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(
                        isAccepted,
                        isAcceptedByCurrentDriver,
                      ),
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 60,
                      ),
                    ),
                    onPressed: _getButtonOnPressed(
                      canAccept,
                      isAccepted,
                      state,
                    ),
                    child: Text(
                      _getButtonText(isAccepted, isAcceptedByCurrentDriver),
                      style: AppTextStyling.font14W500TextInter.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeightHelper.bold,
                      ),
                    ),
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
              widget.order.vehicleType=='car'?Icon(Icons.directions_car, color: AppColors.textSecondary):Icon(Icons.directions_bus, color: AppColors.textSecondary),
               " "
            ),
            const SizedBox(width: 15),
            statItem(
              Icon(Icons.shopping_bag, color: AppColors.textSecondary),
              widget.order.bags.toString(),
            ),
            const SizedBox(width: 15),

            // statItem(vehicleCount(), ""),
            const SizedBox(width: 15),
          ],
        ),
      ],
    );
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  // تحديد لون الزر بناءً على حالة الطلب
  Color _getButtonColor(bool isAccepted, bool isAcceptedByCurrentDriver) {
    if (acceptButton || isAcceptedByCurrentDriver) {
      return AppColors.green; // مقبول من السائق الحالي
    } else if (isAccepted) {
      return AppColors.orange; // مقبول من سائق آخر
    } else {
      return AppColors.textWhite.withOpacity(0.1); // متاح للقبول
    }
  }

  // تحديد النص على الزر
  String _getButtonText(bool isAccepted, bool isAcceptedByCurrentDriver) {
    if (acceptButton || isAcceptedByCurrentDriver) {
      return "طلب مقبول";
    } else if (isAccepted) {
      return "مقبول";
    } else {
      return "قبول";
    }
  }

  // تحديد ما إذا كان يمكن الضغط على الزر
  VoidCallback? _getButtonOnPressed(
    bool canAccept,
    bool isAccepted,
    RequestStatusState state,
  ) {
    if (state is RequestStatusLoading) {
      return null; // تعطيل الزر أثناء التحميل
    }

    if (isAccepted) {
      return null; // تعطيل الزر إذا كان مقبول
    }

    if (!canAccept) {
      return null; // تعطيل الزر إذا لم يكن متاح للقبول
    }

    return () {
      context.read<RequestStatusBloc>().add(
        request_status.AcceptRequestEvent(requestId: widget.order.id),
      );
    };
  }

  // بناء زر سحب الطلب
  Widget _buildTakeoverButton(BuildContext context) {
    return BlocProvider(
      create:
          (context) => RequestTakeoverBloc(
            repository: RequestTakeoverRepositoryImpl(
              dataSource: RequestTakeoverDataSource(),
            ),
          ),
      child: BlocConsumer<RequestTakeoverBloc, RequestTakeoverState>(
        listener: (context, state) {
          if (state is RequestTakeoverSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم سحب الطلب بنجاح من ${state.takeoverResponse.data.previousDriver}',
                ),
                backgroundColor: AppColors.green,
                duration: Duration(seconds: 3),
              ),
            );
            // تحديث قائمة الطلبات
            context.read<RequestStatusBloc>().add(
              request_status.RefreshRequestStatusEvent(),
            );
          } else if (state is RequestTakeoverError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ في سحب الطلب: ${state.message}'),
                backgroundColor: AppColors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return ElevatedButton.icon(
            onPressed:
                state is RequestTakeoverLoading
                    ? null
                    : () => _showTakeoverDialog(context),
            icon:
                state is RequestTakeoverLoading
                    ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textWhite,
                        ),
                      ),
                    )
                    : Icon(Icons.swap_horiz, size: 18),
            label: Text(
              state is RequestTakeoverLoading ? 'جاري السحب...' : 'سحب الطلب',
              style: AppTextStyling.font14W500TextInter.copyWith(
                color: AppColors.textWhite,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: AppColors.textWhite,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }

  // عرض dialog تأكيد السحب
  void _showTakeoverDialog(BuildContext context) {
    final previousDriverName =
        widget.requestStatus?.acceptedByDriverName ?? 'السائق الأساسي';

    showDialog(
      context: context,
      builder:
          (context) => TakeoverConfirmationDialog(
            previousDriverName: previousDriverName,
            requestId: widget.order.id,
            onConfirm: (reason) {
              context.read<RequestTakeoverBloc>().add(
                TakeoverRequestEvent(
                  requestId: widget.order.id,
                  reason: reason,
                  previousDriverName: previousDriverName,
                ),
              );
            },
          ),
    );
  }
}
