namespace eCinema.Core
{
    public class Notification : BaseEntity
    {
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public DateTime? SendOnDate { get; set; }
        public DateTime? DateRead { get; set; }
        public bool? Seen { get; set; }

        public int UserId { get; set; }
        public User User { get; set; } = null!;
    }
}
