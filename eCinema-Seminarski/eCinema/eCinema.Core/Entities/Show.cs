namespace eCinema.Core
{
    public class Show : BaseEntity
    {
        public DateTime Date { get; set; }
        public DateTime StartTime { get; set; }
        public string Format { get; set; } = null!;
        public double Price { get; set; }

        public int CinemaId { get; set; }
        public Cinema Cinema { get; set; } = null!;

        public int MovieId { get; set; }
        public Movie Movie { get; set; } = null!;

        public ICollection<Reservation> Reservations { get; set; } = null!;
    }
}
