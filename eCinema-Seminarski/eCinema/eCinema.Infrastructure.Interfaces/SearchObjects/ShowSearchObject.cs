namespace eCinema.Infrastructure.Interfaces.SearchObjects
{
    public class ShowSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public int? CinemaId { get; set; }
        public int? MovieId { get; set; }
        public DateTime? Date { get; set; }

    }
}
