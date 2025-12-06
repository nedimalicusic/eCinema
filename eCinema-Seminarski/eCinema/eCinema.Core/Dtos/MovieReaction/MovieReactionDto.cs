namespace eCinema.Core
{
    public class MovieReactionDto : BaseDto
    {
        public int UserId { get; set; }
        public UserDto User { get; set; } = null!;

        public int MovieId { get; set; }
        public MovieDto Movie { get; set; } = null!;

        public int Rating { get; set; }
    }
}
