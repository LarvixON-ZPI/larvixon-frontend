import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'app_bar_state.dart';

class AppBarCubit extends Cubit<AppBarState> {
  AppBarCubit() : super(const AppBarState());

  void setBottom(PreferredSizeWidget? bottom) {
    emit(AppBarState(bottom: bottom));
  }

  void clearBottom() {
    emit(const AppBarState());
  }
}
