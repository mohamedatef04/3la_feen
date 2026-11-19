import 'package:ala_feen/core/utils/safe_emit.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'driver_ratings_state.dart';

class DriverRatingsCubit extends Cubit<DriverRatingsState> {
  DriverRatingsCubit(this._repo) : super(DriverRatingsInitial());

  final DriverRepo _repo;

  Future<void> getDriverRatings() async {
    safeEmit(DriverRatingsLoading());
    final result = await _repo.getMyRatings();
    result.fold(
      (failure) => safeEmit(DriverRatingsFailure(failure.errorMessage)),
      (ratings) => safeEmit(DriverRatingsSuccess(ratings)),
    );
  }
}
