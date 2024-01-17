﻿using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IReservationsRepository : IBaseRepository<Reservation,int, ReservationSearchObjet>
    {
        Task<IEnumerable<Reservation>> GetByUserId(int userId,CancellationToken cancellationToken);
        int getCountOfReservation(int cinemaId,CancellationToken cancellationToken);
    }
}