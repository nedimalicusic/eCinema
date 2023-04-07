namespace eCinema.Core
{
    public class ShowUpsertDto : BaseUpsertDto
    {
        public DateOnly Date { get; set; }
        public TimeOnly StartTime { get; set; }
        public string Format { get; set; } = null!;

        public int CinemaId { get; set; }
        public int MovieId { get; set; }
    }
}
