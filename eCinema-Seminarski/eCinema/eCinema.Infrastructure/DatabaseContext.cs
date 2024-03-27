using eCinema.Core;
using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public partial class DatabaseContext : DbContext
    {
        public DbSet<Actors> Actors { get; set; } = null!;
        public DbSet<Cinema> Cinemas { get; set; } = null!;
        public DbSet<City> Cities { get; set; } = null!;
        public DbSet<Country> Countries { get; set; } = null!;
        public DbSet<Employee> Employees { get; set; } = null!;
        public DbSet<Genre> Genres { get; set; } = null!;
        public DbSet<Language> Languages { get; set; } = null!;
        public DbSet<MovieActors> MovieActors { get; set; } = null!;
        public DbSet<MovieGenre> MovieGenres { get; set; } = null!;
        public DbSet<Movie> Movies { get; set; } = null!;
        public DbSet<Notification> Notifications { get; set; } = null!;
        public DbSet<Photo> Photos { get; set; } = null!;
        public DbSet<Production> Productions { get; set; } = null!;
        public DbSet<Reservation> Reservations { get; set; } = null!;
        public DbSet<Seat> Seats { get; set; } = null!;
        public DbSet<Show> Shows { get; set; } = null!;
        public DbSet<User> Users { get; set; } = null!;
        public DbSet<WeekDay> WeekDay { get; set; } = null!;
        public DbSet<ShowType> ShowType { get; set; } = null!;
        public DbSet<Category> Category { get; set; } = null!;
        public DbSet<MovieCategory> MovieCategory { get; set; } = null!;
        public DbSet<ReccuringShows> ReccuringShows { get; set; } = null!;

        public DatabaseContext(DbContextOptions<DatabaseContext> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            SeedData(modelBuilder);
            ApplyConfigurations(modelBuilder);
        }
    }
}
