namespace eCinema.Core.Entities
{
    public class WeekDay : BaseEntity
    {
        public string Name { get; set; } = null!;
        public ICollection<ReccuringShows> ReccuringShows { get; set; } = null!;
    }
}
