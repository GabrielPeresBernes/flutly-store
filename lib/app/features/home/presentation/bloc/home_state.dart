part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required this.productLists});

  final List<HomeProductList> productLists;
}

final class HomeFailure extends HomeState {
  const HomeFailure({required this.exception});

  final AppException exception;
}
