namespace eCinema.Core
{
    public class MovieActorsDto : BaseDto
    {
        public int MovieId { get; set; }
        public MovieDto Movie { get; set; } = null!;

        public int ActorId { get; set; }
        public ActorsDto Actors { get; set; } = null!;
    }
}
