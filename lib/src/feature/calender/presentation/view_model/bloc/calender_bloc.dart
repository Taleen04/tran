import 'package:ai_transport/src/feature/calender/presentation/repo/calender_repo.dart';
import 'package:ai_transport/src/feature/calender/presentation/view_model/bloc/calender_event.dart';
import 'package:ai_transport/src/feature/calender/presentation/view_model/bloc/calender_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarRepository repository;

  CalendarBloc(this.repository) : super(CalendarInitial()) {
    on<FetchCalendarEvent>(_onFetchCalendar);
  }

  Future<void> _onFetchCalendar(
    FetchCalendarEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    try {
      final requests = await repository.fetchOrders(
        status: event.status, // accepted, arrived, picked_up
      );
      emit(CalendarLoaded(requests));
    } catch (e) {
      emit(CalendarError("فشل في تحميل البيانات: $e"));
    }
  }
}
