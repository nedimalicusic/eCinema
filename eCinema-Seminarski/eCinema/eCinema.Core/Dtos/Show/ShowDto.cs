namespace eCinema.Core
{
    public class ShowDto : BaseDto
    {
        public DateTime Date { get; set; }
        public DateTime StartTime { get; set; }
        public string Format { get; set; } = null!;
        public double Price { get; set; } 

        public int CinemaId { get; set; }
        public CinemaDto Cinema { get; set; } = null!;

        public int MovieId { get; set; }
        public MovieDto Movie { get; set; } = null!;
    }
}
