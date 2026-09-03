import '../../models/locations_model.dart';

abstract class LocationsState {}

class LocationsInitial extends LocationsState {}

class LocationsLoading extends LocationsState {}

class LocationsLoaded extends LocationsState {
  final LocationsResponse locationsResponse;
  LocationsLoaded(this.locationsResponse);
}

class LocationsError extends LocationsState {
  final String message;
  LocationsError(this.message);
}
