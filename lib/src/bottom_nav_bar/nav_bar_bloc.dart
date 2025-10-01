
import 'package:ai_transport/src/bottom_nav_bar/nav_bar_event.dart';
import 'package:ai_transport/src/bottom_nav_bar/nav_bar_state.dart';
import 'package:bloc/bloc.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(NavState(1)) {
    on<NavChanged>((event, emit) {
      emit(NavState(event.index));
    });
  }
}
