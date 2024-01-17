using eCinema.Core;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public partial class DatabaseContext
    {
        private readonly DateTime _dateTime = new(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local);

        private void SeedData(ModelBuilder modelBuilder)
        {
            SeedCountries(modelBuilder);
            SeedCities(modelBuilder);
            SeedLanguages(modelBuilder);
            SeedUsers(modelBuilder);
            SeedProduction(modelBuilder);
            SeedCinema(modelBuilder);
            SeedGenre(modelBuilder);
        }


        private void SeedCountries(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Country>().HasData(
              new()
              {
                  Id = 1,
                  Name = "Bosnia and Herzegovina",
                  Abbreviation = "BIH",
                  IsActive = true,
                  CreatedAt = _dateTime,
                  ModifiedAt = null
              },
              new()
              {
                  Id = 2,
                  Name = "Croatia",
                  Abbreviation = "HR",
                  IsActive = true,
                  CreatedAt = _dateTime,
                  ModifiedAt = null
              },
              new()
              {
                  Id = 3,
                  Name = "Serbia",
                  Abbreviation = "SRB",
                  IsActive = true,
                  CreatedAt = _dateTime,
                  ModifiedAt = null
              },
              new()
              {
                  Id = 4,
                  Name = "Montenegro",
                  Abbreviation = "CG",
                  IsActive = true,
                  CreatedAt = _dateTime,
                  ModifiedAt = null
              },
              new()
              {
                  Id = 5,
                  Name = "Slovenia",
                  Abbreviation = "SLO",
                  IsActive = true,
                  CreatedAt = _dateTime,
                  ModifiedAt = null
              },
              new()
              {
                  Id = 6,
                  Name = "United States",
                  Abbreviation = "USA",
                  IsActive = true,
                  CreatedAt = _dateTime,
                  ModifiedAt = null
              },
              new()
              {
                  Id = 7,
                  Name = "German",
                  Abbreviation = "GER",
                  IsActive = true,
                  CreatedAt = _dateTime,
                  ModifiedAt = null
              },
              new()
              {
                  Id = 8,
                  Name = "Austria",
                  Abbreviation = "AT",
                  IsActive = true,
                  CreatedAt = _dateTime,
                  ModifiedAt = null
              });
        }
        private void SeedCities(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<City>().HasData(
                new()
                {
                    Id = 1,
                    Name = "Mostar",
                    ZipCode = "88000",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 2,
                    Name = "Sarajevo",
                    ZipCode = "77000",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                 new()
                 {
                     Id = 3,
                     Name = "Tuzla",
                     ZipCode = "75000",
                     CountryId = 1,
                     IsActive = true,
                     CreatedAt = _dateTime,
                     ModifiedAt = null
                 },
                new()
                {
                    Id = 4,
                    Name = "Zenica",
                    ZipCode = "72000",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                });
        }
        private void SeedLanguages(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Language>().HasData(
                new()
                {
                    Id = 1,
                    Name = "English",
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 2,
                    Name = "German",
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 3,
                    Name = "Bosnian",
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                });
        }
        private void SeedUsers(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>().HasData(
                new User
                {
                    Id = 1,
                    FirstName = "Nedim",
                    LastName = "Admin",
                    Email = "admin@eCinema.com",
                    Role = Role.Administrator,
                    Gender = Gender.Male,
                    PasswordHash = "b4I5yA4Mp+0Pg1C3EsKU17sS13eDExGtBjjI07Vh/JM=", //Plain text: test
                    PasswordSalt = "1wQEjdSFeZttx6dlvEDjOg==",
                    PhoneNumber = "38761123456",
                    IsVerified = true,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                });
        }
        private void SeedProduction(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Production>().HasData(
               new()
               {
                   Id = 1,
                   Name = "Warner Bros",
                   CountryId = 6,
                   CreatedAt = _dateTime,
                   ModifiedAt = null
               },
               new()
               {
                   Id = 2,
                   Name = "Universal Pictures",
                   CountryId = 6,
                   CreatedAt = _dateTime,
                   ModifiedAt = null
               },
                new()
                {
                    Id = 3,
                    Name = "Režim",
                    CountryId = 3,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
               new()
               {
                   Id = 4,
                   Name = "Volcano Films",
                   CountryId = 6,
                   CreatedAt = _dateTime,
                   ModifiedAt = null
               });
        }
        private void SeedCinema(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Cinema>().HasData(
             new()
             {
                 Id = 1,
                 Name = "Cineplexx Plaza Mostar",
                 Address = "Bisce Polje bb",
                 Description = "Opis1",
                 Email = "plazamostar@gmail.com",
                 PhoneNumber = 060100100,
                 NumberOfSeats = 30,
                 CityId = 1,
                 CreatedAt = _dateTime,
                 ModifiedAt = null
             },
             new()
             {
                 Id = 2,
                 Name = "CineStar Sarajevo",
                 Address = "Dzemala Bijedica St",
                 Description = "Opis1",
                 Email = "srajevocinestar@gmail.com",
                 PhoneNumber = 060200200,
                 NumberOfSeats = 40,
                 CityId = 2,
                 CreatedAt = _dateTime,
                 ModifiedAt = null
             });
        }
        private void SeedGenre(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Genre>().HasData(
              new()
              {
                  Id = 1,
                  Name = "Action",
                  CreatedAt = _dateTime,
                  ModifiedAt = null
              },
              new()
              {
                  Id = 2,
                  Name = "Comedy",
                  CreatedAt = _dateTime,
                  ModifiedAt = null
              },
               new()
               {
                   Id = 3,
                   Name = "Horror",
                   CreatedAt = _dateTime,
                   ModifiedAt = null
               },
               new()
               {
                   Id = 4,
                   Name = "Romance",
                   CreatedAt = _dateTime,
                   ModifiedAt = null
               },
               new()
               {
                   Id = 5,
                   Name = "Western",
                   CreatedAt = _dateTime,
                   ModifiedAt = null
               },
               new()
               {
                   Id = 6,
                   Name = "Thriller",
                   CreatedAt = _dateTime,
                   ModifiedAt = null
               });
        }
    }
}
