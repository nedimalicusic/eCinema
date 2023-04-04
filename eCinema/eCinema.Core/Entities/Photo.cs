namespace eCinema.Core
{
    public class Photo : BaseEntity
    {
        public byte[] Data { get; set; } = null!;
        public string ContentType { get; set; } = null!;

        public ICollection<User> Users { get; set; } = null!;
        public ICollection<Movie> Movies { get; set; } = null!;
    }
}
