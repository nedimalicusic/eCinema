namespace eCinema.Core
{
    public class ShowDto : BaseDto
    {
        public DateOnly Date { get; set; }
        public TimeOnly StartTime { get; set; }
        public string Format { get; set; } = null!;

        public int CinemaId { get; set; }
        public CinemaDto Cinema { get; set; } = null!;

        public int MovieId { get; set; }
        public MovieDto Movie { get; set; } = null!;
    }
}
