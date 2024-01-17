
using eCinema.Core;

namespace eCinema.Infrastructure.Interfaces.SearchObjects
{
    public class EmployeeSearchObject : BaseSearchObject
    {
        public int? cinemaId { get; set; }
        public string? name { get; set; }
        public Gender? gender { get; set; }
        public bool? isActive { get; set; }

    }
}
