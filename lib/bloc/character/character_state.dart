import '../../models/character_model.dart';


abstract class CharacterState {}
class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final CharacterResponse characterResponse;
  CharacterLoaded(this.characterResponse);
}
class CharacterError extends CharacterState {
  final String message;
  CharacterError(this.message);
}