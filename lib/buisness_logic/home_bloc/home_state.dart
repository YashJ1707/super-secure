part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeLoadingState extends HomeState {
  List<Object?> get props => [];
}

class HomeLoadedState extends HomeState {
  // final List<University> universities;
  // HomeLoadedState(this.universities);
  List<Object?> get props => [];
}
