import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/locations/location_bloc.dart';
import '../bloc/locations/location_event.dart';
import '../bloc/locations/location_state.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationsPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<LocationBloc>().add(FetchLocations(page: 1));
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<LocationBloc>().state;

      if (state is LocationsLoaded) {
        if (state.locationsResponse.info.next != null &&
            state.locationsResponse.info.next!.isNotEmpty) {
          setState(() {
            _isLoadingMore = true;
            _currentPage++;
          });
          context.read<LocationBloc>().add(FetchLocations(page: _currentPage));
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
        title: const Text("Locations", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF121212),
      body: BlocConsumer<LocationBloc, LocationsState>(
        listener: (context, state) {
          if (state is LocationsLoaded || state is LocationsError) {
            setState(() => _isLoadingMore = false);
          }
        },
        builder: (context, state) {
          if (state is LocationsInitial ||
              (state is LocationsLoading && _currentPage == 1)) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
          if (state is LocationsError && _currentPage == 1) {
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
                      setState(() => _currentPage = 1);
                      context.read<LocationBloc>().add(FetchLocations(page: 1));
                    },
                    child: const Text("Qaytadan urinish"),
                  ),
                ],
              ),
            );
          }

          if (state is LocationsLoaded) {
            final response = state.locationsResponse;
            final locations = response.results;
            return RefreshIndicator(
              color: Colors.green,
              onRefresh: () async {
                setState(() => _currentPage = 1);
                context.read<LocationBloc>().add(FetchLocations(page: 1));
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
                itemExtent: 100.0,
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount:
                    locations.length +
                    (response.info.next != null &&
                            response.info.next!.isNotEmpty
                        ? 1
                        : 0),
                itemBuilder: (context, index) {
                  if (index == locations.length) {
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
                  final location = locations[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white12,
                          child: Icon(Icons.map, color: Colors.green, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.name,
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${location.dimension} | Residents: ${location.residents.length}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white24,
                          size: 14,
                        ),
                        const Divider(color: Colors.white10, height: 1),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        },
      ),
    );
  }
}
