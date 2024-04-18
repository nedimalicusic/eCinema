using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class MovieSearchObject : BaseSearchObject
    {
        public int? GenreId { get; set; }
        public int? CategoryId { get; set; }
        public string? Name { get; set; }

    }
}
