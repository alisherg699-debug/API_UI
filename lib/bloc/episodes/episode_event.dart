abstract class EpisodesEvent {}

class FetchEpisodes extends EpisodesEvent {
  final int page;
  FetchEpisodes({this.page = 1});
}
