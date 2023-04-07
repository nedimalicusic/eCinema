namespace eCinema.Core
{
    public class ShowSeatDto : BaseDto
    {
        public bool isSelected { get; set; }
        public bool isReserved { get; set; }
        public bool isAvailable { get; set; }

        public int ShowId { get; set; }
        public ShowDto Show { get; set; } = null!;

        public int SeatId { get; set; }
        public SeatDto Seat { get; set; } = null!;
    }
}
