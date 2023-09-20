import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/utils/app_string.dart';
import '../../../core/utils/enums.dart';
import '../controller/movies_bloc.dart';
import 'movie_detail_screen.dart';

class TopRatedMoviesScreen extends StatelessWidget {
  const TopRatedMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MoviesBloc>()..add(GetTopRatedMoviesEvent()),
      child: BlocBuilder<MoviesBloc, MoviesState>(
        buildWhen: (previous, current) =>
            previous.topRatedState != current.topRatedState,
        builder: (BuildContext context, MoviesState state) {
          return SafeArea(
            child: Scaffold(
              body: state.topRatedState == RequestState.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : state.topRatedState == RequestState.error
                      ? const Text(AppString.somethingWentWrong)
                      : ListView.separated(
                          itemCount: state.topRatedMovies.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (item, index) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(
                                    id: state.topRatedMovies[index].id,
                                  ),
                                ),
                              ),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: ApiConstants.imageUrl(
                                      state.topRatedMovies[index].backdropPath),
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
