part of 'app_bar_cubit.dart';

class AppBarState extends Equatable {
  final PreferredSizeWidget? bottom;
  const AppBarState({this.bottom});
  double get bottomHeight => bottom?.preferredSize.height ?? 0;

  @override
  List<Object?> get props => [bottom];
}
