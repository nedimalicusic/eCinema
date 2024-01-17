namespace eCinema.Core
{
    public class Actors : BaseEntity
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; } 

        public ICollection<MovieActors> MovieActors { get; set; } = null!;
    }
}
