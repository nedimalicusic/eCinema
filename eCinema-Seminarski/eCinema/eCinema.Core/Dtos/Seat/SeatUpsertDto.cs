namespace eCinema.Core
{
    public class SeatUpsertDto : BaseUpsertDto
    {
        public string Row { get; set; } = null!;
        public int Column { get; set; }
    }
}
