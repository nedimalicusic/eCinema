using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eCinema.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Actors",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    BirthDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Gender = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Actors", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Category",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDisplayed = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Category", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Countries",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Abbreviation = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Countries", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Genres",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Genres", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Languages",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Languages", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Photos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    GuidId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Data = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    ContentType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ThumbnailContent = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Photos", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Seats",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Row = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Column = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Seats", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ShowType",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ShowType", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "WeekDay",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WeekDay", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Cities",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ZipCode = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    CountryId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cities", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Cities_Countries_CountryId",
                        column: x => x.CountryId,
                        principalTable: "Countries",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Productions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CountryId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Productions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Productions_Countries_CountryId",
                        column: x => x.CountryId,
                        principalTable: "Countries",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    BirthDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Gender = table.Column<int>(type: "int", nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Role = table.Column<int>(type: "int", nullable: false),
                    LastSignInAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsVerified = table.Column<bool>(type: "bit", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    ProfilePhotoId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Users_Photos_ProfilePhotoId",
                        column: x => x.ProfilePhotoId,
                        principalTable: "Photos",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "ReccuringShows",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StartingDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndingDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ShowTime = table.Column<TimeSpan>(type: "time", nullable: false),
                    WeekDayId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReccuringShows", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ReccuringShows_WeekDay_WeekDayId",
                        column: x => x.WeekDayId,
                        principalTable: "WeekDay",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Cinemas",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Address = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PhoneNumber = table.Column<int>(type: "int", nullable: false),
                    NumberOfSeats = table.Column<int>(type: "int", nullable: false),
                    CityId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cinemas", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Cinemas_Cities_CityId",
                        column: x => x.CityId,
                        principalTable: "Cities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Movies",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Author = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ReleaseYear = table.Column<int>(type: "int", nullable: false),
                    Duration = table.Column<int>(type: "int", nullable: false),
                    NumberOfViews = table.Column<int>(type: "int", nullable: true),
                    LanguageId = table.Column<int>(type: "int", nullable: false),
                    ProductionId = table.Column<int>(type: "int", nullable: false),
                    PhotoId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Movies", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Movies_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Movies_Photos_PhotoId",
                        column: x => x.PhotoId,
                        principalTable: "Photos",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Movies_Productions_ProductionId",
                        column: x => x.ProductionId,
                        principalTable: "Productions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    SendOnDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DateRead = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Seen = table.Column<bool>(type: "bit", nullable: true),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Notifications_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Employees",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    BirthDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Gender = table.Column<int>(type: "int", nullable: false),
                    isActive = table.Column<bool>(type: "bit", nullable: false),
                    ProfilePhotoId = table.Column<int>(type: "int", nullable: true),
                    CinemaId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Employees", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Employees_Cinemas_CinemaId",
                        column: x => x.CinemaId,
                        principalTable: "Cinemas",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Employees_Photos_ProfilePhotoId",
                        column: x => x.ProfilePhotoId,
                        principalTable: "Photos",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "MovieActors",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MovieId = table.Column<int>(type: "int", nullable: false),
                    ActorId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MovieActors", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MovieActors_Actors_ActorId",
                        column: x => x.ActorId,
                        principalTable: "Actors",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_MovieActors_Movies_MovieId",
                        column: x => x.MovieId,
                        principalTable: "Movies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "MovieCategory",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MovieId = table.Column<int>(type: "int", nullable: false),
                    CategoryId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MovieCategory", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MovieCategory_Category_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Category",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_MovieCategory_Movies_MovieId",
                        column: x => x.MovieId,
                        principalTable: "Movies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "MovieGenres",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MovieId = table.Column<int>(type: "int", nullable: false),
                    GenreId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MovieGenres", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MovieGenres_Genres_GenreId",
                        column: x => x.GenreId,
                        principalTable: "Genres",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_MovieGenres_Movies_MovieId",
                        column: x => x.MovieId,
                        principalTable: "Movies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "MovieReactions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    MovieId = table.Column<int>(type: "int", nullable: false),
                    Rating = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MovieReactions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MovieReactions_Movies_MovieId",
                        column: x => x.MovieId,
                        principalTable: "Movies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_MovieReactions_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Shows",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StartsAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndsAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Price = table.Column<double>(type: "float", nullable: false),
                    ShowTypeId = table.Column<int>(type: "int", nullable: false),
                    RecurringShowId = table.Column<int>(type: "int", nullable: true),
                    CinemaId = table.Column<int>(type: "int", nullable: false),
                    MovieId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Shows", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Shows_Cinemas_CinemaId",
                        column: x => x.CinemaId,
                        principalTable: "Cinemas",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Shows_Movies_MovieId",
                        column: x => x.MovieId,
                        principalTable: "Movies",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Shows_ReccuringShows_RecurringShowId",
                        column: x => x.RecurringShowId,
                        principalTable: "ReccuringShows",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Shows_ShowType_ShowTypeId",
                        column: x => x.ShowTypeId,
                        principalTable: "ShowType",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Reservations",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    isActive = table.Column<bool>(type: "bit", nullable: false),
                    isConfirm = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    ShowId = table.Column<int>(type: "int", nullable: false),
                    SeatId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reservations", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Reservations_Seats_SeatId",
                        column: x => x.SeatId,
                        principalTable: "Seats",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Reservations_Shows_ShowId",
                        column: x => x.ShowId,
                        principalTable: "Shows",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Reservations_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Actors",
                columns: new[] { "Id", "BirthDate", "CreatedAt", "Email", "FirstName", "Gender", "LastName", "ModifiedAt" },
                values: new object[,]
                {
                    { 1, new DateTime(1965, 4, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5368), "robert.downeyjr@example.com", "Robert", 0, "Downey Jr.", null },
                    { 2, new DateTime(1984, 11, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5368), "scarlett.johansson@example.com", "Scarlett", 1, "Johansson", null },
                    { 3, new DateTime(1981, 6, 13, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5368), "chris.evans@example.com", "Chris", 0, "Evans", null },
                    { 4, new DateTime(1981, 6, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5368), "natalie.portman@example.com", "Natalie", 1, "Portman", null },
                    { 5, new DateTime(1996, 6, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5368), "tom.holland@example.com", "Tom", 0, "Holland", null },
                    { 6, new DateTime(1990, 4, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5368), "emma.watson@example.com", "Emma", 1, "Watson", null },
                    { 7, new DateTime(1974, 11, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5368), "leonardo.dicaprio@example.com", "Leonardo", 0, "DiCaprio", null },
                    { 8, new DateTime(1990, 8, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5368), "jennifer.lawrence@example.com", "Jennifer", 1, "Lawrence", null },
                    { 9, new DateTime(1937, 6, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5368), "morgan.freeman@example.com", "Morgan", 0, "Freeman", null },
                    { 10, new DateTime(1975, 6, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5368), "angelina.jolie@example.com", "Angelina", 1, "Jolie", null }
                });

            migrationBuilder.InsertData(
                table: "Category",
                columns: new[] { "Id", "CreatedAt", "IsDisplayed", "ModifiedAt", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Uskoro" },
                    { 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Pretpremijera" },
                    { 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Premijera" },
                    { 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Klasik" },
                    { 5, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Animirani" },
                    { 6, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Dječiji" },
                    { 7, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Domaći" }
                });

            migrationBuilder.InsertData(
                table: "Countries",
                columns: new[] { "Id", "Abbreviation", "CreatedAt", "IsActive", "ModifiedAt", "Name" },
                values: new object[,]
                {
                    { 1, "BIH", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Bosnia and Herzegovina" },
                    { 2, "HR", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Croatia" },
                    { 3, "SRB", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Serbia" },
                    { 4, "CG", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Montenegro" },
                    { 5, "SLO", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Slovenia" },
                    { 6, "USA", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "United States" },
                    { 7, "GER", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "German" },
                    { 8, "AT", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Austria" }
                });

            migrationBuilder.InsertData(
                table: "Genres",
                columns: new[] { "Id", "CreatedAt", "ModifiedAt", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Action" },
                    { 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Comedy" },
                    { 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Horror" },
                    { 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Romance" },
                    { 5, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Western" },
                    { 6, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Thriller" }
                });

            migrationBuilder.InsertData(
                table: "Languages",
                columns: new[] { "Id", "CreatedAt", "ModifiedAt", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "English" },
                    { 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "German" },
                    { 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Bosnian" }
                });

            migrationBuilder.InsertData(
                table: "Seats",
                columns: new[] { "Id", "Column", "CreatedAt", "ModifiedAt", "Row" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "A" },
                    { 2, 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "A" },
                    { 3, 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "A" },
                    { 4, 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "A" },
                    { 5, 5, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "A" },
                    { 6, 6, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "A" },
                    { 7, 7, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "A" },
                    { 8, 8, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "A" },
                    { 9, 9, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "A" },
                    { 10, 10, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "A" },
                    { 11, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "B" },
                    { 12, 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "B" },
                    { 13, 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "B" },
                    { 14, 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "B" },
                    { 15, 5, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "B" },
                    { 16, 6, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "B" },
                    { 17, 7, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "B" },
                    { 18, 8, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "B" },
                    { 19, 9, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "B" },
                    { 20, 10, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "B" },
                    { 21, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "C" },
                    { 22, 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "C" },
                    { 23, 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "C" },
                    { 24, 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "C" },
                    { 25, 5, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "C" },
                    { 26, 6, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "C" },
                    { 27, 7, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "C" },
                    { 28, 8, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "C" },
                    { 29, 9, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "C" },
                    { 30, 10, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "C" },
                    { 31, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "D" },
                    { 32, 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "D" },
                    { 33, 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "D" },
                    { 34, 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "D" },
                    { 35, 5, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "D" },
                    { 36, 6, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "D" },
                    { 37, 7, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "D" },
                    { 38, 8, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "D" },
                    { 39, 9, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "D" },
                    { 40, 10, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "D" },
                    { 41, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "E" },
                    { 42, 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "E" },
                    { 43, 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "E" },
                    { 44, 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "E" },
                    { 45, 5, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "E" },
                    { 46, 6, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "E" },
                    { 47, 7, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "E" },
                    { 48, 8, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "E" },
                    { 49, 9, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "E" },
                    { 50, 10, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "E" }
                });

            migrationBuilder.InsertData(
                table: "ShowType",
                columns: new[] { "Id", "CreatedAt", "ModifiedAt", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "3D" },
                    { 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "4D" },
                    { 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Extreme 2D" },
                    { 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "IMax" },
                    { 5, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Extreme 3D" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "BirthDate", "CreatedAt", "Email", "FirstName", "Gender", "IsActive", "IsVerified", "LastName", "LastSignInAt", "ModifiedAt", "PasswordHash", "PasswordSalt", "PhoneNumber", "ProfilePhotoId", "Role" },
                values: new object[,]
                {
                    { 1, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "admin@gmail.com", "Admin", 0, true, true, "Test", null, null, "b4I5yA4Mp+0Pg1C3EsKU17sS13eDExGtBjjI07Vh/JM=", "1wQEjdSFeZttx6dlvEDjOg==", "38761123456", null, 0 },
                    { 2, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "user@gmail.com", "User", 0, true, true, "Test", null, null, "b4I5yA4Mp+0Pg1C3EsKU17sS13eDExGtBjjI07Vh/JM=", "1wQEjdSFeZttx6dlvEDjOg==", "38761123456", null, 1 }
                });

            migrationBuilder.InsertData(
                table: "WeekDay",
                columns: new[] { "Id", "CreatedAt", "ModifiedAt", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Ponedjeljak" },
                    { 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Utorak" },
                    { 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Srijeda" },
                    { 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Četvrtak" },
                    { 5, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Petak" },
                    { 6, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Subota" },
                    { 7, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Nedjelja" }
                });

            migrationBuilder.InsertData(
                table: "Cities",
                columns: new[] { "Id", "CountryId", "CreatedAt", "IsActive", "ModifiedAt", "Name", "ZipCode" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Mostar", "88000" },
                    { 2, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Sarajevo", "77000" },
                    { 3, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Tuzla", "75000" },
                    { 4, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, null, "Zenica", "72000" }
                });

            migrationBuilder.InsertData(
                table: "Notifications",
                columns: new[] { "Id", "CreatedAt", "DateRead", "Description", "ModifiedAt", "Seen", "SendOnDate", "Title", "UserId" },
                values: new object[] { 1, new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5647), new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5647), "Vaša rezervacija je uspješno kreirana.", null, true, new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5647), "Rezervacija", 2 });

            migrationBuilder.InsertData(
                table: "Productions",
                columns: new[] { "Id", "CountryId", "CreatedAt", "ModifiedAt", "Name" },
                values: new object[,]
                {
                    { 1, 6, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Warner Bros" },
                    { 2, 6, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Universal Pictures" },
                    { 3, 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Režim" },
                    { 4, 6, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Volcano Films" }
                });

            migrationBuilder.InsertData(
                table: "Cinemas",
                columns: new[] { "Id", "Address", "CityId", "CreatedAt", "Description", "Email", "ModifiedAt", "Name", "NumberOfSeats", "PhoneNumber" },
                values: new object[,]
                {
                    { 1, "Bisce Polje bb", 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "Opis1", "plazamostar@gmail.com", null, "Cineplexx Plaza Mostar", 30, 60100100 },
                    { 2, "Zenica bb", 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "Opis2", "plazazenica@gmail.com", null, "Cineplexx Plaza Zenica", 20, 60200200 },
                    { 3, "Dzemala Bijedica St", 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "Opis3", "srajevocinestar@gmail.com", null, "CineStar Sarajevo", 40, 60300300 }
                });

            migrationBuilder.InsertData(
                table: "Movies",
                columns: new[] { "Id", "Author", "CreatedAt", "Description", "Duration", "LanguageId", "ModifiedAt", "NumberOfViews", "PhotoId", "ProductionId", "ReleaseYear", "Title" },
                values: new object[,]
                {
                    { 1, "Director Name", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "A teaser for an upcoming movie.", 120, 1, null, null, null, 1, 2024, "Coming Soon" },
                    { 2, "Name", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "A teaser for an upcoming movie.", 120, 1, null, null, null, 1, 2024, "Venom 3" },
                    { 3, "Name", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "A teaser for an upcoming movie.", 130, 1, null, null, null, 2, 2025, "Creed" }
                });

            migrationBuilder.InsertData(
                table: "Employees",
                columns: new[] { "Id", "BirthDate", "CinemaId", "CreatedAt", "Email", "FirstName", "Gender", "LastName", "ModifiedAt", "ProfilePhotoId", "isActive" },
                values: new object[] { 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "employee@gmail.com", "Zaposlenik", 0, "Test", null, null, true });

            migrationBuilder.InsertData(
                table: "MovieActors",
                columns: new[] { "Id", "ActorId", "CreatedAt", "ModifiedAt", "MovieId" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 1 },
                    { 2, 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 1 },
                    { 3, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 2 },
                    { 4, 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 2 },
                    { 5, 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 3 }
                });

            migrationBuilder.InsertData(
                table: "MovieCategory",
                columns: new[] { "Id", "CategoryId", "CreatedAt", "ModifiedAt", "MovieId" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 1 },
                    { 2, 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 1 },
                    { 3, 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 2 },
                    { 4, 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 2 },
                    { 5, 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 3 }
                });

            migrationBuilder.InsertData(
                table: "MovieGenres",
                columns: new[] { "Id", "CreatedAt", "GenreId", "ModifiedAt", "MovieId" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 1, null, 1 },
                    { 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 2, null, 1 },
                    { 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 1, null, 2 },
                    { 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 3, null, 2 },
                    { 5, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 1, null, 3 }
                });

            migrationBuilder.InsertData(
                table: "Shows",
                columns: new[] { "Id", "CinemaId", "CreatedAt", "EndsAt", "ModifiedAt", "MovieId", "Price", "RecurringShowId", "ShowTypeId", "StartsAt" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5605), new DateTime(2023, 12, 29, 10, 0, 0, 0, DateTimeKind.Unspecified), null, 1, 10.0, null, 1, new DateTime(2023, 12, 29, 8, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 2, 1, new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5605), new DateTime(2023, 12, 30, 10, 0, 0, 0, DateTimeKind.Unspecified), null, 2, 12.0, null, 1, new DateTime(2023, 12, 30, 8, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 3, 1, new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5605), new DateTime(2023, 12, 31, 10, 0, 0, 0, DateTimeKind.Unspecified), null, 3, 15.0, null, 1, new DateTime(2023, 12, 31, 8, 0, 0, 0, DateTimeKind.Unspecified) }
                });

            migrationBuilder.InsertData(
                table: "Reservations",
                columns: new[] { "Id", "CreatedAt", "ModifiedAt", "SeatId", "ShowId", "UserId", "isActive", "isConfirm" },
                values: new object[] { 1, new DateTime(2025, 12, 7, 20, 0, 54, 231, DateTimeKind.Utc).AddTicks(5629), null, 1, 1, 2, true, true });

            migrationBuilder.CreateIndex(
                name: "IX_Cinemas_CityId",
                table: "Cinemas",
                column: "CityId");

            migrationBuilder.CreateIndex(
                name: "IX_Cities_CountryId",
                table: "Cities",
                column: "CountryId");

            migrationBuilder.CreateIndex(
                name: "IX_Employees_CinemaId",
                table: "Employees",
                column: "CinemaId");

            migrationBuilder.CreateIndex(
                name: "IX_Employees_ProfilePhotoId",
                table: "Employees",
                column: "ProfilePhotoId");

            migrationBuilder.CreateIndex(
                name: "IX_MovieActors_ActorId",
                table: "MovieActors",
                column: "ActorId");

            migrationBuilder.CreateIndex(
                name: "IX_MovieActors_MovieId",
                table: "MovieActors",
                column: "MovieId");

            migrationBuilder.CreateIndex(
                name: "IX_MovieCategory_CategoryId",
                table: "MovieCategory",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_MovieCategory_MovieId",
                table: "MovieCategory",
                column: "MovieId");

            migrationBuilder.CreateIndex(
                name: "IX_MovieGenres_GenreId",
                table: "MovieGenres",
                column: "GenreId");

            migrationBuilder.CreateIndex(
                name: "IX_MovieGenres_MovieId",
                table: "MovieGenres",
                column: "MovieId");

            migrationBuilder.CreateIndex(
                name: "IX_MovieReactions_MovieId",
                table: "MovieReactions",
                column: "MovieId");

            migrationBuilder.CreateIndex(
                name: "IX_MovieReactions_UserId",
                table: "MovieReactions",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Movies_LanguageId",
                table: "Movies",
                column: "LanguageId");

            migrationBuilder.CreateIndex(
                name: "IX_Movies_PhotoId",
                table: "Movies",
                column: "PhotoId");

            migrationBuilder.CreateIndex(
                name: "IX_Movies_ProductionId",
                table: "Movies",
                column: "ProductionId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId",
                table: "Notifications",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Productions_CountryId",
                table: "Productions",
                column: "CountryId");

            migrationBuilder.CreateIndex(
                name: "IX_ReccuringShows_WeekDayId",
                table: "ReccuringShows",
                column: "WeekDayId");

            migrationBuilder.CreateIndex(
                name: "IX_Reservations_SeatId",
                table: "Reservations",
                column: "SeatId");

            migrationBuilder.CreateIndex(
                name: "IX_Reservations_ShowId",
                table: "Reservations",
                column: "ShowId");

            migrationBuilder.CreateIndex(
                name: "IX_Reservations_UserId",
                table: "Reservations",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Shows_CinemaId",
                table: "Shows",
                column: "CinemaId");

            migrationBuilder.CreateIndex(
                name: "IX_Shows_MovieId",
                table: "Shows",
                column: "MovieId");

            migrationBuilder.CreateIndex(
                name: "IX_Shows_RecurringShowId",
                table: "Shows",
                column: "RecurringShowId");

            migrationBuilder.CreateIndex(
                name: "IX_Shows_ShowTypeId",
                table: "Shows",
                column: "ShowTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_ProfilePhotoId",
                table: "Users",
                column: "ProfilePhotoId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Employees");

            migrationBuilder.DropTable(
                name: "MovieActors");

            migrationBuilder.DropTable(
                name: "MovieCategory");

            migrationBuilder.DropTable(
                name: "MovieGenres");

            migrationBuilder.DropTable(
                name: "MovieReactions");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "Reservations");

            migrationBuilder.DropTable(
                name: "Actors");

            migrationBuilder.DropTable(
                name: "Category");

            migrationBuilder.DropTable(
                name: "Genres");

            migrationBuilder.DropTable(
                name: "Seats");

            migrationBuilder.DropTable(
                name: "Shows");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Cinemas");

            migrationBuilder.DropTable(
                name: "Movies");

            migrationBuilder.DropTable(
                name: "ReccuringShows");

            migrationBuilder.DropTable(
                name: "ShowType");

            migrationBuilder.DropTable(
                name: "Cities");

            migrationBuilder.DropTable(
                name: "Languages");

            migrationBuilder.DropTable(
                name: "Photos");

            migrationBuilder.DropTable(
                name: "Productions");

            migrationBuilder.DropTable(
                name: "WeekDay");

            migrationBuilder.DropTable(
                name: "Countries");
        }
    }
}
