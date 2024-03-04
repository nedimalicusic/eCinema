using eCinema.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Infrastructure.Interfaces.SearchObjects
{
    public class UserSearchObject : BaseSearchObject
    {
        public string? name { get; set; }
        public Gender? gender { get; set; }
        public bool? isActive { get; set; }
        public bool? isVerified { get; set; }
        public int role { get; set; }
    }
}
