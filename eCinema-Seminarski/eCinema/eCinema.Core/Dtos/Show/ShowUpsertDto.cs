namespace eCinema.Core
{
    public class ShowUpsertDto : BaseUpsertDto
    {
        public DateTime Date { get; set; }
        public DateTime StartTime { get; set; }
        public string Format { get; set; } = null!;
        public double Price { get; set; } 

        public int CinemaId { get; set; }
        public int MovieId { get; set; }
    }
}
