using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.Repositories;
using Microsoft.EntityFrameworkCore.Storage;

namespace eCinema.Infrastructure
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly DatabaseContext _databaseContext;

        public readonly IActorsRepository ActorsRepository;
        public readonly ICinemasRepository CinemasRepository;
        public readonly ICitiesRepository CitiesRepository;
        public readonly ICountiresRepository CountiresRepository;
        public readonly IEmployeesRepository EmployeesRepository;
        public readonly IGenresRepository GenresRepository;
        public readonly ILanguagesRepository LanguagesRepository;
        public readonly IMovieActorsRepository MovieActorsRepository;
        public readonly IMovieGenresRepository MovieGenresRepository;
        public readonly IMoviesRepository MoviesRepository;
        public readonly INotificationsRepository NotificationsRepository;
        public readonly IPhotosRepository PhotosRepository;
        public readonly IProductionsRepository ProductionsRepository;
        public readonly IReservationsRepository ReservationsRepository;
        public readonly ISeatsRepository SeatsRepository;
        public readonly IShowsRepository ShowsRepository;
        public readonly IUsersRepository UsersRepository;
        public readonly IWeekDayRepository WeekDayRepository;
        public readonly IShowTypeRepository ShowTypeRepository;
        public readonly IReccuringShowRepository ReccuringShowRepository;
        public readonly ICategoryRepository CategoryRepository;
        public readonly IMovieCategoryRepository MovieCategoryRepository;

        public UnitOfWork(
            DatabaseContext databaseContext,
            IActorsRepository actorsRepository,
            ICinemasRepository cinemasRepository,
            ICitiesRepository citiesRepository,
            ICountiresRepository countiresRepository,
            IEmployeesRepository employeesRepository,
            IGenresRepository genresRepository,
            ILanguagesRepository languagesRepository,
            IMovieActorsRepository movieActorsRepository,
            IMovieGenresRepository movieGenresRepository,
            IMoviesRepository moviesRepository,
            INotificationsRepository notificationsRepository,
            IPhotosRepository photosRepository,
            IProductionsRepository productionsRepository,
            IReservationsRepository reservationsRepository,
            ISeatsRepository seatsRepository,
            IShowsRepository showsRepository,
            IUsersRepository usersRepository,
            IWeekDayRepository weekDayRepository,
            IShowTypeRepository showTypeRepository,
            IReccuringShowRepository reccuringShowRepository,
            ICategoryRepository categoryRepository,
            IMovieCategoryRepository movieCategoryRepository
            )
        {
            _databaseContext = databaseContext;
            ActorsRepository = actorsRepository;
            CinemasRepository = cinemasRepository;
            CitiesRepository = citiesRepository;
            CountiresRepository = countiresRepository;
            EmployeesRepository = employeesRepository;
            GenresRepository = genresRepository;
            LanguagesRepository = languagesRepository;
            MovieActorsRepository = movieActorsRepository;
            MovieGenresRepository = movieGenresRepository;
            MoviesRepository = moviesRepository;
            NotificationsRepository = notificationsRepository;
            PhotosRepository = photosRepository;
            ProductionsRepository = productionsRepository;
            ReservationsRepository = reservationsRepository;
            SeatsRepository = seatsRepository;
            ShowsRepository = showsRepository;
            UsersRepository = usersRepository;
            MovieCategoryRepository = movieCategoryRepository;
            WeekDayRepository = weekDayRepository;
            CategoryRepository = categoryRepository;
            ShowTypeRepository = showTypeRepository;
            ReccuringShowRepository = reccuringShowRepository;
            MovieCategoryRepository = movieCategoryRepository;
        }


        public async Task<IDbContextTransaction> BeginTransactionAsync(CancellationToken cancellationToken = default)
        {
            return await _databaseContext.Database.BeginTransactionAsync(cancellationToken);
        }

        public async Task CommitTransactionAsync(CancellationToken cancellationToken = default)
        {
            await _databaseContext.Database.CommitTransactionAsync(cancellationToken);
        }

        public async Task RollbackTransactionAsync(CancellationToken cancellationToken = default)
        {
            await _databaseContext.Database.RollbackTransactionAsync(cancellationToken);
        }

        public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            return await _databaseContext.SaveChangesAsync(cancellationToken);
        }
    }
}
