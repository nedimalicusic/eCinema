namespace eCinema.Core
{
    public class Photo : BaseEntity
    {
        public Photo()
        {
            GuidId = Guid.NewGuid();
        }
        public Guid GuidId { get; set; }
        public byte[] Data { get; set; } = null!;
        public string ContentType { get; set; } = null!;
        public byte[] ThumbnailContent { get; set; } = null!;

        public ICollection<User> Users { get; set; } = null!;
        public ICollection<Movie> Movies { get; set; } = null!;
        public ICollection<Employee> Employees { get; set; } = null!;
    }
}
