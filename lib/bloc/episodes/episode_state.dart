import '../../models/episodes_model.dart';


abstract class EpisodesState {}
class EpisodesInitial extends EpisodesState {}

class EpisodesLoading extends EpisodesState {}

class EpisodesLoaded extends EpisodesState {
  final EpisodesResponse episodesResponse;
  EpisodesLoaded(this.episodesResponse);
}
class EpisodesError extends EpisodesState {
  final String message;
  EpisodesError(this.message);
}