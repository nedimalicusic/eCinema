using eCinema.Core.Entities;

namespace eCinema.Core
{
    public class MovieDto : BaseDto
    {
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public string Author { get; set; } = null!;
        public int ReleaseYear { get; set; }
        public int Duration { get; set; }
        public int? NumberOfViews { get; set; }

        public int LanguageId { get; set; }
        public LanguageDto Language { get; set; } = null!;

        public int ProductionId { get; set; }
        public ProductionDto Production { get; set; } = null!;

        public int? PhotoId { get; set; }
        public PhotoDto? Photo { get; set; } = null!;

        public List<GenreDto> Genres { get; set; } = null!;
        public List<CategoryDto> Categories { get; set; } = null!;
        public List<ActorsDto> Actors { get; set; } = null!;

    }
}
