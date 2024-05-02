using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;
using System.Net.Sockets;

namespace eCinema.Application
{
    public class ReservationsService : BaseService<Reservation, ReservationDto, ReservationUpsertDto, ReservationSearchObjet, IReservationsRepository>, IReservationsService
    {
        public ReservationsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ReservationUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }

        public async Task<IEnumerable<ReservationDto>> GetByShowId(int showId, CancellationToken cancellationToken)
        {
            var reservations = await CurrentRepository.GetByShowId(showId, cancellationToken);

            return Mapper.Map<IEnumerable<ReservationDto>>(reservations);
        }

        public async Task<IEnumerable<ReservationDto>> GetByUserId(int userId, CancellationToken cancellationToken)
        {
            var reservations = await CurrentRepository.GetByUserId(userId, cancellationToken);

            return Mapper.Map<IEnumerable<ReservationDto>>(reservations);
        }

        public async Task<List<int>> GetCountByMonthAsync(BarChartSearchObject searchObject, CancellationToken cancellationToken = default)
        {

            return await CurrentRepository.GetCountByMonthAsync(searchObject, cancellationToken);
        }

        public async Task<IEnumerable<ReservationDto>> InsertAsync(IEnumerable<ReservationUpsertDto> reservations, CancellationToken cancellationToken)
        {
            var entities = new List<Reservation>();
            foreach (var reservation in reservations)
            {
                entities.Add(new Reservation
                {
                    isActive = true,
                    isConfirm = true,
                    SeatId = reservation.SeatId,
                    UserId = reservation.UserId,
                    ShowId = reservation.ShowId,
                });
            }
            await CurrentRepository.AddRangeAsync(entities);

            await UnitOfWork.SaveChangesAsync(cancellationToken);

            return Mapper.Map<IEnumerable<ReservationDto>>(entities);
        }
    }
}
