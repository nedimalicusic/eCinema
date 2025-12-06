using AutoMapper;
using FluentValidation;
using Microsoft.ML;
using Microsoft.ML.Trainers;

using eCinema.Core;
using eCinema.Application.Interfaces;
using eCinema.Common.Service;
using eCinema.Core.Entities;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class MoviesService : BaseService<Movie, MovieDto, MovieUpsertDto, MovieSearchObject, IMoviesRepository>, IMoviesService
    {
        private readonly ICryptoService _cryptoService;

        public MoviesService(ICryptoService cryptoService, IMapper mapper, IUnitOfWork unitOfWork, IValidator<MovieUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
            _cryptoService = cryptoService;
        }

        public override async Task<MovieDto> AddAsync(MovieUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<Movie>(dto);

            await CurrentRepository.AddAsync(entity, cancellationToken);

            await UnitOfWork.SaveChangesAsync(cancellationToken);

            InsertRelatedEntities(dto, entity.Id);

            await UnitOfWork.SaveChangesAsync(cancellationToken);

            return Mapper.Map<MovieDto>(entity);
        }

        private void InsertRelatedEntities(MovieUpsertDto dto, int id)
        {
            InsertRelatedCategories(dto, id);
            InsertRelatedGenres(dto, id);
            InsertRelatedActors(dto, id);
        }

        private async void InsertRelatedActors(MovieUpsertDto dto, int id)
        {
            foreach (var item in dto.ActorIds)
            {
                var movieActors = new MovieActors
                {
                    MovieId = id,
                    ActorId = item
                };
                await UnitOfWork.MovieActorsRepository.AddAsync(movieActors);
            }
        }

        private async void InsertRelatedGenres(MovieUpsertDto dto, int id)
        {
            foreach (var item in dto.GenreIds)
            {
                var movieGenre = new MovieGenre
                {
                    MovieId = id,
                    GenreId = item
                };
                await UnitOfWork.MovieGenresRepository.AddAsync(movieGenre);
            }
        }

        private async void InsertRelatedCategories(MovieUpsertDto dto, int id)
        {
            foreach (var item in dto.CategoryIds)
            {
                var movieCategory = new MovieCategory
                {
                    MovieId = id,
                    CategoryId = item
                };
                await UnitOfWork.MovieCategoryRepository.AddAsync(movieCategory);
            }
        }

        public override async Task<MovieDto> UpdateAsync(MovieUpsertDto dto, CancellationToken cancellationToken = default)
        {
            var movie = await CurrentRepository.GetByIdAsync(dto.Id.Value, cancellationToken);
            if (movie == null)
                throw new UserNotFoundException();

            await ValidateAsync(dto, cancellationToken);

            Mapper.Map(dto, movie);

            var entity = Mapper.Map<Movie>(dto);
            CurrentRepository.Update(entity);


            if (!movie.MovieCategories.Select(x => x.CategoryId).SequenceEqual(dto.CategoryIds))
            {
                foreach (var item in movie.MovieCategories)
                {
                    UnitOfWork.MovieCategoryRepository.DetachEntity(item);
                    UnitOfWork.MovieCategoryRepository.Remove(item);
                }

                InsertRelatedCategories(dto, movie.Id);
            }
            if (!movie.MovieActors.Select(x => x.ActorId).SequenceEqual(dto.ActorIds))
            {
                foreach (var item in movie.MovieActors)
                {
                    UnitOfWork.MovieActorsRepository.DetachEntity(item);
                    UnitOfWork.MovieActorsRepository.Remove(item);
                }

                InsertRelatedActors(dto, movie.Id);
            }
            if (!movie.MovieGenres.Select(mc => mc.GenreId).SequenceEqual(dto.GenreIds))
            {
                foreach (var item in movie.MovieGenres)
                {
                    UnitOfWork.MovieGenresRepository.DetachEntity(item);
                    UnitOfWork.MovieGenresRepository.Remove(item);
                }

                InsertRelatedGenres(dto, movie.Id);
            }

            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<MovieDto>(movie);
        }

        public async Task<List<MovieDto>> Recommendation(int userId, CancellationToken cancellationToken = default)
        {
            var user = await UnitOfWork.UsersRepository.GetUserReaction(userId, cancellationToken);

            if (user == null)
                throw new Exception("User does not exist!");

            if (!user.MovieReactions.Any())
            {
                var mostWatched = await UnitOfWork.MoviesRepository.GetMostWatched(cancellationToken);
                return Mapper.Map<List<MovieDto>>(mostWatched);
            }

            // ML.NET context
            var mlContext = new MLContext();

            var model = LoadModel(mlContext);

            var shows = await UnitOfWork.ShowsRepository.GetActiveShows(cancellationToken);
            var movieIds = shows.Select(mc => mc.MovieId).Distinct().ToList();

            var recommendedMovieIds = GetMoviePredictions(mlContext, model, userId, movieIds);

            var movies = await UnitOfWork.MoviesRepository.GetByIds(recommendedMovieIds, cancellationToken);

            return Mapper.Map<List<MovieDto>>(movies);
        }

        ITransformer BuildAndTrainModel(MLContext mlContext, IDataView trainingData)
        {
            var options = new MatrixFactorizationTrainer.Options
            {
                MatrixColumnIndexColumnName = "UserIdEncoded",
                MatrixRowIndexColumnName = "MovieIdEncoded",
                LabelColumnName = "Rating",
                NumberOfIterations = 20,
                ApproximationRank = 100
            };

            // step 1: map userId and movieId to keys
            var pipeline = mlContext.Transforms.Conversion.MapValueToKey(
                    inputColumnName: "UserId",
                    outputColumnName: "UserIdEncoded")
                .Append(mlContext.Transforms.Conversion.MapValueToKey(
                    inputColumnName: "MovieId",
                    outputColumnName: "MovieIdEncoded")

                // step 2: find recommendations using matrix factorization
                .Append(mlContext.Recommendation().Trainers.MatrixFactorization(options)));

            // train the model
            Console.WriteLine("Training the model...");
            var model = pipeline.Fit(trainingData);

            return model;
        }


        void EvaluateModel(MLContext mlContext, IDataView testDataView, ITransformer model)
        {
            var prediction = model.Transform(testDataView);
            var metrics = mlContext.Regression.Evaluate(prediction, labelColumnName: "Rating", scoreColumnName: "Score");

            Console.WriteLine("Root Mean Squared Error : " + metrics.RootMeanSquaredError.ToString());
            Console.WriteLine("RSquared: " + metrics.RSquared.ToString());
        }
        List<int> GetMoviePredictions(MLContext mlContext, ITransformer model, int userId, List<int> movieIds)
        {
            var predictionEngine = mlContext.Model.CreatePredictionEngine<MovieRating, MovieRatingPrediction>(model);
            var predictionList = new List<MovieRatingPrediction>();

            foreach (var movieId in movieIds)
            {
                var testInput = new MovieRating { UserId = userId, MovieId = movieId };

                var prediction = predictionEngine.Predict(testInput);
                prediction.MovieId = movieId;

                Console.WriteLine($"User id {userId} movie prediction : Movie id {movieId}\nScore: {prediction.Score}");

                predictionList.Add(prediction);
            }

            return predictionList
                .OrderByDescending(p => p.Score)
                .Take(3)
                .Select(p => p.MovieId)
                .ToList();
        }

        List<MovieRating> GetTestData()
        {
            return new List<MovieRating>
            {
              new MovieRating { UserId = 1, MovieId = 1, Rating = 5 },
              new MovieRating { UserId = 2, MovieId = 1, Rating = 5 },
              new MovieRating { UserId = 3, MovieId = 2, Rating = 5 },
              new MovieRating { UserId = 4, MovieId = 3, Rating = 5 }
            };
        }

        ITransformer LoadModel(MLContext mlContext)
        {
            DataViewSchema modelSchema;

            var modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "MovieRecommenderModel.zip");
            // Load trained model
            ITransformer trainedModel = mlContext.Model.Load(modelPath, out modelSchema);

            return trainedModel;
        }

        public async Task CreateModel(CancellationToken cancellationToken)
        {
            var mlContext = new MLContext();

            var movieReactions = await UnitOfWork.MovieReactionsRepository.GetMovieReactions(cancellationToken);

            var ratings = movieReactions.Select(x => new MovieRating
            {
                UserId = x.UserId,
                MovieId = x.MovieId,
                Rating = x.Rating
            });

            var trainingData = mlContext.Data.LoadFromEnumerable(ratings);
            var testData = mlContext.Data.LoadFromEnumerable(GetTestData());

            var model = BuildAndTrainModel(mlContext, trainingData);

            EvaluateModel(mlContext, testData, model);

            SaveModel(mlContext, trainingData.Schema, model);
        }

        void SaveModel(MLContext mlContext, DataViewSchema trainingDataViewSchema, ITransformer model)
        {
            var modelPath = Path.Combine(Environment.CurrentDirectory, "Data", "MovieRecommenderModel.zip");

            Console.WriteLine("=============== Saving the model to a file ===============");
            mlContext.Model.Save(model, trainingDataViewSchema, modelPath);
        }

        public class MovieRating
        {
            public int UserId;
            public int MovieId;
            public float Rating;
        }

        public class MovieRatingPrediction
        {
            public float Score;
            public int MovieId;
        }
    }
}
