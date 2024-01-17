using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application
{
    public class ReservationsService : BaseService<Reservation, ReservationDto, ReservationUpsertDto, ReservationSearchObjet, IReservationsRepository>, IReservationsService
    {
        public ReservationsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ReservationUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }

        public async Task<IEnumerable<ReservationDto>> GetByUserId(int userId, CancellationToken cancellationToken)
        {
            var reservations = await CurrentRepository.GetByUserId(userId, cancellationToken);

            return Mapper.Map<IEnumerable<ReservationDto>>(reservations);
        }
    }
}
