import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home_page.dart';
import 'repositories/character_repository.dart';
import 'repositories/episodes_repository.dart';
import 'repositories/location_repository.dart';
import 'bloc/character/character_bloc.dart';
import 'bloc/episodes/episode_bloc.dart';
import 'bloc/locations/location_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CharacterBloc(CharacterRepository()),
        ),
        BlocProvider(
          create: (context) => EpisodeBloc(EpisodesRepository()),
        ),
        BlocProvider(
          create: (context) => LocationBloc(LocationsRepository()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MyHomeWidget(),
    );
  }
}