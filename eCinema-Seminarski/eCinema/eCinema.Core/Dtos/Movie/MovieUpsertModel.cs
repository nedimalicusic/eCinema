using Microsoft.AspNetCore.Http;

namespace eCinema.Core.Dtos.Movie
{
    public class MovieUpsertModel
    {
        public int Id { get; set; }
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public string Author { get; set; } = null!;
        public int ReleaseYear { get; set; }
        public int Duration { get; set; }

        public int LanguageId { get; set; }
        public int ProductionId { get; set; }
        public List<int> GenreIds { get; set; }
        public List<int> ActorIds { get; set; } 
        public List<int> CategoryIds { get; set; }
        public IFormFile Photo { get; set; } = null!;
    }
}
