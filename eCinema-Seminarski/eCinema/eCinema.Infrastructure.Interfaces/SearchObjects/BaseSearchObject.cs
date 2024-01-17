namespace eCinema.Infrastructure.Interfaces
{
    public class BaseSearchObject
    {
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 20;
    }
}
