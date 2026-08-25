import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/episodes/episode_bloc.dart';
import '../bloc/episodes/episode_event.dart';
import '../bloc/episodes/episopde_state.dart';

class EpisodesPage extends StatelessWidget {
  const EpisodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Episodes", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<EpisodeBloc>().add(FetchEpisodes());
            },
            icon: const Icon(Icons.refresh),
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF121212),
      body: BlocBuilder<EpisodeBloc, EpisodesState>(
        builder: (context, state) {
          if (state is EpisodesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          if (state is EpisodesLoaded) {
            final episodes = state.episodesResponse.results;

            return RefreshIndicator(
              color: Colors.green,
              backgroundColor: Colors.black87,
              onRefresh: () async {
                context.read<EpisodeBloc>().add(FetchEpisodes(page: 1));
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: episodes.length,
                separatorBuilder: (context, index) => const Divider(color: Colors.white10),
                itemBuilder: (context, index) {
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
                      ],
                    ),
                  );
                },
              ),
            );
          }

          if (state is EpisodesError) {
            return Center(child: Text(state.message,
                style: const TextStyle(color: Colors.red)));
          }

          return const Center(
              child: Text("Ma'lumot topilmadi",
                  style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }
}