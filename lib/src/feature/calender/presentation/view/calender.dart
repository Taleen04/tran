import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/constants/font_weight_helper.dart';
import 'package:ai_transport/src/feature/calender/data/model/request_task_model.dart';
import 'package:ai_transport/src/feature/calender/presentation/view_model/bloc/calender_bloc.dart';
import 'package:ai_transport/src/feature/calender/presentation/view_model/bloc/calender_event.dart';
import 'package:ai_transport/src/feature/calender/presentation/view_model/bloc/calender_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedStatus =
      'accepted'; // فلتر الحالة المحددة - القيمة الافتراضية accepted
  bool _isCalendarExpanded = true; // متغير للتحكم في فتح/إغلاق التقويم

  // قائمة الحالات المتاحة للمهام
  final List<Map<String, String>> _statusOptions = [
    {'value': 'accepted', 'label': 'مقبولة'},
    {'value': 'arrived', 'label': 'وصلت'},
    {'value': 'picked_up', 'label': 'تم الاستلام'},
  ];

  @override
  void initState() {
    super.initState();
    // لا نحمل البيانات تلقائياً - فقط عند الحاجة
  }

  bool _hasLoadedData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // تحميل البيانات فقط عند أول دخول للتقويم وعدم تحميلها من قبل
    if (!_hasLoadedData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.read<CalendarBloc>().state is CalendarInitial) {
          _hasLoadedData = true;
          context.read<CalendarBloc>().add(
            FetchCalendarEvent(_selectedStatus ?? 'accepted'),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // يخفي زر الرجوع الافتراضي لو ما بدك إياه
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFA726).withOpacity(0.8),
                Color(0xFFFF7043).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 20,
                color: AppColors.textWhite,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                'التقويم',
                style: AppTextStyling.font14W500TextInter.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // زر التحكم في فتح/إغلاق التقويم
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCalendarExpanded = !_isCalendarExpanded;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.textWhite.withOpacity(0.15),
                          AppColors.textWhite.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.textWhite.withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textWhite.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: AnimatedRotation(
                      turns: _isCalendarExpanded ? 0.5 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textWhite,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // التقويم والفلتر مع AnimatedCrossFade
          AnimatedCrossFade(
            duration: Duration(milliseconds: 300),
            crossFadeState:
                _isCalendarExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    context.read<CalendarBloc>().add(
                      FetchCalendarEvent(_selectedStatus ?? 'accepted'),
                    );
                  },
                  headerStyle: HeaderStyle(
                    titleTextStyle: AppTextStyling.font14W500TextInter.copyWith(
                      color: AppColors.textWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    formatButtonVisible: false,
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppColors.textWhite,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppColors.textWhite,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: AppColors.textWhite),
                    weekendStyle: TextStyle(color: AppColors.textWhite),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF7043), Color(0xFFFFA726)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF7043).withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    defaultTextStyle: TextStyle(color: AppColors.textWhite),
                    weekendTextStyle: TextStyle(color: AppColors.textWhite),
                    cellMargin: EdgeInsets.all(2),
                  ),
                  calendarFormat: CalendarFormat.month,
                ),

                const SizedBox(height: 12),

                // فلتر الحالة
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFA726).withOpacity(0.1),
                        Color(0xFFFF7043).withOpacity(0.05),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFFFA726).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: Color(0xFFFFA726),
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'فلتر الحالة:',
                        style: AppTextStyling.font14W500TextInter.copyWith(
                          color: Color(0xFF2D3748),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedStatus ?? 'accepted',
                            isExpanded: true,
                            style: AppTextStyling.font14W500TextInter.copyWith(
                              color: Color(0xFF2D3748),
                              fontWeight: FontWeight.w500,
                            ),
                            items:
                                _statusOptions.map((option) {
                                  return DropdownMenuItem<String>(
                                    value: option['value'],
                                    child: Text(
                                      option['label']!,
                                      style: AppTextStyling.font14W500TextInter
                                          .copyWith(
                                            color: Color(0xFF2D3748),
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedStatus = newValue;
                              });
                              // إعادة تحميل البيانات مع الفلتر الجديد
                              context.read<CalendarBloc>().add(
                                FetchCalendarEvent(newValue ?? 'accepted'),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            secondChild: SizedBox(height: 0), // فارغ عندما يكون مغلق
          ),

          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                if (state is CalendarLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CalendarLoaded) {
                  return _buildRequestList(
                    _filterRequestsByStatus(state.requests),
                  );
                } else if (state is CalendarError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList(List<RequestModel> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textWhite.withOpacity(0.3),
            ),
            SizedBox(height: 12),
            Text(
              "لا توجد مهام",
              style: AppTextStyling.font14W500TextInter.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "اختر حالة أخرى لعرض المهام",
              style: AppTextStyling.font14W500TextInter.copyWith(
                color: AppColors.textWhite.withOpacity(0.7),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    // ترتيب التذاكر حسب وقت الدخول (الأحدث أولاً)
    final sortedTickets = List<RequestModel>.from(requests);
    sortedTickets.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.acceptedAt.toIso8601String());
        final dateB = DateTime.parse(b.acceptedAt.toIso8601String());
        return dateB.compareTo(dateA); // الأحدث أولاً
      } catch (e) {
        return 0;
      }
    });

    return ListView.builder(
      itemCount: sortedTickets.length,
      itemBuilder: (context, index) {
        final ticket = sortedTickets[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFA726).withOpacity(0.1),
                Color(0xFFFF7043).withOpacity(0.05),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(0xFFFFA726).withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFFA726).withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                // Header with ticket number and status
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textWhite.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.textWhite.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getStatusText(ticket.status),
                          style: AppTextStyling.font14W500TextInter.copyWith(
                            color: AppColors.textWhite,
                            fontSize: 10,
                            fontWeight: FontWeightHelper.bold,
                          ),
                        ),
                      ),
                      // Request number
                      Row(
                        children: [
                          Icon(
                            Icons.confirmation_number_outlined,
                            color: AppColors.textWhite,
                            size: 10,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'مهمة #${ticket.id}',
                            style: AppTextStyling.font14W500TextInter.copyWith(
                              color: AppColors.textWhite,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.textWhite.withOpacity(0.95),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Client info
                      _buildModernInfoRow(
                        Icons.person_outline,
                        'العميل',
                        ticket.client.name,
                        Color(0xFF2196F3),
                      ),
                      SizedBox(height: 4),

                      _buildModernInfoRow(
                        Icons.phone_outlined,
                        'رقم الهاتف',
                        ticket.client.phone,
                        Color(0xFF4CAF50),
                      ),
                      SizedBox(height: 4),

                      _buildModernInfoRow(
                        Icons.location_on_outlined,
                        'من',
                        ticket.origin,
                        Color(0xFF9C27B0),
                      ),
                      SizedBox(height: 4),

                      _buildModernInfoRow(
                        Icons.location_off_outlined,
                        'إلى',
                        ticket.destination,
                        Color(0xFFFF5722),
                      ),
                      SizedBox(height: 4),

                      _buildModernInfoRow(
                        Icons.directions_car_outlined,
                        'نوع المركبة',
                        ticket.vehicleType,
                        Color(0xFF2196F3),
                      ),
                      SizedBox(height: 4),

                      _buildModernInfoRow(
                        Icons.people_outlined,
                        'عدد الركاب',
                        '${ticket.passengers}',
                        Color(0xFF4CAF50),
                      ),
                      SizedBox(height: 4),

                      _buildModernInfoRow(
                        Icons.luggage_outlined,
                        'عدد الحقائب',
                        '${ticket.bags}',
                        Color(0xFFFF9800),
                      ),

                      if (ticket.notes != null && ticket.notes!.isNotEmpty) ...[
                        SizedBox(height: 4),
                        _buildModernInfoRow(
                          Icons.note_outlined,
                          'ملاحظات',
                          ticket.notes!,
                          Color(0xFF795548),
                        ),
                      ],

                      SizedBox(height: 4),
                      _buildModernInfoRow(
                        Icons.access_time_outlined,
                        'وقت القبول',
                        _formatDateTime(ticket.acceptedAt.toIso8601String()),
                        Color(0xFFFF9800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernInfoRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(width: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 6),
              Icon(icon, color: color, size: 10),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTime) {
    try {
      final dt = DateTime.parse(dateTime);
      final now = DateTime.now();
      final difference = now.difference(dt);

      if (difference.inDays == 0) {
        return 'اليوم ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'أمس ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} أيام ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } else {
        return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return dateTime;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return 'مقبولة';
      case 'arrived':
        return 'وصلت';
      case 'picked_up':
        return 'تم الاستلام';

      default:
        return status ?? 'غير محدد';
    }
  }

  // فلترة المهام حسب الحالة المحددة
  List<RequestModel> _filterRequestsByStatus(List<RequestModel> requests) {
    if (_selectedStatus == null || _selectedStatus!.isEmpty) {
      return requests; // إرجاع جميع المهام إذا لم يتم تحديد حالة
    }

    final filtered =
        requests.where((request) {
          return true;
        }).toList();

    return filtered;
  }
}
