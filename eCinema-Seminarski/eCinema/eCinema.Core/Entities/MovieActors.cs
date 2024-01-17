namespace eCinema.Core
{
    public class MovieActors : BaseEntity
    {
        public int MovieId { get; set; }
        public Movie Movie { get; set; } = null!;

        public int ActorId { get; set; }
        public Actors Actors { get; set; } = null!;
    }
}
