abstract class CharacterEvent {}
class FetchCharacters extends CharacterEvent {
  final int page;
  FetchCharacters({this.page = 1});
}