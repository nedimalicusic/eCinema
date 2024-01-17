namespace eCinema.Core
{
    public class SeatDto : BaseDto
    {
        public string Row { get; set; } = null!;
        public int Column { get; set; }
    }
}
