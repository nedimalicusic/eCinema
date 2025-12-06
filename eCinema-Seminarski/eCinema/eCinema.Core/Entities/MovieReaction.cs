namespace eCinema.Core
{
    public class MovieReaction : BaseEntity
    {
        public int UserId { get; set; }
        public User User { get; set; } = null!;

        public int MovieId { get; set; }
        public Movie Movie { get; set; } = null!;

        public int Rating { get; set; }
    }
}
