
namespace eCinema.Infrastructure.Interfaces.SearchObjects
{
    public class CategorySearchObject : BaseSearchObject
    {
        public bool? IsDisplayed { get; set; }
        public bool? IncludeMoviesWithData { get; set; }

    }
}
