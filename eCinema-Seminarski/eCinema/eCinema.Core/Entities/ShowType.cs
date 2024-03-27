namespace eCinema.Core.Entities
{
    public class ShowType : BaseEntity
    {
        public string Name { get; set; } = null!;
        public ICollection<Show> Shows { get; set; } = null!;
    }
}
