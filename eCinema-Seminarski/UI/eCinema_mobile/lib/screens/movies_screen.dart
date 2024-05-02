import 'package:ecinema_mobile/models/movie.dart';
import 'package:ecinema_mobile/models/searchObject/movie_search.dart';
import 'package:ecinema_mobile/providers/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../helpers/constants.dart';
import '../models/category.dart';
import '../models/genre.dart';
import '../providers/category_provider.dart';
import '../providers/genre_provider.dart';
import '../utils/authorization.dart';
import '../utils/error_dialog.dart';
import 'movie_detail_screen.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late GenreProvider _genreProvider;
  late MovieProvider _movieProvider;
  late CategoryProvider _categoryProvider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isMounted = false;
  List<Genre> genres = <Genre>[];
  List<Category> categories = <Category>[];
  List<Movie> movies = <Movie>[];
  Category? selectedCategory;
  Genre? selectedGenre;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _movieProvider = context.read<MovieProvider>();
    _genreProvider = context.read<GenreProvider>();
    _categoryProvider = context.read<CategoryProvider>();

    // selectedCategory = _movieProvider.category;
    // categories = _categoryProvider.categories;
    loadData();
  }

  void loadData() async {
    loadMovies(MovieSearchObject(
        name: null,
        genreId: selectedGenre?.id,
        categoryId: selectedCategory?.id));
    await loadGenres();
    await loadCategories();
  }

  void loadMovies(MovieSearchObject searchObject) async {
    loading = true;
    try {
      var data = await _movieProvider.getPaged(searchObject: searchObject);
      if (_isMounted) {
        setState(() {
          movies = data;
        });
      }
      loading = false;
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future loadGenres() async {
    try {
      genres = await _genreProvider.get(null);
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future loadCategories() async {
    try {
      categories = await _categoryProvider.get(null);
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    _movieProvider.setCategory(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmovi'),
        actions: [
          IconButton(
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
              icon: const Icon(Icons.search))
        ],
      ),
      body: Column(
        children: [
          _buildFilterList(),
          _buildMovieList(),
        ],
      ),
      drawer: _buildFilterDrawer(),
      key: _scaffoldKey,
    );
  }

  Widget _buildFilterList() {
    if (selectedCategory == null && selectedGenre == null) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(8, 20, 8, 0),
      child: Row(
        children: [
          if (selectedCategory != null)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(selectedCategory!.name),
            ),
          if (selectedGenre != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(selectedGenre!.name),
            )
        ],
      ),
    );
  }

  Widget _buildFilterDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Text(
                    'Filtriraj rezultate',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                ],
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kategorija',
                    style: TextStyle(fontSize: 18, color: Colors.teal),
                  ),
                  _buildCategoryDropdown(),
                  const Text(
                    'Žanr',
                    style: TextStyle(fontSize: 18, color: Colors.teal),
                  ),
                  _buildGenreDropdown(),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = null;
                        selectedGenre = null;
                      });
                      loadMovies(MovieSearchObject(
                          name: null, genreId: null, categoryId: null));
                    },
                    child: const Text(
                      'Poništi',
                      style: TextStyle(color: Colors.teal),
                    )),
              ),
              Expanded(
                child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState!.closeDrawer();
                    },
                    child: const Text(
                      'Zatvori',
                      style: TextStyle(color: Colors.teal),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
        margin: const EdgeInsets.only(top: 6, bottom: 20),
        child: categories.isNotEmpty
            ? DropdownButton<Category>(
                isExpanded: true,
                value: selectedCategory,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
                elevation: 16,
                hint: const Text(
                  'Odaberi kategoriju...',
                  style: TextStyle(color: Colors.grey),
                ),
                onChanged: (Category? value) {
                  setState(() {
                    selectedCategory = value;
                  });
                  loadMovies(MovieSearchObject(
                      name: null,
                      genreId: null,
                      categoryId: selectedCategory!.id));
                },
                items: categories
                    .map<DropdownMenuItem<Category>>(
                        (c) => DropdownMenuItem<Category>(
                              value: c,
                              child: Text(
                                c.name,
                              ),
                            ))
                    .toList(),
              )
            : Container());
  }

  Widget _buildGenreDropdown() {
    return Container(
        margin: const EdgeInsets.only(top: 6, bottom: 20),
        child: genres.isNotEmpty
            ? DropdownButton<Genre>(
                isExpanded: true,
                value: selectedGenre,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
                elevation: 16,
                hint: const Text(
                  'Odaberi žanr...',
                  style: TextStyle(color: Colors.grey),
                ),
                onChanged: (Genre? value) {
                  setState(() {
                    selectedGenre = value;
                  });
                  loadMovies(MovieSearchObject(
                      name: null,
                      genreId: selectedGenre!.id,
                      categoryId: null));
                },
                items: genres
                    .map<DropdownMenuItem<Genre>>(
                        (c) => DropdownMenuItem<Genre>(
                              value: c,
                              child: Text(
                                c.name,
                              ),
                            ))
                    .toList(),
                selectedItemBuilder: (_) {
                  return genres
                      .map((c) => Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              c.name,
                              style: const TextStyle(color: Colors.teal),
                            ),
                          ))
                      .toList();
                },
              )
            : Container());
  }

  Widget _buildMovieListView(List<Movie> movies) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
        ),
        padding: const EdgeInsets.all(4.0),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return _buildMovie(context, movies[index]);
        },
      ),
    );
  }

  Widget _buildMovieList() {
    if (loading) {
      return Column(
        children: const [
          SizedBox(
            height: 130,
          ),
          Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          ),
        ],
      );
    } else if (movies.isEmpty) {
      return const Center(child: Text('Nema filmova.'));
    }
    return _buildMovieListView(movies);
  }

  Widget _buildMovie(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        MovieDetailScreen.routeName,
        arguments: movie,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: 80,
          height: 90,
          child: movie.photo.guidId != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(
                      '$apiUrl/Photo/GetById?id=${movie.photo.guidId}&original=true',
                      headers: Authorization.createHeaders(),
                    ),
                    fadeInDuration: const Duration(milliseconds: 300),
                    fit: BoxFit.fill,
                  ),
                )
              : const Placeholder(),
        ),
      ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate {
  MovieSearchDelegate() : super(searchFieldLabel: 'Pretraži naslove...');

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          labelStyle: TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) {
    return getMovieResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return getMovieResults(context);
  }

  Widget getMovieResults(BuildContext context) {
    var movieProvider = Provider.of<MovieProvider>(context);
    var search =
        MovieSearchObject(name: query, categoryId: null, genreId: null);
    Future<List<Movie>> moviesFuture =
        movieProvider.getPaged(searchObject: search);

    return FutureBuilder(
      future: moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildMovieListView(snapshot.data!);
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
    );
  }

  Widget _buildMovieListView(List<Movie> movies) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
      ),
      padding: const EdgeInsets.all(4.0),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return _buildMovie(context, movies[index]);
      },
    );
  }

  Widget _buildMovie(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        MovieDetailScreen.routeName,
        arguments: movie,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: 80,
          height: 90,
          child: movie.photo.guidId != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(
                      '$apiUrl/Photo/GetById?id=${movie.photo.guidId}&original=true',
                      headers: Authorization.createHeaders(),
                    ),
                    fadeInDuration: const Duration(milliseconds: 300),
                    fit: BoxFit.fill,
                  ),
                )
              : const Placeholder(),
        ),
      ),
    );
  }
}
