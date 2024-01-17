using Microsoft.AspNetCore.Http;

namespace eCinema.Core
{
    public class MovieUpsertDto : BaseUpsertDto
    {
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public string Author { get; set; } = null!;
        public int ReleaseYear { get; set; }
        public int Duration { get; set; }

        public int LanguageId { get; set; }
        public int ProductionId { get; set; }
        public int PhotoId { get; set; }
    }
}
