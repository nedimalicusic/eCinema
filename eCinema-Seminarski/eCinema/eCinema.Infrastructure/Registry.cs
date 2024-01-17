using eCinema.Infrastructure.Interfaces;
using Microsoft.Extensions.DependencyInjection;

namespace eCinema.Infrastructure
{
    public static class Registry
    {
        public static void AddInfrastructure(this IServiceCollection services)
        {
            services.AddScoped<IActorsRepository, ActorsRepository>();
            services.AddScoped<ICinemasRepository, CinemaRepository>();
            services.AddScoped<ICitiesRepository, CitiesRepository>();
            services.AddScoped<ICountiresRepository, CountriesRepository>();
            services.AddScoped<IEmployeesRepository, EmployeesRepository>();
            services.AddScoped<IGenresRepository, GenresRepository>();
            services.AddScoped<ILanguagesRepository, LanguagesRepository>();
            services.AddScoped<IMovieActorsRepository, MovieActorsRepository>();
            services.AddScoped<IMovieGenresRepository, MovieGenresRepository>();
            services.AddScoped<IMoviesRepository, MoviesRepository>();
            services.AddScoped<INotificationsRepository, NotificationsRepository>();
            services.AddScoped<IPhotosRepository, PhotosRepository>();
            services.AddScoped<IProductionsRepository, ProductionsRepository>();
            services.AddScoped<IReservationsRepository, ReservationsRepository>();
            services.AddScoped<ISeatsRepository, SeatsRepository>();
            services.AddScoped<IShowsRepository, ShowsRepository>();
            services.AddScoped<IUsersRepository, UsersRepository>();

            services.AddScoped<IUnitOfWork, UnitOfWork>();
        }
    }
}
