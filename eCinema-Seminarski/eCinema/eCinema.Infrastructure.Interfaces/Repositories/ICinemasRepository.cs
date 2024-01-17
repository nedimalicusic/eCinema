﻿using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface ICinemasRepository : IBaseRepository<Cinema,int, CinemaSearchObject>
    {
    }
}
