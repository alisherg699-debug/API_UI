import 'package:api_ui/models/episodes_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/episodes_repository.dart';
import 'episode_event.dart';
import 'episopde_state.dart';

class EpisodeBloc extends Bloc<EpisodesEvent, EpisodesState> {
  final EpisodesRepository repository;

  EpisodeBloc(this.repository) : super(EpisodesInitial()) {
    on<FetchEpisodes>(
      _onFetchEpisodes,
      transformer: droppable(),
    );
  }

  Future<void> _onFetchEpisodes(
      FetchEpisodes event,
      Emitter<EpisodesState> emit,
      ) async {
    final currentState = state;
    List<Episodes> oldEpisodes = [];
    EpisodesResponse? lastResponse;

    if (currentState is EpisodesLoaded) {
      oldEpisodes = currentState.episodesResponse.results;
      lastResponse = currentState.episodesResponse;
    }

    if (event.page == 1 && oldEpisodes.isEmpty) {
      emit(EpisodesLoading());
    }

    try {
      final result = await repository.getEpisodes(event.page);

      emit(EpisodesLoaded(
        EpisodesResponse(
          info: result.info,
          results: event.page == 1 ? result.results : oldEpisodes + result.results,
        ),
      ));
    } catch (e) {
      if (oldEpisodes.isNotEmpty && lastResponse != null) {
        emit(EpisodesLoaded(lastResponse));
      } else {
        emit(EpisodesError(e.toString()));
      }
    }
  }
}
