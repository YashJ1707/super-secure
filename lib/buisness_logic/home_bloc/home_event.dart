part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class LoadApiEvent extends HomeEvent {
  List<Object> get props => [];
}

class ScreenShotEvent extends HomeEvent {
  List<Object> get props => [];
}

class DeleteListItemEvent extends HomeEvent {
  final int index;

  DeleteListItemEvent(this.index);
  List<Object> get props => [];
}

class ArchiveListItemEvent extends HomeEvent {
  final int index;

  ArchiveListItemEvent(this.index);
  List<Object> get props => [];
}
