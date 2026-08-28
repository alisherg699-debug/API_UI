import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/episodes/episode_bloc.dart';
import '../bloc/episodes/episode_event.dart';
import '../bloc/episodes/episode_state.dart';

class EpisodesPage extends StatefulWidget {
  const EpisodesPage({super.key});

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<EpisodeBloc>().add(FetchEpisodes(page: 1));
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<EpisodeBloc>().state;

      if (state is EpisodesLoaded) {
        if (state.episodesResponse.info.next != null && state.episodesResponse.info.next!.isNotEmpty) {
          setState(() {
            _isLoadingMore = true;
            _currentPage++;
          });
          context.read<EpisodeBloc>().add(FetchEpisodes(page: _currentPage));
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Episodes", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF121212),
      body: BlocConsumer<EpisodeBloc, EpisodesState>(
        listener: (context, state) {
          if (state is EpisodesLoaded || state is EpisodesError) {
            setState(() => _isLoadingMore = false);
          }
        },
        builder: (context, state) {
          if (state is EpisodesInitial || (state is EpisodesLoading && _currentPage == 1)) {
            return const Center(child: CircularProgressIndicator(color: Colors.green,));
          }
          if (state is EpisodesError && _currentPage == 1) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _currentPage = 1);
                      context.read<EpisodeBloc>().add(FetchEpisodes(page: 1));
                    },
                    child: const Text("Qaytadan urinish"),
                  )
                ],
              ),
            );
          }
          if (state is EpisodesLoaded) {
            final response = state.episodesResponse;
            final episodes = response.results;
            return RefreshIndicator(
              color: Colors.green,
              onRefresh: () async {
                setState(() => _currentPage = 1);
                context.read<EpisodeBloc>().add(FetchEpisodes(page: 1));
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
                itemExtent: 100.0,
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: episodes.length + (response.info.next
                  !=null && response.info.next!.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == episodes.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );
                  }
                  final episode = episodes[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white12,
                          child: Icon(Icons.movie_filter, color: Colors.green, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                episode.name,
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${episode.episode} | ${episode.air_date}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
                        const Divider(color: Colors.white10, height: 1),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator(color: Colors.green));
        }
      ),
    );
  }
}

