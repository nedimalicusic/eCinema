using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Core.Dtos.Cinema
{
    public class DashboardDto 
    {
        public int countUsers { get; set; }
        public int countUsersActive { get; set; }
        public int countUsersInActive { get; set; }
        public int countEmployees { get; set; }
        public int countOfReservation { get; set; }
    }
}
