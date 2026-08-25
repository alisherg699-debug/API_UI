import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationsEvent, LocationsState> {
  final LocationsRepository repository;

  LocationBloc(this.repository) : super(LocationsInitial()) {
    on<FetchLocations>(_onFetchLocations);
  }
  Future<void> _onFetchLocations(
      FetchLocations event,
      Emitter<LocationsState> emit,
      ) async {
    emit(LocationsLoading());
    try {
      final result = await repository.getLocations(event.page);
      emit(LocationsLoaded(result));
    } catch (e) {
      emit(LocationsError(e.toString()));
    }
  }

}