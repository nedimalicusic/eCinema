using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Infrastructure.Interfaces.SearchObjects
{
    public class ReservationSearchObjet : BaseSearchObject
    {
        public string? name { get; set; }
        public int? cinemaId { get; set; }
    }
}
