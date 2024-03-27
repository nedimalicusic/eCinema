using eCinema.Core.Entities;

namespace eCinema.Core
{
    public class ReccuringShowDto : BaseDto
    {
        public DateTime StartingDate { get; set; }
        public DateTime EndingDate { get; set; }
        public TimeSpan ShowTime { get; set; }
        public int WeekDayId { get; set; }
        public WeekDay WeekDay { get; set; } = null!;

    }
}
