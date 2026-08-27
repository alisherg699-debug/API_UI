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

    if (state is CharacterLoading && event.page > 1) return;
    final currentState = state;
    List<Character> oldCharacters = [];

    if (currentState is CharacterLoaded) {
      oldCharacters = currentState.characterResponse.results;
    }
    if (event.page == 1) {
      emit(CharacterLoading());
    }

    try {
      final result = await repository.getCharacters(event.page);

      if (event.page > 1) {
        emit(
            CharacterLoaded(
          CharacterResponse(
            info: result.info,
            results: oldCharacters + result.results,
          ),
          ),
        );
      } else {
        emit(CharacterLoaded(result));
      }
    } catch (e) {
      emit(CharacterError(e.toString()));
    }
  }
}
