namespace eCinema.Core
{
    public class MovieActorsUpsertDto : BaseUpsertDto
    {
        public int MovieId { get; set; }
        public int ActorId { get; set; }
    }
}
