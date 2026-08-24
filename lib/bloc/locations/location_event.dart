abstract class LocationsEvent {}
class FetchLocations extends LocationsEvent {
  final int page;
  FetchLocations({this.page = 1});
}