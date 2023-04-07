namespace eCinema.Core
{
    public class ReservationDto : BaseDto
    {
        public bool isActive { get; set; }
        public bool IsClosed { get; set; }

        public int ShowSeatId { get; set; }
        public ShowSeatDto ShowSeat { get; set; } = null!;

        public int UserId { get; set; }
        public UserDto User { get; set; } = null!;
    }
}
