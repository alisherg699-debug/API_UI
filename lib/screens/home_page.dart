import 'package:api_ui/bloc/locations/location_bloc.dart';
import 'package:api_ui/bloc/locations/location_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character/character_bloc.dart';
import '../bloc/character/character_event.dart';
import '../bloc/episodes/episode_bloc.dart';
import '../bloc/episodes/episode_event.dart';
import '../screens/episodes_page.dart';
import '../screens/characters_page.dart';
import '../screens/locations_page.dart';


class MyHomeWidget extends StatefulWidget {
  const MyHomeWidget({super.key});

  @override
  State<MyHomeWidget> createState() => _MyHomeWidgetState();
}

class _MyHomeWidgetState extends State<MyHomeWidget> {

  int _selectionIndex = 0;

  static const List<Widget> _pages = [
    CharacterPage(),
    LocationsPage(),
    EpisodesPage(),
  ];
  /*@override
  void initState() {
    super.initState();

    context.read<CharacterBloc>().add(
      FetchCharacters(),
    );
    context.read<EpisodeBloc>().add(
      FetchEpisodes(page: 2)
    );
    context.read<LocationBloc>().add(
      FetchLocations(page: 1),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectionIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectionIndex,
        onTap: (index) {
          setState(() {
            _selectionIndex = index;
          });
        },
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Characters"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Locations"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.tv),
              label: "Episodes"
          ),
        ],
      ),
    );
  }
}