part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class LoadApiEvent extends HomeEvent {
  List<Object> get props => [];
}

class ScreenShotEvent extends HomeEvent {
  List<Object> get props => [];
}
