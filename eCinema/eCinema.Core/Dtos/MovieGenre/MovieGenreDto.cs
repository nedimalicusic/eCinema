namespace eCinema.Core
{
    public class MovieGenreDto : BaseDto
    {
        public int MovieId { get; set; }
        public MovieDto Movie { get; set; } = null!;

        public int GenreId { get; set; }
        public GenreDto Genre { get; set; } = null!;
    }
}
