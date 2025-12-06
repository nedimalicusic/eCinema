using eCinema.Core.Entities;

namespace eCinema.Core
{
    public class Movie : BaseEntity
    {
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public string Author { get; set; } = null!;
        public int ReleaseYear { get; set; }
        public int Duration { get; set; }
        public int? NumberOfViews { get; set; }

        public int LanguageId { get; set; }
        public Language Language { get; set; } = null!;

        public int ProductionId { get; set; }
        public Production Production { get; set; } = null!;

        public int? PhotoId { get; set; }
        public Photo? Photo { get; set; } = null!;

        public ICollection<MovieActors> MovieActors { get; set; } = null!;
        public ICollection<MovieGenre> MovieGenres { get; set; } = null!;
        public ICollection<MovieCategory> MovieCategories { get; set; } = null!;
        public ICollection<MovieReaction> MovieReactions { get; set; } = null!;
        public ICollection<Show> Shows { get; set; } = null!;
    }
}
