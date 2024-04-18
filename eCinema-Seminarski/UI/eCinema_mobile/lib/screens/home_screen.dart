import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/category.dart';
import 'package:ecinema_mobile/models/movie.dart';
import 'package:ecinema_mobile/providers/category_provider.dart';
import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:ecinema_mobile/providers/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:transparent_image/transparent_image.dart';

import '../utils/authorization.dart';
import '../utils/error_dialog.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> futureMovies;
  late Future<List<Category>> futureCategories;

  late CategoryProvider _categoryProvider;
  late MovieProvider _movieProvider;
  late UserLoginProvider _userLoginProvider;

  Future<List<Movie>> fetchMovies() async {
    try {
      return await _movieProvider
          .recommend(int.parse(_userLoginProvider.user!.Id));
    } catch (e) {
      showErrorDialog(context, e.toString().substring(11));

      return <Movie>[];
    }
  }

  Future<List<Category>> fetchByCategories() async {
    try {
      var params = <String, String>{
        'includeMoviesWithData': 'true',
        'isDisplayed': 'true'
      };
      return await _categoryProvider.get(params);
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));

      return <Category>[];
    }
  }

  @override
  void initState() {
    super.initState();

    _categoryProvider = context.read<CategoryProvider>();
    _movieProvider = context.read<MovieProvider>();
    _userLoginProvider = context.read<UserLoginProvider>();

    // futureMovies = fetchMovies();
    futureCategories = fetchByCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "eCinema",
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   height: 350,
            //   padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            //   child: FutureBuilder(
            //     future: futureMovies,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return GridView(
            //           gridDelegate:
            //               const SliverGridDelegateWithFixedCrossAxisCount(
            //             crossAxisCount: 1,
            //             childAspectRatio: 4 / 3,
            //             mainAxisSpacing: 0,
            //           ),
            //           scrollDirection: Axis.horizontal,
            //           children: _buildMovieList(snapshot.data!),
            //         );
            //       } else if (snapshot.hasError) {
            //         return Text('${snapshot.error}');
            //       }
            //       return Center(
            //         child: CircularProgressIndicator(
            //           color: Colors.lightBlue[300],
            //         ),
            //       );
            //     },
            //   ),
            // ),
            FutureBuilder(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildCategories(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return SizedBox(
                  height: 350,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.lightBlue[300],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMovieList(List<Movie> movies) {
    return movies
        .map((movie) => Column(
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    MovieDetailScreen.routeName,
                    arguments: movie,
                  ),
                  child: movie.photoId != null
                      ? SimpleShadow(
                          sigma: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: FadeInImage(
                              image: NetworkImage(
                                '$apiUrl/Photo/${movie.photoId}',
                                headers: Authorization.createHeaders(),
                              ),
                              placeholder: MemoryImage(kTransparentImage),
                              height: 210,
                              fadeInDuration: const Duration(milliseconds: 300),
                            ),
                          ),
                        )
                      : const Placeholder(
                          fallbackHeight: 210,
                        ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ))
        .toList();
  }

  Widget _buildCategories(List<Category> categories) {
    var categoriesToShow = [];
    // categories.where((c) => c.movieCategories.isNotEmpty);

    return Column(
      children: categoriesToShow
          .map(
            (c) => Container(
              height: 190,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.lightBlueAccent,
                    width: 0.2,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(c.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 18)),
                      TextButton(
                        onPressed: () => openMoviesScreen(c),
                        child: const Text(
                          'Pogledaj sve',
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: c.movieCategories.take(4).map((m) {
                        return InkWell(
                            onTap: () => Navigator.pushNamed(
                                  context,
                                  MovieDetailScreen.routeName,
                                  arguments: m,
                                ),
                            child: SizedBox(
                              width: 70,
                              height: 90,
                              child: m.photoId != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: FadeInImage(
                                        image: NetworkImage(
                                          '$apiUrl/Photo/${m.photoId}',
                                          headers:
                                              Authorization.createHeaders(),
                                        ),
                                        placeholder:
                                            MemoryImage(kTransparentImage),
                                        fit: BoxFit.fill,
                                        fadeInDuration:
                                            const Duration(milliseconds: 300),
                                      ),
                                    )
                                  : const Placeholder(),
                            ));
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  openMoviesScreen(Category category) {
    _movieProvider.setCategory(category);

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false,
        arguments: 1);
  }
}
