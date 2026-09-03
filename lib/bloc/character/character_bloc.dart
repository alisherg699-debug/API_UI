import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/character_repository.dart';
import '../../models/character_model.dart';
import 'character_event.dart';
import 'character_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;

  CharacterBloc(this.repository) : super(CharacterInitial()) {
    on<FetchCharacters>(
      _onFetchCharacters,
      transformer: droppable(),
    );
  }

  Future<void> _onFetchCharacters(
    FetchCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    final currentState = state;
    List<Character> oldCharacters = [];
    CharacterResponse? lastResponse;

    if (currentState is CharacterLoaded) {
      oldCharacters = currentState.characterResponse.results;
      lastResponse = currentState.characterResponse;
    }

    if (event.page == 1) {
      emit(CharacterLoading());
    }

    try {
      final result = await repository.getCharacters(event.page);

      emit(CharacterLoaded(
        CharacterResponse(
          info: result.info,
          results: event.page == 1 ? result.results : oldCharacters + result.results,
        ),
      ));
    } catch (e) {
      if (oldCharacters.isNotEmpty && lastResponse != null) {
        emit(CharacterLoaded(lastResponse));
      } else {
        emit(CharacterError(e.toString()));
      }
    }
  }
}
