namespace eCinema.Core
{
    public class MovieReactionUpsertDto : BaseUpsertDto
    {
        public int UserId { get; set; }
        public int MovieId { get; set; }
        public int Rating { get; set; }
    }
}
