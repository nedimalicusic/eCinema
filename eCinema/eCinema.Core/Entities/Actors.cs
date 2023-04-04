namespace eCinema.Core
{
    public class Actors : BaseEntity
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public Gender Gender { get; set; } 

        public ICollection<Movie> Movies { get; set; } = null!;
    }
}
