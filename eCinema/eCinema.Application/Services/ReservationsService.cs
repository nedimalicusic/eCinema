using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class ReservationsService : BaseService<Reservation, ReservationDto, ReservationUpsertDto, BaseSearchObject, IReservationsRepository>, IReservationsService
    {
        public ReservationsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ReservationUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
