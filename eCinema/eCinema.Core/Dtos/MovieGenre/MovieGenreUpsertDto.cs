namespace eCinema.Core
{
    public class MovieGenreUpsertDto : BaseUpsertDto
    {
        public int MovieId { get; set; }
        public int GenreId { get; set; }
    }
}
