namespace eCinema.Core
{
    public class Genre : BaseEntity
    {
        public string Name { get; set; } = null!;

        public ICollection<MovieGenre> Movies { get; set; } = null!;
    }
}
