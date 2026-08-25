import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/episodes_repository.dart';
import 'episode_event.dart';
import 'episopde_state.dart';

class EpisodeBloc extends Bloc<EpisodesEvent, EpisodesState> {
  final EpisodesRepository repository;

  EpisodeBloc(this.repository) : super(EpisodesInitial()) {
    on<FetchEpisodes>(_onFetchEpisodes);
  }
    Future<void> _onFetchEpisodes(
      FetchEpisodes event,
      Emitter<EpisodesState> emit,
    ) async {
      emit(EpisodesLoading());
      try {
        final result = await repository.getEpisodes(event.page);
        emit(EpisodesLoaded(result));
      } catch (e) {
        emit(EpisodesError(e.toString()));
      }
    }
  }
