using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class MovieSearchObject : BaseSearchObject
    {
        public int? GenreId { get; set; }
        public string? name { get; set; }

    }
}
