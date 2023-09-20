import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_with_clean_architecture_and_bloc/movies/presentation/controller/movies_bloc.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/utils/app_string.dart';
import '../../../core/utils/enums.dart';
import 'movie_detail_screen.dart';

class NowPlayingMoviesScreen extends StatelessWidget {
  const NowPlayingMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MoviesBloc>()..add(GetNowPlayingMoviesEvent()),
      child: BlocBuilder<MoviesBloc, MoviesState>(
        buildWhen: (previous, current) =>
            previous.nowPlayingState != current.nowPlayingState,
        builder: (BuildContext context, MoviesState state) {
          return SafeArea(
            child: Scaffold(
              body: state.nowPlayingState == RequestState.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : state.nowPlayingState == RequestState.error
                      ? const Text(AppString.somethingWentWrong)
                      : ListView.separated(
                          itemCount: state.nowPlayingMovies.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (item, index) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(
                                    id: state.nowPlayingMovies[index].id,
                                  ),
                                ),
                              ),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: ApiConstants.imageUrl(state
                                      .nowPlayingMovies[index].backdropPath),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          );
        },
      ),
    );
  }
}
