import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/category.dart';
import 'package:ecinema_mobile/models/category_movies.dart';
import 'package:ecinema_mobile/models/movie.dart';
import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:ecinema_mobile/providers/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../providers/category_provider.dart';
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
  late Future<List<CategoryMovies>> futureCategories;
  late Future<List<Category>> categories;

  late CategoryProvider _categoryProvider;
  late MovieProvider _movieProvider;
  late UserLoginProvider _userLoginProvider;

  @override
  void initState() {
    super.initState();

    _movieProvider = context.read<MovieProvider>();
    _userLoginProvider = context.read<UserLoginProvider>();
    _categoryProvider = context.read<CategoryProvider>();

    // futureMovies = fetchMovies();
    // categories = loadCategories();
    futureCategories = fetchByCategories();
  }

  Future<List<Category>> loadCategories() async {
    try {
      return await _categoryProvider.get(null);
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
      return <Category>[];
    }
  }

  Future<List<Movie>> fetchMovies() async {
    try {
      return await _movieProvider
          .recommend(int.parse(_userLoginProvider.user!.Id));
    } catch (e) {
      showErrorDialog(context, e.toString().substring(11));

      return <Movie>[];
    }
  }

  Future<List<CategoryMovies>> fetchByCategories() async {
    try {
      return await _movieProvider.getCategoryAndMovies();
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
      return <CategoryMovies>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Početna"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildCategories(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const SizedBox(
                  height: 350,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
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

  Widget _buildCategories(List<CategoryMovies> movies) {
    return Column(
      children: movies
          .map(
            (c) => Container(
              height: 200,
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
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
                      Text(c.category.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 18)),
                      TextButton(
                        onPressed: () => openMoviesScreen(c.category),
                        child: const Text(
                          'Pogledaj sve',
                          style: TextStyle(color: Colors.teal),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: c.movies.take(4).map((m) {
                        return InkWell(
                          onTap: () => Navigator.pushNamed(
                            context,
                            MovieDetailScreen.routeName,
                            arguments: m,
                          ),
                          child: SizedBox(
                            width: 90,
                            height: 120,
                            child: m.photo.guidId != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: FadeInImage(
                                      placeholder:
                                          MemoryImage(kTransparentImage),
                                      image: NetworkImage(
                                        '$apiUrl/Photo/GetById?id=${m.photo.guidId}&original=true',
                                        headers: Authorization.createHeaders(),
                                      ),
                                      fadeInDuration:
                                          const Duration(milliseconds: 300),
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : const Placeholder(),
                          ),
                        );
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
