namespace eCinema.Core.Entities
{
    public class ReccuringShows : BaseEntity
    {
        public DateTime StartingDate { get; set; }

        public DateTime EndingDate { get; set; }

        public TimeSpan ShowTime { get; set; }

        public int WeekDayId { get; set; }
        public WeekDay WeekDay { get; set; } = null!;

        public ICollection<Show> Shows { get; set; } = null!;
    }
}
