import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character/character_bloc.dart';
import '../bloc/character/character_state.dart';
import '../bloc/character/character_event.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> cratedState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
   final ScrollController _scrollController = ScrollController();
   int _currentPage = 1;

   @override
   void initState() {
     super.initState();
     _scrollController.addListener(_onScroll);
   }

   void _onScroll() {
     if (_scrollController.position.pixels >=
         _scrollController.position.maxScrollExtent - 200) {

       final state = context.read<CharacterBloc>().state;

       if (state is CharacterLoaded) {

         if (state.characterResponse.info.next != null) {
           _currentPage++;
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
        title: const Text("Characters", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF121212),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading && _currentPage == 1) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          if (state is CharacterLoaded) {
            final characters = state.characterResponse.results;

            return RefreshIndicator(
              onRefresh: () async {
                _currentPage = 1;
                context.read<CharacterBloc>().add(FetchCharacters(page: 1));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      "👀 CLICK ON ANY CELL FOR FURTHER INFORMATION",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: characters.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.white10,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final character = characters[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white12,
                                backgroundImage: NetworkImage(character.image),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      character.name,
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      character.status,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white24,
                                size: 16,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is CharacterError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CharacterBloc>().add(FetchCharacters());
                    },
                    child: const Text("Qaytadan urinish"),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              "Ma'lumot topilmadi",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}