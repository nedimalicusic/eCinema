namespace eCinema.Core
{
    public class ShowSeatUpsertDto : BaseUpsertDto
    {
        public bool isSelected { get; set; }
        public bool isReserved { get; set; }
        public bool isAvailable { get; set; }

        public int ShowId { get; set; }
        public int SeatId { get; set; }
    }
}
