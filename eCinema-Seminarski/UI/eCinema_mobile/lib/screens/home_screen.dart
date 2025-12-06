import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/category.dart';
import 'package:ecinema_mobile/models/category_movies.dart';
import 'package:ecinema_mobile/models/movie.dart';
import 'package:ecinema_mobile/providers/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/searchObject/movie_search.dart';
import '../providers/category_provider.dart';
import '../providers/login_provider.dart';
import '../utils/authorization.dart';
import '../utils/error_dialog.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<CategoryMovies>>? futureCategories;
  late MovieProvider _movieProvider;
  late CategoryProvider _categoryProvider;
  late UserLoginProvider _userLoginProvider;

  List<Movie> recommendedMovies = [];
  List<Movie> movies = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    _movieProvider = context.read<MovieProvider>();
    _categoryProvider = context.read<CategoryProvider>();
    _userLoginProvider = context.read<UserLoginProvider>();

    loadData();
  }

  void loadData() async {
    try {
      var allMovies = await _movieProvider.getPaged(searchObject: MovieSearchObject(name: null));
      if (!mounted) return;

      movies = allMovies;

      if (_userLoginProvider.user != null) {
        recommendedMovies = await _movieProvider.recommend(int.parse(_userLoginProvider.user!.id));
      }

      futureCategories = fetchCategoriesMovies();

      if (!mounted) return;
      setState(() {
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future<List<CategoryMovies>> fetchCategoriesMovies() async {
    List<CategoryMovies> result = [];
    var categories = await _categoryProvider.get(null);

    for (var category in categories) {
      var moviesForCategory = movies.where((m) => m.categories.any((c) => c.id == category.id)).take(3).toList();

      if (moviesForCategory.isNotEmpty) {
        result.add(CategoryMovies(
          category: category,
          movies: moviesForCategory,
        ));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Početna"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recommendedMovies.isNotEmpty) _buildRecommendedSection(),
                  FutureBuilder<List<CategoryMovies>>(
                    future: futureCategories,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _buildCategories(snapshot.data!);
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Greška pri učitavanju kategorija: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator(color: Colors.teal));
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Preporučeno za vas',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recommendedMovies.length,
            itemBuilder: (context, index) {
              final m = recommendedMovies[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    MovieDetailScreen.routeName,
                    arguments: m,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: SizedBox(
                      width: 120,
                      child: m.photo?.guidId != null
                          ? FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: NetworkImage(
                                '$apiUrl/Photo/GetById?id=${m.photo?.guidId}&original=true',
                                headers: Authorization.createHeaders(),
                              ),
                              fit: BoxFit.cover,
                            )
                          : const Placeholder(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(List<CategoryMovies> categoriesMovies) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: categoriesMovies.map((c) {
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.lightBlueAccent, width: 0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        c.category.name,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => openMoviesScreen(c.category),
                      child: const Text(
                        'Pogledaj sve ->',
                        style: TextStyle(color: Colors.teal),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: c.movies.map((m) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              MovieDetailScreen.routeName,
                              arguments: m,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: SizedBox(
                                width: 120,
                                child: m.photo?.guidId != null
                                    ? FadeInImage(
                                        placeholder: MemoryImage(kTransparentImage),
                                        image: NetworkImage(
                                          '$apiUrl/Photo/GetById?id=${m.photo?.guidId}&original=true',
                                          headers: Authorization.createHeaders(),
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : const Placeholder(),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void openMoviesScreen(Category category) {
    _movieProvider.setCategory(category);
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
      arguments: 1,
    );
  }
}
