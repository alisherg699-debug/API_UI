import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character/character_bloc.dart';
import '../bloc/character/character_state.dart';
import '../bloc/character/character_event.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<CharacterBloc>().add(FetchCharacters(page: 1));
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<CharacterBloc>().state;

      if (state is CharacterLoaded) {
        if (state.characterResponse.info.next != null && state.characterResponse.info.next!.isNotEmpty) {
          setState(() {
            _isLoadingMore = true;
            _currentPage++;
          });
          context.read<CharacterBloc>().add(FetchCharacters(page: _currentPage));
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
        title: const Text("Characters", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF121212),
      body: BlocConsumer<CharacterBloc, CharacterState>(
        listener: (context, state) {
          if (state is CharacterLoaded || state is CharacterError) {
            setState(() => _isLoadingMore = false);
          }
        },
        builder: (context, state) {
          if (state is CharacterInitial || (state is CharacterLoading && _currentPage == 1)) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }

          if (state is CharacterError && _currentPage == 1) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _currentPage = 1);
                      context.read<CharacterBloc>().add(FetchCharacters(page: 1));
                    },
                    child: const Text("Qaytadan urinish"),
                  ),
                ],
              ),
            );
          }

          if (state is CharacterLoaded) {
            final response = state.characterResponse;
            final characters = response.results;

            return RefreshIndicator(
              color: Colors.green,
              onRefresh: () async {
                setState(() => _currentPage = 1);
                context.read<CharacterBloc>().add(FetchCharacters(page: 1));
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      "👀 CLICK ON ANY CELL FOR FURTHER INFORMATION",
                      style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemExtent: 100.0,
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: characters.length + (response.info.next
                          != null && response.info.next!.isNotEmpty ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == characters.length) {
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

                        final character = characters[index];
                        return Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.white12,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: character.image,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => const Center(
                                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green),
                                          ),
                                          errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(character.name, style: const TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 4),
                                          Text(character.status, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(color: Colors.white10, height: 1),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator(color: Colors.green));
        },
      ),
    );
  }
}
