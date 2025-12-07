using eCinema.Application.Interfaces;
using eCinema.Application.Interfaces.Services;
using eCinema.Application.Services;
using eCinema.Application.Validators;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using FluentValidation;
using Microsoft.Extensions.DependencyInjection;

namespace eCinema.Application
{
    public static class Registry
    {

        public static void AddApplication(this IServiceCollection services)
        {
            services.AddScoped<IActorsService, ActorsService>();
            services.AddScoped<ICinemasService, CinemasService>();
            services.AddScoped<ICitiesService, CitiesService>();
            services.AddScoped<ICountriesService, CountriesService>();
            services.AddScoped<IEmployeesService, EmployeesService>();
            services.AddScoped<IGenresService, GenresService>();
            services.AddScoped<ILanguagesService, LanguagesService>();
            services.AddScoped<IMovieActorsService, MovieActorsService>();
            services.AddScoped<IMovieGenresService, MovieGenresService>();
            services.AddScoped<IMoviesService, MoviesService>();
            services.AddScoped<INotificationsService, NotificationsService>();
            services.AddScoped<IPhotosService, PhotosService>();
            services.AddScoped<IProductionsService, ProductionsService>();
            services.AddScoped<IReservationsService, ReservationsService>();
            services.AddScoped<ISeatsService, SeatsService>();
            services.AddScoped<IShowsService, ShowsService>();
            services.AddScoped<IUsersService, UseresService>();
            services.AddScoped<IWeekDayService, WeekDayService>();
            services.AddScoped<IShowTypeService, ShowTypeService>();
            services.AddScoped<IReccuringShowService, ReccuringShowService>();
            services.AddScoped<ICategoryService, CategoryService>();
            services.AddScoped<IMovieCategoryService, MovieCategoryService>();
            services.AddScoped<IMovieReactionsService, MovieReactionsService>();
            services.AddScoped<IRabbitMQProducer, RabbitMQProducer>();
        }

        public static void AddValidators(this IServiceCollection services)
        {
            services.AddScoped<IValidator<ActorsUpsertDto>, ActorsValidator>();
            services.AddScoped<IValidator<CinemaUpsertDto>, CinemaValidator>();
            services.AddScoped<IValidator<CityUpsertDto>, CityValidator>();
            services.AddScoped<IValidator<CountryUpsertDto>, CountryValidator>();
            services.AddScoped<IValidator<EmployeeUpsertDto>, EmployeeValidator>();
            services.AddScoped<IValidator<GenreUpsertDto>, GenreValidator>();
            services.AddScoped<IValidator<LanguageUpsertDto>, LanguageValidator>();
            services.AddScoped<IValidator<MovieActorsUpsertDto>, MovieActorsValidator>();
            services.AddScoped<IValidator<MovieGenreUpsertDto>, MovieGenreValidator>();
            services.AddScoped<IValidator<MovieUpsertDto>, MovieValidator>();
            services.AddScoped<IValidator<NotificationUpsertDto>, NotificationValidator>();
            services.AddScoped<IValidator<PhotoUpsertDto>, PhotoValidator>();
            services.AddScoped<IValidator<ProductionUpsertDto>, ProductionValidator>();
            services.AddScoped<IValidator<ReservationUpsertDto>, ReservationValidator>();
            services.AddScoped<IValidator<SeatUpsertDto>, SeatValidator>();
            services.AddScoped<IValidator<ShowUpsertDto>, ShowValidator>();
            services.AddScoped<IValidator<UserUpsertDto>, UserValidator>();
            services.AddScoped<IValidator<WeekDayUpsertDto>, WeekDayValidator>();
            services.AddScoped<IValidator<ShowTypeUpsertDto>, ShowTypeValidator>();
            services.AddScoped<IValidator<ReccuringShowUpsertDto>, ReccuringShowValidator>();
            services.AddScoped<IValidator<CategoryUpsertDto>, CategoryValidator>();
            services.AddScoped<IValidator<MovieCategoryUpsertDto>, MovieCategoryValidator>();
            services.AddScoped<IValidator<MovieReactionUpsertDto>, MovieReactionValidator>();
        }
    }
}
