import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../../models/locations_model.dart';
import '../../repositories/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationsEvent, LocationsState> {
  final LocationsRepository repository;

  LocationBloc(this.repository) : super(LocationsInitial()) {
    on<FetchLocations>(
      _onFetchLocations,
      transformer: droppable(),
    );
  }

  Future<void> _onFetchLocations(
      FetchLocations event,
      Emitter<LocationsState> emit,
      ) async {
    final currentState = state;
    List<Locations> oldLocations = [];
    LocationsResponse? lastResponse;

    if (currentState is LocationsLoaded) {
      oldLocations = currentState.locationsResponse.results;
      lastResponse = currentState.locationsResponse;
    }

    if (event.page == 1) {
      emit(LocationsLoading());
    }

    try {
      final result = await repository.getLocations(event.page);

      emit(LocationsLoaded(
        LocationsResponse(
          info: result.info,
          results: event.page == 1 ? result.results : oldLocations + result.results,
        ),
      ));
    } catch (e) {
      if (oldLocations.isNotEmpty && lastResponse != null) {
        emit(LocationsLoaded(lastResponse));
      } else {
        emit(LocationsError(e.toString()));
      }
    }
  }
}
