namespace eCinema.Core
{
    public class ReservationDto : BaseDto
    {
        public bool isActive { get; set; }
        public bool isConfirm { get; set; }

        public int ShowId { get; set; }
        public ShowDto Show { get; set; } = null!;

        public int SeatId { get; set; }
        public SeatDto Seat { get; set; } = null!;

        public int UserId { get; set; }
        public UserDto User { get; set; } = null!;
    }
}
