namespace eCinema.Core
{
    public class ReccuringShowUpsertDto : BaseUpsertDto
    {
        public DateTime StartingDate { get; set; }
        public DateTime EndingDate { get; set; }
        public TimeSpan ShowTime { get; set; }
        public int WeekDayId { get; set; }
    }
}
